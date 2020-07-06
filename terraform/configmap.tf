resource "kubernetes_config_map" "nginx_server" {
  metadata {
    name = "nginx-server-configmap"
  }

  data = {
    "default.conf" = file("${path.module}/assets/nginx/default.conf")
  }
}
