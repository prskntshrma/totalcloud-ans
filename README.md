# pre-requisites
# 1. On AWS
VM os: Ubuntu 18.04 LTS. 3 vms with name master-vm, node01-vm, node02-vm which are connected by a virtual network and have dns entries so they can refer to each other with their names. Each of the VMs should have a user ansibleadmin, same ssh key named anskey for logging into VMs for ease of configuration. The designated master vm should have ansible installed.

# 2. On Azure
If Azure is available, please cd into terraform folder and set up your credentials and then terraform apply.

# 3. Master Setup
Log into the master vm using ssh key and clone the git repo https://github.com/prskntshrma/totalcloud-ans.git. Copy the anskey into ansible folder of this git repo using scp or any other method. In the group_vars folder a file named master.yaml is present. Provide the private ip address of vm against masterip like this masterip: <private ip address>

# 4. Main task
Run ansible-playbook playbook.yaml inside ansible directory

# 5. deploy application
After the command execution is finished wait for the nodes to be ready. Check using  "kubectl get nodes". Once nodes are ready head to kube-manifests directory and run command kubectl apply -f app.yaml. Check the port of the service using "kubectl get svc" command and look for high port in range of 32000. Access the app using any of the VMs ip and this high port like http://ip:32000 but for that you need to open these ports to public explicitly. You can also check the deployment using the cluster ip and port 80.
# Notes
I have experience with Azure but not AWS. If pre-requisites are met then this would work fine in any case.
