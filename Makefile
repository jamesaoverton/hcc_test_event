

SHEET := https://docs.google.com/spreadsheets/d/11zNY4MEoEUZsmA-UYMuzclQIog_7X8264vz8Do056pE/export?format=xlsx

build/:
	mkdir -p $@

build/nanobot: | build/
	curl -L -o $@ "https://github.com/ontodev/nanobot.rs/releases/download/v2023-06-30/nanobot-x86_64-unknown-linux-musl"
	chmod +x $@

build/test_event.xlsx: | build/
	curl -L -k -o $@ "$(SHEET)"

TABLES := table column datatype planned_event arm arm_2_planned_event
TSVS := $(foreach TABLE,$(TABLES),src/$(TABLE).tsv)

src/%.tsv: build/test_event.xlsx
	mkdir -p build/src/
	xlsx2csv --delimiter tab --ignoreempty --sheetname $* $< build/$@
	xsv fixlengths --delimiter '	' --output $@ build/$@
	rm build/$@

.PHONY: update
update: $(TSVS)

.PHONY: clean
clean:
	rm -f build/test_event.xlsx build/nanobot.db

build/nanobot.db: $(TSVS) | build/nanobot
	rm -f $@
	build/nanobot init
