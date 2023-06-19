# Caddy settings:
BASE_URL=http://127.0.0.1
APP_PATH=/api

# TOP Framework related settings:
DB_NAME=postgres
DB_USER=postgres
DB_PASS=password # You should change this value!
DB_NEO4J_USER=neo4j
DB_NEO4J_PASS=password # You should change this value!
API_URL=${BASE_URL}${APP_PATH}
DATA_SOURCE_CONFIG_DIR=/configs
QUERY_RESULT_DIR=/data/query_results
TERMINOLOGY_SERVICE_ENDPOINT=https://www.ebi.ac.uk/ols/api
GDPR_NOTICE=false
GDPR_POLICY_URL=
SYSTEM_NOTICE=

# PostgreSQL settings
POSTGRES_DB=${DB_NAME}
POSTGRES_USER=${DB_USER}
POSTGRES_PASSWORD=${DB_PASS}

# Neo4J settings
NEO4J_AUTH=${DB_NEO4J_USER}/${DB_NEO4J_PASS}

# If you want to protect both, front and backend with an authentication server, please modify below variables
OAUTH2_ENABLED=false
OAUTH2_URL=http://127.0.0.1/auth
OAUTH2_REALM=top-realm
OAUTH2_CLIENT_ID=top-frontend
