resource "kubernetes_service" "webapp" {
  metadata {
    name = "webapp-service"
    labels = {
      app = kubernetes_deployment.webapp.metadata[0].labels.app
    }
  }

  spec {
    selector = {
      app = kubernetes_deployment.webapp.metadata[0].labels.app
    }

    port {
      protocol    = "TCP"
      port        = kubernetes_deployment.webapp.spec[0].template[0].spec[0].container[0].port[0].container_port
      target_port = kubernetes_deployment.webapp.spec[0].template[0].spec[0].container[0].port[0].container_port
      name        = "http"
    }

    type = "LoadBalancer"
  }
}
