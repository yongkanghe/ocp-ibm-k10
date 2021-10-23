echo '-------Creating an OCP Cluster'
starttime=$(date +%s)
. setenv.sh

#ibmcloud login --apikey @ibmapi.key
ibmcloud target -g $MY_RESOURCE_GROUP
ibmcloud oc cluster create vpc-gen2 \
  --name $MY_CLUSTER --version $MY_OCP_VERSION_openshift \
  --zone $MY_ZONE --vpc-id $(cat my_vpc_id) \
  --subnet-id $(cat my_subnet_id) \
  --cos-instance 'crn:v1:bluemix:public:cloud-object-storage:global:a/692d79f012494327bf4b5a9e8f915787:01b75142-4ef8-4b17-8e4d-4e9d38fc4ec3::' \
  --flavor $MY_WORKER_FLAVOR \
  --workers 4 #bx2.4x16, cx2.8x16

echo '-------Please be patient as it takes about 40 mins'
sleep 300

echo '-------Still Deploying OpenShift Cluster'
sleep 300

echo '-------Still Deploying OpenShift Cluster'
sleep 300

echo '-------Still Deploying OpenShift Cluster'
sleep 300

echo '-------Retrieving OpenShift Cluster kubeconfig'
ibmcloud oc cluster config -c $MY_CLUSTER --admin

echo '-------Waiting for OCP Cluster up running'
sleep 300

echo '-------Still waiting for OCP Cluster up running'
sleep 200

#kubectl wait --for=condition=ready --timeout=900s -n openshift-console pod -l component=ui

echo '-------Deploying OpenShift Container Storage' #Wait for at least 23 mins
ibmcloud ks cluster addon enable openshift-data-foundation -c $MY_CLUSTER -f -y

echo '-------Waiting for OCS services up running'
sleep 360

echo '-------Still waiting for OCS services up running'
sleep 360

echo '-------Now it is ready to deploy Apps into OCP Cluster'

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo '' | awk '{print $1}'
echo '-------Created by Yongkang'
echo '-------Email me if any suggestions or issues he@yongkang.cloud'
echo '' | awk '{print $1}'
echo '' | awk '{print $1}'
