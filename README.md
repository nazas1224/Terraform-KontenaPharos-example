# Terraform-KontenaPharos-example
Terraform Example for Kontena Pharos on Cherryservers

# Prerequisities:
* Kontena Pharos toolchain installed locally
* Terraform v11.x installed locally (for now works only with legacy versions of Terraform) 
* Terraform Provider Cherryservers (http://downloads.cherryservers.com/other/terraform/)
* Cherryservers.com credentials (api key, Team ID)

# Setup Kontena Pharos CLI Toolchain:

```$ curl -s https://get.pharos.sh | bash

$ chpharos login
Log in using your Kontena Account credentials
Visit https://account.kontena.io/ to register a new account.
Username: email
Password:
Logged in.

$ chpharos install latest --use
```
# Prepare Nodes for Kubernetes Cluster:

Note: For now works with CentOS 7 64bit image.

Update variables in main.tf file

```
$ terraform apply
```
after its complete update cluster.yml file:
add additional addons or other configurations depending on your needs.

# Bootstrap your First Pharos Kubernetes Cluster using Terraform

```
$ pharos tf apply -c cluster.yml
```
