#Create 3 VPC
 resource "aws_vpc" "vpc-passion" {
   cidr_block       =  var.cidr-vpc-passion[count.index]
   instance_tenancy = "default"
   main_route_table_id = false
   count = 3
   tags = {
     Name = "VPC-${count.index}"
   }
 }
