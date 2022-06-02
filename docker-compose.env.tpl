DB_USER=neo4j
DB_PASS=password
NEO4J_AUTH=${DB_USER}/${DB_PASS}

# If you want to protect both, front and backend with an authentication server, please use the image top-frontend:latest-auth and modify below variables
OAUTH2_ENABLED=false
OAUTH2_URL=http://127.0.0.1:8081
OAUTH2_REALM=top-realm
OAUTH2_CLIENT_ID=top-frontend
