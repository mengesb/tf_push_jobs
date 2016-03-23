# Fix for push-jobs-client and push-jobs-server
# https://github.com/chef/opscode-pushy-server/issues/119
resource "null_resource" "patch-clients" {
  count = "${length(split(",", var.push_jobs_client))}"
  #provisioner "local-exec" {
  #  command = "echo Count is ${count.index} and host is ${element(split(",", var.push_jobs_client), count.index)}"
  #}
  connection {
    user        = "${lookup(var.ami_usermap, var.ami_os)}"
    private_key = "${var.aws_private_key_file}"
    host        = "${element(split(",", var.push_jobs_client), count.index)}"
  }
  provisioner "file" {
    #source      = "${var.client_patch}"
    source      = "${path.module}/files/pushy_client.rb.patch"
    destination = "/tmp/pushy_client.rb.patch"
  }
  provisioner "remote-exec" {
    inline = [
      "curl -s https://packagecloud.io/install/repositories/chef/current/script.deb.sh -o /tmp/script.deb.sh",
      "curl -s https://packagecloud.io/install/repositories/chef/current/script.rpm.sh -o /tmp/script.rpm.sh",
      "[ -x /usr/bin/yum ] && sudo bash /tmp/script.rpm.sh || sudo bash /tmp/script.deb.sh",
      "rm -f /tmp/script.*.sh",
      "[ -f /etc/yum.repos.d/chef_current.repo ] && sudo sed -i 's|enabled=1|enabled=0|g' /etc/yum.repos.d/chef_current.repo || sudo sed -i 's|^|#|g' /etc/apt/repos.d/chef_current.list",
      "[ -x /usr/bin/yum ] && sudo yum install -y -q -e 0 --disablerepo=* --enablerepo=chef_current push-jobs-client || sudo apt-get -qq install -y -t chef_current push-jobs-client",
      "sudo yum install -y patch",
      "sudo patch /opt/push-jobs-client/embedded/lib/ruby/gems/2.1.0/gems/opscode-pushy-client-2.0.2/lib/pushy_client.rb < /tmp/pushy_client.rb.patch",
    ]
  }
}
resource "null_resource" "patch-servers" {
  count = "${length(split(",", var.push_jobs_server))}"
  connection {
    user        = "${lookup(var.ami_usermap, var.ami_os)}"
    private_key = "${var.aws_private_key_file}"
    host        = "${element(split(",", var.push_jobs_server), count.index)}"
  }
  provisioner "remote-exec" {
    inline = [
      "curl -s https://packagecloud.io/install/repositories/chef/current/script.deb.sh -o /tmp/script.deb.sh",
      "curl -s https://packagecloud.io/install/repositories/chef/current/script.rpm.sh -o /tmp/script.rpm.sh",
      "[ -x /usr/bin/yum ] && sudo bash /tmp/script.rpm.sh || sudo bash /tmp/script.deb.sh",
      "rm -f /tmp/script.*.sh",
      "[ -x /usr/bin/yum ] && sudo yum install -y -q -e 0 --disablerepo=* --enablerepo=chef_current opscode-push-jobs-server || sudo apt-get -qq install -y -t chef_current opscode-push-jobs-server",
      "sudo opscode-push-jobs-server-ctl reconfigure",
      "[ -f /etc/yum.repos.d/chef_current.repo ] && sudo rm -f /etc/yum.repos.d/chef_current.repo || sudo rm -f /etc/apt/repos.d/chef_current.list",
      "echo 'Chef CURRENT repo removed'",
    ]
  }
}

