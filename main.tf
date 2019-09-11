variable "auth_token" {
  description="Your Cherryservers API token"
#  default =""
}

variable "team_id" {
  description = "Your Team ID from portal.cherryservers.com"
#  default = ""
}

resource "cherryservers_ssh" "kontena_ssh" {
  name       = "kontena_ssh"
  public_key = "${file("~/.ssh/Your_ssh.key")}"
}

variable "cluster_name" {
  default = "pharos"
}

variable "region" {
  default = "EU-East-1"
}

variable "master_plan" {
  default = "113"
}

variable "worker_plan" {
  default = "113"
}

variable "master_count" {
  default = 1
}

variable "worker_count" {
  default = 3
}

variable "host_os" {
  default = "CentOS 7 64bit"
}

provider "cherryservers" {
    auth_token = "${var.auth_token}"
}

resource "cherryservers_project" "Kontena_Pharos" {
  team_id = "${var.team_id}"
  name    = "Kontena_Pharos"
}
#This will order 1 floating IP to each of the worker nodes
#If You need floating IP's for your application 
#
#resource "cherryservers_ip" "floating-ip-kontena-worker" {
#    project_id = "${cherryservers_project.Kontena_Pharos.id}"
#    region = "${var.region}"
#    count = "${var.worker_count}"
#} 

resource "cherryservers_server" "pharos_master" {
  count           = "${var.master_count}"
  hostname        = "${var.cluster_name}-master-${count.index}"
  plan_id         = "${var.master_plan}"
  region          = "${var.region}"
  image           = "${var.host_os}"
  project_id      = "${cherryservers_project.Kontena_Pharos.id}"
  ssh_keys_ids    = ["${cherryservers_ssh.kontena_ssh.id}"]
  }

resource "cherryservers_server" "pharos_worker" {
  count        = "${var.worker_count}"
  hostname     = "${var.cluster_name}-worker-${count.index}"
  plan_id      = "${var.worker_plan}"
  region       = "${var.region}"
  image        = "${var.host_os}"
  project_id   = "${cherryservers_project.Kontena_Pharos.id}"
  ssh_keys_ids = ["${cherryservers_ssh.kontena_ssh.id}"]
#  ip_addresses_ids = ["${cherryservers_ip.floating-ip-kontena-worker.*.id[count.index]}"] <<-- This line will add 1 flaoting IP per worker node
}

output "pharos_hosts" {
  value = {
    masters = {
      address         = "${cherryservers_server.pharos_master.*.primary_ip}"
      private_address = "${cherryservers_server.pharos_master.*.private_ip}"
      role            = "master"
      user            = "root"
    }
    workers = {
      address         = "${cherryservers_server.pharos_worker.*.primary_ip}"
      private_address = "${cherryservers_server.pharos_worker.*.private_ip}"
      role            = "worker"
      user            = "root"
      label = {
        ingress = "nginx"

      }
    }
  }
}


