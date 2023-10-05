# Criação dos seguintes recursos para o projeto:
#   - CloudSQL em HA

# Variaveis
PROJECT_ID="migration-factory-375017"
REGION="us-central1"
ZONE1="$REGION-a"
ZONE2="$REGION-b"
CLOUDSQL_NAME="srv-mysql-01"
NETWORK="vpc-main-01"

# Criar Instância do Cloud SQL
# Criar Acesso Privado
gcloud compute addresses create google-managed-services-$NETWORK \
    --global \
    --purpose=VPC_PEERING \
    --prefix-length=24 \
    --network=projects/$PROJECT_ID/global/networks/$NETWORK
gcloud services vpc-peerings connect \
--service=servicenetworking.googleapis.com \
--ranges=google-managed-services-$NETWORK \
--network=$NETWORK \
--project=$PROJECT_ID
        
# Criar instancia privada
gcloud sql instances create $CLOUDSQL_NAME \
--database-version=MYSQL_8_0 \
--cpu=2 \
--memory=7680MB \
--zone=$ZONE1 \
--network=$NETWORK \
--no-assign-ip \
--enable-google-private-path \
--availability-type=REGIONAL \
--secondary-zone=$ZONE2 \
--enable-bin-log

# Criar Usuário e Senha para acesso ao Banco de Dados;
app-user
oy>ZQ2$()$sHT{3B
# Criar Banco de Dados;
app-db

# Criar Secret "MYSQL_DB_PASSWD" no Secret Manager