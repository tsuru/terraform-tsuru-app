# Copyright 2026 tsuru authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

.PHONY: help fmt docs

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

fmt: ## Format Terraform files
	@echo "Formatting Terraform files..."
	@terraform fmt -recursive .

docs: ## Generate documentation using terraform-docs
	@echo "Generating documentation..."
	@terraform-docs .
