BOOTSTRAP ?= ./bin/bootstrap
CONFIG ?= ./config/config.yaml

.PHONY: help dry all p0 p1 p2 p3 p4 p5 p6 verify

help:
	@$(BOOTSTRAP) --help

dry:
	@$(BOOTSTRAP) --config $(CONFIG) --dry-run --all

all:
	@$(BOOTSTRAP) --config $(CONFIG) --all

p0:
	@$(BOOTSTRAP) --config $(CONFIG) 0

p1:
	@$(BOOTSTRAP) --config $(CONFIG) 1

p2:
	@$(BOOTSTRAP) --config $(CONFIG) 2

p3:
	@$(BOOTSTRAP) --config $(CONFIG) 3

p4:
	@$(BOOTSTRAP) --config $(CONFIG) 4

p5:
	@$(BOOTSTRAP) --config $(CONFIG) 5

p6:
	@$(BOOTSTRAP) --config $(CONFIG) 6

verify:
	@$(BOOTSTRAP) --config $(CONFIG) 99
