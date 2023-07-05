# Install apache generating the name
helm install bitnami/apache --generate-name

# Install apache generating the name using a template
helm install bitnami/apache --generate-name --name-template "mywebserver-{{randAlpha 7 | lower}}"

# Install apache by setting a timeout
helm install mywebserver bitnami/apache --wait --timeout 10m10s 

# Install apache by setting a timeout with atomic configuration (all or nothing)
helm install mywebserver bitnami/apache --atomic --wait --timeout 7m12s

# Force and upgrade apache by recreating the whole deployment
helm upgrade mywebserver bitnami/apache --force		# delete the deployment and create new ones

# Upgrade cleaning on failure
helm upgrade mywebserver bitnami/apache --cleanup-on-failure
