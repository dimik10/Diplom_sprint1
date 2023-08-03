variable "instance_family_image" {
  description = "Instance image"
  type        = string
  default     = "ubuntu-2204-lts"
  #  default     = "lamp"
}

variable "vpc_subnet_id" {
  description = "VPC subnet network id"
  type        = string
}

variable "instance_root_disk" {
  default = "50"
}

variable "srv" {
  description = "Count of srv nodes"
  type        = number
  default     = 1
}

variable "master" {
  description = "Count of master nodes"
  type        = number
  default     = 1
}

variable "app" {
  description = "Count of app nodes"
  type        = number
  default     = 1
}


variable "ssh_credentials" {
  description = "Credentials for connect to instances"
  type        = object({
    user        = string
    private_key = string
    pub_key     = string
  })
  default     = {
    user        = "ubuntu"
    private_key = "~/.ssh/yandex1"
    pub_key     = "~/.ssh/yandex1.pub"
  }
}
# Переменная определяющая зону для разворачивания ВМ
variable "zone" {
  description = "Use specific availability zone"
  type        = list(string)
  default     = ["ru-central1-b", "ru-central1-a", "ru-central1-c"]
}
