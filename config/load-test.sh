### https://cloud.google.com/architecture/distributed-load-testing-using-gke?hl=pt-br


#Clone Git
git clone https://github.com/GoogleCloudPlatform/distributed-load-testing-using-kubernetes
cd distributed-load-testing-using-kubernetes

# Defina variavies
export GKE_CLUSTER=gke-devops-01
export AR_REPO=dist-lt-repo
export REGION=us-central1
export ZONE=us-central1-a
export PROJECT="migration-factory-375017"
export SAMPLE_APP_TARGET="34.149.12.219"
export LOCUST_IMAGE_NAME=locust-tasks
export LOCUST_IMAGE_TAG=latest

# Configure a Zona Default
gcloud config set compute/zone ${ZONE}

# Cria uma Artifact Registry
gcloud artifacts repositories create ${AR_REPO} \
    --repository-format=docker  \
    --location=${REGION} \
    --description="Distributed load testing with GKE and Locust"

# Crie a imagem de container
gcloud builds submit \
    --tag ${REGION}-docker.pkg.dev/${PROJECT}/${AR_REPO}/${LOCUST_IMAGE_NAME}:${LOCUST_IMAGE_TAG} \
    docker-image

# Conect no cluster K8S
 gcloud container clusters get-credentials gke-devops-01 --zone us-central1-a --project migration-factory-375017 

# Altera o tipo de Load Balance de Interno para Externo
sed -i "s/Internal/External/g" kubernetes-config/locust-master-service.yaml.tpl
# Altera o numero de replicas dos works
sed -i "s/5/7/g" kubernetes-config/locust-worker-controller.yaml.tpl 

# Faça o deploy do Locust
envsubst < kubernetes-config/locust-master-controller.yaml.tpl | kubectl apply -f -
envsubst < kubernetes-config/locust-worker-controller.yaml.tpl | kubectl apply -f -
envsubst < kubernetes-config/locust-master-service.yaml.tpl | kubectl apply -f -

# Veja se o deploy foi realizado com sucesso
kubectl get pods -o wide
kubectl get services

# Obtenha o endereço IP externo do Locust
export INTERNAL_LB_IP=$(kubectl get svc locust-master-web  \
                               -o jsonpath="{.status.loadBalancer.ingress[0].ip}") && \
                               echo $INTERNAL_LB_IP




envsubst < kubernetes-config/locust-master-controller.yaml.tpl | kubectl delete -f -
envsubst < kubernetes-config/locust-worker-controller.yaml.tpl | kubectl delete -f -
envsubst < kubernetes-config/locust-master-service.yaml.tpl | kubectl delete -f -


agents_to_install.csv && \
> echo '"projects/migration-factory-375017/zones/us-central1-b/instances/instance-group-1-04jd","[{""type"":""ops-ag


sudo systemctl status google-cloud-ops-agent"*"

:> agents_to_install.csv && \
> echo '"projects/migration-factory-375017/zones/us-central1-a/instances/instance-template-3","[{""type"":""ops-agent""}]"' >> agents_to_install.csv && \
> curl -sSO https://dl.google.com/cloudagents/mass-provision-google-cloud-ops-agents.py && \
> python3 mass-provision-google-cloud-ops-agents.py --file agents_to_install.csv


sudo systemctl status google-osconfig-agent
sudo systemctl status google-cloud-ops-agent
sudo systemctl restart google-cloud-ops-agent