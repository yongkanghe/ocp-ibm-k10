starttime=$(date +%s)
. setenv.sh
MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')

# oc config delete-context $(oc config get-contexts -o name | grep ocp4yong1 | head -1)

# ibmcloud oc cluster rm --cluster $MY_CLUSTER --force-delete-storage -f #-q

echo "-------delete postgresql & kasten-io"
helm uninstall postgres -n postgresql
helm uninstall k10 -n kasten-io
kubectl delete ns postgresql
kubectl delete ns kasten-io
#helm uninstall mongodb -n mongodb
#kubectl delete ns mongodb

# echo '-------Deleting the GKE Cluster (typically in less than 10 mins)'
# MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')
# gkeclustername=$(gcloud container clusters list --format="value(name)" --filter="$MY_PREFIX-$MY_CLUSTER")
# gcloud container clusters delete $gkeclustername --zone $MY_ZONE --quiet

# echo '-------Deleting disks'
# for i in $(gcloud compute disks list --format="value(name)" --filter="$MY_PREFIX-$MY_CLUSTER");do echo $i;gcloud compute disks delete $i --zone=$MY_ZONE -q;done

# echo '-------Deleting snapshots'
# for i in $(gcloud compute snapshots list --format="value(name)" --filter="$MY_PREFIX-$MY_CLUSTER");do echo $i;gcloud compute snapshots delete $i -q;done

echo '-------Deleting the bucket'
myproject=$(gcloud config get-value core/project)
gsutil -m rm -r gs://$MY_PREFIX-$MY_BUCKET

# echo '-------Deleting kubeconfig for this cluster'
# kubectl config delete-context $(kubectl config get-contexts | grep $MY_PREFIX-$MY_CLUSTER | awk '{print $2}')

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
