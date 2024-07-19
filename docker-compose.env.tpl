# The TOP Framework uses the web server Caddy to proxy incoming requests to underlying Docker containers.
# Caddy supports automatic HTTPS. You can find more information on: https://caddyserver.com
# The BASE_URL variable is also used to configure the URL, the frontend sends it's requests to.
BASE_URL=http://localhost

# Use the variable APP_PATH to configure on what path the backend is running. This path will be appended
# to BASE_URL.
APP_PATH=/api

# Setting this variable to true will create a demo organisation with a small BMI phenotype model on startup.
IMPORT_DEMO_DATA=false

# These are the parameters to connect to the TOP Framework PostgreSQL DB. If you want to use an external
# PostgreSQL DB, modify the variables below as needed and disable the docker compose 'db' service.
DB_NAME=postgres
DB_USER=postgres
DB_PASS=password # You should change this value!

# Above variables are also used to configure the docker compose 'db' service.
POSTGRES_DB=${DB_NAME}
POSTGRES_USER=${DB_USER}
POSTGRES_PASSWORD=${DB_PASS}

# The API URL is used by the frontend to access the backend. It is built from BASE_URL and APP_PATH.
# In some cases it might be required to change this URL.
API_URL=${BASE_URL}${APP_PATH}

# Adapter configuration files can be stored in a folder and mounted to the docker compose 'backend'
# service. The variable DATA_SOURCE_CONFIG_DIR is used to modify the location where the backend looks
# for configuration files.
DATA_SOURCE_CONFIG_DIR=/configs

# The variable QUERY_RESULT_DIR can be used to modify the location where phenotype query results are
# stored as ZIP files.
QUERY_RESULT_DIR=/data/query_results

# The backend can query terms from an OLS (v4) instance. The API endpoint of that instance is configured
# with TERMINOLOGY_SERVICE_ENDPOINT
TERMINOLOGY_SERVICE_ENDPOINT=https://www.ebi.ac.uk/ols4/api

# If you want the frontend to show a GDPR conform cookie notification, you can set the variable
# GDPR_NOTICE to true. Users can accept the notification and it will not be displayed until cookies
# expire or are deleted.
GDPR_NOTICE=false

# The optional GDPR_POLICY_URL variable can be used to specify a link that will be added to the GDPR
# notification. The label of that link becomes 'Learn more'.
GDPR_POLICY_URL=

# Use the variable SYSTEM_NOTICE to specify a system notification text that is displayed in the
# frontend. Users can dismiss the alert box containing the text.
SYSTEM_NOTICE=

##
# Document search related settings. You can ignore this section if DOCUMENTS_ENABLED is false.
##
DOCUMENTS_ENABLED=false

# Location of document data source configuration files.
DOCUMENT_DATA_SOURCE_CONFIG_DIR=config/data_sources/nlp

# Use the following variables to configure the Neo4j authentication parameters.
DB_NEO4J_USER=neo4j
DB_NEO4J_PASS=password # You should change this value!

# Above variables are also used to configure the docker compose 'neo4j' service.
NEO4J_AUTH=${DB_NEO4J_USER}/${DB_NEO4J_PASS}

# Timeout in seconds for requests to Neo4j.
DB_NEO4J_CONNECTION_TIMEOUT=30s

# Endpoint of the concept-graphs service. See https://github.com/Onto-Med/concept-graphs for documentation.
CONCEPT_GRAPHS_API_ENDPOINT=http://localhost:9007

##
# Authentication
##

# If you want to protect both, front and backend with an authentication server, please set
# OAUTH2_ENABLED to true and modify below variables.
OAUTH2_ENABLED=false
OAUTH2_URL=http://127.0.0.1/auth
OAUTH2_REALM=top-realm
OAUTH2_CLIENT_ID=top-frontend

##
# Logging
##

# Spring uses Logback by default: TRACE, DEBUG, INFO, WARN, ERROR
LOG_LEVEL_SPRING=WARN
LOG_LEVEL_LIQUIBASE=WARN
# https://docs.liquibase.com/concepts/connections/liquibase-environment-variables.html
LIQUIBASE_LOG_LEVEL=${LOG_LEVEL_LIQUIBASE}
LOG_LEVEL_HIBERNATE=WARN
# Java Util Logging: FINEST, FINER, FINE, CONFIG, INFO, WARNING, SEVERE
LOG_LEVEL_JUL=WARNING
JAVA_OPTS=-Djava.util.logging.ConsoleHandler.level=${LOG_LEVEL_JUL} -Dlogging.level.org.springframework=${LOG_LEVEL_SPRING} -Dlogging.level.liquibase=${LOG_LEVEL_LIQUIBASE} -Dlogging.level.org.hibernate=${LOG_LEVEL_HIBERNATE}
# Some JDKs only pick this up instead of JAVA_OPTS
JAVA_TOOL_OPTIONS=${JAVA_OPTS}
