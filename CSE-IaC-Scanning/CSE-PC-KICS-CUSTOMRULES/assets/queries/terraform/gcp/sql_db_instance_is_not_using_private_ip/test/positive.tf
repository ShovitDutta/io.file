resource "google_sql_database_instance" "positive1" {
    name             = "master-instance"
    database_version = "MYSQL_8_0_31"
    region           = "us-central1"
    public_ip_address = "10.10.1.1"
}