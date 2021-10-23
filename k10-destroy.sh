starttime=$(date +%s)
. setenv.sh
MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')

echo "-------Delete postgresql & kasten-io"
./helm uninstall postgres -n postgresql
./helm uninstall k10 -n kasten-io
kubectl delete ns postgresql
kubectl delete ns kasten-io

echo '-------Deleting the bucket'
ibmcloud cos bucket-delete --bucket $MY_PREFIX-$MY_BUCKET --region $MY_REGION --force

# echo '-------Deleting kubeconfig for this cluster'
# kubectl config delete-context $(kubectl config get-contexts | grep $MY_PREFIX-$MY_CLUSTER | awk '{print $2}')

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
