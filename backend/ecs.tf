resource "aws_ecs_cluster" "cluster" {
  name = "md2pdf"
}

resource "aws_ecs_service" "api_service" {
  name            = "api-md2pdf"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.api_md2pdf_task.arn
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_lb_target_group.api_group.arn
    container_name   = "api-md2pdf"
    container_port   = 81
  }
  deployment_controller {
    type = "ECS"
  }
}

resource "aws_ecs_task_definition" "api_md2pdf_task" {
  family                   = "api-md2pdf"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
  {
    "name": "api-md2pdf",
    "image": "036117471787.dkr.ecr.us-west-2.amazonaws.com/md2pdf-api:v0.0.1",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 81,
        "hostPort": 81
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/api-md2pdf",
        "awslogs-region": "us-west-2",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "healthCheck": {
        "command": ["CMD-SHELL","curl -f http://localhost:81/ || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 0
    },
    "environment": [
      {
        "name": "API_KEY",
        "value": "TBD"
      }
    ],
    "cpu": 1024,
    "memory": 512,
    "memoryReservation": 256
  }
]
DEFINITION
}


resource "aws_cloudwatch_log_group" "api_md2pdf_log_group" {
  name = "/ecs/api-md2pdf"
}


resource "aws_cloudwatch_log_group" "ui_md2pdf_log_group" {
  name = "/ecs/ui-md2pdf"
}

resource "aws_ecs_service" "ui_service" {
  name            = "ui-md2pdf"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ui_md2pdf_task.arn
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_lb_target_group.ui_group.arn
    container_name   = "ui-md2pdf"
    container_port   = 80
  }
  deployment_controller {
    type = "ECS"
  }
}

resource "aws_ecs_task_definition" "ui_md2pdf_task" {
  family                   = "ui-md2pdf"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
  {
    "name": "ui-md2pdf",
    "image": "036117471787.dkr.ecr.us-west-2.amazonaws.com/md2pdf:v0.0.1",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/ui-md2pdf",
        "awslogs-region": "us-west-2",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "healthCheck": {
        "command": ["CMD-SHELL","curl -f http://localhost/ || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 0
    },
    "cpu": 256,
    "memory": 512,
    "memoryReservation": 128
  }
]
DEFINITION
}
