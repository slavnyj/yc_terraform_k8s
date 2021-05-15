# Create K8S Cluster in Yandex Cloud using Terraform and Ansible magic
2 virtual machines are created in the Yandex Cloud using Terraform. Ansible playbook installs a Kubernetes cluster with two nodes using kubeadm and install Web UI.

&nbsp;
## Prerequisites
### 1. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) on Local machine or Control Server

```
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
```

Add remote host to Inventory File
```
sudo vim /etc/ansible/hosts
```
Add two groups master and workers
```
[masters]
master ansible_host=your-host-ip ansible_user=robot
 
[workers]
worker1 ansible_host=your-host-ip ansible_user=robot
```
Create config file

```
sudo vim /etc/ansible/ansible.cfg
```
Add the following lines
```
[defaults]
allow_world_readable_tmpfiles = True
pipelining = True
 
[workers]
worker1 ansible_host=84.252.138.110 ansible_user=robot
```

### 2. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### 3. Clone this repo
```
git clone https://github.com/slavnyj/yc_terraform_k8s.git
```
&nbsp;

## Create Kubernetes cluster using Terraform & Ansible magic
1. Go to cloning repo
```
cd yc_terraform_k8s
```
2. Modify `main.tf` file. In *"provider"* section set your values from Cloud Console.
3. Change *"metadata"* section in `main.tf` file. Specify the full path to the cloned repository. Save changes in file.
4. Initialize a working directory containing Terraform configuration files.  
```
terraform init
```
5. Validate `main.tf` file.
```
terraform validate
```
6. Rewrite Terraform configuration file `main.tf` to a canonical format and style.
```
terraform fmt
```
7. In `cloud-config.txt` set your public SSH key.
8. Check that Terraform will do everything we need, create a plan.
```
terraform plan
```
9. Let's create 2 VMs in Yandex Cloud.
```
terraform apply
```
10. After completing the creation of the VM, you saw the external IP addresses of your VMs. These addresses need to be specified in `/etc/ansible/hosts` (instead of '`your-host-ip`').
11. We have 2 virtual machines. Now let's make Ansible magic, which will create a Kubernetes cluster and configure it. Go to `kubernetes-setup` directory and run playbook.
```
cd kubernetes-setup
ansible-playbook kubernetes-setup
```  
&nbsp;

## An example of doing everything described above in the terminal can be found in the Logs folder.  

&nbsp;
  
*DEVOPS-7. Alexandr Ivanov*