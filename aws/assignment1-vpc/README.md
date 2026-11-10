# Assignment 1 — VPC & Networking

## Objective

The objective of this assignment was to design and build a custom AWS networking environment from scratch. The environment included a VPC, public and private subnets, an Internet Gateway, a NAT Gateway, route tables, EC2 instances and security groups.

The design was intended to demonstrate network segmentation: the public EC2 instance could be reached from my laptop, while the private EC2 instance had no public IP and could only be accessed through the public bastion host.

This assignment was not only about creating AWS resources. It was also about understanding why each resource is needed and how the resources work together. The final design needed to demonstrate that:

- resources can be separated into different network zones;
- public resources can receive controlled inbound connections;
- private resources can initiate outbound connections without being directly exposed;
- routing determines where traffic goes;
- security groups restrict which connections are allowed; and
- a private server can be administered through a controlled bastion-host access path.

### Success criteria

The lab was considered successful when the following behaviour could be demonstrated:

1. The public EC2 instance had a public IPv4 address and could be reached over SSH from my IP address.
2. The private EC2 instance had no public IPv4 address.
3. The private EC2 instance could not be reached directly from the internet.
4. The private EC2 instance could be reached from the public EC2/bastion host using an internal VPC address.
5. The private subnet had an outbound route through the NAT Gateway.
6. The public subnet had an outbound route through the Internet Gateway.

## Why this architecture is needed

### What is a VPC?

An Amazon Virtual Private Cloud is an isolated, logically defined network inside AWS. It gives me control over the private IP address range, subnets, routing and network access rules used by resources such as EC2 instances.

Using a custom VPC makes the design explicit. Instead of relying on a default VPC with pre-created networking components, I created the network boundaries and routing myself so that I could understand and document each decision.

### Why are subnets needed?

A subnet is a smaller network segment inside a VPC. Subnets divide the VPC address space into separate areas where resources can be placed. They are also associated with Availability Zones, which gives AWS a physical and logical placement boundary for resources.

The two subnets were needed to separate resources according to their exposure and function:

- The **public subnet** contained the public EC2 instance and NAT Gateway. It had a route to the Internet Gateway.
- The **private subnet** contained the private EC2 instance. It did not have a direct route to the Internet Gateway and did not assign a public IPv4 address.

This separation reduces the attack surface. A server that does not need to accept connections directly from the internet should not be placed in the same network segment as an internet-facing server. The private subnet provides an additional boundary, while the route table and security group determine exactly what traffic is allowed.

It is important to note that a subnet is not automatically public merely because it is named “public”. A subnet is effectively public when its route table has a route to an Internet Gateway and its resources have the addressing and security-group rules required for public access.

### Why are separate route tables needed?

Route tables act like traffic-direction rules for a subnet. They determine the next hop for traffic leaving an instance. Separate route tables were needed because the public and private subnets require different default routes:

```text
Public subnet:  0.0.0.0/0 → Internet Gateway
Private subnet: 0.0.0.0/0 → NAT Gateway
```

Without separate route tables, both subnets could be given the same network behaviour, which would undermine the intended public/private separation.

### Why use an Internet Gateway?

An Internet Gateway, or IGW, is attached to the VPC and provides a path between the VPC and the public internet. It is used by resources in a public subnet when they need direct internet connectivity.

For an EC2 instance to communicate directly with the internet, the network path normally requires all of the following:

- a subnet route table with a default route to the IGW;
- a public IPv4 address or another public-facing translation mechanism; and
- security-group rules allowing the required traffic.

### Why use a NAT Gateway?

A NAT Gateway allows instances in a private subnet to initiate outbound connections to the internet without giving those instances public IP addresses. The NAT Gateway translates the private instance’s source address and sends the traffic out through the public subnet and Internet Gateway.

The important security property is that the connection is initiated from the private instance. The NAT Gateway allows the returning traffic for that connection, but it does not provide a route for an unsolicited connection from the internet into the private EC2 instance.

```text
Private EC2 → NAT Gateway → Internet Gateway → Internet       allowed
Internet → private EC2                                      not directly allowed
```

The NAT Gateway therefore provides controlled outbound access, not inbound public access.

### Why use security groups?

