# Networking Fundamentals Module Overview

This module covered the core networking concepts that support communication across local networks, cloud infrastructure, and the internet. Topics included network components, IP addressing, ports and protocols, DNS, routing, subnetting, NAT, troubleshooting, and a practical AWS EC2 + NGINX + Cloudflare assignment.

---

## Network Basics

A network connects devices so they can communicate and share resources such as files, applications, printers, and internet access.

### Common Network Types
- **LAN (Local Area Network):** Covers a small geographical area, such as a home, office, school, or building.
- **WAN (Wide Area Network):** Connects networks across large geographical areas. The internet is the largest example of a WAN.

### Key Network Components
| Component | Function |
|---|---|
| **Switch** | Connects devices within the same LAN and forwards traffic using MAC addresses |
| **Router** | Connects different networks and directs packets toward their destination using IP addresses and routing tables |
| **Firewall** | Controls incoming and outgoing network traffic based on configured security rules |

---

## IP and MAC Addressing

### IPv4
- 32 bits
- Written as four decimal numbers separated by dots
- Example: `192.168.0.5`
- Limited to approximately 4.3 billion addresses

IPv4 addresses can be:
- **Private:** Used inside local or cloud networks and not directly routable on the public internet
- **Public:** Routable across the internet

### IPv6
Introduced to provide a much larger address space.
- 128 bits
- Written using hexadecimal values separated by colons
- Example: `2001:db8::1`

### MAC Addresses
A MAC address is a 48-bit hardware identifier associated with a network interface.
Example: `00:18:2B:AA:BB:CC`

MAC addresses operate at the **Data Link layer** and are mainly used for communication within a local network.

---

## Ports and Protocols

Ports are logical communication endpoints, often described as doors that allow network services to receive traffic.

### Common Ports
| Port | Protocol/Service | Purpose |
|---|---|---|
| 22 | SSH | Secure remote administration |
| 53 | DNS | Domain name resolution |
| 80 | HTTP | Unencrypted web traffic |
| 443 | HTTPS | Encrypted web traffic |

### TCP (Transmission Control Protocol)
- Connection-oriented
- Reliable
- Uses a handshake before communication
- Provides delivery confirmation, sequencing, and error checking

**Common uses:** web browsing, email, file transfers, SSH

### UDP (User Datagram Protocol)
- Connectionless
- Faster and lower overhead
- Less reliable than TCP
- Does not guarantee delivery or ordering

**Common uses:** streaming, online gaming, voice/video communication, many DNS queries

---

## OSI and TCP/IP Models

### OSI Model (7 Layers)
1. **Physical** — Cables, signals, and hardware transmission
2. **Data Link** — Frames, switches, and MAC addresses
3. **Network** — IP addressing and routing
4. **Transport** — TCP and UDP
5. **Session** — Establishes and manages communication sessions
6. **Presentation** — Data formatting, encryption, and compression
7. **Application** — User-facing network services such as HTTP and DNS

### TCP/IP Model (4 Layers)
1. **Network Access**
2. **Internet** — IP addressing and routing
3. **Transport** — TCP and UDP
4. **Application** — HTTP, DNS, SSH, and other application protocols

---

## DNS (Domain Name System)

DNS translates human-readable domain names into IP addresses.
Example: `nginx.example.com` → `44.223.32.247`

DNS can be thought of as the internet's phone book.

### DNS Name Servers
- **Recursive resolver:** Searches for DNS information on behalf of the client and can cache results
- **Authoritative name server:** Stores the official DNS records for a domain and provides definitive answers

### Zone Files
A DNS zone contains DNS information for a domain. A zone file stores the DNS resource records used by authoritative name servers to answer queries.

### Common DNS Records
| Record | Purpose |
|---|---|
| A | Maps a domain or hostname to an IPv4 address |
| AAAA | Maps a domain or hostname to an IPv6 address |
| CNAME | Creates an alias pointing to another hostname |
| MX | Specifies mail servers for a domain |
| TXT | Stores verification information, metadata, and email security records |
| NS | Identifies the authoritative name servers for a domain |

### DNS Resolution Process

Client
↓
Local cache / hosts file
↓
Recursive DNS resolver
↓
Root DNS server
↓
TLD server (.com, .org, .co.uk, etc.)
↓
Authoritative name server
↓
IP address returned


The resolver caches results according to the record's **TTL (Time To Live)**.

### Domain Registrar vs. DNS Hosting Provider
- **Domain registrar:** Allows domains to be purchased and registered
- **DNS hosting provider:** Hosts DNS zones and manages DNS records

The same company can provide both services, but they don't have to be the same provider.

---

## Routing

