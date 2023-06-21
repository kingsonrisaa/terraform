#Create 3 VPC - AWS
 resource "aws_vpc" "vpc-passion" {
   cidr_block       =  var.cidr-vpc-passion[count.index]
   instance_tenancy = "default"
   count = 3
   tags = {
     Name = "VPC-${count.index}"
   }
 }
