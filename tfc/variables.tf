#variables AWS
variable "aws_region" {
  type = string
  description = "Region"
}

variable "cidr-vpc-passion" {
  description = "CIDR block VPC"
  type = list(string)
}

variable "access_key" {

}

variable "secret_key" {

}
