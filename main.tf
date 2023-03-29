provider "aws" {
  region = "eu-west-3"
  shared_credentials_file = "${path.module}/credentials"
}


#CREATING RDS POSGRES DB


# Create a security group
resource "aws_security_group" "rds_public_sg" {
  name_prefix = "rds_public_sg"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the RDS PostgreSQL instance
resource "aws_db_instance" "postgres" {
  identifier            = "my-rds-postgres"
  engine                = "postgres"
  engine_version        = "14.6"
  instance_class        = "db.t3.micro"
  db_name               ="price_comparator"
  username              = "postgres"
  password              = "mypassword"
  parameter_group_name  = "default.postgres14"
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.rds_public_sg.id]
  allocated_storage    = 20

}


data "aws_db_instance" "postgres" {
  db_instance_identifier = aws_db_instance.postgres.identifier
}


output "rds_host" {
  value = data.aws_db_instance.postgres.endpoint
}

data "aws_vpc" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

output "default_subnet_ids" {
  value = data.aws_subnet_ids.default.ids
}


#CREATING EC2 INSTANCE




resource "tls_private_key" "ec2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = "key"
  public_key = tls_private_key.ec2_private_key.public_key_openssh
}
# Create an EC2 instance for the bastion host
resource "aws_instance" "ec2_scraper" {
  ami                    = "ami-0eb375f24fdf647b8" # Amazon Linux 2 AMI
  instance_type         = "t2.micro"
  key_name              = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_scraper_sg.id]
  
  tags = {
    Name = "ec2_scraper"
  }

   provisioner "file" {
        source      = "./scrape_scripts"
        destination = "/home/ec2-user/scrape_scripts"
}
 provisioner "file" {
        source      = "./tests"
        destination = "/home/ec2-user/tests"
}
provisioner "remote-exec" {
    inline = [
      "sudo yum update -y","mkdir /home/ec2-user/scrape_scripts/data",
      "sudo amazon-linux-extras install -y postgresql13",
      "export PGPASSWORD=${aws_db_instance.postgres.password}",
      "printf '\n export PGPASSWORD=${aws_db_instance.postgres.password}  \n export PGHOST=${data.aws_db_instance.postgres.endpoint} \n export PGDB=${aws_db_instance.postgres.db_name}' >>  /home/ec2-user/.bash_profile",
      "psql -h ${split(":", data.aws_db_instance.postgres.endpoint)[0]} -U postgres -d ${aws_db_instance.postgres.db_name} -f /home/ec2-user/scrape_scripts/schema.sql",
      "sudo yum -y install python-pip",
      "pip install -r /home/ec2-user/scrape_scripts/requirements.txt",
      "echo '10 0 * * * /usr/bin/nohup /usr/bin/python /home/ec2-user/scrape_scripts/scrapeJumia.py & && /usr/bin/nohup /usr/bin/python /home/ec2-user/scrape_scripts/updateProducts.py & && /usr/bin/nohup /usr/bin/python /home/ec2-user/scrape_scripts/updatePrices.py & &&  /usr/bin/nohup /usr/bin/python /home/ec2-user/scrape_scripts/updateProdRanking.py & &&  /usr/bin/nohup /usr/bin/python /home/ec2-user/scrape_scripts/updateKpi.py &' > /tmp/my-cron",
      "crontab /tmp/my-cron"

    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.ec2_private_key.private_key_pem
    host        = self.public_ip
  }

  
}

