#
# ECR 
#

resource "aws_ecr_repository" "ecs-task" {
  name = "${var.ECR_PREFIX}${var.APPLICATION_NAME}"
}

#
# get latest active revision
#
data "aws_ecs_task_definition" "ecs-task" {
  task_definition = aws_ecs_task_definition.ecs-task-taskdef.family
  depends_on      = [aws_ecs_task_definition.ecs-task-taskdef]
}

#
# task definition template
#

data "template_file" "ecs-task" {
  template = file(var.TASK_DEF_TEMPLATE)

  vars = {
    APPLICATION_NAME    = var.APPLICATION_NAME
    APPLICATION_VERSION = var.APPLICATION_VERSION
    ECR_URL             = aws_ecr_repository.ecs-task.repository_url
    AWS_REGION          = var.AWS_REGION
    CPU_RESERVATION     = var.CPU_RESERVATION
    MEMORY_RESERVATION  = var.MEMORY_RESERVATION
    LOG_GROUP           = var.LOG_GROUP
  }
}

#
# task definition
#

resource "aws_ecs_task_definition" "ecs-task-taskdef" {
  family                = var.APPLICATION_NAME
  container_definitions = data.template_file.ecs-task.rendered
  task_role_arn         = var.TASK_ROLE_ARN
}

# scheduling
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "Run${replace(var.APPLICATION_NAME, "-", "")}"
  description         = "runs ecs task"
  schedule_expression = var.SCHEDULE
}

resource "aws_cloudwatch_event_target" "schedule" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "Run${replace(var.APPLICATION_NAME, "-", "")}"
  arn       = var.CLUSTER_ARN
  role_arn  = var.EVENTS_ROLE_ARN

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.ecs-task-taskdef.arn
  }
}

