data "aws_iam_role" "pipeline_role" {
  name = "codepipeline-role" #role created!
}

data "aws_iam_role" "ecs-task" {
  name = "ecsTaskExecutionRole"
}