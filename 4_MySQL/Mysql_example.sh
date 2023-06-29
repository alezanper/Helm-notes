# Install mysql chart from bitnami
helm install mydb bitnami/mysql

# This will show the instructions for interact with the release
helm status mydb
# echo Username: root
# MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default mydb-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
# kubectl run mydb-mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.33-debian-11-r17 --namespace # default --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash
# mysql -h mydb-mysql.default.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"

# Checking chart installation status and details
helm list
helm list -n <namespace>

# Uninstall chart
helm uninstall mydb

# Install mysql chart overwritting the root password
helm install mydb bitnami/mysql --set auth.rootPassword=mypassword

# Install mysql chart overwriting default values
helm install mydb bitnami/mysql --values values.yaml

# Upgrade deployment with new values
helm upgrade mydb bitnami/mysql --values values_upgrade.yaml

# Keep data to reuse it during rollback actions
helm uninstall mydb --keep-history
helm rollback mydb 

# use previous data during an upgrade
helm upgrade mydb bitnami/mysql --reuse-values

