variable "MYSQL_ROOT_PASSWORD" {
    description = "La contraseña del usuario root de MySQL"
    type        = string
    default     = "password"
}

variable "MYSQL_DATABASE" {
    description = "El nombre de la base de datos de MySQL"
    type        = string
    default     = "wordpress"
}

variable "db_container_name" {
    description = "El nombre del contenedor de bd"
    type        = string
    default     = "mariadb"
}

variable "wp_container_name" {
    description = "El nombre del contenedor de wp"
    type        = string
    default     = "wordpress"
}
