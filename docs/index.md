---
layout: default
title: Home
nav_order: 1
description: "Terminology- and Ontology-based Phenotyping Framework"
permalink: /
---

# TOP Framework
{: .fs-9 }

Terminology- and Ontology-based Phenotyping Framework
{: .fs-6 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 } [View it on GitHub](https://github.com/Onto-Med/top-deployment){: .btn .fs-5 .mb-4 .mb-md-0 }

---

The TOP Framework enables users to model phenotypes according to the [Core Ontology of Phenotypes](https://github.com/Onto-Med/COP). It also inclused a custom reasoning engine and query service for classification of individual data and searching in data repositories (e.g., Health Data Stores).

## Getting started
Follow these instructions to set up the TOP framework:

1. Clone the repository

        git clone https://github.com/Onto-Med/top-deployment.git
        cd top-deployment
2. Modify the environment variables as needed
3. Log in to GitHub Container Registry with personal access token

        echo $PAT | docker login ghcr.io --username <username> --password-stdin
4. Use Docker Compose to startup the TOP Framework services

        docker compose up -d

## About the project
The TOP Framework is currently under heavy development. Do not use it in a production environment!

### License
The source code of the components is currently closed source and not licensed for distribution or use.
