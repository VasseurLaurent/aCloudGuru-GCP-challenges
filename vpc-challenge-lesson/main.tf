/*
* ## Description 
*
* On this challenge I have deployed : 
*   - One custom VCP with 2 subnets and 2 cloud NAT
*   - One jumpstation reachable from internet on the port 22
*   - Two instances templates : frontend and backend
*   - Two instances groups (frontend and backend) , deployed on a dedicated subnets, public for frontend and private for backends
*   - Firewall rules : 
*       - Allow ICMP within the VPC
*       - Allow SSH from the jumpstation to the VPC
*       - Allow HTTP/HTTPS from outside to frontend instances (just firewall rules, not reachable because it needs a loabalancer)
*       - Allow HTTP/HTTPS from frontend to backend (only)
*/
