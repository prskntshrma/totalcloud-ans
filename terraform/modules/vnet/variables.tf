variable "address_space" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "rgname" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_address_prefixes" {
  type = list(string)
}
