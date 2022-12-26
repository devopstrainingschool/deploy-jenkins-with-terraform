variable "ec2_amis" {
    type = string
    description = "deploy amazon linux"
    default = "ami-05a36e1502605b4aa"

}
variable "instance_type" {
    type = string
    description = "deploy amazon linux"
    default = "t2.medium"

}
variable "key_name" {
    type = string
    description = "(optional) describe your variable"
    default = "anael"
 }