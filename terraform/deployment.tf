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

        volume {
          name = "public"
          config_map {
            name = kubernetes_config_map.webapp_public.metadata[0].name
          }
        }

        volume {
          name = "static-js"
          config_map {
            name = kubernetes_config_map.webapp_static_js.metadata[0].name
          }
        }

        volume {
          name = "static-css"
          config_map {
            name = kubernetes_config_map.webapp_static_css.metadata[0].name
          }
        }

        volume {
          name = "static-media"
          config_map {
            name = kubernetes_config_map.webapp_static_media.metadata[0].name
          }
        }

        container {
          name  = "nginx"
          image = "nginx:1.19.0-alpine"

          volume_mount {
            name       = "server"
            mount_path = "/etc/nginx/conf.d"
            read_only  = true
          }

          volume_mount {
            name       = "public"
            mount_path = "/var/www/webapp"
            read_only  = true
          }

          volume_mount {
            name       = "static-js"
            mount_path = "/var/www/webapp/static/js"
            read_only  = true
          }

          volume_mount {
            name       = "static-css"
            mount_path = "/var/www/webapp/static/css"
            read_only  = true
          }

          volume_mount {
            name       = "static-media"
            mount_path = "/var/www/webapp/static/media"
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
