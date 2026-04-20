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

- A Java Runtime Environment (JRE) installed on your system (version 21 or higher).
- The TOP Framework CLI JAR file, which can be downloaded from the [official TOP Phenotypic Query repository](https://github.com/Onto-Med/top-phenotypic-query) or built from the source code.
- Access to a patient data source that is compatible with the TOP Framework.

## Usage

The CLI can be invoked from the command line using the following syntax:

```sh
# show help message
java -jar top-phenotypic-query-x.x.x.jar --help
```

For more details, please refer to the following sections and to the [official TOP Phenotypic Query repository](https://github.com/Onto-Med/top-phenotypic-query).

### Query Execution

```sh
# show available query options
java -jar top-phenotypic-query-x.x.x.jar query --help

# execute phenotypic queries based on a phenotype model, results are written to ZIP
java -jar top-phenotypic-query-x.x.x.jar query <phenotype model> <adapter config> \
  <query config> -o <ZIP output path>
```

- `<phenotype model>` holds the phenotype definitions to be used for the query
- `<adapter config>` specifies the connection details to the patient data source
- `<query config>` contains the query parameters (optional)

Other options are available to control which phenotype classes will be considered for query execution and what output format shall be used.

### Analyses

The CLI provided the command `analysis` to perform calculations and generate reports based on query results (ZIP archives) that where previously generated from the TOP Framework.
Some analyses require additional configuration, which can be provided as YAML file using the `--config` option.

```sh
# list available analyses
java -jar top-phenotypic-query-x.x.x.jar analysis --help

# print the number of phenotype classes contained all provided query result archives
java -har top-phenotypic-query-x.x.x.jar analysis count-phenotypes query_result_1.zip query_result_2.zip
```
