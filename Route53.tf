# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_route53_hosted_zone" "public" {
#   name = "ankar.com"
  
#   vpc {
#     vpc_id = aws_vpc.Test-vpc.id

#   }
# }

# resource "aws_route53_record" "public_A" {
#   zone_id = aws_route53_hosted_zone.public.zone_id
#   name = "robosale"
#   type = "A"
#   ttl = "300"
# }

# resource "aws_route53_hosted_zone" "private" {
#   name = "ankar.internal"
#   vpc {
#     vpc_id = "vpc-5678efgh"
#   }
# }

# resource "aws_route53_record" "private_A" {
#   zone_id = aws_route53_hosted_zone.private.zone_id
#   name = "example.com"
#   type = "A"
#   ttl = "300"
#   records = ["10.0.0.1"]
# }
