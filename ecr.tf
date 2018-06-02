resource "aws_ecr_repository" "nginx_repo" {
  name = "${var.container_name}"
}

resource "aws_ecr_repository_policy" "nginx_repo" {
  repository = "${aws_ecr_repository.nginx_repo.name}"

  policy = "${file("policies/ecr.json")}"

}