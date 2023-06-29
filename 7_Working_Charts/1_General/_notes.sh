# Create an nginx chart
helm create nginxchart

# Structure	
#	chart.yaml
#	charts <folder>			# depending charts will be downloaded here
#	templates <folder>
#	values.yaml	

# Install general chart
helm install nginxchart nginxchart

# chart.yaml content:
apiVersion
name
description
icon
keywords
home
sources
maintainers: name, email

# /templates/_helpers.tpl content
stores information like charts name, labeles, etc

# Package chart
helm package nginxchart -u	# update dependencies with -u option

# To check the helm templates:
helm lint nginxchart
