# Check helm version
helm version

# list repos
helm repo list
helm repo ls

# Add a repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# apache:           name of release
# bitnami/apache:	repository
# Install apache chart
helm install apache bitnami/apache -namespace=<namespace>
helm install mywebserver bitnami/apache --namespace mynamespace --create-namespace

# upgrade apache chart
helm upgrade apache bitnami/apache -namespace=<namespace>

# Check version history show be 2 version
helm history apache

# Rollback to version 1
helm rollback apache 1 -namespace=<namespace>

# Check secrets. Eache installation will generate a secret
kubectl get secrets

# Uninstall apache
helm uninstall apache

# Remove repo
helm repo remove bitnami

