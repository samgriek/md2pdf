resource "aws_ecs_cluster" "cluster" {
  name = "apis"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "api-md2pdf"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions    = <<DEFINITION
[
  {
    "name": "md2pdf-api",
    "image": "036117471787.dkr.ecr.us-west-2.amazonaws.com/md2pdf-api:latest",
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
        "awslogs-group": "/ecs/api-md2pdf",
        "awslogs-region": "us-west-2",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "environment": [
      {
        "name": "API_KEY",
        "value": "TBD"
      }
    ],
    "cpu": 256,
    "memory": 512,
    "memoryReservation": 256
  }
]
DEFINITION
}

resource "aws_ecs_service" "service" {
  name            = "api-md2pdf"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.group.arn
    container_name   = "md2pdf-api"
    container_port   = 80
  }

  deployment_controller {
    type = "ECS"
  }
}
