resource "kubernetes_config_map" "nginx_server" {
  metadata {
    name = "nginx-server-configmap"
  }

  data = {
    default = file("${path.module}/assets/nginx/default")
  }
}
