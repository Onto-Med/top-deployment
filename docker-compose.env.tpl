DB_USER=neo4j
DB_PASS=password
NEO4J_AUTH=${DB_USER}/${DB_PASS}

# If you want to protect both, front and backend with an authentication server, please use the image top-frontend:latest-auth and modify below variables
OAUTH2_ENABLED=false
OAUTH2_PROTOCOL=http
OAUTH2_HOST=127.0.0.1
OAUTH2_PORT=8081
OAUTH2_URL=${OAUTH2_PROTOCOL}://${OAUTH2_HOST}:${OAUTH2_PORT}/
OAUTH2_REALM=top-realm
OAUTH2_CLIENT_ID=top-frontend