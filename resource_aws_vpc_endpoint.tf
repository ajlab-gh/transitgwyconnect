resource "aws_vpc_endpoint" "s3-endpoint-fgtvm-vpc" {
  vpc_id          = aws_vpc.fgtvm-vpc.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [ aws_route_table.fgtvmpublicrt.id ]
      policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY
  tags = {
    Name     = "s3-endpoint-fgtvm-vpc"
  }
}
