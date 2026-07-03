## 🌟 EKS Add-ons

Amazon EKS **add-ons** are managed integrations that simplify the installation and lifecycle management of critical Kubernetes components. Instead of manually deploying and upgrading these components, EKS add-ons allow you to enable, configure, and update them directly through the EKS console, CLI, or Terraform.

### Common EKS Add-ons
- **[Amazon VPC CNI](ca://s?q=Amazon_VPC_CNI_Addon)** – Manages pod networking in EKS clusters, allowing pods to receive IP addresses from the VPC.
- **[CoreDNS](ca://s?q=CoreDNS_in_EKS)** – Provides DNS-based service discovery for Kubernetes workloads.
- **[kube-proxy](ca://s?q=Kube_proxy_in_EKS)** – Maintains network rules on nodes to allow communication between pods and services.
- **[Amazon EBS CSI Driver](ca://s?q=Amazon_EBS_CSI_Driver_Addon)** – Enables dynamic provisioning and management of Amazon EBS volumes.
- **[Amazon EFS CSI Driver](ca://s?q=Amazon_EFS_CSI_Driver_Addon)** – Provides persistent storage using Amazon EFS file systems.
- **[AWS Load Balancer Controller](ca://s?q=AWS_Load_Balancer_Controller_Addon)** – Manages AWS Application Load Balancers (ALB) and Network Load Balancers (NLB) for Kubernetes Ingress resources.

### Benefits of Using Add-ons
- **Simplified Management** – Install and update directly from EKS without manual Helm/Terraform steps.
- **Version Control** – EKS ensures compatibility between add-on versions and Kubernetes versions.
- **Security Updates** – Critical patches are easier to apply through managed add-ons.
- **Consistency** – Standardized deployment across clusters.

---

## 📚 Terraform Modules for Addons.

| Addon Name | Description | Documentation |
|:-------------|:-------------|:----------------|
| amazon-ebs-csi-driver        | Install Amazon EBS CSI Driver which help to create EBS volumes. | [amazon-ebs-csi-driver ](amazon-ebs-csi-driver/README.md) |
| amazon-efs-csi-driver        | Install Amazon EFS CSI Driver which help to create EFS volume. | [amazon-efs-csi-driver ](amazon-efs-csi-driver/README.md) |
| k8s-ingress-controller        | Install Kubernetes Ingress Controller which help to create Ingress load balancers. | [ingress-controller ](ingress-controller/README.md) |
| dynatrace operator       | Install Dynatrace operator and oneagent for K8S monitoring. | [dynatrace-operator ](dynatrace-operator/README.md) |
| amazon vpc cni       | Install Amazon VPC CNI plugin for custom pod networking. | [amazon-vpc-cni ](amazon-vpc-cni/README.md) |