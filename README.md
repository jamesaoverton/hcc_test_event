# hcc_test_event

This repo demonstrates using
[VALVE](https://github.com/ontodev/valve.rs)
and
[Nanobot](https://github.com/ontodev/nanobot.rs)
to validate a
[Google Sheet](https://docs.google.com/spreadsheets/d/11zNY4MEoEUZsmA-UYMuzclQIog_7X8264vz8Do056pE/)
used for describing immunology study designs.

Run `make clean all`.
See results in the `build/` directory.

For a web interface, run `build/nanobot serve`.

## Requirements

Linux on an x86_64 processor, GNU Make, and SQLite3.
Other binaries are downloaded by the Makefile.
