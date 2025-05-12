# msc-thesis

## Repository Overview

This repository contains the following components related to the master thesis:

### 1. Infrastructure as Code (IAC)
The IAC folder includes all the scripts and configurations required to provision and manage the infrastructure for the project. It leverages modern tools and practices to ensure scalability, reliability, and maintainability.

### 2. MARP Presentation
The MARP folder contains the code and assets for the thesis presentation. It is built using the MARP framework, enabling the creation of professional and visually appealing slides.

## Usage

1. **IAC**: Resides in the `iac/` directory 
2. **MARP Presentation**: Resides in the `presentation/`

### IAC

Terraform has been used for the IaC. GitHub Actions is used for CI/CD, and the workflows are located in the `.github/workflows/` directory. The main workflow is `iac-pr-close.yaml`, which is triggered on the close of a pull request that results in a push to the `main` branch. The second workflow is the `iac-pr.yaml`, which runs when a PR that is targeted at master is created. This workflow creates a Terraform Plan and comments on the PR with the plan.

The state is saved in Microsoft Azure.

The secrets necessary to access the state, create plans, and apply the plan, are stored in the GitHub repository secrets.

### MARP Presentation

MARP is a framework based on MarkDown that is used to create presentations. The source code exists in the `presentation/slides.md` file. The presentation can be built using the `marp` command line tool.

For example, to start a web server serving the presentation, please run the following command:
```bash
cd presentation
marp --html -s -I .
```

Please refer to the official MARP documentation for more information on how to use the framework: [MARP Documentation](https://marp.app/docs/).