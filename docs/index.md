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

The TOP Framework enables users to model phenotypes according to the [Core Ontology of Phenotypes](https://github.com/Onto-Med/COP). It also includes a custom reasoning engine and query service for classification of individual data and searching in data repositories (e.g., Health Data Stores).

## Getting started
Follow these instructions to set up the TOP framework:

1. Clone this repository

        git clone https://github.com/Onto-Med/top-deployment.git
        cd top-deployment
2. Copy [docker-compose.env.tpl](docker-compose.env.tpl) and modify it as needed

        cp docker-compose.env.tpl docker-compose.env
3. Log in to GitHub Container Registry with personal access token

        echo $PAT | docker login ghcr.io --username <username> --password-stdin
4. Use Docker Compose to startup the TOP Framework services

        docker compose up -d

All data will be stored in the Docker volume `top-data` (see declaration at the end of [docker-compose.yml](docker-compose.yml)).
Feel free to update this volume configuration (e.g., make it external or provide an absolute path on the host).

### Add Data Adapter Configurations
You can create data adapter configuration files and mount them into the `backend` container by modifying [docker-compose.yml](docker-compose.yml). For a detailed specification of the configuration files, see [top-phenotypic-query](https://github.com/Onto-Med/top-phenotypic-query).

```yml
services:
  backend:
    # ...
    volumes:
      - top-data-adapter-configs:/configs
volumes:
  top-data-adapter-configs:
    # volume settings
```

### Protection with OAuth2
If you want to protect front and backend with OAuth2 authentication, you must set up a [Keycloak](https://hub.docker.com/r/jboss/keycloak/) server and use an "*-auth" variant of the top-frontend image.
You may also need to modify the configurations in `docker-compose.env.tpl`.

Example Keycloak startup:

```bash
docker run -p 8081:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin quay.io/keycloak/keycloak:18.0.0 --spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true start-dev
```

After starting Keycloak, log in with admin credentials and perform the following tasks:
1. Create a new realm (e.g.: "top-realm")
2. Create a new client for that realm (e.g.: "top-frontend"). Make sure to modify the URLs in the client configuration to match your TOP Frontend instance.

The TOP Frontend should now display a login button in the top right corner. If a visitor clicks on that button he will be redirected to the Keycloak login page. After a successful login he will be redirected back to the TOP Frontend.

At it's current state the TOP Framework does not have a permission system, which means that all users with valid accounts are able to access and manipulate all content. In a future update we will modify the connection to Keycloak, so that administrators can define their own permissions in Keycloak.

## About the project
The TOP Framework is currently under heavy development. Do not use it in a production environment!

### License
The source code of the TOP Framework components is currently closed source and not licensed for distribution or use.
