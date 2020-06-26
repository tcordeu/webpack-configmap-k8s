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
        container {
          name  = "nginx"
          image = "nginx:1.19.0-alpine"

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
