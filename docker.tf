data "docker_registry_image" "watchtower" {
  name = "containrrr/watchtower:latest"
}

resource "docker_image" "watchtower" {
  name = data.docker_registry_image.watchtower.name
  pull_triggers = [data.docker_registry_image.watchtower.sha256_digest]
}

resource "docker_container" "watchtower" {
  image = docker_image.watchtower.image_id
  name  = "watchtower"
  restart = "always"
  volumes {
      host_path = "/var/run/docker.sock"
      container_path = "/var/run/docker.sock"
  }
  env = [
    "TZ=America/Denver",
    "WATCHTOWER_CLEANUP=true",
    "WATCHTOWER_INCLUDE_STOPPED=true",
    "WATCHTOWER_REVIVE_STOPPED=false",
    "WATCHTOWER_SCHEDULE=0,15,30,45 * * * *"
  ]
}
