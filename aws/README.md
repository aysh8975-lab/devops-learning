# AWS DevOps Assignments

This repository contains practical AWS assignments completed as part of my DevOps learning journey with CoderCo. The assignments build progressively: Assignment 1 focuses on designing secure AWS networking, while Assignment 2 introduces application availability and traffic distribution using an Application Load Balancer.

Together, the assignments demonstrate how AWS infrastructure can be designed, configured, tested and documented. They also show the importance of understanding how different AWS services work together rather than treating each service as an isolated component.

## Assignment 1 — VPC and Networking

Assignment 1 focused on building a custom network environment in AWS using Amazon VPC. I created a VPC with separate public and private subnets, allowing resources to be placed according to their required level of internet exposure.

The public subnet contained an EC2 instance that acted as a bastion host. This instance had a public IP address and could be accessed through SSH from an approved IP address. The private subnet contained an EC2 instance with no public IP address. The private instance could not be accessed directly from the internet and was accessed through the bastion host using its private VPC address.

The assignment also included an Internet Gateway, NAT Gateway, Elastic IP, route tables and security groups. The Internet Gateway provided the public internet path, while the NAT Gateway allowed the private instance to make outbound connections without making it directly reachable from the internet. Separate route tables controlled the traffic paths for the public and private subnets.

This assignment developed my understanding of CIDR ranges, subnetting, Availability Zones, routing, public and private IP addresses, security groups, NAT and controlled administrative access.

## Assignment 2 — Application Load Balancer

Assignment 2 focused on deploying two EC2 web servers behind an Application Load Balancer. For this assignment, I used the default VPC and placed the two instances in separate default subnets across two Availability Zones where possible.

Each EC2 instance used user data to install and start Apache. The web page displayed the instance hostname, making it possible to identify which server responded to a request. The two instances were registered with a target group using HTTP on port 80.

The Application Load Balancer acted as the single public entry point for the application. It used an HTTP listener on port 80 and forwarded incoming requests to the target group. The ALB performed health checks against the root path `/` and sent traffic only to targets that were considered healthy.

Separate security groups were used for the ALB and EC2 instances. The ALB security group allowed HTTP traffic from the internet, while the EC2 security group allowed HTTP traffic only from the ALB security group. This demonstrated security-group referencing and ensured that application traffic was intended to pass through the load balancer rather than directly to the web servers.

Testing involved accessing the ALB DNS name, refreshing the page to observe responses from both instances and confirming that both targets showed a healthy status. The resources were then removed after testing to avoid unnecessary AWS charges.

## Overall learning outcome

These assignments helped me connect AWS networking concepts with real application infrastructure. Assignment 1 established the network and security foundations, while Assignment 2 showed how to distribute traffic across multiple servers and improve availability. The detailed steps, diagrams, screenshots and testing evidence are documented separately for each assignment.