Security groups are stateful virtual firewalls attached to network interfaces. They control inbound and outbound traffic at the instance level. Because they are stateful, return traffic for an allowed connection is automatically permitted.

For this lab, the public security group allowed only the required SSH and HTTP traffic from my IP address. The private security group allowed SSH from the public EC2 security group rather than from the entire internet. Referencing the bastion security group means that access follows the role of the resource instead of depending on a fixed private IP address.

### Why use a bastion host?

A bastion host is a controlled entry point into a private network. In this design, my laptop connected to the public EC2 instance, and the public EC2 instance then connected to the private EC2 instance over the VPC’s internal network.

```text
My laptop → public EC2/bastion → private EC2
```

This avoids giving the private server a public IP or opening SSH to `0.0.0.0/0`. In production, bastion hosts should be hardened, monitored and tightly restricted; alternatives such as AWS Systems Manager Session Manager may also be preferred.

## Architecture plan

The architecture was planned before implementation using the following address space:

| Resource | CIDR / configuration |
|---|---|
| VPC | `10.0.0.0/16` |
| Public subnet | `10.0.1.0/24` |
| Private subnet | `10.0.2.0/24` |
| Public default route | `0.0.0.0/0 → Internet Gateway` |
| Private default route | `0.0.0.0/0 → NAT Gateway` |

![Network plan](images/Network%20plan.png)

The final version of the network plan showed the public and private traffic paths, the route-table targets and the bastion-host relationship.

![Final network plan](images/Network%20plan%281%29.png)

## Resources created and their purpose

| Resource | Configuration | Purpose |
|---|---|---|
| VPC | `10.0.0.0/16` | Provides the isolated AWS network and overall private address space. |
| Public subnet | `10.0.1.0/24` | Holds resources that need a path to the public internet. |
| Private subnet | `10.0.2.0/24` | Holds resources that should not be directly reachable from the internet. |
| Internet Gateway | Attached to the VPC | Provides the VPC’s public internet path. |
| Public route table | `0.0.0.0/0 → IGW` | Sends public-subnet internet traffic to the Internet Gateway. |
| Private route table | `0.0.0.0/0 → NAT Gateway` | Sends private-subnet outbound traffic to the NAT Gateway. |
| Elastic IP | Allocated to the NAT Gateway | Provides a stable public address for NAT traffic. |
| Public EC2 | Public IPv4 enabled | Acts as the public server and bastion host. |
| Private EC2 | No public IPv4 | Provides a protected internal server. |
| Public security group | SSH/HTTP from my IP | Restricts access to the public EC2. |
| Private security group | SSH from public EC2 security group | Restricts access to the private EC2. |

## Implementation steps

### 1. Created the VPC and subnets

I created a custom VPC with the `10.0.0.0/16` CIDR range. A `/16` provides a large private address space for the VPC, while the `/24` subnet ranges divide that space into smaller network segments.

I then created separate public and private subnets within the VPC. The public subnet was `10.0.1.0/24`, and the private subnet was `10.0.2.0/24`. These ranges do not overlap, so AWS can route traffic between them using the VPC’s local route.

The subnet choice was deliberate: the public subnet was intended for the bastion host and NAT Gateway, while the private subnet was intended for the internal EC2 instance. The subnet names alone do not create this behaviour; the route-table associations created that behaviour later.

![Public subnet settings](images/Public%20Subnet%20settings.png)

![Private subnet settings](images/Priv%20subnet%20settings.png)

### 2. Configured the Internet Gateway

I created an Internet Gateway and attached it to the custom VPC. Attaching the IGW alone does not automatically make every subnet public. The public route table also had to send internet-bound traffic to the IGW, and the public EC2 instance needed a public IPv4 address.

The resulting public traffic path was:

```text
Public EC2 → public route table → Internet Gateway → internet
```

![Internet Gateway](images/IGW.png)

![Route table and Internet Gateway association](images/rt%20and%20igw%20assoc.png)

### 3. Created the NAT Gateway and Elastic IP

I allocated an Elastic IP and used it when creating a public NAT Gateway in the public subnet. A public NAT Gateway must be placed in a subnet that has a route to the Internet Gateway; otherwise, it cannot forward traffic to the internet.

