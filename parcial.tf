# Ejercicio: Crear VPC, subredes (4) public y private, tabla de rutas, grupo de seguridad


# vpc
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "PARCIAL_VPC"
    }
}

# subredes:
# publica 1
resource "aws_subnet" "subnet1" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    # defino que sea publica
    map_public_ip_on_launch = true

    tags = {
        Name = "PUBLIC1"
    }
}
# publica 2
resource "aws_subnet" "subnet2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"

    # defino que sea publica
    map_public_ip_on_launch = true 

    tags = {
        Name = "PUBLIC2"
    }
}


# privada 1
resource "aws_subnet" "subnet3" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1c"

    tags = {
        Name = "PRIVATE1"
    }
}
# privada 2
resource "aws_subnet" "subnet4" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1d"

    tags = {
        Name = "PRIVATE2"
    }
}


# tabla de enrutamiento
resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "TABLE_ROUT"
    }
}

# enlazo la tabla con las subredes
resource "aws_route_table_association" "subnet1" {
    subnet_id      = aws_subnet.subnet1.id
    route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet2" {
    subnet_id      = aws_subnet.subnet2.id
    route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet3" {
    subnet_id      = aws_subnet.subnet3.id
    route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet4" {
    subnet_id      = aws_subnet.subnet4.id
    route_table_id = aws_route_table.main.id
}


# Gateway de internet
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "GATEWAY"
    }
}


# grupo de seguridad
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
