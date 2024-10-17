# VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "PARCIAL_VPC"
    }
}

# Subredes públicas
resource "aws_subnet" "subnet1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "PUBLIC1"
    }
}

resource "aws_subnet" "subnet2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true 

    tags = {
        Name = "PUBLIC2"
    }
}

# Subredes privadas
resource "aws_subnet" "subnet3" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1c"

    tags = {
        Name = "PRIVATE1"
    }
}

resource "aws_subnet" "subnet4" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1d"

    tags = {
        Name = "PRIVATE2"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "GATEWAY"
    }
}

# Tabla de enrutamiento pública
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "PUBLIC_ROUTE_TABLE"
    }
}

# Tabla de enrutamiento privada
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "PRIVATE_ROUTE_TABLE"
    }
}

# Asociaciones de tabla de enrutamiento pública
resource "aws_route_table_association" "public1" {
    subnet_id      = aws_subnet.subnet1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
    subnet_id      = aws_subnet.subnet2.id
    route_table_id = aws_route_table.public.id
}

# Asociaciones de tabla de enrutamiento privada
resource "aws_route_table_association" "private1" {
    subnet_id      = aws_subnet.subnet3.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
    subnet_id      = aws_subnet.subnet4.id
    route_table_id = aws_route_table.private.id
}

# Grupo de seguridad
resource "aws_security_group" "main" {
    vpc_id = aws_vpc.main.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "SECURITY_GROUP"
    }
}