Spring Boot CI/CD Deployment to Rancher Desktop

This repository implements a complete CI/CD workflow to build, test, containerize, and deploy a Spring Boot application to a local Rancher Desktop Kubernetes cluster using:

GitHub Actions

Docker Hub

Terraform

Helm

Traefik Ingress

Prometheus and Grafana

1. Prerequisites

Install the following on your local machine:

Rancher Desktop (Kubernetes enabled, Traefik enabled)

Docker

kubectl

Helm

Terraform

Java 17

GitHub Self-Hosted Runner (macOS)

2. Clone the Repository
git clone <your-repo-url>
cd <project-folder>

3. Configure GitHub Secrets

In GitHub:

Settings → Secrets and Variables → Actions → New Repository Secret

Create the following:

Secret Name	Value
DOCKER_HUB_USERNAME	your Docker Hub username
DOCKER_HUB_TOKEN	your Docker Hub access token
4. Configure Self-Hosted Runner (macOS)

Run the GitHub runner setup:

./config.sh
./run.sh


Use these runner labels:

self-hosted
macOS
ARM64


Keep the runner terminal open.

5. Start Rancher Desktop

Ensure Kubernetes is active:

kubectl get nodes

6. Trigger CI/CD Pipeline

Push code to the main branch:

git add .
git commit -m "deploy"
git push origin main


The GitHub Actions workflow will:

Build and test the Spring Boot project

Build a Docker image

Push the image to Docker Hub

Run Terraform to prepare Kubernetes namespace

Deploy using Helm

7. Verify Deployment
kubectl get pods -n springboot-app
kubectl get svc -n springboot-app
kubectl get deployment -n springboot-app

8. Enable Local Domain (Ingress)
8.1 Add host entry

Edit /etc/hosts:

127.0.0.1 springboot.local

8.2 Check Ingress
kubectl get ingress -n springboot-app


Expected:

NAME         CLASS     HOSTS              ADDRESS
springboot   traefik   springboot.local   192.168.x.x

8.3 Access application through Ingress
curl http://springboot.local
curl http://springboot.local/actuator/health


Or open in browser:

http://springboot.local

9. Port-Forward Access (Optional)
kubectl port-forward -n springboot-app deployment/springboot-app-springboot-app 8080:8080


Then access:

http://localhost:8080

10. Observability (Prometheus and Grafana)
10.1 Install monitoring stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace

10.2 Access Prometheus
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090


Open:

http://localhost:9090

10.3 Access Grafana
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80


Open:

http://localhost:3000


Login credentials:

username: admin
password: prom-operator

10.4 Import Spring Boot Grafana Dashboard

In Grafana:
Dashboards → Import → Enter Dashboard ID:

4701

11. Verify Prometheus Metrics

Inside the pod:

kubectl exec -it -n springboot-app $(kubectl get pod -n springboot-app -o jsonpath='{.items[0].metadata.name}') -- \
wget -qO- http://localhost:8080/actuator/prometheus


You should see JVM and Spring Boot metrics.

12. Cleanup
kubectl delete namespace springboot-app
kubectl delete namespace monitoring

Project Structure
.
├── helm/                 # Helm chart for deployment
├── terraform/            # Terraform configuration
├── src/                  # Spring Boot source
├── Dockerfile            # Docker image definition
├── pom.xml               # Maven configuration
└── .github/workflows/    # GitHub Actions CI/CD pipeline