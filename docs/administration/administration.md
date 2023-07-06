---
layout: default
title: Administration
nav_order: 3
has_children: true
permalink: /administration
---

# Administration
{: .no_toc }

The TOP Framework consists of:

* **Frontend:** [Vue.js](https://vuejs.org) and [Quasar](https://quasar.dev) based Single-Page Application ([top-frontend](https://github.com/Onto-Med/top-frontend))
* **Backend:** [Spring Boot Resource Server](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/index.html) ([top-backend](https://github.com/Onto-Med/top-backend))

## Getting started
Follow these instructions to set up the TOP framework:

1. Clone this repository

        git clone https://github.com/Onto-Med/top-deployment.git
        cd top-deployment
2. Copy [docker-compose.env.tpl](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.env.tpl) and modify it as needed

        cp docker-compose.env.tpl docker-compose.env
3. Use Docker Compose to startup the TOP Framework services

        docker compose up -d

If you didn't modify docker-compose.env, you can now access the framework at <http://localhost> in your browser.

All data will be stored in the Docker volume `top-data` (see declaration at the end of [docker-compose.yml](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.yml)).
Feel free to update this volume configuration (e.g., make it external or provide an absolute path on the host).

### Use SSL
The TOP Framework uses [Caddy](https://caddyserver.com) as reverse proxy. Caddy is able to automatically generate SSL certs for you.

Do the following to enable SSL:

1. Add a port mapping for port 443 to docker compose service 'caddy'

        services:
          caddy:
            # ...
            ports:
              - 80:80
              - 443:443
2. Modify the environment variable `BASE_URL` in `docker-compose.env` to something like: 'https://your.domain'
3. Restart the docker compose stack

        docker compose up -d

### Add Plugins
Plugins can be provided as JAR files (dependencies must be included too, see for example [Apache Maven Assembly Plugin](https://maven.apache.org/plugins/maven-assembly-plugin/usage.html)).
You just have to place those JAR files in a directory and mount it to `\plugins` directory of the backend container.

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
You can create data adapter configuration files and mount them into the `backend` container by modifying [docker-compose.yml](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.yml). For a detailed specification of the configuration files, see [Data Adapter Configuration](./administration/data-adapter-configuration).

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
If you want to protect front and backend with OAuth2 authentication, you must set up a [Keycloak](https://hub.docker.com/r/jboss/keycloak/) server.
Respective Keycloak containers are already included in the [docker-compose.yml](https://github.com/Onto-Med/top-deployment/blob/main/docker-compose.yml) file (use docker compose profile "auth", e.g.: `docker compose --profile auth up -d`).

You may also need to modify the configurations in `docker-compose.env.tpl`.

If Keycloak is run for the first time, you need to create an admin account:

```sh
docker compose exec keycloak /opt/jboss/keycloak/bin/add-user-keycloak.sh -u <USERNAME> -p <PASSWORD>
docker compose restart keycloak
```

After starting Keycloak, log in with admin credentials and perform the following tasks:
1. Create a new realm (e.g.: "top-realm")
2. Create a new client for that realm (e.g.: "top-frontend"). Make sure to modify the URLs in the client configuration to match your TOP Frontend instance.

The TOP Frontend should now display a login button in the top right corner. If a visitor clicks on that button they will be redirected to the Keycloak login page.
After a successful login they will be redirected back to the TOP Frontend.
