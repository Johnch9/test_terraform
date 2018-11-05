#Setup Helm provider
provider "helm" {
  kubernetes {
    config_path = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
  }
}

#Add Helm Repo for SVC Cat
resource "helm_repository" "google-incubator-cat" {
  name = "google-incubator-cat"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
}

#Deploy SvcCat
resource "helm_release" "catalog" {
  depends_on = ["helm_repository.google-incubator-cat"]
  name       = "istio"
  chart      = "google-incubator-cat/istio"
  namespace  = "istio"

  set {
    name  = "istio.sidecar-injector"
    value = true
  }
}