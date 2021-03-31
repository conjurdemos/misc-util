
variable "puppet_agent_win_nodes" {
  default = [
    "agent-win-2008r2.puppet"
    ,"agent-win-2019.puppet"
    ,"agent-win-core.puppet"
  ]
}

variable "puppet_agent_win_amis" {
  default = [
     "ami-062d3fb9f5d18af75" # Windows 2008R2
    ,"ami-09ef280df1a6a5330" # Windows 2019
    #,"ami-04f46af0096c1d8b9" # Windows 2019 Core
  ]
}

module "puppet_agents_win" {
  source = "../../../../terraform_modules/puppet/agent-windows"

  ami_ids = "${var.puppet_agent_win_amis}"
  node_names = "${var.puppet_agent_win_nodes}"
  puppet_master_ip = "${module.puppet_master.private_ip}"
  vpc_id = "${var.vpc_id}"
  security_group_id = "${aws_security_group.puppet_agent_node.id}"
  resource_prefix = "${var.resource_prefix}"
  ssh_key_name = "${aws_key_pair.generated_key.key_name}"
  ssh_key_pem = "${tls_private_key.ssh_access_key.private_key_pem}"
}

output "puppet_agent_win_public_dns" {
  value = "${module.puppet_agents_win.public_dns}"
}
