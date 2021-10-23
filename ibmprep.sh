echo "-------Create a resource group"
MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')
ibmcloud target -r $MY_REGION
ibmcloud resource group-create $MY_PREFIX-$MY_RESOURCE_GROUP
ibmcloud target -g $MY_PREFIX-$MY_RESOURCE_GROUP

echo "-------Create a seprate VPC, Subnet, Public Gateway"
ibmcloud is vpc-create $MY_VPC
ibmcloud oc vpcs --provider vpc-gen2 | grep $MY_VPC | awk '{print $2}' > my_vpc_id
ibmcloud is vpc-address-prefixes $(cat my_vpc_id) | grep $MY_ZONE | awk '{print $3}' | sed -e 's/\/.*/\/24/g' > my_cidr_block
ibmcloud is subnet-create $MY_SUBNET $(cat my_vpc_id) $MY_REGION --ipv4-cidr-block $(cat my_cidr_block)
ibmcloud is subnets | grep $MY_SUBNET | awk '{print $1}' > my_subnet_id
ibmcloud is public-gateway-create $MY_GATEWAY $(cat my_vpc_id) $MY_ZONE
ibmcloud is subnet-update $MY_SUBNET --public-gateway-id $(ibmcloud is public-gateways | grep $MY_GATEWAY | awk '{print $1}')

echo "-------Create an Cloud Object Storage instance"
ibmcloud resource service-instance-create $MY_OBJECT_STORAGE cloud-object-storage standard global
ibmcloud resource service-key-create svckey4yong1 --instance-name $MY_OBJECT_STORAGE --parameters '{"HMAC":true}'
ibmcloud resource service-key svckey4yong1 --output JSON | jq '.[].credentials.cos_hmac_keys.access_key_id' > ibmaccess
ibmcloud resource service-key svckey4yong1 --output JSON | jq '.[].credentials.cos_hmac_keys.secret_access_key' >> ibmaccess

echo "" | awk '{print $1}'
echo "-------You are ready to deploy now!"
echo "" | awk '{print $1}'


