

#!/bin/bash



# Define variables

POSTGRESQL_PORT=${POSTGRES_PORT}



# Allow traffic from PostgreSQL port in iptables

iptables -A INPUT -p tcp --dport $POSTGRESQL_PORT -j ACCEPT

iptables-save > /etc/sysconfig/iptables



# Check if iptables rules have been updated

iptables -L



echo "PostgreSQL port $POSTGRESQL_PORT has been allowed in iptables."