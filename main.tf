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
    source      = "${path.module}/files/pushy_client.rb.patchfile"
    destination = "/tmp/pushy_client.rb.patchfile"
  }
  provisioner "file" {
    source      = "${path.module}/files/pushy_client.rb"
    destination = "/tmp/pushy_client.rb"
  }
  provisioner "remote-exec" {
    inline = [
      "curl -sL ${lookup(var.packagecloud, var.ami_os)} | sudo bash",
      "sudo ${lookup(var.packager, var.ami_os)} ${lookup(var.packager_opts, var.ami_os)} ${lookup(var.client_package_version, var.ami_os)}",
      "sudo ${lookup(var.packager, var.ami_os)} patch",
      "sudo cp /opt/push-jobs-client/embedded/lib/ruby/gems/2.1.0/gems/opscode-pushy-client-2.0.2/lib/pushy_client.rb pushy_client.rb.orig",
      "sudo chown ${lookup(var.ami_usermap, var.ami_os)} pushy_client.rb.orig",
      "sudo patch -i /tmp/pushy_client.rb.patchfile /opt/push-jobs-client/embedded/lib/ruby/gems/2.1.0/gems/opscode-pushy-client-2.0.2/lib/pushy_client.rb",
      "[ $? -ne 0 ] && sudo mv /tmp/pushy_client.rb /opt/push-jobs-client/embedded/lib/ruby/gems/2.1.0/gems/opscode-pushy-client-2.0.2/lib/pushy_client.rb || echo OK",
      "sudo chown root:root /opt/push-jobs-client/embedded/lib/ruby/gems/2.1.0/gems/opscode-pushy-client-2.0.2/lib/pushy_client.rb",
      "[ -f /etc/yum.repos.d/chef_current.repo ] && sudo rm -f /etc/yum.repos.d/chef_current.repo || echo OK",
      "[ -f /etc/apt/sources.list.d/chef_current.list ] && sudo rm -f /etc/apt/sources.list.d/chef_current.list || echo OK",
      "echo Say WHAT again I double dare you"
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
      "set -x",
      "sudo ${lookup(var.packages_chef_requirements, var.ami_os)}",
      "echo -e '${lookup(var.packages_chef_text, var.ami_os)}' > repo.file",
      "[ -d /etc/yum.repos.d ] && sudo mv repo.file /etc/yum.repos.d/chef_current.repo || echo OK",
      "[ -d /etc/apt/sources.list.d ] && sudo mv repo.file /etc/apt/sources.list.d/chef_current.list || echo OK",
      "sudo ${lookup(var.check_update, var.ami_os)}",
      "sudo ${lookup(var.packager, var.ami_os)} ${lookup(var.packager_opts, var.ami_os)} ${lookup(var.server_package_version, var.ami_os)}",
      "sudo opscode-push-jobs-server-ctl reconfigure",
      "[ -f /etc/yum.repos.d/chef_current.repo ] && sudo rm -f /etc/yum.repos.d/chef_current.repo || echo OK",
      "[ -f /etc/apt/sources.list.d/chef_current.list ] && sudo rm -f /etc/apt/sources.list.d/chef_current.list || echo OK",
      "echo Say WHAT again I double dare you"
    ]
  }
}

