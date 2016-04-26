###################################################
# Define VPC Variables
###################################################

variable "vpc_name" {
	default = "ar-va-vpc"
}
variable "vpc_cidr" {
	default = "10.0.0.0/16"
}
variable "aws_internet_gateway_name" {
	default = "ar-va-igw"
}

###################################################
# Define Subnet Variables
###################################################

variable "va_mgmnt_sub_name" {
	default = "ar-va-mgmnt-sub"
}
variable "mgmnt_sub_cidr" {
	default = "10.0.0.0/24"
}
variable "mgmnt_az" {
	default = "us-west-2a"
}
variable "va_fab_sub_name" {
	default = "ar-va-fab-sub"
}
variable "fab_sub_cidr" {
	default = "10.0.2.0/24"
}
variable "fab_az" {
	default = "us-west-2a"
}
variable "va_data1_sub_name" {
	default = "ar-va-data1-sub"
}
variable "data1_sub_cidr" {
	default = "10.0.3.0/24"
}
variable "data1_az" {
	default = "us-west-2a"
}
variable "va_data2_sub_name" {
	default = "ar-va-data2-sub"
}
variable "data2_sub_cidr" {
	default = "10.0.4.0/24"
}
variable "data2_az" {
	default = "us-west-2a"
}

###################################################
# Define Routing Variables
###################################################

variable "mgmnt_route_table_name" {
	default = "ar-va-mgmnt-route-table-name"
}
variable "mgmnt_route_table_cidr" {
	default = "0.0.0.0/0"
}
variable "mgmnt_route_table_assoc_name" {
	default = "ar-va-mgmnt-route-assoc-name"
}

###################################################
# Define Security Group Variables
###################################################

variable "va_sec_group_name" {
	default = "ar-va-sec-grp"
}
variable "va_sec_group_desc" {
	default = "ar-va-sec-grp"
}
variable "sec_group_ingress_from_port" {
	default = "0"
}
variable "sec_group_ingress_to_port" {
	default = "0"
}
variable "sec_group_ingress_protocol" {
	default = "-1"
}
variable "sec_group_ingress_cidr" {
	default = "0.0.0.0/0"
}

###################################################
# Define ENI Variables
###################################################

# Management ENIs

variable "va_dir_mgmnt_Interface_name" {
	default = "ar-va-dir-mgmnt-int"
}
variable "va_dir_mgmnt_priv_ip" {
	default = "10.0.0.50"
}

variable "va_ep1_mgmnt_Interface_name" {
	default = "ar-va-ep1-mgmnt-int"
}
variable "va_ep1_mgmnt_priv_ip" {
	default = "10.0.0.51"
}


# Fabric ENIs

variable "va_dir_fab_Interface_name" {
	default = "ar-va-dir-fab-int"
}
variable "va_dir_fab_priv_ip" {
	default = "10.0.2.50"
}

variable "va_ep1_fab_Interface_name" {
	default = "ar-va-ep1-fab-int"
}
variable "va_ep1_fab_priv_ip" {
	default = "10.0.2.51"
}

# Data1 ENIs

variable "va_ep1_data1_Interface_name" {
	default = "ar-va-ep1-rev1-int"
}
variable "va_ep1_data1_priv_ip" {
	default = "10.0.3.50"
}

variable "va_ep2_data1_Interface_name" {
	default = "ar-va-ep2-rev1-int"
}
variable "va_ep2_data1_priv_ip" {
	default = "10.0.3.51"
}

# Data2 ENIs

variable "va_ep1_data2_Interface_name" {
	default = "ar-va-ep1-rev2-int"
}
variable "va_ep1_data2_priv_ip" {
	default = "10.0.4.50"
}
variable "va_ep2_data2_Interface_name" {
	default = "ar-va-ep2-rev2-int"
}
variable "va_ep2_data2_priv_ip" {
	default = "10.0.4.51"
}


###################################################
# Define Policy/Group Variables
###################################################

variable "va-role-name" {
	default = "andy-test-role"
}

###################################################
# Define Instance Variables
###################################################

variable "va-ami-name" {
	default = "ami-2b2ac24b"
}
variable "va-inst-type" {
	default = "m3.xlarge"
}
variable "va-dir-name" {
	default = "ar-va-director"
}



