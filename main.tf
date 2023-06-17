
#Create the VPC
 resource "aws_vpc" "vpc-passion" {               
   cidr_block       =  var.cidr-vpc-passion 
   instance_tenancy = "default"
 }
