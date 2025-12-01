---
layout: default
title: Administration
nav_order: 3
has_children: true
permalink: /administration
---

# Administration
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Overview

The TOP Framework consists of:

- **Frontend:** [Vue.js](https://vuejs.org) and [Quasar](https://quasar.dev) based Single-Page Application ([top-frontend](https://github.com/Onto-Med/top-frontend))
- **Backend:** [Spring Boot Resource Server](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/index.html) ([top-backend](https://github.com/Onto-Med/top-backend))

In addition, the framework uses the following services:

- **PostgreSQL:** Database for the backend ([postgres](https://www.postgresql.org))
- *optional:* **Concept Graphs:** Service for concept graphs ([concept-graphs](https://github.com/Onto-Med/concept-graphs))
- *optional:* **Neo4j:** Graph database for storing concept graphs ([neo4j](https://neo4j.com))
- *optional:* **Elasticsearch:** Search engine for documents ([elasticsearch](https://www.elastic.co/elasticsearch/))
- *optional:* **Caddy:** Reverse proxy and SSL certificate management ([caddy](https://caddyserver.com))
- *optional:* **Keycloak:** Identity and Access Management ([keycloak](https://www.keycloak.org))

## Getting started

Follow these instructions to set up the TOP framework:

1. Clone this repository.

   ```sh
   git clone https://github.com/Onto-Med/top-deployment.git
   cd top-deployment
   ```

2. Copy [docker-compose.env.tpl](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.env.tpl) and modify it as needed.

   ```sh
   cp docker-compose.env.tpl docker-compose.env
   ```

3. Use Docker Compose to startup the TOP Framework services.

   ```sh
   docker compose up -d
   ```

If you didn't modify docker-compose.env, you can now access the framework at <http://localhost> in your browser.

All data will be stored in the Docker volumes `top-data`, `top-neo4j-data`, and `query-results` (see declaration at the end of [docker-compose.yml](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.yml)).
We suggest to use external volumes for production deployments, so that data is not lost when the containers are removed.
You can do this by modifying the `volumes` section in [docker-compose.yml](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.yml).

```yml
volumes:
  top-data:
    external: true
  neo4j-data:
    external: true
  query-results:
    external: true
```

This also applies to the volume `keycloak-data` if you are using Keycloak for authentication.

### How to Upgrade

1. Stop the services and backup your Docker volumes. See [Official Docker Documentation](https://docs.docker.com/engine/storage/volumes/#back-up-restore-or-migrate-data-volumes).
2. Pull changes from this repository.

   ```sh
   cd top-deployment
   git pull
   ```

3. Review [docker-compose.env.tpl](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.env.tpl) for new environment variables.
4. Pull Docker images and recreate containers.

   ```sh
   docker compose up --pull always -d
   ```

### Use SSL

The TOP Framework uses [Caddy](https://caddyserver.com) as reverse proxy. Caddy is able to automatically generate SSL certs for you.

Do the following to enable SSL:

1. Add a port mapping for port 443 to docker compose service 'caddy'

   ```yml
   services:
     caddy:
       # ...
       ports:
         - 80:80
         - 443:443 # <- add this line
   ```

2. Modify the environment variable `BASE_URL` in `docker-compose.env` to something like: `https://your.domain>`
3. Restart the docker compose stack

   ```sh
   docker compose up -d
   ```

### Add Plugins

Plugins can be provided as JAR files (dependencies must be included too, see for example [Apache Maven Assembly Plugin](https://maven.apache.org/plugins/maven-assembly-plugin/usage.html)).
You just have to place those JAR files in a directory and mount it to the `\plugins` directory of the backend container.

```yml
services:
  backend:
    # ...
    volumes:
      - top-plugins-dir:/plugins
  volumes:
    top-plugins-dir:
      # volume settings
```

More information about backend plugins is available at the [top-backend documentation](https://github.com/Onto-Med/top-backend#plugins).

### Add Data Adapter Configurations

You can create data adapter configuration files and mount them into the `backend` container by modifying [docker-compose.yml](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.yml).
In this example, we assume that the data source configurations reside in the `./configs` folder.
To make a data source available to an organization and all of its repositories, an administrator has to add the data source in the organization page via the "Manage"->"Data sources" menu.
For a detailed specification of the configuration files, see [Data Adapter Configuration](./administration/data-adapter-configuration).

```yml
services:
  backend:
    # ...
    volumes:
      - ./configs:/configs:ro
```

There is also an option to upload specific formats to create a data source that is directly stored in the backend database.
We currently support the upload of FHIR and CSV files.
After the upload has finished, you can enable the data source for any organization.
Navigate to the organization page and select "Manage"->"Data sources" to do so.

![Manage data sources](assets/images/manage-data-sources.png)

### NLP/Document related configuration

To utilize the document search of the framework, one needs three different services running:

1. Elasticsearch or something similar
2. A Neo4j cluster
3. And the [concept graphs service](https://github.com/Onto-Med/concept-graphs)

The document search is adapter-centric and requires a working configuration file (YAML) that specifies the addresses of the above services
in the folder declared with the `DOCUMENT_DATA_SOURCE_CONFIG_DIR` environment variable.
If no `DOCUMENT_DEFAULT_ADAPTER` is specified, the first adapter found in the folder is used for setup.

Similarly to data adapter configurations, document adapter configurations must be mounted into the backend Docker container.

For convenience reasons, the default value of `DOCUMENT_DATA_SOURCE_CONFIG_DIR` is `/configs/nlp`, which means that you can create a sub folder `nlp` in the host systems `configs` folder and reuse the Docker mount configuration from [NLP/Document related configuration](#add-data-adapter-configurations).

### Protection with OAuth2

If you want to protect front and backend with OAuth2 authentication, you must set up a [Keycloak](https://quay.io/repository/keycloak/keycloak?tab=info) server.
Respective Keycloak containers are already included in the [docker-compose.yml](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.yml) file (use docker compose profile "auth", e.g.: `docker compose --profile auth up -d`).

You may also need to modify the configurations in `docker-compose.env`.

If you are running Keycloak for the first time, you need to create an admin account.
In the `docker-compose.yml` file, set the environment variables `KC_BOOTSTRAP_ADMIN_USERNAME` and `KC_BOOTSTRAP_ADMIN_USERNAME_PASSWORD` to your desired username and password, respectively.
After the first startup, these variables can be removed.

After starting Keycloak, log in with the admin credentials and perform the following tasks:

1. Create a new realm (e.g.: "top-realm").
   The name should match the `OAUTH2_REALM` environment variable in `docker-compose.env`.
2. Create a new client for that realm (e.g.: "top-frontend").
   The name should match the `OAUTH2_CLIENT_ID` environment variable in `docker-compose.env`.

   - *Root URL*: `http://localhost/auth` (or your domain if you are using SSL)
   - *Valid Redirect URIs* and *Web Origins*: `http://localhost/*` (or your domain if you are using SSL)
   - *Valid post logout redirect URIs*: `+`

3. Optionally, you can create a user group (e.g.: "top-managers") with roles "manage-users", "query-users", "view-realm", and "view-users".
   Assign users to this group to allow them to manage users in the TOP Framework.
   They can log in at <http://localhost/auth/admin/top-realm/console>.

The TOP Frontend should now display a login button in the top right corner.
If a visitor clicks on that button they will be redirected to the Keycloak login page.
After a successful login, they will be redirected back to the TOP Frontend.

## Troubleshoot

- **`java.lang.OutOfMemoryError` when running queries:**

  Depending on the query complexity and the amount of data available in a data source, queries may require a lot of memory (RAM).
  You can increase the Java Runtime Environment's maximum Java heap size with the [-Xmx option](https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html#wp999528).

  Override the `entrypoint` of the `backend` service in the [docker-compose.yml](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.yml) file:

  ```sh
  services:
    backend:
      # set maximum heap size to 4GB
      entrypoint: java -Xmx4G -cp top-backend.jar:/plugins/* org.springframework.boot.loader.PropertiesLauncher
      # other options...
  ```
