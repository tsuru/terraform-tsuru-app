# Contributing Guide

Thank you for considering contributing to the Terraform Tsuru App module! This document provides guidelines and instructions to help you contribute effectively.

## How to Contribute

Contributions are very welcome! There are several ways to contribute:

- Report bugs
- Suggest new features
- Improve documentation
- Submit code fixes and improvements
- Add or improve tests

## Contribution Process

### 1. Fork and Clone

1. Fork the repository and clone your fork locally:
   ```bash
   git clone https://github.com/<your-username>/terraform-tsuru-app.git
   cd terraform-tsuru-app
   ```

### 2. Make Changes

- Make your code changes
- Ensure you follow [Code Standarts](##code-standarts)
- Run validation commands before committing

### 3. Submit Pull Request

- Fill out the PR template completely
- Clearly describe what was changed and why
- Reference related issues, if any
- Add screenshots or examples, if applicable

## Development

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [terraform-docs](https://terraform-docs.io/) (for documentation generation)

### Makefile Commands

```bash
make help         # Show available commands
make fmt          # Format Terraform files
make docs         # Generate documentation using terraform-docs
```

### Code Standards

#### Formatting

- Always run `make fmt` before committing to ensure consistent formatting
- The Terraform formatter will automatically run on all `.tf` files

#### Documentation

- Add clear descriptions for all variables and outputs
- Document complex behaviors with comments
- Update documentation when adding new features
- Run `make docs` to update automatically generated documentation

#### Validation

Before submitting a PR, make sure to:

1. Run `make fmt` and verify there are no pending changes
2. Run `make docs` and verify documentation is up to date
3. Validate Terraform syntax:
   ```bash
   terraform init
   terraform validate
   ```
4. Test with a real example, if possible

## Code of Conduct

- Be respectful and professional
- Accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## Pull Request Review

All PRs need to be reviewed before being merged. Maintainers will review:

- Code quality and clarity
- Compliance with project standards
- Documentation completeness
- Impact on existing functionality

## License

This project is licensed under the MIT License - see the [LICENSE](LICENCE) guideline for details.
