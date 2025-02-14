.DEFAULT_GOAL := help
SHELL := bash

DUTY = $(shell [ -n "${VIRTUAL_ENV}" ] || echo pdm run) duty

args = $(foreach a,$($(subst -,_,$1)_args),$(if $(value $a),$a="$($a)"))
check_quality_args = files
docs_args = host port
release_args = version
test_args = match
fuzz_args = pdm profile browser

BASIC_DUTIES = \
	changelog \
	check-api \
	check-dependencies \
	clean \
	coverage \
	docs \
	docs-deploy \
	format \
	release \
	fuzz

QUALITY_DUTIES = \
	check-quality \
	check-docs \
	check-types \
	test

.PHONY: help
help:
	@$(DUTY) --list

.PHONY: lock
lock:
	@pdm lock --no-cross-platform

.PHONY: setup
setup:
	@bash scripts/setup.sh

.PHONY: check
check:
	@pdm multirun duty check-quality check-types check-docs
	@$(DUTY) check-dependencies check-api

.PHONY: $(BASIC_DUTIES)
$(BASIC_DUTIES):
	@$(DUTY) $@ $(call args,$@)

.PHONY: $(QUALITY_DUTIES)
$(QUALITY_DUTIES):
	@pdm multirun duty $@ $(call args,$@)
