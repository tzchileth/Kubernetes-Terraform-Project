# Tiny-Cluster Deployment with Terraform and k3d

This project demonstrates how to create a lightweight Kubernetes cluster using **k3d**, then deploy an Nginx application using **Terraform** and the **Kubernetes provider**.

---

## 📌 Prerequisites

Ensure you have the following installed:

* Docker
* k3d
* kubectl
* Terraform (v1.3+ recommended)

---

## 🚀 1. Create the k3d Cluster

```bash
k3d cluster create tiny-cluster --agents 2 --k3s-arg "--disable=traefik@server:0"
```

Verify the cluster:

```bash
kubectl get nodes
```

Get the kubeconfig path:

```bash
kubectl config view --minify
```

Export it for Terraform:

```bash
export KUBECONFIG=$(kubectl config view --minify -o jsonpath='{.current-context}')
```

If needed:

```bash
export KUBECONFIG=$HOME/.config/k3d/kubeconfig-tiny-cluster.yaml
```

---

## 📁 2. Terraform Files

The project contains:

* **main.tf** – Provider + Namespace + Deployment + Service + ConfigMap
* **variables.tf** – Namespace variable
* **outputs.tf** – Exposed service URL

Initialize Terraform:

```bash
terraform init
```

Apply the configuration:

```bash
terraform apply -auto-approve
```

Expected output:

```
namespace = "demo"
service_url = "http://localhost:<nodeport>"
```

---

## 🌐 3. Access the Application

### Option A: Use the NodePort

Open in browser:

```
http://localhost:<nodeport>
```

(Replace with the value from Terraform output.)

### Option B: Port-Forward

```bash
kubectl port-forward -n demo service/nginx-service 8080:80
```

Visit:

```
http://localhost:8080
```

---

## 🔍 4. Verify Kubernetes Resources

```bash
kubectl get pods -n demo
kubectl get svc -n demo
kubectl get configmap -n demo
```

---

## 🧹 5. Cleanup

To destroy Terraform-managed resources:

```bash
terraform destroy -auto-approve
```

To delete the k3d cluster:

```bash
k3d cluster delete tiny-cluster
```

---

## 📦 Summary

This setup creates:

* A **k3d cluster** with 2 agents
* A **demo namespace**
* An **Nginx deployment** managed via Terraform
* A **NodePort service** exposing the application
* A **ConfigMap** for injecting configuration

This is a great starting template for testing Kubernetes with Terraform in a fully local environment.
