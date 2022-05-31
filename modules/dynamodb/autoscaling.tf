// based original code https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/v1.2.2 and https://github.com/snowplow-devops/terraform-aws-dynamodb-autoscaling/tree/release/0.1.2
resource "aws_appautoscaling_target" "read_target" {
  count = var.create_table && var.autoscaling_enabled ? 1 : 0
  max_capacity       = var.as_read_max_capacity
  min_capacity       = var.as_read_min_capacity
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "write_target" {
  count = var.create_table && var.autoscaling_enabled ? 1 : 0
  max_capacity       = var.as_write_max_capacity
  min_capacity       = var.as_write_min_capacity
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy" {
  count = var.create_table && var.autoscaling_enabled ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value       = var.as_read_target_value
    scale_in_cooldown  = var.as_read_scale_in_cooldown
    scale_out_cooldown = var.as_read_scale_out_cooldown
  }

  depends_on = [aws_appautoscaling_target.read_target[0]]
}

resource "aws_appautoscaling_target" "index_read" {
  for_each = var.create_table && var.autoscaling_enabled ? var.autoscaling_indexes : {}

  max_capacity       = each.value["read_max_capacity"]
  min_capacity       = each.value["read_min_capacity"]
  resource_id        = "table/${aws_dynamodb_table.table_autoscaled[0].name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "index_read_policy" {
  for_each = var.create_table && var.autoscaling_enabled ? var.autoscaling_indexes : {}

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.index_read[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_read[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_read[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_read[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value       = try(each.value["read_index_target"], var.as_read_target_value)
    scale_in_cooldown  = try(each.value["read_index_scale_in_cooldown"], var.as_read_scale_in_cooldown)
    scale_out_cooldown = try(each.value["read_index_scale_out_cooldown"], var.as_read_scale_out_cooldown)
  }
}

resource "aws_appautoscaling_target" "index_write" {
  for_each = var.create_table && var.autoscaling_enabled ? var.autoscaling_indexes : {}

  max_capacity       = each.value["write_max_capacity"]
  min_capacity       = each.value["write_min_capacity"]
  resource_id        = "table/${aws_dynamodb_table.table_autoscaled[0].name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy" {
  count = var.create_table && var.autoscaling_enabled ? 1 : 0
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value       = var.as_write_target_value
    scale_in_cooldown  = var.as_write_scale_in_cooldown
    scale_out_cooldown = var.as_write_scale_out_cooldown
  }

  depends_on = [aws_appautoscaling_target.write_target[0]]
}

resource "aws_appautoscaling_policy" "index_write_policy" {
  for_each = var.create_table && var.autoscaling_enabled ? var.autoscaling_indexes : {}

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.index_write[each.key].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_write[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.index_write[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_write[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value       = try(each.value["write_index_target"], var.as_write_target_value)
    scale_in_cooldown  = try(each.value["write_index_scale_in_cooldown"], var.as_write_scale_in_cooldown)
    scale_out_cooldown = try(each.value["write_index_scale_out_cooldown"], var.as_write_scale_out_cooldown)
  }
}