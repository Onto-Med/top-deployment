---
layout: default
title: Query Builder
parent: User Manual
nav_order: 2
has_children: false
---

# Query Builder
{: .no_toc }

Build and perform phenotypic queries.
{: .fs-6 .fw-300 }

The Query Builder enables users to construct phenotypic queries with phenotypes of a repository.
Queries can be executed against one or more data sources to get result sets with matching subjects (i.e., patients and study participants).

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Access the Query Builder
In order to access the query builder and start building your query, you first have to navigate to the repository from which you want to build the query.

Click on the button "Build query" above the entity tree on the left side (see figure 1).

!["Build query" button](../assets/images/query-builder-access.png)
_Figure 1: Press the "Build query" button to open the query builder._

## Build a Query
The query building is divided in multiple steps, which will be described in the next few sections.

### General Configuration
In the first step you can define a name for the query and select one ore more data sources, on which you want to perform the query.

There is also an option to import a previously exported query setup.

![General query configuration](../assets/images/query-builder-configuration.png)
_Figure 2: General configuration of a query._

### In- and Exclusion Criteria
Left click on phenotypes in the tree on the left side to add them as inclusion criteria to your query. If you want to convert them to an exclusion criterion, you can use the sliders on front of each criteria. In the example in figure 3, the phenotype BMI has be marked as exclusion criterion. You can remove criteria by clicking the minus button behind each criteria.

![Query criteria](../assets/images/query-builder-criteria.png)
_Figure 3: A simple selection of query criteria. BMI is an exclusion criterion._

Advanced queries can be build by specifying age or time restrictions for criteria. For instance, you can query for subjects with height values in ranges 4-8 years **or** 12-16 years (see figure 4). You can also add multiple entries of a phenotype to the criteria list and specify different age/time ranges for each entry. In contrast to the example in figure 4, the ranges will then be concatenated with an and operator. For example, height values in ranges 4-8 years **and** 12-16 years.

![Restrictions for criterion "height"](../assets/images/query-builder-criteria-restrictions.png)
_Figure 4: Example restrictions for criterion "height", they are concatenated with an or operator._

### Projection
In the step "Define Result set" you can select phenotypes that you want to include in your result set ("projection"). For each projection entry you can select a sorting direction. The arrows in front of each entry are for rearranging the entries.

![Example projection](../assets/images/query-builder-projection.png)
_Figure 5: Example projection on weight and BMI._

## Execute a Query
In the step "Closure" you can select whether you want to export your current query settings for later use or execute the current query. If you execute the query, the result will be displayed below. You can adjust a query and execute it multiple times. All results will be listed below in chronological order.

![Query closure](../assets/images/query-builder-closure.png)
_Figure 6: Query closure and execution._