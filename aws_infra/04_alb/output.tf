# alb/output.tf
output "was_tg_arn" {
  value = aws_lb_target_group.aws07_alb_was_group.arn
}
output "jenkins_tg_arn" {
  value = aws_lb_target_group.aws07_alb_jenkins_group.arn
}
