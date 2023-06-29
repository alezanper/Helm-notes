# Create an nginx chart
helm create nginxchart

# Install general chart
helm install nginxchart nginxchart

# Add values to work with at values.yaml
custom:
  labels:
    label1: value1
    label2: value2
    label3: value3

# Include the block the the template(s) that require the labels:
{{- with .Values.custom.labels }}
labels:
{{- toYaml . | nindent 4}}
{{- end}}

# Compile an generate the template
helm template nginxchart