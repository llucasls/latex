OUTPUT_DIR = documents
DOCUMENTS := $(patsubst %.tex,$(OUTPUT_DIR)/%.pdf,$(wildcard *.tex))

ENGINE = xelatex
FLAGS  = --output-directory=$(OUTPUT_DIR)

define PDF_VIEWER
_zathura() { tabbed -dc zathura $$@ -e; }; \
_zathura
endef

GET_FILES = $(foreach FILE,$(filter %.pdf,$1),$(OUTPUT_DIR)/$(FILE))

all: $(DOCUMENTS)

$(OUTPUT_DIR)/%.pdf: %.tex | $(OUTPUT_DIR)
	if test $< -nt $@; then $(ENGINE) $(FLAGS) $<; fi

%.pdf: %.tex
	@$(MAKE) --no-print-directory $(OUTPUT_DIR)/$@

$(OUTPUT_DIR):
	mkdir $(OUTPUT_DIR)

preview:
	files="$(call GET_FILES,$(MAKECMDGOALS))"; \
	test -n "$${files}" && $(PDF_VIEWER) $${files} 2> /dev/null

clean:
	rm -f $(OUTPUT_DIR)/*

.SILENT: $(DOCUMENTS) preview

.IGNORE: preview clean

.PHONY: all preview clean
