resource "kubernetes_deployment" "webapp" {
  metadata {
    name = "webapp-deployment"
    labels = {
      app = "webapp"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "webapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }

      spec {
        volume {
          name = "server"
          config_map {
            name = kubernetes_config_map.nginx_server.metadata[0].name
          }
        }

        container {
          name  = "nginx"
          image = "nginx:1.19.0-alpine"

          volume_mount {
            name       = "server"
            mount_path = "/etc/nginx/sites-available"
            sub_path   = "default"
            read_only  = true
          }

          port {
            container_port = 80
            protocol       = "TCP"
          }

          resources {
            limits {
              cpu    = 1
              memory = "100Mi"
            }

            requests {
              cpu    = 0.15
              memory = "25Mi"
            }
          }

          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = 80
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            period_seconds        = 5
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = 80
              scheme = "HTTP"
            }

            initial_delay_seconds = 20
            period_seconds        = 5
          }
        }
      }
    }
  }
}
