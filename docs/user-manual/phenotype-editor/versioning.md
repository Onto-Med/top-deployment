---
layout: default
title: Versioning
parent: Phenotype Editor
grand_parent: User Manual
nav_order: 2
permalink: /user-manual/phenotype-editor/versioning
---

# Versioning
Whenever you are creating or changing an entity, a new version is created. You can see the current version of an entity on the top of the entities tab (see figure 1).

![Version displayed at the top of the Entity tab](../../assets/images/phenotype-editor-version.png)

_Figure 1: Entity version is displayed at the top of the entity tab._

By clicking the clock in the top right corner, all versions of the entity are displayed. You can jump to previous versions by left clicking on one of them.

![Entity history](../../assets/images/phenotype-editor-history.png)

_Figure 2: Version list of the entity 'Height'._

You will enter a read-only mode of the selected version. In this mode you can examine the metadata of that version and restore it by clicking the 'Restore' button.

All versions of an entity can be referenced at any time by adding the version number as query parameter to the entities URL.

e.g.: <https://top.imise.uni-leipzig.de/imise/bmi_example/086cd9d0-3f2f-40c8-bd12-af326dfc2944?version=4> (notice the '?version=4' section at the end of the URL)

If the specified version no longer exists, you will be redirected to the current version of the entity.