The NAT Gateway was required so that the private EC2 instance could initiate outbound internet connections without receiving a public IP address. The Elastic IP gave the NAT Gateway a stable public address for translated traffic. It was not intended to be attached to the private EC2 instance.

The resulting private outbound path was:

```text
Private EC2
→ private route table
→ NAT Gateway with Elastic IP
→ public route table
→ Internet Gateway
→ internet
```

![Elastic IP](images/elastic%20ip.png)

![NAT Gateway settings](images/Nat%20gateway%20settings.png)

### 4. Configured the route tables

I created two route tables because the two subnets needed different default routes. Each route table automatically retained the local VPC route, which allows resources inside the VPC to communicate using private IP addresses.

The public route table was associated with the public subnet and contained a default route to the Internet Gateway:

```text
10.0.0.0/16 → local
0.0.0.0/0 → Internet Gateway
```

![Public route table](images/pub%20rt%20settings.png)

The private route table was associated with the private subnet and contained a default route to the NAT Gateway:

```text
10.0.0.0/16 → local
0.0.0.0/0 → NAT Gateway
```

![Private route table](images/priv%20rt%20settings.png)

The distinction between these routes is important. During troubleshooting, I initially associated the wrong route table with the public subnet, causing the public EC2 connection to time out. The public subnet had to use the IGW route; the NAT Gateway route was intended for the private subnet.

### 5. Created the security groups

The public EC2 security group allowed SSH on TCP port 22 and HTTP on TCP port 80 from my IP address. Restricting these rules to my IP reduced unnecessary exposure during the lab.

The SSH rule allowed me to administer the bastion host. The HTTP rule was included to meet the assignment requirement and would allow me to test a web server from my own connection. In a real public website design, HTTP might need to be available to users from wider sources, but that was not necessary for this restricted lab.

![Public security group](images/pub%20sg.png)

The private EC2 security group allowed SSH only from the public EC2 security group. This meant that the private server could not be accessed directly from the internet. Using the bastion security group as the source was more flexible and safer than allowing SSH from every IPv4 address.

![Private security group](images/priv%20sg.png)

### 6. Launched the EC2 instances

I launched one EC2 instance in the public subnet and one in the private subnet.

The public instance had a public IPv4 address and acted as the bastion host. The public IP allowed my laptop to reach the instance over the internet, while the public security group limited which inbound connections were accepted.

The private instance had only a private IPv4 address. It could communicate with resources inside the VPC through the local route and could use the NAT Gateway for outbound access, but it had no public address that an internet client could connect to directly.

![Public EC2 instance](images/pub%20inst.png)

![Both instances running](images/both%20instances%20running.png)

### 7. Prepared SSH access

I used the EC2 key pair to authenticate to the instances. The key pair is separate from the network path: the public IP, route table and security group determine whether SSH can reach the server, while the private key authenticates me after the connection reaches the SSH service.

The private key permissions were restricted using `chmod 400`, as required by SSH. This ensures that the key is readable only by its owner and prevents OpenSSH from rejecting it because it is too broadly accessible.

![Local key permissions](images/chmod%20400.png)

![Key permissions on the bastion](images/chmod%20in%20bastion.png)

## Connectivity tests

The tests were designed to verify behaviour, not just configuration. A route-table screenshot shows the intended path, but a successful SSH connection or a blocked connection demonstrates what the network actually allows.

### SSH access to the bastion host

I successfully connected from my laptop to the public EC2 instance using SSH. This confirmed that the instance had a working public route through the Internet Gateway, a public IPv4 address and an appropriate inbound security-group rule.

![SSH into bastion](images/ssh%20into%20bastion.png)

### SSH access to the private EC2 instance

From inside the bastion host, I successfully connected to the private EC2 instance using its private IP address. This demonstrated that the private security group allowed SSH from the bastion security group and that traffic could move between the two subnets through the VPC’s local routing.

![Bastion to private server](images/bastion%20to%20priv%20server%20success.png)

### Direct access to the private server was blocked

I also confirmed that the private server could not be accessed directly without going through the bastion host. This demonstrated the intended segmentation between the public and private subnets. The private server did not have a public IPv4 address, and its security group did not allow SSH from the public internet.

