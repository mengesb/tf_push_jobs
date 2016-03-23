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

