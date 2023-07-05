---
layout: default
title: Data Adapter Configuration
parent: Administration
nav_order: 1
permalink: /administration/adapter-configuration
---

# Data Adapter Configuration
{: .no_toc }

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
The TOP Framework provides two inbuilt data adapters for querying SQL databases and FHIR Search (R4) services:

* [`care.smith.top.top_phenotypic_query.adapter.sql.SQLAdapter`](https://github.com/Onto-Med/top-phenotypic-query/blob/main/src/main/java/care/smith/top/top_phenotypic_query/adapter/sql/SQLAdapter.java)
* [`care.smith.top.top_phenotypic_query.adapter.fhir.FHIRAdapter`](https://github.com/Onto-Med/top-phenotypic-query/blob/main/src/main/java/care/smith/top/top_phenotypic_query/adapter/fhir/FHIRAdapter.java)

Both are configurable via YAML files. The idea is to have one YAML file for each database or FHIR Search
service, you want to connect the TOP Framework to. A JSON schema specification for these configuration files
is available here: [adapter_config_schema.json](https://github.com/Onto-Med/top-phenotypic-query/blob/main/src/main/resources/adapter_config_schema.json)

There are also some default configurations provided by these files:

* [Default_SQL_Adapter.yml](https://github.com/Onto-Med/top-phenotypic-query/blob/main/src/main/resources/default_adapter_configuration/Default_SQL_Adapter.yml)
* [Default_FHIR_Adapter.yml](https://github.com/Onto-Med/top-phenotypic-query/blob/main/src/main/resources/default_adapter_configuration/Default_FHIR_Adapter.yml)

Because connection properties are needed in order to connect to a database or FHIR Search service, above listed
default configurations are not sufficient. They just provided some default values that will be merged into your
configuration files automatically.

In case of the public HAPI FHIR server, the following data adapter configuration is sufficient:

```yaml
id: Hapi_Adapter
adapter: care.smith.top.top_phenotypic_query.adapter.fhir.FHIRAdapter
connection:
  url: https://hapi.fhir.org/baseR4
```

You can find more example configurations at our [top-phenotypic-query tests](https://github.com/Onto-Med/top-phenotypic-query/tree/main/src/test/resources/config).

## Configuration Property Descriptions
In the next sections, all configuration properties are described in detail. However, we recommend you to use 
[adapter_config_schema.json](https://github.com/Onto-Med/top-phenotypic-query/blob/main/src/main/resources/adapter_config_schema.json)
to create and validate your adapter configurations. For instance, [react-jsonschema-form](https://github.com/rjsf-team/react-jsonschema-form)
can be used to build a data adapter configuration via web forms.

### Preamble
| property            | description                                         | example value                     |
| ------------------- | --------------------------------------------------- | --------------------------------- |
| id                  | name of the adapter, this value should be unique    | Example Adapter                   |
| adapter             | full Java class name of the adapter to be used      | `care.smith.[...].sql.SQLAdapter` |
| connection.url      | IP or hostname to connect to                        | example.com:5432                  |
| connection.user     | username for authentication (SQL adapter)           | dummy_user                        |
| connection.password | password for authentication (SQL adapter)           | strong_password                   |
| connection.token    | token for HTTP bearer authentication (FHIR adapter) | example_token                     |

### Subject Query (relevant for SQL)
| property              | description                                                                          | example value                                              |
| --------------------- | ------------------------------------------------------------------------------------ | ---------------------------------------------------------- |
| baseQuery             | this query is performed if there are no other restrictions to the subject set        | SELECT subject_id, birth_date, sex FROM subject WHERE TRUE |
| sexListPart           | additional restriction to the subject's sex that is appended to the baseQuery        | AND sex IN ({values})                                      |
| birthdateIntervalPart | additional restriction to the subject's birth date that is appended to the baseQuery | AND birth_date {operator} {value}                          |
| output.id             | name of the subject ID column in the resulting record set                            | subject_id                                                 |
| output.sex            | name of the subject's sex column in the resulting record set                         | sex                                                        |
| output.birthdate      | name of the subject's birth date column in the resulting record set                  | birth_date                                                 |

### Phenotype Queries (relevant for SQL)
This part of the configuration can hold one or more query definitions with the properties listed
below. They are analogous to the properties of subject queries.

| property             | example value                                                                             |
| -------------------- | ----------------------------------------------------------------------------------------- |
| baseQuery            | SELECT subject_id, created_at, {phenotype} FROM assessment1 WHERE {phenotype} IS NOT NULL |
| dateTimeIntervalPart | AND created_at {operator} {value}                                                         |
| subjectsPart         | AND subject_id IN ({values})                                                              |
| valueIntervalPart    | AND {phenotype} {operator} {value}                                                        |
| valueListPart        | AND {phenotype} IN ({values})                                                             |
| output.subject       | subject_id                                                                                |
| output.dateTime      | created_at                                                                                |
| output.dateTimeValue | {phenotype} or date_time_value                                                            |
| output.numberValue   | {phenotype} or number_value                                                               |
| output.textValue     | {phenotype} or text_value                                                                 |
| output.value         | {phenotype} or value                                                                      |

Above examples use placeholders like `{phenotype}`, where the actual column name is derived from
the code mappings as described in the next section.

Depending on the phenotype class data type, the respective `output.xxx` is used to extract the
phenotype value.

### Mappings (relevant for both SQL and FHIR)

Mappings for the following aspects can be added to the adapter configuration:

* birth date
* subject age
* sex
* code

All of them require a property `code` that contains a code from a standard terminology
(e.g., 'http://loinc.org|3141-9'). These codes are used to identify phenotype class definitions
contained in a TOP phenotype model, to which the mapping should be applied to.

| property | description                                                                                                                   | example value             |
| -------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| code     | identifies phenotype class definitions the mapping is applied to                                                              | `http://loinc.org|3141-9` |
| type     | in case of `codeMappings` this property refers to the `phenotypeQueries` entry to be used for the query execution             | default                   |
| unit     | the UCUM unit that is used in the database or FHIR server, values will be converted automatically to the phenotype class unit | cm                        |

Mappings can overwrite restriction ranges an phenotype classes to be used for a given code from
the SQL database or FHIR server. Use the properties `restrictionMappings` and `phenotypeMappings`
which are comprised as follows:

#### Restriction Mappings
| property       | description | example value |
| -------------- | ----------- | ------------- |
| model (array)  |             |               |
| source (array) |             |               |

#### Phenotype Mappings
| property  | description | example value |
| --------- | ----------- | ------------- |
| codes     |             |               |
| phenotype |             |               |