Routing is the process of determining the best path for packets to travel across different networks. Routers use routing tables to decide where traffic should be sent.

Computer 1 → Local router → Multiple networks/routers → Computer 2


Routing is important because it:
- Reduces latency
- Improves network performance
- Supports reliable application delivery
- Helps manage complex cloud and enterprise infrastructure
- Allows engineers to troubleshoot connectivity problems

### Static Routing
- Manually configured
- Fixed until an administrator changes them
- Simple and predictable
- Suitable for small, stable networks
- Difficult to scale in large or frequently changing networks

### Dynamic Routing
- Uses routing protocols and algorithms
- Automatically adapts to network changes
- Can find alternative paths after failures
- More scalable for large and complex networks

### Common Routing Protocols

**OSPF — Open Shortest Path First**
- Commonly used inside large organisations
- Uses link-state information
- Calculates efficient paths using link costs
- Fast convergence when network changes occur

**BGP — Border Gateway Protocol**
- Routes traffic between Autonomous Systems (ASs)
- Uses path-vector information
- Supports routing policies
- Core protocol used to exchange routes across the internet

---

## Subnetting and CIDR

Subnetting divides a large network into smaller subnetworks.

**Benefits:**
- Better organisation
- Improved performance
- Reduced broadcast traffic
- More efficient IP address allocation
- Easier network management and security control

### CIDR Notation
Example: `192.168.1.0/24`

The `/24` means:
- First 24 bits = network portion
- Remaining 8 bits = host portion

### Subnet Mask
The equivalent subnet mask is `255.255.255.0`. The subnet mask identifies which bits belong to the network and which belong to hosts.

### Basic Subnetting Method
1. Identify the CIDR prefix
2. Calculate host bits: `Host bits = 32 − CIDR prefix`
3. Calculate the number of addresses: `Total addresses = 2^(host bits)`
4. Calculate usable hosts: `Usable hosts = total addresses − 2`
5. Find the subnet block size
6. Identify: Network ID, first usable host, last usable host, broadcast address, next network

### Example: `192.168.1.0/26`
- Network bits: 26
- Host bits: 32 − 26 = 6
- Total addresses: 2⁶ = 64
- Usable hosts: 64 − 2 = 62
- Block size: 64

| Network ID | Usable Host Range | Broadcast |
|---|---|---|
| 192.168.1.0/26 | .1 – .62 | .63 |
| 192.168.1.64/26 | .65 – .126 | .127 |
| 192.168.1.128/26 | .129 – .190 | .191 |
| 192.168.1.192/26 | .193 – .254 | .255 |

> If the target IP is exactly the network address (e.g. `192.168.1.0/26`), it's the **Network ID** — there is no address before it within that subnet.

---

## NAT (Network Address Translation)

NAT translates private IP addresses into public IP addresses so internal devices can communicate with the internet.

Private device: 192.168.1.10
↓ (Router performs NAT)
Internet sees: Public IP address


When the response returns, the router translates the traffic back to the correct private device.

### Types of NAT

**Static NAT**
- One private IP ↔ one public IP
- Fixed one-to-one mapping
- Useful for servers that require a consistent public address

**Dynamic NAT**
- Private addresses are mapped to available public addresses from a pool
- Public addresses are assigned as needed

**PAT — Port Address Translation** (also called NAT Overload)
- Many private devices share one public IP
- Different source ports identify different connections
- Commonly used by home routers

### Benefits of NAT
- Conserves public IPv4 addresses
- Allows private addressing inside networks
- Hides internal IP addresses from direct exposure
- Simplifies network design

---

## Network Troubleshooting

### Useful Tools
| Tool | Purpose |
|---|---|
| `ping host` | Tests basic connectivity |
| `traceroute host` (`tracert host` on Windows) | Shows the path traffic takes through routers |
| `nslookup domain` | Queries DNS information |
| `dig domain` | Provides detailed DNS query information |

```bash
dig NS example.com          # Finds a domain's name servers
dig +short NS example.com   # Returns a shorter name-server result
```

### Systematic Troubleshooting Approach
When a website or service is not reachable:
1. Check that the server is running
2. Check the application/service status
3. Confirm the service is listening on the correct port
4. Test locally using `curl`
5. Check firewall or security-group rules
6. Verify routing and internet connectivity
7. Check DNS records and DNS resolution
8. Test from another browser or device
9. Check logs for errors

> A browser-specific issue can sometimes make a working service appear unavailable, so testing with another browser is a useful troubleshooting step.

---

## Practical Assignment: Host an NGINX Web Server on AWS EC2 and Connect a Domain

**Objective:** Launch an EC2 instance, install NGINX, allow HTTP traffic, and point a Cloudflare DNS record to the EC2 public IPv4 address.

