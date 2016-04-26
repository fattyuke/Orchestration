###################################################
# Setup the terraform provider
###################################################
provider "aws" {
	region = "us-west-2"
}

###################################################
# Create VA VPC along with Internet Gateway
###################################################

resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    tags {
        Name = "${var.vpc_name}"
    }
}

resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.vpc.id}"
	tags {
		Name = "${var.aws_internet_gateway_name}"
	}
}

###################################################
# Create VA subnets
###################################################

resource "aws_subnet" "sub1" {
	vpc_id = "${aws_vpc.vpc.id}"

	cidr_block = "${var.mgmnt_sub_cidr}"
	availability_zone = "${var.mgmnt_az}"
	tags {
		Name = "${var.va_mgmnt_sub_name}"
	}
}

resource "aws_subnet" "sub2" {
	vpc_id = "${aws_vpc.vpc.id}"

	cidr_block = "${var.fab_sub_cidr}"
	availability_zone = "${var.fab_az}"
	tags {
		Name = "${var.va_fab_sub_name}"
	}
}

resource "aws_subnet" "sub3" {
	vpc_id = "${aws_vpc.vpc.id}"

	cidr_block = "${var.data1_sub_cidr}"
	availability_zone = "${var.data1_az}"
	tags {
		Name = "${var.va_data1_sub_name}"
	}
}

resource "aws_subnet" "sub4" {
	vpc_id = "${aws_vpc.vpc.id}"

	cidr_block = "${var.data2_sub_cidr}"
	availability_zone = "${var.data2_az}"
	tags {
		Name = "${var.va_data2_sub_name}"
	}
}

###################################################
# Routing table for management subnet
###################################################

resource "aws_route_table" "mgmnt_route_table" {
	vpc_id = "${aws_vpc.vpc.id}"

	route {
		cidr_block = "${var.mgmnt_route_table_cidr}"
		gateway_id = "${aws_internet_gateway.igw.id}"
	}
	tags {
		Name = "${var.mgmnt_route_table_name}"
	}
}

resource "aws_route_table_association" "Management_Route_Table_Assoc" {
	subnet_id = "${aws_subnet.sub1.id}"
	route_table_id = "${aws_route_table.mgmnt_route_table.id}"
}

###################################################
# Create and configure the security groups
###################################################

resource "aws_security_group" "sec_grp" {
  name = "${var.va_sec_group_name}"
  description = "${var.va_sec_group_desc}"

  ingress {
      from_port = "${var.sec_group_ingress_from_port}"
      to_port = "${var.sec_group_ingress_to_port}"
      protocol = "${var.sec_group_ingress_protocol}"
      cidr_blocks = ["${var.sec_group_ingress_cidr}"]
  }

  tags {
    Name = "${var.va_sec_group_name}"
  }
  vpc_id = "${aws_vpc.vpc.id}"
 
}

###################################################
# Create and configure the policies and profiles
# ** Commented out to avoid recreating, this should
# ** Be created in the AWS console
###################################################

#resource "aws_iam_instance_profile" "va-instance_profile" {
#    name = "va-instance_profile"
#    roles = ["${aws_iam_role.va-role.name}"]
#}

#resource "aws_iam_role" "va-role" {
#    name = "${var.va-role-name}"
#    assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ec2.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#}

#resource "aws_iam_policy_attachment" "ec2-full" {
#    name = "ec2-full"
#    roles = ["${aws_iam_role.va-role.id}"]
#    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
#}

#resource "aws_iam_policy_attachment" "vpc-full" {
#    name = "vpc-full"
#    roles = ["${aws_iam_role.va-role.id}"]
#    policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
#}


###################################################
# Template for initial va user data
###################################################
resource "template_file" "init" {
    template = "${file("init.tpl")}"
}


###################################################
# Create the Director Instance
###################################################

resource "aws_instance" "director" {
  ami ="${var.va-ami-name}"
  instance_type = "${var.va-inst-type}"
  availability_zone = "${var.mgmnt_az}"
  vpc_security_group_ids = ["${aws_security_group.sec_grp.id}"]
  subnet_id = "${aws_subnet.sub1.id}"
  disable_api_termination = "false"
  instance_initiated_shutdown_behavior = "stop"
  iam_instance_profile = "${aws_iam_instance_profile.va-instance_profile.name}"
  monitoring = "false"
  tags {
        Name = "${var.va-dir-name}"
    }
  user_data = "${template_file.init.rendered}"   
}


