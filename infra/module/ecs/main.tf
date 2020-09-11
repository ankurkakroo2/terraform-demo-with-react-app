############################################################
# DATA
###########################################################

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

############################################################
# RESOURCES
###########################################################

resource "aws_ecs_cluster" "cluster" {
  name = "react-app-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "react-app-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "react-app-task",
      "image": "${var.ecr_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Using Fargate
  network_mode             = "awsvpc"    # Required for Fargate
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${aws_iam_role.ecs_task_exec_role.arn}"
}

resource "aws_iam_role" "ecs_task_exec_role" {
  name               = "ecs_task_exec_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecs_task_exec_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "service" {
  name            = "react-app-service"
  cluster         = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  launch_type     = "FARGATE"
  desired_count   = 2
  depends_on      = [var.lb_listner, var.lb_target_group]

  load_balancer {
    target_group_arn = "${var.lb_target_group.arn}"
    container_name   = "${aws_ecs_task_definition.task.family}"
    container_port   = 80
  }


  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = var.security_groups
  }
}

