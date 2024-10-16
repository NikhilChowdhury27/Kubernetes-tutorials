
# AWS EKS Setup Documentation

## 1. Steps to Configure AWS Credentials

```bash
aws configure
```
You will be prompted to enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., `us-west-2`)
- Default output format (json)

## 2. Installing EKSctl

```bash
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl
```

Verify the installation:

```bash
eksctl version
```

## 3. Creating a Cluster with EKSctl

```bash
eksctl create cluster --name <cluster-name> --region <region-name>
```

Example:

```bash
eksctl create cluster --name my-cluster --region us-west-2
```

## 4. Switching Context with Kubectl

List all available contexts:

```bash
kubectl config get-contexts
```

Switch to a specific context:

```bash
kubectl config use-context <context-name>
```

Example:

```bash
kubectl config use-context my-cluster-context
```
