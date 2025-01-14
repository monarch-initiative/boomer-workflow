
## Customize Makefile settings for monarch_mapping_commons
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

MAPPING_DIR = 					mappings
SCRIPT_DIR =					scripts
SRC_DIR = 						sources
TMP_DIR = 						tmp
METADATA_DIR = 					metadata
RUN = poetry run


benchmark:
	pip install py-spy
	sudo py-spy record -o flamegraph.svg -- $(SSSOM_TOOLKIT) validate $(MAPPING_DIR)/gene_mappings.sssom.tsv


$(MAPPING_DIR)/ $(SCRIPT_DIR)/ $(SRC_DIR)/ $(TMP_DIR)/:
	mkdir -p $@


$(MAPPING_DIR)/mondo.sssom.tsv:
	mkdir -p $(MAPPING_DIR) $(TMP_DIR)
	wget -q http://purl.obolibrary.org/obo/mondo/mappings/mondo.sssom.tsv -O $@

$(MAPPING_DIR)/mesh_chebi_biomappings.sssom.tsv:
	mkdir -p $(MAPPING_DIR) $(TMP_DIR)
	wget -q https://raw.githubusercontent.com/biopragmatics/biomappings/master/docs/_data/sssom/biomappings.sssom.tsv -O $(TMP_DIR)/biomappings.sssom.tsv
	$(RUN) python3 $(SCRIPT_DIR)/process_biomappings.py --input $(TMP_DIR)/biomappings.sssom.tsv --output $(TMP_DIR)/mesh_chebi_biomappings.sssom.tsv
	$(RUN) sssom parse $(TMP_DIR)/mesh_chebi_biomappings.sssom.tsv -m $(METADATA_DIR)/mesh_chebi_biomappings.sssom.yml --prefix-map-mode merged -o $@

$(MAPPING_DIR)/gene_mappings.sssom.tsv:
ifeq ($(GH_ACTION), true)
	@printf "\nGene Mappings target is unavailable in GitHub actions.\n\n"
else
	mkdir -p $(MAPPING_DIR) $(TMP_DIR)
	$(RUN) gene-mapping generate --download --preprocess-uniprot --output-dir $(TMP_DIR)
	$(RUN) sssom parse $(TMP_DIR)/gene_mappings.sssom.tsv -m $(METADATA_DIR)/gene_mappings.sssom.yml --prefix-map-mode merged -o $@
endif

$(MAPPING_DIR)/hp_mesh.sssom.tsv:
	wget -q https://raw.githubusercontent.com/monarch-initiative/umls-ingest/main/src/umls_ingest/mappings/hp_mesh.sssom.tsv -O $@

$(MAPPING_DIR)/umls_hp.sssom.tsv:
	wget -q https://raw.githubusercontent.com/monarch-initiative/umls-ingest/main/src/umls_ingest/mappings/umls_hp.sssom.tsv -O $@

$(MAPPING_DIR)/upheno-cross-species.sssom.tsv:
	wget -q https://raw.githubusercontent.com/obophenotype/upheno-dev/refs/heads/master/src/mappings/upheno-cross-species.sssom.tsv -O $@

$(MAPPING_DIR)/nbo-go.sssom.tsv:
	wget -q https://raw.githubusercontent.com/obophenotype/upheno-dev/refs/heads/master/src/mappings/nbo-go.sssom.tsv -O $@

$(MAPPING_DIR)/uberon.sssom.tsv:
	wget -q https://raw.githubusercontent.com/obophenotype/upheno-dev/refs/heads/master/src/mappings/uberon.sssom.tsv -O $@

$(MAPPING_DIR)/upheno-species-independent.sssom.tsv:
	wget -q https://raw.githubusercontent.com/obophenotype/upheno-dev/refs/heads/master/src/mappings/upheno-species-independent.sssom.tsv -O $@

$(MAPPING_DIR)/mondo_hasdbxref_hp.sssom.tsv:
	wget -q  http://purl.obolibrary.org/obo/mondo/mappings/mondo_hasdbxref_hp.sssom.tsv -O $@
$(MAPPING_DIR)/mondo_hp_lexical.sssom.tsv:
	wget -q https://raw.githubusercontent.com/mapping-commons/disease-mappings/refs/heads/main/mappings/mondo_hp_lexical.sssom.tsv -O $@

.PHONY: mappings_to_ttl
mappings_to_ttl: mappings
	$(RUN) python3 $(SCRIPT_DIR)/registry_parser.py registry.yml

benchmark:
	pip install py-spy
	sudo py-spy record -o flamegraph.svg -- $(SSSOM_TOOLKIT) validate $(MAPPING_DIR)/gene_mappings.sssom.tsv