**Final architecture:**

Browser → nginx.aishamoad.co.uk → Cloudflare DNS A record → EC2 Public IPv4 address
→ AWS Security Group (TCP port 80) → NGINX web server → "Welcome to nginx!" page


### Step 1: Buy or Register a Domain
Purchase or register a domain using a provider such as Cloudflare or AWS Route 53.
Example: `aishamoad.co.uk`

### Step 2: Launch an EC2 Instance

In the AWS Console:
1. Open EC2
2. Select **Instances**
3. Click **Launch instances**
4. Give the instance a name (e.g. `Myweb`)
5. Select an operating system: **Amazon Linux 2023** (Ubuntu can also be used)
6. Select an appropriate instance type, such as `t3.micro`
7. Create or select an SSH key pair
8. Download and securely store the `.pem` key file
9. Configure a security group:

| Rule | Protocol | Port | Source |
|---|---|---|---|
| SSH | TCP | 22 | My IP |
| HTTP | TCP | 80 | Anywhere (0.0.0.0/0) |

10. Launch the instance

### Step 3: Connect to the EC2 Instance

From WSL, move or copy the key into a secure location and set the correct permissions:
```bash
chmod 400 ~/Downloads/your-key.pem
```

Connect using:
```bash
ssh -i ~/Downloads/your-key.pem ec2-user@YOUR-EC2-PUBLIC-IP
```

For Amazon Linux, the default username is usually `ec2-user`. For Ubuntu, it's usually `ubuntu`.

![EC2 Instance](../images/instance.png)

### Step 4: Install NGINX

For Amazon Linux 2023:
```bash
sudo dnf install -y nginx
```

Enable NGINX so it starts automatically after a reboot:
```bash
sudo systemctl enable nginx
```

Start NGINX:
```bash
sudo systemctl start nginx
```

Check the service:
```bash
sudo systemctl status nginx
```

Expected status: `Active: active (running)`
Press `q` to exit the status screen.

### Step 5: Test NGINX Locally

```bash
curl http://localhost
```

You should receive HTML containing: `Welcome to nginx!`

Check that NGINX is listening on port 80:
```bash
sudo ss -tulpn | grep :80
```

Expected output should include `0.0.0.0:80` — this means NGINX is listening on port 80 across all IPv4 interfaces.

### Step 6: Test Using the EC2 Public IPv4 Address

In the AWS EC2 console:
1. Select the instance
2. Copy the Public IPv4 address
3. Open a browser
4. Visit: `http://YOUR-EC2-PUBLIC-IP`

Do **not** use the private IP address. Example: `http://xx.xxx.xx.xxx`

The NGINX landing page should load.

**If the page does not load:**
- Confirm the instance is running
- Confirm the security group allows TCP port 80 from `0.0.0.0/0`
- Confirm NGINX is active
- Confirm NGINX is listening on port 80
- Test another browser if the configuration appears correct

### Step 7: Create the Cloudflare DNS Record

In Cloudflare:
1. Open the domain
2. Go to **DNS → Records**
3. Click **Add record**
4. Configure:

| Setting | Value |
|---|---|
| Type | A |
| Name | `nginx` |
| IPv4 address | EC2 Public IPv4 address |
| Proxy status | DNS only |
| TTL | Auto |

Example: Type `A`, Name `nginx`, IPv4 address `xx.xxx.xx.xxx`, Proxy status `DNS only`, TTL `Auto`

Cloudflare automatically combines the record name with the domain: `nginx.aishamoad.co.uk`

![DNS Setup](../images/DNS.png)

### Step 8: Test the Domain

Wait for the DNS record to propagate, then open:
`http://nginx.aishamoad.co.uk`

The NGINX default page should appear.

![Live Site](../images/site.png)

---

## Important Notes
- Use the EC2 **Public** IPv4 address in the Cloudflare A record, not the private IP
- A private address such as `172.31.x.x` is used inside AWS and is not directly reachable from the public internet
- An auto-assigned EC2 public IPv4 address may change after the instance is stopped and started
- If the public IP changes, update the Cloudflare A record
- An Elastic IP can provide a persistent public IPv4 address if needed
- Stop the EC2 instance when it is not needed to avoid unnecessary charges
- Do not terminate the instance unless you are finished and no longer need its configuration

---

## Key Takeaway

This assignment demonstrated how networking concepts work together in a real cloud environment:

Domain name → DNS → Public IP address → Routing → AWS security group
→ TCP port 80 → NGINX web server → HTTP response → Browser


The project connected DNS, public and private IP addressing, routing, ports, firewalls/security groups, HTTP, Linux service management, and cloud infrastructure into one practical workflow.