###################################################
# Create and configure the Network Interfaces
###################################################

resource "aws_network_interface" "dm_int" {
    subnet_id = "${aws_subnet.sub1.id}"
    private_ips = ["${var.va_dir_mgmnt_priv_ip}"]
    security_groups = ["${aws_security_group.sec_grp.id}"]
    source_dest_check = "false"
    tags {
	    Name = "${var.va_dir_mgmnt_Interface_name}"
    }
    attachment {
        instance = "${aws_instance.director.id}"
        device_index = 1
    }
}

resource "aws_network_interface" "df_int" {
    subnet_id = "${aws_subnet.sub2.id}"
    private_ips = ["${var.va_dir_fab_priv_ip}"]
    security_groups = ["${aws_security_group.sec_grp.id}"]
    source_dest_check = "false"
    tags {
	    Name = "${var.va_dir_fab_Interface_name}"
    }
    attachment {
        instance = "${aws_instance.director.id}"
        device_index = 2
    }
}

resource "aws_network_interface" "ep1m_int" {
    subnet_id = "${aws_subnet.sub1.id}"
    private_ips = ["${var.va_ep1_mgmnt_priv_ip}"]
    security_groups = ["${aws_security_group.sec_grp.id}"]
    source_dest_check = "false"
    tags {
	    Name = "${var.va_ep1_mgmnt_Interface_name}"
    }
}

resource "aws_network_interface" "ep1f_int" {
    subnet_id = "${aws_subnet.sub2.id}"
    private_ips = ["${var.va_ep1_fab_priv_ip}"]
    security_groups = ["${aws_security_group.sec_grp.id}"]
    source_dest_check = "false"
    tags {
	    Name = "${var.va_ep1_fab_Interface_name}"
    }
}

resource "aws_network_interface" "ep1-data1_int" {
    subnet_id = "${aws_subnet.sub3.id}"
    private_ips = ["${var.va_ep1_data1_priv_ip}"]
    security_groups = ["${aws_security_group.sec_grp.id}"]
    source_dest_check = "false"
    tags {
	    Name = "${var.va_ep1_data1_Interface_name}"
    }
}

resource "aws_network_interface" "ep1-data2_int" {
    subnet_id = "${aws_subnet.sub4.id}"
    private_ips = ["${var.va_ep1_data2_priv_ip}"]
    security_groups = ["${aws_security_group.sec_grp.id}"]
    source_dest_check = "false"
    tags {
	    Name = "${var.va_ep1_data2_Interface_name}"
    }
}
resource "aws_network_interface" "ep2-data1_int" {
    subnet_id = "${aws_subnet.sub3.id}"
    private_ips = ["${var.va_ep2_data1_priv_ip}"]
    security_groups = ["${aws_security_group.sec_grp.id}"]
    source_dest_check = "false"
    tags {
	    Name = "${var.va_ep2_data1_Interface_name}"
    }
}

resource "aws_network_interface" "ep2-data2_int" {
    subnet_id = "${aws_subnet.sub4.id}"
    private_ips = ["${var.va_ep2_data2_priv_ip}"]
    security_groups = ["${aws_security_group.sec_grp.id}"]
    source_dest_check = "false"
    tags {
	    Name = "${var.va_ep2_data2_Interface_name}"
    }
}

###################################################
# Create the EP1 Instance
###################################################

resource "aws_instance" "ep1" {
  ami ="${var.va-ami-name}"
  instance_type = "${var.va-inst-type}"
  availability_zone = "${var.mgmnt_az}"
  vpc_security_group_ids = ["${aws_security_group.sec_grp.id}"]
  subnet_id = "${aws_subnet.sub1.id}"
  disable_api_termination = "false"
  instance_initiated_shutdown_behavior = "stop"
  iam_instance_profile = "${aws_iam_instance_profile.va-instance_profile.name}"
  monitoring = "false"
  tags {
        Name = "${var.va-dir-name}"
    }
  user_data = "${template_file.init.rendered}"   
}



