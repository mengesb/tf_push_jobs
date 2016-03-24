#
# AWS provider specific configs
#
variable "aws_private_key_file" {
  description = "Full path to your local private key"
}
#
# AMI mapping
#
variable "ami_os" {
  description = "Delivery server OS (options: centos7, [centos6], ubuntu16, ubuntu14)"
  default     = "centos6"
}
variable "ami_usermap" {
  description = "Default username map for AMI selected"
  default     = {
    centos7   = "centos"
    centos6   = "centos"
    ubuntu16  = "ubuntu"
    ubuntu14  = "ubuntu"
    ubuntu12  = "ubuntu"
  }
}
#
# specific configs
#
variable "client_patch" {
  description = "Path to opscode-push-jobs-client patch file"
  default     = "files/pushy_client.rb.patch"
}
variable "push_jobs_client" {
  description = "CSV list of hosts with opscode-push-jobs-client installed"
}
variable "push_jobs_server" {
  description = "CSV list of hosts with opscode-push-jobs-server installed"
}
#
# package map
#
variable "check_update" {
  default     = {
    centos7   = "yum check-update"
    centos6   = "yum check-update"
    ubuntu16  = "apt-get update"
    ubuntu14  = "apt-get update"
    ubuntu12  = "apt-get update"
  }
}
variable "client_package_version" {
  default     = {
    centos7   = "push-jobs-client-2.0.2-1.el7"
    centos6   = "push-jobs-client-2.0.2-1.el6"
    ubuntu16  = "push-jobs-client=2.0.2-1"
    ubuntu14  = "push-jobs-client=2.0.2-1"
    ubuntu12  = "push-jobs-client=2.0.2-1"
  }
}
variable "packagecloud" {
  default     = {
    centos7   = "https://packagecloud.io/install/repositories/chef/current/script.rpm.sh"
    centos6   = "https://packagecloud.io/install/repositories/chef/current/script.rpm.sh"
    ubuntu16  = "https://packagecloud.io/install/repositories/chef/current/script.deb.sh"
    ubuntu14  = "https://packagecloud.io/install/repositories/chef/current/script.deb.sh"
    ubuntu12  = "https://packagecloud.io/install/repositories/chef/current/script.deb.sh"
  }
}
variable "packager" {
  default     = {
    centos7   = "yum install -y -q -e 0"
    centos6   = "yum install -y -q -e 0"
    ubuntu16  = "apt-get -qq install -y"
    ubuntu14  = "apt-get -qq install -y"
    ubuntu12  = "apt-get -qq install -y"
  }
}
variable "packager_opts" {
  default     = {
    centos7   = "--disablerepo=* --enablerepo=chef_current"
    centos6   = "--disablerepo=* --enablerepo=chef_current"
    ubuntu16  = "-t chef_current"
    ubuntu14  = "-t chef_current"
    ubuntu12  = "-t chef_current"
  }
}
variable "packages_chef_requirements" {
  default     = {
    centos7   = "rpm --import https://downloads.chef.io/packages-chef-io-public.key"
    centos6   = "rpm --import https://downloads.chef.io/packages-chef-io-public.key"
    ubuntu16  = "apt-get install apt-transport-https && wget -qO - https://downloads.chef.io/packages-chef-io-public.key | sudo apt-key add -"
    ubuntu14  = "apt-get install apt-transport-https && wget -qO - https://downloads.chef.io/packages-chef-io-public.key | sudo apt-key add -"
    ubuntu12  = "apt-get install apt-transport-https && wget -qO - https://downloads.chef.io/packages-chef-io-public.key | sudo apt-key add -"
  }
}
variable "packages_chef_text" {
  default     = {
    centos7   = "[chef_current]\nname=chef_current\nbaseurl=https://packages.chef.io/current-yum/el/$releasever/$basearch/\ngpgcheck=1\nenabled=0"
    centos6   = "[chef_current]\nname=chef_current\nbaseurl=https://packages.chef.io/current-yum/el/$releasever/$basearch/\ngpgcheck=1\nenabled=0"
    ubuntu16  = "deb https://packages.chef.io/current-apt xenial main"
    ubuntu14  = "deb https://packages.chef.io/current-apt trusty main"
    ubuntu12  = "deb https://packages.chef.io/current-apt precise main"

  }
}
variable "repo_file" {
  default     = {
    centos7   = "/etc/yum.reos.d/chef_current.repo"
    centos6   = "/etc/yum.reos.d/chef_current.repo"
    ubuntu16  = "/etc/apt/sources.list.d/chef_curent.list"
    ubuntu14  = "/etc/apt/sources.list.d/chef_curent.list"
    ubuntu12  = "/etc/apt/sources.list.d/chef_curent.list"
  }
}
variable "server_package_version" {
  default     = {
    centos7   = "opscode-push-jobs-server-2.0.0~alpha.4+20160322080812-1.el7"
    centos6   = "opscode-push-jobs-server-2.0.0~alpha.4+20160322080812-1.el6"
    ubuntu16  = "opscode-push-jobs-server=2.0.0~alpha.4+20160322080812-1"
    ubuntu14  = "opscode-push-jobs-server=2.0.0~alpha.4+20160322080812-1"
    ubuntu12  = "opscode-push-jobs-server=2.0.0~alpha.4+20160322080812-1"
  }
}

