##############################################
### Generated Makefile - Do not edit!      ###
### Add custom targets to custom.Makefile  ###
### See README.md for more information     ###
##############################################

PROJECT_DIR=projects
CONFIG_DIR=config
MAPPINGS_DIR=mappings
TMP_DIR=tmp

$(MAPPINGS_DIR)/ $(TMP_DIR)/:
	mkdir -p $@

MAKEFILE_TEMPLATE=$(CONFIG_DIR)/project.Makefile.j2

ALL_PROJECTS=$(strip $(patsubst %.symbiont.yaml, %, $(notdir $(wildcard $(PROJECT_DIR)/*.yaml))))
ALL_SYMBIONT = $(patsubst %, symbiont-%, $(ALL_PROJECTS))

all: $(ALL_SYMBIONT)

symbiont-%:
	mkdir -p $(PROJECT_DIR)/$*
	j2 $(MAKEFILE_TEMPLATE) $(PROJECT_DIR)/$*.symbiont.yaml > $(PROJECT_DIR)/$*/Makefile
	touch $(PROJECT_DIR)/$*/custom.Makefile
	cd $(PROJECT_DIR)/$* && make reset_boomer_output && make all HOME_DIR=$(shell pwd) -B

#####################
## Mappings #########
#####################

ALL_MAPPINGS=$(MAPPINGS_DIR)/empty.sssom.tsv $(MAPPINGS_DIR)/mondo_hasdbxref_icd10cm.sssom.tsv $(MAPPINGS_DIR)/mondo_exactmatch_icd10cm.sssom.tsv $(MAPPINGS_DIR)/mondo_narrowmatch_icd10cm.sssom.tsv $(MAPPINGS_DIR)/mondo_broadmatch_icd10cm.sssom.tsv $(MAPPINGS_DIR)/ncit_icd10_2017.sssom.tsv $(MAPPINGS_DIR)/mondo.sssom.tsv $(MAPPINGS_DIR)/mondo_all.sssom.tsv $(MAPPINGS_DIR)/upheno-all.sssom.tsv $(MAPPINGS_DIR)/upheno-curated.sssom.tsv $(MAPPINGS_DIR)/upheno-curated-negative.sssom.tsv $(MAPPINGS_DIR)/upheno-lexical-oak.sssom.tsv $(MAPPINGS_DIR)/upheno-lexical-custom.sssom.tsv $(MAPPINGS_DIR)/upheno-logical-safe.sssom.tsv $(MAPPINGS_DIR)/biomappings.sssom.tsv 


$(MAPPINGS_DIR)/empty.sssom.tsv: | $(MAPPINGS_DIR)/
	wget https://raw.githubusercontent.com/mapping-commons/mapping-commons.github.io/main/mappings/empty.sssom.tsv -O $@

$(MAPPINGS_DIR)/mondo_hasdbxref_icd10cm.sssom.tsv: | $(MAPPINGS_DIR)/
	wget https://raw.githubusercontent.com/monarch-initiative/mondo/master/src/ontology/mappings/mondo_hasdbxref_icd10cm.sssom.tsv -O $@

$(MAPPINGS_DIR)/mondo_exactmatch_icd10cm.sssom.tsv: | $(MAPPINGS_DIR)/
	wget https://raw.githubusercontent.com/monarch-initiative/mondo/master/src/ontology/mappings/mondo_exactmatch_icd10cm.sssom.tsv -O $@

$(MAPPINGS_DIR)/mondo_narrowmatch_icd10cm.sssom.tsv: | $(MAPPINGS_DIR)/
	wget https://raw.githubusercontent.com/monarch-initiative/mondo/master/src/ontology/mappings/mondo_narrowmatch_icd10cm.sssom.tsv -O $@

$(MAPPINGS_DIR)/mondo_broadmatch_icd10cm.sssom.tsv: | $(MAPPINGS_DIR)/
	wget https://raw.githubusercontent.com/monarch-initiative/mondo/master/src/ontology/mappings/mondo_broadmatch_icd10cm.sssom.tsv -O $@

$(MAPPINGS_DIR)/ncit_icd10_2017.sssom.tsv: | $(MAPPINGS_DIR)/
	wget https://raw.githubusercontent.com/mapping-commons/disease-mappings/main/mappings/ncit_icd10_2017.sssom.tsv -O $@

$(MAPPINGS_DIR)/mondo.sssom.tsv: | $(MAPPINGS_DIR)/
	wget https://raw.githubusercontent.com/monarch-initiative/mondo/master/src/ontology/mappings/mondo.sssom.tsv -O $@

$(MAPPINGS_DIR)/mondo_all.sssom.tsv: | $(MAPPINGS_DIR)/
	wget http://w3id.org/sssom/commons/monarch/mondo_all.sssom.tsv -O $@

$(MAPPINGS_DIR)/upheno-all.sssom.tsv: | $(MAPPINGS_DIR)/
	wget http://w3id.org/sssom/commons/monarch/upheno-all.sssom.tsv -O $@

$(MAPPINGS_DIR)/upheno-curated.sssom.tsv: | $(MAPPINGS_DIR)/
	wget http://w3id.org/sssom/commons/monarch/upheno-curated.sssom.tsv -O $@

$(MAPPINGS_DIR)/upheno-curated-negative.sssom.tsv: | $(MAPPINGS_DIR)/
	wget http://w3id.org/sssom/commons/monarch/upheno-curated-negative.sssom.tsv -O $@

$(MAPPINGS_DIR)/upheno-lexical-oak.sssom.tsv: | $(MAPPINGS_DIR)/
	wget http://w3id.org/sssom/commons/monarch/upheno-lexical-oak.sssom.tsv -O $@

$(MAPPINGS_DIR)/upheno-lexical-custom.sssom.tsv: | $(MAPPINGS_DIR)/
	wget http://w3id.org/sssom/commons/monarch/upheno-lexical-custom.sssom.tsv -O $@

$(MAPPINGS_DIR)/upheno-logical-safe.sssom.tsv: | $(MAPPINGS_DIR)/
	wget http://w3id.org/sssom/commons/monarch/upheno-logical-safe.sssom.tsv -O $@

$(MAPPINGS_DIR)/biomappings.sssom.tsv: | $(MAPPINGS_DIR)/
	wget https://raw.githubusercontent.com/biopragmatics/biomappings/master/docs/_data/sssom/biomappings.sssom.tsv -O $@


mappings: $(ALL_MAPPINGS)

all: $(ALL_MAPPINGS)

include custom.Makefile