# 📚 Amazon VPC CNI Plugin.

Amazon VPC CNI is the networking plugin used by Amazon EKS to give Kubernetes pods IP addresses directly from your VPC, ensuring pods are first-class citizens in the VPC network.

### Can we use other network plugin other than VPC CNI with EKS❓

Yes, you can use other Kubernetes network plugins (like Calico, Cilium, Antrea, or Contrail) instead of Amazon VPC CNI in EKS, but doing so comes with trade‑offs. The biggest drawback is losing native AWS VPC integration — pods won’t get routable VPC IPs, which impacts simplicity, performance, and compatibility with AWS services. 

### ⚠️ Cons of other network plugins with AWS EKS

- Fargate nodes only support VPC CNI — alternate CNIs cannot run there.
- Some AWS features (like Security Groups for Pods) rely on VPC CNI.
- EKS Auto Mode does not support alternate CNIs.
- Amazon VPC CNI is the default and safest choice for EKS because it integrates seamlessly with AWS networking.
- Alternatives (Calico, Cilium, etc.) can be used for advanced policy or observability, but they add complexity and lose native AWS features.
- If you adopt an alternate plugin, ensure you have vendor support or strong in‑house networking expertise.

---

## 📖 Steps to install Amazon VPC CNI plugin with Secondary CIDR for POD.

1. Need to create IRSA `system:serviceaccount:kube-system:aws-node`

2. Need to attach this `arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy` policy to IRSA role.

3. Create resource Amazon VPC CNI. Pass cluster name, IRSA role, Addon name and Addon version.

4. Create ENIConfig custom networking 

---

### 📖 Why ENIConfig Name Must Match the Availability Zone

The VPC CNI plugin uses the ENI_CONFIG_LABEL_DEF environment variable to decide how to map nodes to ENIConfigs.

In your setup, you set:

```hcl
ENI_CONFIG_LABEL_DEF = "topology.kubernetes.io/zone"
```
That means the CNI looks at the AZ label on each node (topology.kubernetes.io/zone=us-east-1a, etc.).

It then tries to find an ENIConfig resource with the same name as that AZ.

Example:

Node in us-east-1a → label topology.kubernetes.io/zone=us-east-1a

CNI searches for ENIConfig named us-east-1a

If found, it uses the subnet/security groups defined there to allocate pod IPs.

If the ENIConfig name doesn’t match the AZ label, the aws‑node daemonset won’t find it, and pod IP allocation fails.

---

### 📖 Why kube‑system Pods Use Primary Subnet

Custom networking applies only to regular workloads (pods in your namespaces).

`The aws‑node daemonset itself, kube‑proxy, and other system add‑ons in the kube-system namespace are considered infrastructure pods.`

These pods are deliberately assigned IPs from the primary ENI/subnet where the node was launched.

`The reason:`

- They need guaranteed connectivity to the Kubernetes control plane and cluster services.
- They must come up even if secondary ENIConfig mappings are misconfigured.
- AWS designed the CNI so that system pods don’t depend on custom networking, reducing risk of cluster bootstrap failures.