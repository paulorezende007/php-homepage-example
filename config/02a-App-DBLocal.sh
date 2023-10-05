# Variaveis
PROJECT_ID="migration-factory-375017"
REGION="us-central1"
ZONE1="$REGION-a"
INSTANCE_NAME="app-dblocal"
NETWORK="vpc-main-01"
SUBNET="subnet-01"
STARTUP_SCRIPT_URL="gs://bucket-dgc-arquitetura-tradicional/startup-script-app-dblocal.sh"
SERVICE_ACCOUNT_NAME="desvendando-google-cloud-sa"

gcloud compute instances create $INSTANCE_NAME --project=$PROJECT_ID --zone=$ZONE1 \
 --machine-type=e2-small --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$SUBNET \
 --metadata=startup-script-url=$STARTUP_SCRIPT_URL \
 --maintenance-policy=MIGRATE --provisioning-model=STANDARD \
 --service-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
 --scopes=https://www.googleapis.com/auth/cloud-platform --tags=rdp-ssh,http-server \
 --create-disk=auto-delete=yes,boot=yes,device-name=$INSTANCE_NAME,image=projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230919,mode=rw,size=10,type=projects/$PROJECT_ID/zones/$ZONE1/diskTypes/pd-balanced \
 --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any