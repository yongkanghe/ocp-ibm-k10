I just want to build a Red Hat OpenShift Container Platform to play with the various Data Management capabilities e.g. Backup/Restore, Disaster Recovery and Application Mobility. 

It is challenging to create an OpenShift cluster from IBM Cloud if you are not familiar to it. After the OCP Cluster is up running, we still need to install Kasten, create a sample DB, create policies etc.. The whole process is not that simple.

![image](https://blog.kasten.io/hs-fs/hubfs/Partner%20Images/Red%20Hat/kasten+openshift-social.png?width=500&name=kasten+openshift-social.png)

This script based automation allows you to build a ready-to-use Kasten K10 demo environment running on OpenShift Container Platform on IBM Cloud in about 40 minutes. To demonsrate OpenShift Container Storage feature, the OCP cluster will have 4 worker nodes and be built in a new vpc using a new subnet, gateway. This is bash shell based scripts which has been tested on Cloud Shell in the Sydney region. 

# Here're the prerequisities. 
1. Go to open IBM Cloud Shell
2. Clone the github repo to your local host, run below command
````
git clone https://github.com/yongkanghe/ocp-ibm-k10.git
````
3. Complete the preparation tasks first
````
cd ocp-ibm-k10;./ibmprep.sh
````
4. Optionally, you can customize the clustername, worker flavor, zone, region, bucketname etc.
````
vim setenv.sh
````
 
# To build the labs, run 
````
./deploy.sh
````
1. Create an OCP Cluster from CLI
2. Install Kasten K10
3. Deploy a Postgres database
4. Create an IBM COB location profile
5. Create a backup policy
6. Run an on-demand backup job

# To delete the labs, run 
````
./destroy.sh
````
1. Remove OpenShift Cluster Cluster
2. Remove all the relevant disks
3. Remove all the relevant snapshots
4. Remove the bucket

# Cick my picture to watch the how-to video.
[![IMAGE ALT TEXT HERE](https://media-exp1.licdn.com/dms/image/C5622AQFAVpxHMBu7lw/feedshare-shrink_2048_1536/0/1630923993310?e=1637193600&v=beta&t=1Zq_4N_9mj4EOZdtpKb5HeXl_K7svyMK3_ADMxHbqzM)](https://www.youtube.com/watch?v=6vDEk_9cNaI)

# For more details about OCP Backup and Restore
https://blog.kasten.io/kubernetes-backup-with-openshift-container-storage

https://blog.kasten.io/kasten-and-red-hat-migration-and-backup-for-openshift

# Kasten - No. 1 Kubernetes Backup
https://kasten.io 

# Kasten - DevOps tool of the month July 2021
http://k10.yongkang.cloud

# Contributors

### [Yongkang He](http://yongkang.cloud)
### [Michael Nguyen](https://www.linkedin.com/in/michael-nguyen-29811034/)
### [Hitesh Kataria](https://www.linkedin.com/in/hitesh-kataria09/)

