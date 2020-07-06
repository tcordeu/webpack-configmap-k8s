resource "kubernetes_config_map" "nginx_server" {
  metadata {
    name = "nginx-server-configmap"
  }

  data = {
    "default.conf" = file("${path.module}/assets/nginx/default.conf")
  }
}

resource "kubernetes_config_map" "webapp_public" {
  metadata {
    name = "webapp-public-configmap"
  }

  data = {
    "index.html" = file("${path.module}/assets/public/index.html") # Placeholder.
  }
}

resource "kubernetes_config_map" "webapp_static_js" {
  metadata {
    name = "webapp-static-js-configmap"
  }

  data = {
    "placeholder" = file("${path.module}/assets/static/js/placeholder.js") # Placeholder.
  }
}

resource "kubernetes_config_map" "webapp_static_css" {
  metadata {
    name = "webapp-static-css-configmap"
  }

  data = {
    "placeholder" = file("${path.module}/assets/static/css/placeholder.css") # Placeholder.
  }
}

resource "kubernetes_config_map" "webapp_static_media" {
  metadata {
    name = "webapp-static-media-configmap"
  }

  data = {
    "placeholder" = file("${path.module}/assets/static/media/placeholder.svg") # Placeholder.
  }
}
