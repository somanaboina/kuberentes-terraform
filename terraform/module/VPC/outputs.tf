output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_sub_1_a_id" {
  value = aws_subnet.public01.id
}
output "pub_sub_2_b_id" {
  value = aws_subnet.public02.id
}
output "pri_sub_3_a_id" {
  value = aws_subnet.private01.id
}

output "pri_sub_4_b_id" {
  value = aws_subnet.private02.id
}
output "igw_id" {
    value = aws_internet_gateway.igw.id
}
