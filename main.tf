#Setup Helm provider
provider "helm" {
  kubernetes {
#    config_path = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
    config_path = "./azurek8s"
  }
}

#Add Helm Repo for SVC Cat
resource "helm_repository" "incubator" {
  name = "incubator"
#  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
  url  = "./istio/install/kubernetes/helm/"
}

#Deploy SvcCat
resource "helm_release" "istio" {
  name       = "istio"
  repository = "${helm_repository.incubator.metadata.0.name}"
  chart      = "istio"
  namespace  = "istio"

  set {
    name  = "istio.sidecar-injector"
    value = true
  }
}