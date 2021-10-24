echo "-------Create a resource group if not exist"
starttime=$(date +%s)
. setenv.sh
MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')
ibmcloud target -r $MY_REGION

ibmcloud resource groups | grep $MY_PREFIX-$MY_RESOURCE_GROUP
if [ `echo $?` -eq 1 ]
then
  ibmcloud resource group-create $MY_PREFIX-$MY_RESOURCE_GROUP
fi
  ibmcloud target -g $MY_PREFIX-$MY_RESOURCE_GROUP

echo "-------Create a new VPC if not exist"
ibmcloud is vpcs | grep $MY_PREFIX-$MY_VPC
if [ `echo $?` -eq 1 ]
then
  ibmcloud is vpc-create $MY_PREFIX-$MY_VPC
  ibmcloud oc vpcs --provider vpc-gen2 | grep $MY_PREFIX-$MY_VPC | awk '{print $2}' > my_vpc_id
fi

if [ ! -f my_vpc_id ]; then
  ibmcloud oc vpcs --provider vpc-gen2 | grep $MY_PREFIX-$MY_VPC | awk '{print $2}' > my_vpc_id
fi

echo "-------Create a new Subnet if not exist"
ibmcloud is subnets | grep $MY_PREFIX-$MY_SUBNET
if [ `echo $?` -eq 1 ]
then
  ibmcloud is vpc-address-prefixes $(cat my_vpc_id) | grep $MY_ZONE | awk '{print $3}' | sed -e 's/\/.*/\/24/g' > my_cidr_block
  ibmcloud is subnet-create $MY_PREFIX-$MY_SUBNET $(cat my_vpc_id) $MY_ZONE --ipv4-cidr-block $(cat my_cidr_block)
  ibmcloud is subnets | grep $MY_PREFIX-$MY_SUBNET | awk '{print $1}' > my_subnet_id
fi

if [ ! -f my_subnet_id ]; then
ibmcloud is subnets | grep $MY_PREFIX-$MY_SUBNET | awk '{print $1}' > my_subnet_id
fi

echo "-------Create a new Public Gateway and associate to the Subnet if not exist"
ibmcloud is public-gateways | grep $MY_PREFIX-$MY_GATEWAY
if [ `echo $?` -eq 1 ]
then
  ibmcloud is public-gateway-create $MY_PREFIX-$MY_GATEWAY $(cat my_vpc_id) $MY_ZONE
  ibmcloud is subnet-update $MY_PREFIX-$MY_SUBNET --pgw $(ibmcloud is public-gateways | grep $MY_PREFIX-$MY_GATEWAY | awk '{print $1}')
fi

echo "-------Create a Cloud Object Storage instance if not exist"
ibmcloud resource service-instances | grep $MY_PREFIX-$MY_OBJECT_STORAGE
if [ `echo $?` -eq 1 ]
then
  ibmcloud resource service-instance-create $MY_PREFIX-$MY_OBJECT_STORAGE cloud-object-storage standard global
fi
  ibmcloud resource service-instance $MY_PREFIX-$MY_OBJECT_STORAGE --output json | jq '.[].id' | sed -e 's/\"//g' | head -1 > my_cos_instance_id

echo "-------Create an Cloud Object Storage Service Key if not exist"
ibmcloud resource service-keys | grep $MY_PREFIX-$MY_SERVICE_KEY
if [ `echo $?` -eq 1 ]
then
  ibmcloud resource service-key-create $MY_PREFIX-$MY_SERVICE_KEY --instance-name $MY_PREFIX-$MY_OBJECT_STORAGE --parameters '{"HMAC":true}'
fi

ibmcloud resource service-key $MY_PREFIX-$MY_SERVICE_KEY --output JSON | jq '.[].credentials.cos_hmac_keys.access_key_id' > ibmaccess
ibmcloud resource service-key $MY_PREFIX-$MY_SERVICE_KEY --output JSON | jq '.[].credentials.cos_hmac_keys.secret_access_key' >> ibmaccess

echo "-------Create an Object Storage Bucket if not exist"
ibmcloud cos buckets --ibm-service-instance-id $(cat my_cos_instance_id) | grep $MY_BUCKET
if [ `echo $?` -eq 1 ]
then
  echo $MY_PREFIX-$MY_BUCKET-$(date +%s) > my_ibm_bucket
  ibmcloud cos bucket-create --bucket $(cat my_ibm_bucket) --ibm-service-instance-id $(cat my_cos_instance_id) --class standard --region $MY_REGION
fi

ibmcloud cos buckets --ibm-service-instance-id $(cat my_cos_instance_id) | grep $MY_BUCKET | awk '{print $1}' > ibmbucket  

echo "-------Upgrade Helm to version 3"
if [ ! -f helm ]; then
  #helm init --stable-repo-url https://charts.helm.sh/stable
  wget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz
  tar zxf helm-v3.7.1-linux-amd64.tar.gz
  mv linux-amd64/helm .
  rm helm-v3.7.1-linux-amd64.tar.gz 
  rm -rf linux-amd64 
fi

export PATH=~/ocp-ibm-k10:$PATH

echo "" | awk '{print $1}'
echo "-------You are ready to deploy now!"
echo "" | awk '{print $1}'

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time for the prep tasks is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
