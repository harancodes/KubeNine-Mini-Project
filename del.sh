#!/bin/bash
VPC_ID="vpc-0cde4382a1c7d1455"
REGION="your-region"

echo "=== Checking dependencies for VPC $VPC_ID ==="

# Check for network interfaces (most common culprit)
echo "Network Interfaces:"
aws ec2 describe-network-interfaces --region $REGION --filters "Name=vpc-id,Values=$VPC_ID" --query 'NetworkInterfaces[*].[NetworkInterfaceId,Description,Status,Attachment.InstanceId]' --output table

# Check for NAT Gateways
echo "NAT Gateways:"
aws ec2 describe-nat-gateways --region $REGION --filter "Name=vpc-id,Values=$VPC_ID" --query 'NatGateways[*].[NatGatewayId,State]' --output table

# Check for Load Balancers
echo "Load Balancers:"
aws elbv2 describe-load-balancers --region $REGION --query 'LoadBalancers[?VpcId==`'$VPC_ID'`].[LoadBalancerName,Type,State.Code]' --output table

# Check for VPC Endpoints
echo "VPC Endpoints:"
aws ec2 describe-vpc-endpoints --region $REGION --filters "Name=vpc-id,Values=$VPC_ID" --query 'VpcEndpoints[*].[VpcEndpointId,ServiceName,State]' --output table

# Check for Elastic IPs
echo "Elastic IPs:"
aws ec2 describe-addresses --region $REGION --query 'Addresses[?Domain==`vpc`].[AllocationId,PublicIp,InstanceId,NetworkInterfaceId]' --output table