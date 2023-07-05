# The dry run command will generate the templates and the notes on console
helm install mydb bitnami/mysql --values values.yaml --dry-run

# It will generate only the template 
helm template mydb bitnami/mysql --values values.yaml
helm template mydb bitnami/mysql --values values.yaml > template.yaml

# It will generate the release notes
helm get notes mydb

# It will return the values passed during deployment
helm get values mydb

# It will return all values
helm get values mydb --all

# It will return values on revision 1
helm get values mydb --revision 1	# values provided on version 1
helm get manifest mydb --revision 1	# whole yaml for revision 1

