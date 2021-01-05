variable "serviceprinciple_id" {
}

variable "serviceprinciple_key" {
}

variable "tenant_id" {
}

variable "subscription_id" {
}


variable "ssh_key" {
}

variable "location" {

}

variable "kubernetes_version" {
  default = "1.16.15"
}

variable "cloud_sql_user" {

}
variable "cloud_sql_password" {

}

variable "cloud_sql_db_names" {
  type = list(string)
}

variable "resourceGroupName" {

}

variable "hosted_zone" {

}

variable "cluster_name" {

}
