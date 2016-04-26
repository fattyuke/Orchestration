vArmour Fabric via Terraform for AWS
=========

- vArmour Website: http://www.varmour.com
- Website: http://www.terraform.io

<img src="http://allegiscap.com/wp-content/uploads/2015/03/vArmour-Logo-Color1.jpg" /><img src="https://xebialabs.com/assets/files/plugins/terraform.jpg" width="300" height="250" />

###vArmour
vArmour is the industry’s first distributed security system that provides insight and control for multi-cloud environments. With its patented software, vArmour micro-segments each application by wrapping protection around every workload - increasing visibility, security, and operational efficiency.

For more information, see the [Product Overview section](https://www.varmour.com/product/overview) of the vArmour website.

###Terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

The key features of Terraform are:

- **Infrastructure as Code**: Infrastructure is described using a high-level configuration syntax. This allows a blueprint of your datacenter to be versioned and treated as you would any other code. Additionally, infrastructure can be shared and re-used.

- **Execution Plans**: Terraform has a "planning" step where it generates an *execution plan*. The execution plan shows what Terraform will do when you call apply. This lets you avoid any surprises when Terraform manipulates infrastructure.

- **Resource Graph**: Terraform builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, Terraform builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.

- **Change Automation**: Complex changesets can be applied to your infrastructure with minimal human interaction. With the previously mentioned execution plan and resource graph, you know exactly what Terraform will change and in what order, avoiding many possible human errors.

For more information, see the [introduction section](http://www.terraform.io/intro) of the Terraform website.

Why Terraform
-------------------------------
Comparable tools are Amazon CloudFormation and OpenStack Heat. They are both locked to their respective platforms. Terraform on the other hand supports all the major cloud providers - from DigitalOcean and Linode to the big ones like Azure, Google Compute and of course Amazon.

If you are already invested in a CAPS(Chef, Ansible, Puppet and Salt), than you already know that all of them have at least decent support for building servers in the cloud. What makes Terraform different? Why should you invest your precious time in learning yet another tool offering similar functionality. Here's why:

**State**

In a way Terraform acts as a simple version control for cloud infrastructure. Once you run terraform apply, it will create a .tfstate file with details about the newly created resource. The next time you run the the command, it will get the id from the tfstate file and compare that to what already exist in the real world.

The tfstate file is a simple JSON, you can keep it in Git, share it with your team and build on it. If something bad happens - you can easily rebuild.

**Planning**

For me this was the main reason to try Terraform. terraform plan matches the definition against the real world infrastructure and shows you exactly what is going to happen if you execute in that moment.

vArmour in AWS
-------------------------------
###Description
In this document we will illustrate how we can leverage Terraform to deploy vArmour Fabric in AWS as well as how we can micro­segment the workloads in AWS using vArmour EP’s.

###Deployment Requirements
The requirements listed in this section must be met in order to successfully deploy vArmour DSS:

-You have an AWS account.

-You have access to the vArmour DSS Amazon Machine Image (AMI).

-You have create a vArmour Role & Policy (See Creating “Creating vArmour IAM Role” section)

**Note:**
For access to the vArmour DSS AMI contact your sales representative or send a request to support@varmour.com.

###Example Topology
For the purpose of this guide we will be deploying the following sample architecture.

In the example topology shown we have:
 
1. VPC with CIDR 10.254.0.0/16

2. Subnets
  * Management ­ 10.254.1.0/24
  * Fabric ­ 10.254.2.0/24
  * Data­1 ­ 10.254.3.0/24
  * Data­2 ­ 10.254.4.0/24 

3. ENI’s in each of the subnets 
  * Management   
    1. 10.254.1.10 ­ Director Management Eni  
    2. 10.254.1.11 ­ EP1 Management Eni   
    3. 10.254.1.100 ­ Analytics Platform Eni   
    4. 10.254.1.200 ­ Windows RDP Gateway   

  * Fabric 
    1. 10.254.2.10 ­ Director Fabric Eni 
    2. 10.254.2.11 ­ EP1 Fabric Eni

  * Data­1 
    1. 10.254.3.11 ­ EP1 Revenue1 Eni 
    2. 10.254.3.12 ­ AppServer1 Eni 
    3. 10.254.3.13 ­ AppServer2 Eni 
    4. 10.254.3.14 ­ AppServer3 Eni 

  * Data­2 
    1. 10.254.4.11 ­ EP1 Revenue2 Eni 
    2. 10.254.4.12 ­ WebServer1 Eni 
    3. 10.254.4.13 ­ WebServer2 Eni 
    4. 10.254.4.14 ­ WebServer3 Eni 

***Installing Terraform

Terraform has precompiled binaries for all the major distros. You download, unzip and you run terraform plan/apply. Nothing complicated here. A few notes:

-In the Terraform folder you will find 20-30 additional binaries. These are plugins and you don't interract with them directly. You can delete the ones you don't need if you want.
-Adding the Terraform folder to the system path is crucial. This way you will be able to execute the terraform command from anywhere
-oh-my-zsh has a very useful autocomplete plugin for Terraform
-Atom and Sublime Text both have syntax plugins for Terraform making it easier to spot typos

There are two other options for getting started with Terraform:

Using a pre-packaged AMI from the AWS Marketplace that contains Terraform
If you prefer to use something like Vagrant, there is a Vagrant/Terraform box available

***AWS Credentials

Since it's a bad practice to have your credentials in source code, you should load them from the default configuration file: `~/.aws/credentials`. This file could look like this:

```[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY```

If there is no `~/.aws/credentials` file in your home directory, simply create one. 

For more information, please see: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-config-files





