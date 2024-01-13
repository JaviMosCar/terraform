terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "~> 3.0.1"
        }
    }
}

// Definir proveedor de Docker
provider "docker" {}

resource "docker_image" "mariadb" {
    name = "mariadb:latest"
    keep_locally = false
}

resource "docker_image" "wordpress" {
    name = "wordpress:latest"
    keep_locally = false
}

// Definir la red de Docker
resource "docker_network" "my_network" {
    name = "my_network"
}

// Definir el contenedor de MariaDB
resource "docker_container" "mariadb" {
    image = docker_image.mariadb.image_id
    name  = "${var.db_container_name}"
    networks_advanced {
        name = "${docker_network.my_network.name}"
    }
    env = [
        "MYSQL_ROOT_PASSWORD=${var.MYSQL_ROOT_PASSWORD}",
        "MYSQL_DATABASE=${var.MYSQL_DATABASE}",
    ]
    volumes {
        container_path  = "/var/lib/mysql"
        volume_name     = docker_volume.my_volume.name
        read_only       = false
    }
}

// Definir el contenedor de Wordpress
resource "docker_container" "wordpress" {
    image = docker_image.wordpress.image_id
    name  = "${var.wp_container_name}"
    ports {
        internal = 80
        external = 8080
    }
    networks_advanced {
        name = "${docker_network.my_network.name}"
    }
    env = [
        "WORDPRESS_DB_HOST=${docker_container.mariadb.name}",
        "WORDPRESS_DB_USER=root",
        "WORDPRESS_DB_PASSWORD=${var.MYSQL_ROOT_PASSWORD}",
        "WORDPRESS_DB_NAME=${var.MYSQL_DATABASE}",
    ]
}

// Definir el volumen de Docker
resource "docker_volume" "my_volume" {
    name = "my_volume"
}
