---
layout: default
title: Data Adapter Configuration
parent: Administration
nav_order: 1
permalink: /administration/data-adapter-configuration
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

An adapter configuration consists of the following parts:

1. id, adapter class and connection properties (minimal adapter configuration)
2. subject (e.g., patient) query template
3. phenotype queries templates
4. code mappings (birth date mapping, age mapping, sex mapping, code mappings for other phenotype classes)

The first part is mandatory (see minimal adapter configuration), the rest is optional.

We recommend you to use 
[adapter_config_schema.json](https://github.com/Onto-Med/top-phenotypic-query/blob/main/src/main/resources/adapter_config_schema.json)
to create and validate your adapter configurations. For instance, [react-jsonschema-form](https://github.com/rjsf-team/react-jsonschema-form)
can be used to build a data adapter configuration via web forms.

You can find more example configurations at our [top-phenotypic-query tests](https://github.com/Onto-Med/top-phenotypic-query/tree/main/src/test/resources/config).

## Minimal Adapter Configuration

### Properties

| property            | description                                      |
| ------------------- | ------------------------------------------------ |
| id                  | name of the adapter, this value should be unique |
| adapter             | full Java class name of the adapter to be used   |
| connection.url      | IP or hostname to connect to                     |
| connection.user     | username for authentication                      |
| connection.password | password for authentication                      |
| connection.token    | token for HTTP bearer authentication             |

### Examples

#### FHIR Search

```yaml
id: Hapi_Adapter
adapter: care.smith.top.top_phenotypic_query.adapter.fhir.FHIRAdapter
connection:
  url: https://hapi.fhir.org/baseR4
```

The minimal FHIR configuration can be used if no further FHIR resources are needed than those already specified
in the default configuration (Patient, Condition, Observation, MedicationAdministration, MedicationStatement,
MedicationRequest, Procedure) and no mappings (codes, ranges, units) are required.

#### SQL

```yaml
id: SQL_Adapter
adapter: care.smith.top.top_phenotypic_query.adapter.sql.SQLAdapter
connection:
  url: jdbc:h2:mem:db
  user: user
  password: password
```

The minimal SQL configuration can be used if the following tables/views are provided in the source system and no
mappings are required.

``` sql
CREATE TABLE subject (
    subject_id bigint                   NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    birth_date timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sex        text                     NOT NULL,
    PRIMARY KEY (subject_id)
);

CREATE TABLE phenotype (
    phenotype_id    bigint                   NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    subject_id      bigint                   NOT NULL REFERENCES subject,
    created_at      timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    code_system     text                     NOT NULL,
    code            text                     NOT NULL,
    unit            text,
    number_value    numeric,
    text_value      text,
    date_time_value timestamp,
    boolean_value   boolean,
    PRIMARY KEY (phenotype_id)
);
```

## Subject Query Template

### Properties

| property              | description                                                                                                              |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| baseQuery             | this query is performed if there are no other restrictions to the subject set                                            |
| sexListPart           | additional restriction to the subject's sex that is appended to the baseQuery                                            |
| birthdateIntervalPart | additional restriction to the subject's birth date that is appended to the baseQuery                                     |
| output.sex            | name of the subject's sex column (SQL) or a FHIRPath expression to get the sex value in the resulting record set         |
| output.birthdate      | name of the subject's birth date column (SQL) or a FHIRPath expression to get the birth date in the resulting record set |

### Examples

#### FHIR Search

```yaml
subjectQuery: 
  baseQuery: 'Patient?_format=json'
  sexListPart: '&gender={values}'
  birthdateIntervalPart: '&birthdate{operator}{value}'
  output:
    sex: gender.value
    birthdate: birthDate
```

#### SQL

```yaml
subjectQuery:
  baseQuery: |-
    SELECT subject_id, birth_date, sex
    FROM subject
    WHERE TRUE
  sexListPart: ' AND sex IN ({values})'
  birthdateIntervalPart: ' AND birth_date {operator} {value}'
  output:
    id: subject_id
    sex: sex
    birthdate: birth_date
```

## Phenotype Queries Templates
This part of the configuration can hold one or more phenotype query definitions analogous to the subject queries.

### Examples

#### FHIR Search

```yaml
observation:
  baseQuery: 'Observation?code={codes}'
  numberValueIntervalPart: '&value-quantity{operator}{value}'
  numberValueListPart: '&value-quantity={values}'
  textValueListPart: '&value-string={values}'
  conceptValueListPart: '&value-concept={values}'
  dateTimeValueIntervalPart: '&value-date{operator}{value}'
  dateTimeIntervalPart: '&date{operator}{value}'
  output:
    subject: subject.reference.value
    numberValue: value.value
    textValue: value
    conceptValue: "value.coding.select(system.value + '|' + code)"
    dateTimeValue: value
    dateTime: effective
```

Depending on the phenotype class data type, the respective `output.xxx` (e.g., numberValue or textValue) is used
to extract the phenotype value, because different FHIRPath expressions have to be used for different data types.

#### SQL

```yaml
assessment:
  baseQuery: |-
    SELECT subject_id, created_at, {phenotype}
    FROM assessment1
    WHERE {phenotype} IS NOT NULL
  valueIntervalPart: ' AND {phenotype} {operator} {value}'
  valueListPart: ' AND {phenotype} IN ({values})'
  dateTimeIntervalPart: ' AND created_at {operator} {value}'
  output:
    subject: subject_id
    value: '{phenotype}'
    dateTime: created_at
```

In SQL, the distinction between different data types is not relevant at this point, because only the database
column name has to be specified (value: "{phenotype}").

Query templates use placeholders/variables like `{codes}` or `{phenotype}`. The values for these variables are
derived from the phenotype class specification (e.g., codes associated with the phenotype class) or from the
code mappings (e.g. column name in a database table) as described in the next section.

## Code Mappings (relevant for both SQL and FHIR)

Mappings for the following aspects can be added to the adapter configuration:

* birth date
* subject age
* sex
* other phenotype classes

All of them require a property `code` that contains a code from a standard terminology
(e.g., 'http://loinc.org|3141-9'). These codes are used to identify phenotype class definitions
contained in a TOP phenotype model, to which the mapping should be applied to.

### Properties

| property            | description                                                                                                                   |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| code                | identifies phenotype class definitions the mapping is applied to                                                              |
| type                | in case of `codeMappings` this property refers to the `phenotypeQueries` entry to be used for the query execution             |
| unit                | the UCUM unit that is used in the database or FHIR server, values will be converted automatically to the phenotype class unit |
| restrictionMappings | overwrites restriction ranges of the phenotype class                                                                          |
| phenotypeMappings   | defines variable values for query templates                                                                                   |

### Example

```yaml
birthdateMapping:
  code: http://loinc.org|21112-8
ageMapping:
  code: http://loinc.org|30525-0
  restrictionMappings:
    - model: [ '>=', 18, '<', 34 ]
      source: [ '>=', 19, '<', 34 ]
sexMapping:
  code: http://loinc.org|46098-0
  restrictionMappings:
    - model: [ http://hl7.org/fhir/administrative-gender|male ]
      source: [ male ]
    - model: [ http://hl7.org/fhir/administrative-gender|female ]
      source: [ female ]
    - model: [ http://hl7.org/fhir/administrative-gender|other ]
      source: [ other ]
    - model: [ http://hl7.org/fhir/administrative-gender|unknown ]
      source: [ unknown ]
codeMappings:
  - code: http://loinc.org|3137-7
    type: assessment
    unit: cm
    phenotypeMappings:
      phenotype: height
  - code: http://loinc.org|3141-9
    type: assessment
    phenotypeMappings:
      phenotype: weight
```
