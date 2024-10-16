
# EFK Stack Deployment on Kubernetes with EBS

## 1. Commands to Add EBS CSI Driver

To add the Amazon EBS CSI driver, use one of the following methods depending on how you're managing your cluster.

### Option 1: Install EBS CSI Driver via AWS EKS Add-ons
If you're using **Amazon EKS**, you can install the CSI driver as an add-on:

```bash
aws eks create-addon --cluster-name <your-cluster-name> --addon-name aws-ebs-csi-driver
```

### Option 2: Install EBS CSI Driver via Helm
If you’re not using EKS or prefer using Helm:

1. Add the Helm repo:
    ```bash
    helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
    ```

2. Install the CSI driver:
    ```bash
    helm install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver     --namespace kube-system     --set controller.serviceAccount.create=true     --set controller.serviceAccount.name=ebs-csi-controller-sa
    ```

---

## 2. Security Policy to Attach

The following IAM policy allows the EBS CSI driver to manage Amazon EBS volumes:

```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateVolume",
    "ec2:DeleteVolume",
    "ec2:AttachVolume",
    "ec2:DetachVolume",
    "ec2:ModifyVolume",
    "ec2:DescribeAvailabilityZones",
    "ec2:DescribeVolumes",
    "ec2:DescribeVolumesModifications"
  ],
  "Resource": "*"
}
```

You need to attach this policy to the IAM role associated with your EKS worker nodes or Kubernetes nodes.

To attach this policy:
- Go to the **IAM Console** in AWS.
- Find the node instance role (`eksctl-<cluster-name>-nodegroup-<group-name>-NodeInstanceRole`).
- Attach the policy above or the AWS-managed policy **AmazonEBSCSIDriverPolicy**.

---

## 3. Commands to Run the EFK Stack (Elasticsearch, Fluentd, Kibana)

Once your YAML files are ready (with the appropriate configuration for Kibana, Elasticsearch, and Fluentd), use the following commands to deploy the stack.

1. Create the namespace:
   ```bash
   kubectl create namespace elastic-stack
   ```

2. Apply the **Elasticsearch** StatefulSet and Service:
   ```bash
   kubectl apply -f elasticSearch.statefulSet.yaml -n elastic-stack
   ```

3. Apply the **Fluentd** DaemonSet:
   ```bash
   kubectl apply -f fluentd.deployment.yaml -n elastic-stack
   ```

4. Apply the **Kibana** Deployment and Service:
   ```bash
   kubectl apply -f kibana.deployment.yaml -n elastic-stack
   ```

---

## 4. Commands to Check Deployment Status

To verify that all components are running and healthy, use the following commands:

1. **Check Pods in the `elastic-stack` Namespace**:
   ```bash
   kubectl get pods -n elastic-stack
   ```

2. **Check the PersistentVolumeClaims (PVCs)**:
   ```bash
   kubectl get pvc -n elastic-stack
   ```

3. **Check Logs for Kibana**:
   ```bash
   kubectl logs deployment/kibana -n elastic-stack
   ```

4. **Check Logs for Elasticsearch**:
   ```bash
   kubectl logs statefulset/elasticsearch -n elastic-stack
   ```

5. **Check Logs for Fluentd**:
   ```bash
   kubectl logs daemonset/fluentd -n elastic-stack
   ```

---

## Additional Information:
- Once the stack is deployed and running, Kibana should be accessible via the NodePort or LoadBalancer service. 
- Ensure your security group allows access to the Kibana port (e.g., 32001 if using NodePort).

