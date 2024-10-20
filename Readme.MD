this terraform code will create a 

+-------------------+
|       VPC         | (CIDR: 10.0.0.0/16)
|                   |
| +---------------+ |       +-------------------+
| | Public Subnet | |<----->| Internet Gateway   |
| | 10.0.1.0/24   | |       +-------------------+
| +---------------+ |
|                   |
| +---------------+ |
| | Public Subnet | |
| | 10.0.2.0/24   | |
| +---------------+ |
|                   |
| +---------------+ |
| | Private Subnet| |
| | 10.0.3.0/24   | |
| +---------------+ |
|                   |
| +---------------+ |
| | Private Subnet| |
| | 10.0.4.0/24   | |
| +---------------+ |
+-------------------+

+-------------------+
|       VPC         | (CIDR: 10.0.0.0/16)
|                   |
| +---------------+ |       +-------------------+
| | Public Route  | |<----->| Internet Gateway   |
| | Table         | |       +-------------------+
| +---------------+ |
|                   |
| +---------------+ |       +-------------------+
| | Security Group |<----->| EC2 Instances      |
| | SG1           | |       +-------------------+
| +---------------+ |
+-------------------+

Routing Table Routes:
- Destination: `0.0.0.0/0` -> Target: Internet Gateway

Security Group Rules:
- Ingress: 
   - SSH (Port 22)
   - HTTP (Port 80)
   - HTTPS (Port 443)
- Egress: Allow all outbound traffic

EC2 Instances:
- Instance A (Public Subnet 1)
- Instance B (Public Subnet 2)
- Vault Server (Private Subnet)


+-----------------------------------------------------------+
|                          TEST_VPC                         |
|                        (10.0.0.0/16)                      |
|                                                           |
|    +---------------------+      +---------------------+   |
|    |    Public Subnet 1  |      |    Public Subnet 2  |   |
|    |    (10.0.1.0/24)    |      |    (10.0.2.0/24)    |   |
|    +---------------------+      +---------------------+   |
|           |                               |               |
|           |                               |               |
|           +-------------------------------+               |
|                      +-----------------------------------+|
|                      |         Public Route Table         |
|                      +-----------------------------------+|
|                      | Route:                             |
|                      | Destination: 0.0.0.0/0             |
|                      | Target: Internet Gateway           |
|                      +-----------------------------------+|
|                               ^                           |
|                               |                           |
|                       +----------------------+            |
|                       | TEST_InternetGateway |            |
|                       +----------------------+            |
|                                                           |
|    +---------------------+      +---------------------+   |
|    |    Private Subnet 1 |      |   Private Subnet 2  |   |  
|    |    (10.0.3.0/24)    |      |  (10.0.4.0/24)      |   |  
|    +---------------------+      +---------------------+   |
|                                                           |
+-----------------------------------------------------------+

                           Security Group: SG1
                           ---------------------
                           Ingress Rules:
                           - SSH (Port 22)
                           - HTTP (Port 80)
                           - HTTPS (Port 443)
                           ---------------------
                           Egress Rule:
                           - Allow All Outbound Traffic


+-------------------+
|   EC2 Instances    |
+-------------------+
| TEST_instance      |
|(Public Subnet 1)   |
+-------------------+
| Vault-Server       |
|(Public Subnet 2)   |
+-------------------+