![Private server inaccessible without bastion](images/confirmed%20privsv%20no%20access%20without%20bastion.png)

### Private-server outbound internet test

The private server was configured to send internet-bound traffic to the NAT Gateway through the private route table. I completed the connectivity test during the lab, but I did not capture a screenshot of the terminal output before tearing down the environment. The NAT Gateway configuration and private route-table screenshot provide supporting evidence for the intended outbound path.

The test I intended to document was a command such as:

```bash
curl -I https://aws.amazon.com
```

or:

```bash
ping -c 4 google.com
```

The expected result was that the private instance could initiate an outbound connection through the NAT Gateway, while a new inbound SSH connection from the internet would still not be possible.

The expected traffic flow was:

```text
Private EC2
→ Private route table
→ NAT Gateway
→ Internet Gateway
→ Internet
```

The NAT Gateway allows connections initiated by the private instance to reach the internet, while preventing unsolicited inbound connections from reaching the private instance.

## Troubleshooting lesson

Initially, I could not SSH into the public bastion host and the connection timed out. After checking the instance, security group and subnet settings, I discovered that the public subnet was associated with the wrong default route. Its route table was sending `0.0.0.0/0` traffic to the NAT Gateway instead of the Internet Gateway.

The correct routing design is:

```text
Public subnet  → Internet Gateway
Private subnet → NAT Gateway → Internet Gateway
```

After correcting the route-table association, SSH access to the bastion worked. This troubleshooting process reinforced the importance of checking routing before assuming that an SSH problem is caused by the key pair or username.

The timeout was a useful diagnostic clue. A timeout occurred before SSH authentication, so the key pair had not yet been tested. If the network path had been working but the key or username was wrong, I would normally expect an authentication error such as `Permission denied (publickey)` instead. This helped separate network-layer problems from authentication problems.

I also learned that the NAT Gateway should not replace the Internet Gateway route for a public subnet. The NAT Gateway is placed in the public subnet so it can reach the IGW, but it primarily serves private-subnet resources. The public EC2 instance itself should use the IGW route directly.

## Optional bonus requirements

### Bastion host

The bastion-host bonus was completed. The public EC2 instance served as the bastion host, and I used it as the controlled SSH entry point to the private EC2 instance.

### CloudWatch monitoring

CloudWatch monitoring was not included in the captured evidence for this assignment. The basic EC2 monitoring available through AWS is enabled by default, while more detailed monitoring can be configured separately. If extending the lab, I would enable detailed monitoring and review metrics such as CPU utilisation, network traffic and status-check failures. I would also consider configuring alarms so that unusual behaviour or instance health problems generated an alert.

## Key lessons learned

- A VPC provides the isolated network boundary in which the AWS resources are deployed.
- Subnets divide the VPC into smaller zones so public-facing and internal resources can be separated.
- A public subnet needs a route to an Internet Gateway.
- A subnet becomes public through its route-table and addressing configuration; the name alone is not enough.
- A private subnet can use a NAT Gateway for outbound internet access without having a public IP.
- A NAT Gateway belongs in a public subnet, but it serves private resources.
- An Internet Gateway and NAT Gateway solve different problems: the IGW provides public VPC connectivity, while NAT provides translated outbound access for private resources.
- Route tables decide the next hop for traffic, while security groups decide which instance connections are allowed.
- Security groups can reference another security group as the source of permitted traffic.
- A bastion host provides a controlled access path to private instances.
- A public IP address provides reachability, but it does not replace a route or a security-group rule.
- Architecture diagrams are useful for planning and troubleshooting, not just documentation.
- Route-table mistakes can cause connection timeouts before SSH authentication is even reached.

## Cleanup

After completing the tests, I tore down the lab environment to avoid unnecessary AWS charges. This included deleting the EC2 instances and NAT Gateway, releasing the Elastic IP, removing the route tables and subnets, detaching the Internet Gateway and deleting the VPC.

## Conclusion

This assignment gave me practical experience designing AWS networking infrastructure and troubleshooting connectivity. It helped me understand how public and private subnets, route tables, Internet Gateways, NAT Gateways, security groups and bastion hosts work together to provide controlled access and network segmentation.
