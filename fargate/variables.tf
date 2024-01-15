variable "region" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_task_definition_cpu" {
  type = string
  default = "256"
}

variable "ecs_task_definition_memory" {
  type = string
  default = "512"
}

variable "ecs_task_definition_family" {
  type = string
}

variable "ecs_task_container_name" {
  type = string
}

variable "ecs_task_container_image" {
  type = string
}

variable "ecs_task_container_port" {
  type = number
}

variable "ecs_task_host_port" {
  type = number
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "ecs_service_security_group_id" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "lb_security_group_id" {
  type = string
}

variable "lb_target_group_name" {
  type = string
}

variable "lb_target_group_port" {
  type = number
}

variable "lb_listener_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id_1" {
  type = string
}

variable "public_subnet_id_2" {
  type = string
}

