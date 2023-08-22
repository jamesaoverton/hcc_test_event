.PHONY: all
all: build/nanobot.db

.PHONY: clean
clean:
	rm -f build/test_event.xlsx build/nanobot.db

build/:
	mkdir -p $@

# Download Nanobot binary for Linux ARM64
build/nanobot: | build/
	curl -L -o $@ "https://github.com/ontodev/nanobot.rs/releases/download/v2023-06-30/nanobot-x86_64-unknown-linux-musl"
	chmod +x $@

# Download qsv binary for Linux ARM64
build/qsv: | build/
	curl -L -k -o build/qsv.zip "https://github.com/jqnatividad/qsv/releases/download/0.112.0/qsv-0.112.0-x86_64-unknown-linux-musl.zip"
	cd build && unzip qsv.zip

# Fetch Google Sheet in Excel format
SHEET := https://docs.google.com/spreadsheets/d/11zNY4MEoEUZsmA-UYMuzclQIog_7X8264vz8Do056pE/export?format=xlsx
build/test_event.xlsx: | build/
	curl -L -k -o $@ "$(SHEET)"

TABLES := table column datatype planned_event arm arm_2_planned_event
TSVS := $(foreach TABLE,$(TABLES),src/$(TABLE).tsv)

# Convert Excel sheets to TSV format
src/%.tsv: build/test_event.xlsx | build/qsv
	build/qsv excel --delimiter '	' --sheet $* --output $@ $<

.PHONY: update
update: $(TSVS)

# Initialize Nanobot database and run additional validation
build/nanobot.db: $(TSVS) | build/nanobot
	rm -f $@
	build/nanobot init
	sqlite3 $@ < src/validate_start_min_max.sql

