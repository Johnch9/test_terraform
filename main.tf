# Setup Helm provider
provider "helm" {
  kubernetes {
        # host     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
        # username = "${azurerm_kubernetes_cluster.k8s.kube_config.0.username}"
        # password = "${azurerm_kubernetes_cluster.k8s.kube_config.0.password}"

        # client_certificate     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate}"
        # client_key             = "${azurerm_kubernetes_cluster.k8s.kube_config.0.client_key}"
        # cluster_ca_certificate = "${azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate}"
#    config_path = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
    config_path = "~/.kube/config"
  }
}

resource "null_resource" "first" {
    provisioner "local-exec" {
        command = "echo 'first'"
    }
}

resource "null_resource" "second" {
    depends_on = ["null_resource.first"]
    provisioner "local-exec" {
        command = "echo 'second'"
    }
}

resource "null_resource" "third" {
    depends_on = ["null_resource.second"]
    provisioner "local-exec" {
        command = "echo 'third'"
    }
}

# Add Helm Repo for SVC Cat
resource "helm_repository" "incubator" {
  name = "incubator"
#  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
  url  = "./istio/install/kubernetes/helm/"
}

# Deploy SvcCat
resource "helm_release" "istio" {
  name       = "istio"
#  repository = "${helm_repository.incubator.metadata.0.name}"
  repository = "./"
#  repository = "./istio/install/kubernetes/helm/"
  chart      = "istio"
  namespace  = "istio"

  set {
    name  = "istio.sidecar-injector"
    value = true
  }
}