# TOP Framework Deployment
This repository contains deployment instructions and resources for the TOP Framework.

The TOP Framework consists of:

* **Frontend:** [Vue.js](https://vuejs.org) and [Quasar](https://quasar.dev) based Single-Page Application ([top-frontend](https://github.com/Onto-Med/top-frontend))
* **Backend:** [Spring Boot Resource Server](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/index.html) ([top-backend](https://github.com/Onto-Med/top-backend))
* **Database:** [Neo4j](https://neo4j.com)

## State of the Project
The TOP Framework is currently under heavy development. Do not use it in a production environment!

## Usage
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

## Protection with OAuth2
If you want to protect front and backend with OAuth2 authentication, you must set up a [Keycloak](https://hub.docker.com/r/jboss/keycloak/) server and use an "*-auth" variant of the top-frontend image.
You may also need to modify the configurations in `docker-compose.env.tpl`.

Example Keycloak startup:

```bash
docker run -p 8081:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin quay.io/keycloak/keycloak:18.0.0 --spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true start-dev
```
