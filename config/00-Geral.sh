# Criação dos seguintes recursos para o projeto:
#   - VPC e SUBNET
#   - Regras de Firewall
#   - Cloud NAT
#   - Conta de Serviço para Compute Engine
#   - Cloud Storage para SCRIPT-STARTUP
#   - Conexão com Repositorio GIT via Cloud Source Repositories

# Variaveis
PROJECT_ID="migration-factory-375017"
REGION="us-central1"
BUCKET="bucket-dgc-arquitetura-tradicional"
SERVICE_ACCOUNT_NAME="desvendando-google-cloud-sa"
SERVICE_ACCOUNT_DISPLAY_NAME="Desvendando Google Cloud"
SERVICE_ACCOUNT_DESCRIPTION="Conta de Serviço para laboratórios do Desvendando Google Cloud"
NETWORK="vpc-main-01"
SUBNET="subnet-01"
SUBNET_RANGE="10.2.0.0/24"
ROUTER_NAME="router-$NETWORK"

# Create VPC 
gcloud compute networks create $NETWORK --project=$PROJECT_ID \
--subnet-mode=custom --mtu=1460 --bgp-routing-mode=global
# Create Subnet
gcloud compute networks subnets create $SUBNET --project=$PROJECT_ID  --range=$SUBNET_RANGE \
--stack-type=IPV4_ONLY --network=$NETWORK --region=$REGION --enable-private-ip-google-access
# Create Firewall Rulles
gcloud compute firewall-rules create "$NETWORK-allow-custom" --project=$PROJECT_ID --network=$NETWORK \
--direction=INGRESS --priority=65534 --source-ranges=$SUBNET_RANGE --action=ALLOW --rules=all
gcloud compute firewall-rules create "$NETWORK--allow-icmp" --project=$PROJECT_ID --network=$NETWORK \
--direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp
gcloud compute firewall-rules create "$NETWORK--allow-iap" --project=$PROJECT_ID --network=$NETWORK \
--direction=INGRESS --priority=65534 --source-ranges=35.235.240.0/20 --action=ALLOW --rules=tcp:22,tcp:3389 --target-tags=rdp-ssh
gcloud compute firewall-rules create "$NETWORK--allow-http-https" --project=$PROJECT_ID --network=$NETWORK \
--direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:80,tcp:443 --target-tags=http-server,https-server
gcloud compute firewall-rules create "$NETWORK--allow-healthcheck" --project=$PROJECT_ID --network=$NETWORK \
--direction=INGRESS --priority=65534 --source-ranges=35.191.0.0/16,130.211.0.0/22 --action=ALLOW --rules=tcp:80,tcp:443
# Create Cloud Router e Cloud NAT
gcloud compute routers create $ROUTER_NAME \
    --network=$NETWORK\
    --region=$REGION
gcloud compute routers nats create $ROUTER_NAME-nat \
    --router=$ROUTER_NAME \
    --region=$REGION \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips \
    --auto-network-tier=PREMIUM

# Cloud Storage
gcloud storage buckets create gs://$BUCKET/ --uniform-bucket-level-access --location=$REGION

# Upload "startup-script-mig.sh" para bucket

# Create Conta de Serviço para Instancias de Compute Engine
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
    --description="${SERVICE_ACCOUNT_DESCRIPTION}" \
    --display-name="${SERVICE_ACCOUNT_DISPLAY_NAME}"
# Conceder Permissões
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/logging.logWriter" \
    --role="roles/monitoring.metricWriter" \
    --role="roles/source.reader" \
    --role="roles/secretmanager.secretAccessor" \
    --role="roles/storage.objectViewer"

# Conectar no repositorio remoto (GitHUb)
# Criar uma conexao com o Cloud Source Repositories
