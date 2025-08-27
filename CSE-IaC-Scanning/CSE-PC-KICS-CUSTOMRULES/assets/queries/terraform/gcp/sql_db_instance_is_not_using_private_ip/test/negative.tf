resource "google_sql_database_instance" "negative1" {
    name             = "master-instance"
    database_version = "MYSQL_8_0_31"
    region           = "us-central1"
    private_ip_address = "10.0.1.0"
}