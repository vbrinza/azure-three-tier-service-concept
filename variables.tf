variable "environment" {
  default     = "testing"
  description = "The environment name."
}

variable "project_name" {
  default     = "multitier-service"
  description = "The project name."
}

variable "project_location" {
  default     = "westeurope"
  description = "The project location."
}

variable "virtual_network" {
  default     = "10.0.0.0/16"
  description = "The virtual network address space."
}

variable "frontend_subnetwork" {
  default     = "10.0.1.0/24"
  description = "The frontend subnetwork address space."
}

variable "backend_subnetwork" {
  default     = "10.0.2.0/24"
  description = "The backend subnetwork address space."
}

variable "db_subnetwork" {
  default     = "10.0.3.0/24"
  description = "The db subnetwork address space."
}

variable "frontend_port" {
  default     = "443"
  description = "The frontend port."
}

variable "backend_port" {
  default     = "8080"
  description = "The backend port."
}

variable "db_port" {
  default     = "5432"
  description = "The db port."
}
