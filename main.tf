terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8"
    }
  }
}

provider "kubernetes" {
  config_path = "/home/achile/.config/k3d/kubeconfig-tiny-cluster.yaml"
}

# 1. Create a Namespace
resource "kubernetes_namespace" "example" {
  metadata {
    name = "demo"
  }
}

# 2. Create a Deployment (Nginx)
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:1.24"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# 3. Expose Deployment via Service
resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec[0].template[0].metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

# 4. Enhancement: ConfigMap
resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = "nginx-config"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  data = {
    "welcome.message" = "Hello from Terraform-managed k3d cluster!"
  }
}
