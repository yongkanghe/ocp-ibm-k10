ocpk10starttime=$(date +%s)

./ocp-deploy.sh

./k10-deploy.sh

ocpk10endtime=$(date +%s)
ocpk10duration=$(( $ocpk10endtime - $ocpk10starttime ))
echo "-------Total time is $(($ocpk10duration / 60)) minutes $(($ocpk10duration % 60)) seconds."
echo "" | awk '{print $1}'
