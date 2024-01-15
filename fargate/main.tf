terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
}

resource "aws_ecs_cluster" "service" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "service" {
  family = var.ecs_task_definition_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu       = var.ecs_task_definition_cpu
  memory    = var.ecs_task_definition_memory

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.ecs_task_container_name
      image     = var.ecs_task_container_image
      essential = true
      portMappings = [
        {
          containerPort = var.ecs_task_container_port
          hostPort      = var.ecs_task_host_port
          protocol = "tcp"
        }
      ]
    },
  ])
}

resource "aws_lb" "service" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_group_id]
  subnets            = [var.public_subnet_id_1, var.public_subnet_id_2]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "service" {
  name        = var.lb_target_group_name
  port        = var.lb_target_group_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "service" {
  load_balancer_arn = aws_lb.service.arn
  port              = var.lb_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }
}

resource "aws_ecs_service" "service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.service.id
  task_definition = aws_ecs_task_definition.service.arn
  launch_type = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets            = [var.public_subnet_id_1, var.public_subnet_id_2]
    security_groups = [var.ecs_service_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service.arn
    container_name   = var.ecs_task_container_name
    container_port   = var.ecs_task_container_port
  }
}
