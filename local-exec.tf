resource "null_resource" "packer" {

  provisioner "local-exec" {
    command = <<EOT
        packer build \
          -var docker_tag='latest-${random_id.random.hex}' \
          -var docker_repo='${aws_ecr_repository.nginx_repo.repository_url}' \
          -var login_srv='https://${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/' \
          -var aws_access_key='${var.aws_access_key}' \
          -var aws_secret_key='${var.aws_secret_key}' \
          packer/nginx.json
EOT

  }
  depends_on = ["aws_ecr_repository.nginx_repo", "random_id.random", "data.aws_caller_identity.current"]

}


resource "random_id" "random" {
  byte_length = 10
}



resource "null_resource" "curl" {

  provisioner "local-exec" {
    command = "bash -c 'while [[ \"$(curl -s -o /dev/null -w ''%{http_code}'' ${aws_elb.nginx_elb.dns_name}:${var.elb_port})\" != \"200\" ]]; do sleep 5; done' }"
  }
  depends_on = ["aws_elb.nginx_elb", "aws_ecs_task_definition.nginx_task","aws_security_group.elb_sg","aws_ecr_repository_policy.nginx_repo", "aws_ecs_service.nginx_service", "aws_ecr_repository.nginx_repo"]
}
