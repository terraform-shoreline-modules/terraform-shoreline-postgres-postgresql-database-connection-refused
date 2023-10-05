
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# PostgreSQL database connection refused.
---

This incident type occurs when a software system is unable to establish a connection to a PostgreSQL database due to the database server refusing the connection. This can be caused by a variety of factors such as network issues, incorrect credentials, or the database server being unavailable. This can lead to the system being unable to perform necessary database operations, which can impact the functionality of the software system.

### Parameters
```shell
export POSTGRES_PORT="PLACEHOLDER"

export POSTGRESQL_CONF_FILE="PLACEHOLDER"

export POSTGRES_DATABASE="PLACEHOLDER"

export POSTGRES_USER="PLACEHOLDER"

export POSTGRES_HOST="PLACEHOLDER"

export POSTGRES_LOG_FILE="PLACEHOLDER"
```

## Debug

### Check if PostgreSQL service is running
```shell
systemctl status postgresql.service
```

### Check if the PostgreSQL server is listening to incoming connections on the correct port
```shell
ss -nlt | grep ${POSTGRES_PORT}
```

### Check if the PostgreSQL server is listening on the correct IP address
```shell
cat ${POSTGRESQL_CONF_FILE} | grep listen_addresses
```

### Try to connect to the PostgreSQL database using the psql client and the correct credentials
```shell
psql -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} -d ${POSTGRES_DATABASE}
```

### Check the PostgreSQL server logs for errors or messages related to connection issues
```shell
tail -n 50 ${POSTGRES_LOG_FILE}
```

### Check the PostgreSQL server configuration file for any settings that may be causing connection issues
```shell
cat ${POSTGRESQL_CONF_FILE}
```

### Network connectivity issues such as firewall blocking the database connection port or DNS resolution failure.
```shell


#!/bin/bash



# Define variables

DB_HOST=${POSTGRES_HOST}

DB_PORT=${POSTGRES_PORT}



# Check if the database port is accessible

nc -zv $DB_HOST $DB_PORT



# Check if DNS resolution is successful

ping -c 1 $DB_HOST


```

## Repair

### Allow traffic from the PostgreSQL port in iptables
```shell


#!/bin/bash



# Define variables

POSTGRESQL_PORT=${POSTGRES_PORT}



# Allow traffic from PostgreSQL port in iptables

iptables -A INPUT -p tcp --dport $POSTGRESQL_PORT -j ACCEPT

iptables-save > /etc/sysconfig/iptables



# Check if iptables rules have been updated

iptables -L



echo "PostgreSQL port $POSTGRESQL_PORT has been allowed in iptables."


```

### Restart the PostgreSQL server
```shell


#!/bin/bash



# Restart the PostgreSQL service

sudo systemctl restart postgresql



# Wait for the service to restart

sleep 5



# Verify that the service is running

sudo systemctl status postgresql


```