# Create a security group for the bastion host
resource "aws_security_group" "ec2_scraper_sg" {
  name_prefix = "ec2_scraper_sg"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "private_key" {
  value     = tls_private_key.ec2_private_key.private_key_pem
  sensitive = true
}
#export the private key
resource "local_file" "private_key" {
  filename = "key.pem"
  content  = "${tls_private_key.ec2_private_key.private_key_pem}"
}





#LAMBDA






resource "aws_iam_role" "lambda_role" {
name   = "price_comparator_lambda_role"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "aws_iam_policy_for_terraform_aws_lambda_role"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
resource "aws_security_group" "postgres" {
  name_prefix = "postgres-sg-"
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["*"]
    allow_methods = [ "POST"]
    allow_origins = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id      = aws_apigatewayv2_api.lambda.id
  name        = "serverless_lambda_stage"
  auto_deploy = true
}

locals {
  endpoints = [
    "get_price_history",
    "get_kpi",
    "get_top_products",
    "get_product_details",
  ]
}


resource "local_file" "endpoint_urls" {
  filename = "./tests/.env"
  content = join("\n", concat([
    for i, endpoint in local.endpoints : "endpoint${i+1}=${aws_apigatewayv2_stage.lambda.invoke_url}/${endpoint}"
  ], [
    "ec2host=${aws_instance.ec2_scraper.public_dns}"
  ],["PGHOST=${data.aws_db_instance.postgres.endpoint}"],["PGDB=${aws_db_instance.postgres.db_name}"],["PGPASSWORD=${aws_db_instance.postgres.password}"]))
}

resource "local_file" "front_end_env" {
  filename = "./frontend/.env.development"
  content="GATSBY_API_URL=${aws_apigatewayv2_stage.lambda.invoke_url}/"
}



#get_price_history

variable "get_price_history_lambda_root" {
  type        = string
  description = "The relative path to the source of the lambda"
  default     = "./lambda_functions/get_price_history"
}

resource "null_resource" "install_dependencies_get_price_history" {
  provisioner "local-exec" {
    command = "pip install -r ${var.get_price_history_lambda_root}/requirements.txt -t ${var.get_price_history_lambda_root}/"
  }
  
  triggers = {
    dependencies_versions = filemd5("${var.get_price_history_lambda_root}/requirements.txt")
    source_versions = filemd5("${var.get_price_history_lambda_root}/index.py")
  }
}
data "archive_file" "zip_the_python_code_get_price_history" {
type        = "zip"
source_dir  = "${path.module}/lambda_functions/get_price_history/"
output_path = "${path.module}/lambda_functions/get_price_history/package.zip"
}



resource "aws_lambda_function" "get_price_history" {
filename                       = "${path.module}/lambda_functions/get_price_history/package.zip"
function_name                  = "get_price_history"
role                           = aws_iam_role.lambda_role.arn
handler                        = "index.lambda_handler"
runtime                        = "python3.8"
timeout = "15"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
layers = ["arn:aws:lambda:eu-west-3:336392948345:layer:AWSDataWrangler-Python38:5","arn:aws:lambda:eu-west-3:898466741470:layer:psycopg2-py38:1","arn:aws:lambda:eu-west-3:234666901317:layer:database:1"]

vpc_config {
  security_group_ids=[aws_security_group.postgres.id]
  subnet_ids=data.aws_subnet_ids.default.ids
}
 environment {
    variables = {
      DB_USER_NAME = "postgres"
      DB_PASSWORD = aws_db_instance.postgres.password,
      DB_HOST=aws_db_instance.postgres.endpoint,
      DB_NAME=aws_db_instance.postgres.db_name
    }
}
}


resource "aws_apigatewayv2_integration" "get_price_history" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.get_price_history.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "terraform_lambda_func_get_price_history" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /get_price_history"
  target    = "integrations/${aws_apigatewayv2_integration.get_price_history.id}"
}
resource "aws_lambda_permission" "api_gw_get_price_history" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_price_history.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}





#get_product_details

variable "get_product_details_lambda_root" {
  type        = string
  description = "The relative path to the source of the lambda"
  default     = "./lambda_functions/get_product_details"
}

resource "null_resource" "install_dependencies_get_product_details" {
  provisioner "local-exec" {
    command = "pip install -r ${var.get_product_details_lambda_root}/requirements.txt -t ${var.get_product_details_lambda_root}/"
  }
  
  triggers = {
    dependencies_versions = filemd5("${var.get_product_details_lambda_root}/requirements.txt")
    source_versions = filemd5("${var.get_product_details_lambda_root}/index.py")
  }
}
data "archive_file" "zip_the_python_code_get_product_details" {
type        = "zip"
source_dir  = "${path.module}/lambda_functions/get_product_details/"
output_path = "${path.module}/lambda_functions/get_product_details/package.zip"
}



resource "aws_lambda_function" "get_product_details" {
filename                       = "${path.module}/lambda_functions/get_product_details/package.zip"
function_name                  = "get_product_details"
role                           = aws_iam_role.lambda_role.arn
handler                        = "index.lambda_handler"
runtime                        = "python3.8"
timeout = "15"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
layers = ["arn:aws:lambda:eu-west-3:336392948345:layer:AWSDataWrangler-Python38:5","arn:aws:lambda:eu-west-3:898466741470:layer:psycopg2-py38:1","arn:aws:lambda:eu-west-3:234666901317:layer:database:1"]

vpc_config {
  security_group_ids=[aws_security_group.postgres.id]
  subnet_ids=data.aws_subnet_ids.default.ids
}
 environment {
    variables = {
      DB_USER_NAME = "postgres"
      DB_PASSWORD = aws_db_instance.postgres.password,
      DB_HOST=aws_db_instance.postgres.endpoint,
      DB_NAME=aws_db_instance.postgres.db_name
    }
}
}


