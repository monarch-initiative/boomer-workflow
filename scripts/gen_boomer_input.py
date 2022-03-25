from os.path import join
from pathlib import Path
from sssom.parsers import read_sssom_table
from sssom.writers import write_table
from sssom.util import MappingSetDataFrame
import pandas as pd
import yaml
import click


@click.group()
def cli():
    pass

@cli.command()
@click.option("--config", "-c", type=click.Path(exists=True), help=f"Path to the config folder.")
@click.option("--source-location", "-s", type=click.Path() , help=f"Path to source of individual sssom.tsv files.")
@click.option("--target-location", "-t", type=click.Path(), help=f"Path to save the combined.sssom.tsv and prefix.yaml files.")
def run(config:Path, source_location:Path, target_location:Path):
    # Variables
    PREFIX_YAML_FILE = join(target_location, "prefix.yaml")
    COMBINED_SSSOM = join(target_location, "combined.sssom.tsv")

    with open(config, "rb") as c:
        config_yaml = yaml.safe_load(c)

    
    _, id = target_location.split('/')

    concerned_run_list = [
                        info for info in config_yaml["config"]["boomer_config"]["runs"]
                        if info["id"] == id
                    ]
    if len(concerned_run_list) == 1 :
        concerned_run = concerned_run_list[0]
    elif len(concerned_run_list) > 1:
            raise(ValueError(f"{config} file has multiple configurations for id = {id}"))
    else:
        raise(ValueError(f"{config} file does not have configuration for id = {id}"))

    mapping_files = concerned_run["mappings"]

    metadata = dict()
    prefix_map = dict()
    msdf_list = []
    df_list = []

    for fn in mapping_files:

        mapping_ref = [
            info for info in config_yaml["mapping_registry"]["mapping_set_references"]
            if info["local_name"] == fn
        ]
        if len(mapping_ref) == 1 :
            concerned_map = mapping_ref[0]
        elif len(mapping_ref) > 1:
                raise(ValueError(f"{config} file has multiple \
                    mapping_set_reference for local_name = {fn}"))
        else:
            raise(ValueError(f"{config} file does not have \
                mapping_set_reference for local_name = {fn}"))

        confidence = concerned_map["registry_confidence"]

        fp = join(source_location, fn)
        print(f"Loading file:{fn} ")
        msdf = read_sssom_table(fp)
        msdf.df['confidence'] = confidence
        metadata.update({k:v for k,v in msdf.metadata.items() if k not in metadata.keys()})
        prefix_map.update({k:v for k,v in msdf.prefix_map.items() if k not in prefix_map.keys()})
        msdf_list.append(msdf)
        df_list.append(msdf.df)

    combined_df = pd.concat(df_list, axis=0, ignore_index=True)
    combined_df = combined_df.drop_duplicates()

    with open(PREFIX_YAML_FILE, "w+") as yml:
        yaml.dump(prefix_map,yml)

    combined_msdf = MappingSetDataFrame(df=combined_df, prefix_map=prefix_map, metadata=metadata)
    with open(COMBINED_SSSOM, "w") as combo_file:
        write_table(combined_msdf, combo_file)


if __name__ == "__main__":
    cli()

