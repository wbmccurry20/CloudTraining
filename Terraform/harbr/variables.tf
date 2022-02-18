variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  type = map(string)
  description = "EC2 instance name"
  default     = {
	"PROD" = "PROD"
	"NONPROD" = "NONPROD"
  }
 }

