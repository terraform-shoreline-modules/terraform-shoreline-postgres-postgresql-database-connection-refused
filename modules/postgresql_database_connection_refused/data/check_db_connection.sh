

#!/bin/bash



# Define variables

DB_HOST=${POSTGRES_HOST}

DB_PORT=${POSTGRES_PORT}



# Check if the database port is accessible

nc -zv $DB_HOST $DB_PORT



# Check if DNS resolution is successful

ping -c 1 $DB_HOST