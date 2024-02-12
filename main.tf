resource "aws_launch_configuration" "web_server_as" {
    name_prefix        = "web-server-as-"  # Added name_prefix to ensure unique names
    image_id           = "ami-06b72b3b2a773be2b"
    instance_type      = "t2.micro"
    key_name           = "ansible-kp"  # Corrected key pair name
}

resource "aws_elb" "web_server_lb" {
    name             = "web-server-lb"
    security_groups  = [aws_security_group.web_server.id]
    subnets          = ["subnet-03ac495b978db1d94", "subnet-09b4e38787b97c35c"]
    listener {
        instance_port     = 8000
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
    tags = {
        Name = "terraform-elb"
    }
}

resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    launch_configuration = aws_launch_configuration.web_server_as.name  # Corrected reference
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]  # Corrected reference
    availability_zones   = ["ap-south-1a", "ap-south-1b"]
}
