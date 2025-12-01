---
layout: default
title: Command Line Interface
parent: Administration
nav_order: 2
permalink: /administration/command-line-interface
---

# Command Line Interface
{: .no_toc }
{: .fs-6 .fw-300 }

Using the Query and Reasoning Capabilities of the TOP Framework via Command Line Interface.

## Background

The TOP Framework provides a command line interface (CLI) that allows users to interact with the system's query and reasoning capabilities.
This interface is designed for advanced users who prefer to work directly with commands rather than through a graphical user interface.

The advantage of using the CLI is that it does not require the complete TOP Framework to be deployed, making it lightweight and efficient for specific tasks.
Specifically, the CLI can be used to execute queries and perform reasoning tasks on a patient data source in a restricted environment, where Docker installations are not feasible or allowed.
The CLI can be integrated into other applications or used in scripts to automate tasks.

## Requirements

To use the CLI, you need to have the following:

- A Java Runtime Environment (JRE) installed on your system (version 17 or higher).
- The TOP Framework CLI JAR file, which can be downloaded from the [official TOP Phenotypic Query repository](https://github.com/Onto-Med/top-phenotypic-query) or built from the source code.
- Access to a patient data source that is compatible with the TOP Framework.

## Usage

The CLI can be invoked from the command line using the following syntax:

```bash
# show help message
java -jar top-phenotypic-query-x.x.x.jar query --help

# execute phenotypic queries based on a phenotype model, results are written to ZIP
java -jar top-phenotypic-query-x.x.x.jar query <query config> <phenotype model> \
  <adapter config> <ZIP output path>
```

- `<query config>` contains the query parameters
- `<phenotype model>` holds the phenotype definitions to be used for the query
- `<adapter config>` specifies the connection details to the patient data source

Please refer to the [official TOP Phenotypic Query repository](https://github.com/Onto-Med/top-phenotypic-query) for more details.