resource "aws_apigatewayv2_integration" "get_product_details" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.get_product_details.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "terraform_lambda_func_get_product_details" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /get_product_details"
  target    = "integrations/${aws_apigatewayv2_integration.get_product_details.id}"
}
resource "aws_lambda_permission" "api_gw_get_product_details" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_product_details.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}



#get_top_products

variable "get_top_products_lambda_root" {
  type        = string
  description = "The relative path to the source of the lambda"
  default     = "./lambda_functions/get_top_products"
}

resource "null_resource" "install_dependencies_get_top_products" {
  provisioner "local-exec" {
    command = "pip install -r ${var.get_top_products_lambda_root}/requirements.txt -t ${var.get_top_products_lambda_root}/"
  }
  
  triggers = {
    dependencies_versions = filemd5("${var.get_top_products_lambda_root}/requirements.txt")
    source_versions = filemd5("${var.get_top_products_lambda_root}/index.py")
  }
}
data "archive_file" "zip_the_python_code_get_top_products" {
type        = "zip"
source_dir  = "${path.module}/lambda_functions/get_top_products/"
output_path = "${path.module}/lambda_functions/get_top_products/package.zip"
}



resource "aws_lambda_function" "get_top_products" {
filename                       = "${path.module}/lambda_functions/get_top_products/package.zip"
function_name                  = "get_top_products"
role                           = aws_iam_role.lambda_role.arn
handler                        = "index.lambda_handler"
runtime                        = "python3.8"
timeout = "15"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
layers = ["arn:aws:lambda:eu-west-3:336392948345:layer:AWSDataWrangler-Python38:5","arn:aws:lambda:eu-west-3:898466741470:layer:psycopg2-py38:1","arn:aws:lambda:eu-west-3:234666901317:layer:database:1"]

vpc_config {
  security_group_ids=[aws_security_group.postgres.id]
  subnet_ids=data.aws_subnet_ids.default.ids
}
 environment {
    variables = {
      DB_USER_NAME = "postgres"
      DB_PASSWORD = aws_db_instance.postgres.password,
      DB_HOST=aws_db_instance.postgres.endpoint,
      DB_NAME=aws_db_instance.postgres.db_name
    }
}
}


resource "aws_apigatewayv2_integration" "get_top_products" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.get_top_products.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "terraform_lambda_func_get_top_products" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /get_top_products"
  target    = "integrations/${aws_apigatewayv2_integration.get_top_products.id}"
}
resource "aws_lambda_permission" "api_gw_get_top_products" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_top_products.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}




#get_kpi

variable "get_kpi_lambda_root" {
  type        = string
  description = "The relative path to the source of the lambda"
  default     = "./lambda_functions/get_kpi"
}

resource "null_resource" "install_dependencies_get_kpi" {
  provisioner "local-exec" {
    command = "pip install -r ${var.get_kpi_lambda_root}/requirements.txt -t ${var.get_kpi_lambda_root}/"
  }
  
  triggers = {
    dependencies_versions = filemd5("${var.get_kpi_lambda_root}/requirements.txt")
    source_versions = filemd5("${var.get_kpi_lambda_root}/index.py")
  }
}
data "archive_file" "zip_the_python_code_get_kpi" {
type        = "zip"
source_dir  = "${path.module}/lambda_functions/get_kpi/"
output_path = "${path.module}/lambda_functions/get_kpi/package.zip"
}



resource "aws_lambda_function" "get_kpi" {
filename                       = "${path.module}/lambda_functions/get_kpi/package.zip"
function_name                  = "get_kpi"
role                           = aws_iam_role.lambda_role.arn
handler                        = "index.lambda_handler"
runtime                        = "python3.8"
timeout = "15"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
layers = ["arn:aws:lambda:eu-west-3:336392948345:layer:AWSDataWrangler-Python38:5","arn:aws:lambda:eu-west-3:898466741470:layer:psycopg2-py38:1","arn:aws:lambda:eu-west-3:234666901317:layer:database:1"]

vpc_config {
  security_group_ids=[aws_security_group.postgres.id]
  subnet_ids=data.aws_subnet_ids.default.ids
}
 environment {
    variables = {
      DB_USER_NAME = "postgres"
      DB_PASSWORD = aws_db_instance.postgres.password,
      DB_HOST=aws_db_instance.postgres.endpoint,
      DB_NAME=aws_db_instance.postgres.db_name
    }
}
}


resource "aws_apigatewayv2_integration" "get_kpi" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.get_kpi.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "terraform_lambda_func_get_kpi" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /get_kpi"
  target    = "integrations/${aws_apigatewayv2_integration.get_kpi.id}"
}
resource "aws_lambda_permission" "api_gw_get_kpi" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_kpi.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}





#10 0 * * * /usr/bin/nohup /usr/bin/python /home/ec2-user/jumiascraping/jumiaBot.py &




