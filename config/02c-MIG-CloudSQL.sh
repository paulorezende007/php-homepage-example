
# Variaveis
PROJECT_ID="migration-factory-375017"
REGION="us-central1"
ZONE1="$REGION-a"
ZONE2="$REGION-b"
TEMPLATE_NAME=instance-template-5
NETWORK="vpc-main-01"
SUBNET="subnet-01"
STARTUP_SCRIPT_URL="gs://bucket-dgc-arquitetura-tradicional/startup-script-app-cloudsql.sh"
SERVICE_ACCOUNT_NAME="desvendando-google-cloud-sa"
HEALTHCHECK_NAME="healthcheck-mig"
INSTANCE_GROUP_NAME="instance-group-1"


# gcloud compute instances create $INSTANCE_NAME --project=$PROJECT_ID --zone=$ZONE1 \
#  --machine-type=e2-small --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$SUBNET \
#  --metadata=startup-script-url=$STARTUP_SCRIPT_URL \
#  --maintenance-policy=MIGRATE --provisioning-model=STANDARD \
#  --service-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
#  --scopes=https://www.googleapis.com/auth/cloud-platform --tags=rdp-ssh,http-server \
#  --create-disk=auto-delete=yes,boot=yes,device-name=$INSTANCE_NAME,image=projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230919,mode=rw,size=10,type=projects/$PROJECT_ID/zones/$ZONE1/diskTypes/pd-balanced \
#  --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

# Instance Template
 gcloud compute instance-templates create $TEMPLATE_NAME --project=$PROJECT_ID --machine-type=e2-small --network-interface=subnet=$SUBNET,no-address \
  --metadata=startup-script-url=$STARTUP_SCRIPT_URL --maintenance-policy=MIGRATE --provisioning-model=STANDARD \
  --service-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform \
  --region=$REGION --tags=rdp-ssh,http-server \
  --create-disk=auto-delete=yes,boot=yes,device-name=$TEMPLATE_NAME,image=projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230919,mode=rw,size=10,type=pd-balanced \
  --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any --labels=goog-ops-agent-policy=v2-x86-template-1-1-0

# Grupo de Instâncias
 gcloud beta compute health-checks create tcp $HEALTHCHECK_NAME --project=$PROJECT_ID --port=80 --proxy-header=NONE \
  --no-enable-logging --check-interval=10 --timeout=5 --unhealthy-threshold=3 --healthy-threshold=3 
 gcloud beta compute instance-groups managed create $INSTANCE_GROUP_NAME --project=$PROJECT_ID --base-instance-name=$INSTANCE_GROUP_NAME \
  --size=2 --template=projects/$PROJECT_ID/global/instanceTemplates/$TEMPLATE_NAME --zones=$ZONE1,$ZONE2 \
  --target-distribution-shape=EVEN --instance-redistribution-type=PROACTIVE --list-managed-instances-results=PAGELESS \
  --health-check=projects/$PROJECT_ID/global/healthChecks/$HEALTHCHECK_NAME --initial-delay=180 --force-update-on-repair
 gcloud compute instance-groups set-named-ports $INSTANCE_GROUP_NAME --project=$PROJECT_ID --region=$REGION --named-ports=http:80
 gcloud beta compute instance-groups managed set-autoscaling $INSTANCE_GROUP_NAME --project=$PROJECT_ID --region=$REGION\
  --cool-down-period=120 --max-num-replicas=10 --min-num-replicas=2 --mode=on --target-cpu-utilization=0.6

 # Create Load Balance

 # Create Cloud Armor

 # Aponte DNS e gere certificado se quiser 