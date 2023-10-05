resource "shoreline_notebook" "postgresql_database_connection_refused" {
  name       = "postgresql_database_connection_refused"
  data       = file("${path.module}/data/postgresql_database_connection_refused.json")
  depends_on = [shoreline_action.invoke_check_db_connection,shoreline_action.invoke_pg_port_iptables,shoreline_action.invoke_postgre_restart]
}

resource "shoreline_file" "check_db_connection" {
  name             = "check_db_connection"
  input_file       = "${path.module}/data/check_db_connection.sh"
  md5              = filemd5("${path.module}/data/check_db_connection.sh")
  description      = "Network connectivity issues such as firewall blocking the database connection port or DNS resolution failure."
  destination_path = "/agent/scripts/check_db_connection.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "pg_port_iptables" {
  name             = "pg_port_iptables"
  input_file       = "${path.module}/data/pg_port_iptables.sh"
  md5              = filemd5("${path.module}/data/pg_port_iptables.sh")
  description      = "Allow traffic from the PostgreSQL port in iptables"
  destination_path = "/agent/scripts/pg_port_iptables.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "postgre_restart" {
  name             = "postgre_restart"
  input_file       = "${path.module}/data/postgre_restart.sh"
  md5              = filemd5("${path.module}/data/postgre_restart.sh")
  description      = "Restart the PostgreSQL server"
  destination_path = "/agent/scripts/postgre_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_db_connection" {
  name        = "invoke_check_db_connection"
  description = "Network connectivity issues such as firewall blocking the database connection port or DNS resolution failure."
  command     = "`chmod +x /agent/scripts/check_db_connection.sh && /agent/scripts/check_db_connection.sh`"
  params      = ["POSTGRES_PORT","POSTGRES_HOST"]
  file_deps   = ["check_db_connection"]
  enabled     = true
  depends_on  = [shoreline_file.check_db_connection]
}

resource "shoreline_action" "invoke_pg_port_iptables" {
  name        = "invoke_pg_port_iptables"
  description = "Allow traffic from the PostgreSQL port in iptables"
  command     = "`chmod +x /agent/scripts/pg_port_iptables.sh && /agent/scripts/pg_port_iptables.sh`"
  params      = ["POSTGRES_PORT"]
  file_deps   = ["pg_port_iptables"]
  enabled     = true
  depends_on  = [shoreline_file.pg_port_iptables]
}

resource "shoreline_action" "invoke_postgre_restart" {
  name        = "invoke_postgre_restart"
  description = "Restart the PostgreSQL server"
  command     = "`chmod +x /agent/scripts/postgre_restart.sh && /agent/scripts/postgre_restart.sh`"
  params      = []
  file_deps   = ["postgre_restart"]
  enabled     = true
  depends_on  = [shoreline_file.postgre_restart]
}

