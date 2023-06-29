
-------------------------------------------

install bitnami/tomcat
get password
upgarde values.yaml
uninstall

valuesTomcat.yaml
--------------------
tomcatPassword: test
service:
  type: NodePort
  nodeports:
    http: 30007
--------------------

helm install tomcat bitnami/tomcat
helm status tomcat
echo Password: $(kubectl get secret --namespace default tomcat -o jsonpath="{.data.tomcat-password}" | base64 -d)

vim valuesTomcat.yaml

helm upgrade tomcat bitnami/tomcat --values valuesTomcat.yaml

https://bitnami.com/stack/tomcat/helm

https://artifacthub.io/packages/helm/bitnami/tomcat


helm release workflow

helm bitnami chart 



--------------------------------------
--------------------------------------

{{}}	actions
- 		to remove innecessary spaces
.		to pass values
.Values.<variable>

helm template firstchart	to generate template

.Chart.Name
.Chart.Vserion
.Chart.AppVersions
.Chart.Annotations

.Release.Name
.release.Namespace
.Release.IsInstall
.Release.IsUpgrade
.Release.Service

.Template.Name
.Template.BasePath

{{.Values.something | default "testdefault" | upper | quote}}

---------------------------------------
nindent		new line indent
toYaml

helm template function list

https://helm.sh/docs/chart_template_guide/function_list/

---------------------------------------

{{- if <not> .Value.my.flag }}
{{"Output of if" | nindent 2}}
{{- else}}
{{"Output of else" | nindent 2}}
{{- end}}

if and condition condition2

--------------------------------------

variables

{{ $myFlag := "test" }}
{{ $myFlag := .Values.my.flag }}
{{- if $myFlag }}

{{ $myFlag = false }}

--------------------------------------

loop dict

values.yaml
image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: ""

template.yaml
{{- range $key,$value := .Values.image}}
  - {{$key}}: {{$value | quote}}
{{- end]

--------------------------------------

debugging

helm install myapp firstchart --dry-run
helm template firstchart

--------------------------------------

manifest

helm ls 
helm get manifest firstapp 

--------------------------------------

helpers.tpl

--------------------------------------
--------------------------------------

Dependencies

on chart.yaml:

dependencies:
  - name: mysql
    version: "8.8.6"
    repository: "http://charts.bitnami.com/bitnami"


helm dependency update firstchart
helm install myfirstapp firstchart

after installing the dependency will be installed too.

-------------------------------------

version range

on chart.yaml:
dependencies:
  - name: mysql
    version: "=> 8.8.6 and < 9.0.0"
    repository: "http://charts.bitnami.com/bitnami"

^1.3.4 		>= 1.3.4 < 2.0.0
^2.x		>= 0.2.4 < 3
^0			>= 0.0.0 < 1.0.0

~1.3.4		>= 1.3.4 < 1.4.0
~2			>= 2	 < 3

--------------------------------------

dependency conditionals

on values.yaml

mysql:
  enable: false

on chart.yaml:
dependencies:
  - name: mysql
    version: "=> 8.8.6 and < 9.0.0"
    repository: "http://charts.bitnami.com/bitnami"
    condition: mysql.enabled

--------------------------------------

multiple condition dependencies

on values.yaml
tags:
  enable: false

on chart.yaml:
dependencies:
  - name: mysql
    version: "=> 8.8.6 and < 9.0.0"
    repository: "http://charts.bitnami.com/bitnami"
    tags:
      - enabled

--------------------------------------

pass values to dependencies

on values.yaml:
mysql:				# must be the same
  auth:
    rootPassword: test1234
  primary:
    service:
	  type: NodePort
	  nodePort: 30788

on chart.yaml:
dependencies:
  - name: mysql		# must be the same
    version: "=> 8.8.6 and < 9.0.0"
    repository: "http://charts.bitnami.com/bitnami"
    tags:
      - enabled

---------------------------------------

read values from child charts

export:
  service:
    port: 8080

on chart.yaml:
dependencies:
  - name: mysql		# must be the same
    version: "=> 8.8.6 and < 9.0.0"
    repository: "http://charts.bitnami.com/bitnami"
    tags:
      - enabled
    import-values:
      - service

----------------------------------------
use values not exported

where there is not a explicit export

on chart.yaml:
dependencies:
  - name: mysql		# must be the same
    version: "=> 8.8.6 and < 9.0.0"
    repository: "http://charts.bitnami.com/bitnami"
    tags:
      - enabled
    import-values:
	  - child: primary.service
	    parent: mysqlService

-----------------------------------------

Hooks
	a process during an installation we use hooks:
		data to db
		backing up a db

hookpod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "firstchart.fullname" . }}-pre-install"
  annotations:
    "helm.sh/hook": pre-install
    "helm.sh/hook-weight": "1"
	"helm.sh/hook-delete-policy": hook-succeded
spec:
  containers:
    - name: pre-install
      image: busybox
	  imagePullPoliciy: IfNotPresent
	  command: ['sh', '-c', 'echo Pod is Running']
  restartPoliciy: OnFailure


pre-install
post-install
pre-delete
post-delete
pre-upgrade
post-upgrade
pre-rollback
post-rollbacck
test

before-hook-creation
hook-succeded
hook-failed

-----------------------------------------

put hook on templates folder

-----------------------------------------

test folder including:

apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "firstchart.fullname" . }}-test-connection"
  labels:
    {{- include "firstchart.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
	  command: ['wget']
	  args: ['{{ include "firstchart.fullname" . }}:{{ .Values.service.port}}
  restartPoliciy: Never

helm install myfirstapp firstchart
helm test myfirstapp

----------------------------------------
----------------------------------------

repositories

create a folder chartsrepo

helm repo index chartsrepo/

helm package firstchart -d chartsrepo

helm repo index chartsrepo

----------------------------------------

install python

python download on a browser 

----------------------------------------

cd chartsrepo
python3 -m http.server --bind 127.0.0.1 8080

----------------------------------------

helm repo list 

helm repo add localrepo http://localhost:8080

helm install firstapp localrepo/firstchart

-----------------------------------------

helm pull

helm pull localrepo/firstchart

helm install fisrtapp firstchat-0.1.0.tgz

-----------------------------------------

update repositories

helm create secondchart
helm package secondchart -d chartsrepo

helm repo index chartsrepo/

helm search repo firstchart

helm repo update 
helm search repo secondchart

-----------------------------------------

github pages

create a repository on github

git clone <url>
cd <repo>
helm create demochart
helm package demochart
helm repo index .

git add .
git commit -m "initial commit"
git push

setting
	pages
	source -> master
	save

helm repo add gitrepo https://<github-account>.github.io/<repo-name>

helm repo list
helm install gitadd gitrepo/<reponame>

-----------------------------------------

with this feature can be uploaded several versions

since Helm 3.8.0 the environment variable HELM_EXPERIMENTAL_OCI is enabled by default

export HELM_EXPERIMENTAL_OCI=1

docker run -d --name oci-registry -p 5000:5000 registry

helm package firstchart

helm push firstchart-0.1.0.tgz oci://localhost:5000/helm-charts

helm show all oci://localhost:5000/helm-charts/firstchart --version 0.1.0

helm pull oci://localhost:5000/helm-charts/firstchart --version 0.1.0

helm template myrelease oci://localhost:5000/helm-charts/firstchart --version 0.1.0

helm install myrelease oci://localhost:5000/helm-charts/firstchart --version 0.1.0

helm upgrade myrelease oci://localhost:5000/helm-charts/firstchart --version 0.2.0

helm registry login -u myuser <oci registry>

helm registry logout <oci registry url>

----------------------------------------
----------------------------------------

Security

provenance, integrity

private key and public key
gnupg download (to create keys)

gpg --version

gpg --full-generate-key
	1
	3072
	0
	y
	alezanper
	alezanper@mail.com
	comments
	O

passphrase: test1234

gpg --export-secret-keys > ~/.gnupg/secring.gpg 

-----------------------------------------

helm package --sign --key alezanper@mail.com --keyring ~/.gnupg/secring.gpg firstchart -d chartsrepo

helm verify chartsrepo/firstchart-0.1.0.tgz --keyring 
~/.gnupg/secring.gpg

-----------------------------------------

helm repo index chartsrepo 
cd chartsrepo
python3 -m http.server --bind 127.0.0.1 8080
helm install --verify --keyring ~/.gnupg/secring.gpg temprelease localrepo/firstchart 

-----------------------------------------

Use Cases

service that return information about coupons

bharatht19/couponservice

helm create couponservice

----------------------------------------
----------------------------------------

starters

- create chart specific for the language

helm env HELM_DATA_HOME		Create a folder helm and then a folder starters

replace <CHARTNAME>

helm create --starter springwebappmysql demoapp

----------------------------------------

Plugins

helm starter plugin github

helm plugin list

helm plugin install <github url> --version <version>

helm starter --helpers

----------------------------------------

values.schema.json		to test the content of values.yaml

{
  "$schema": "http://json-schema.org/schema#",
  "type": "object",
  "required": [
    "image"
  ],
  "properties": {
    "image": {
      "type": "object",
      "required": [
        "repository",
        "pullPolicy"
      ],
      "properties": {
        "repository": {
          "type": "string"
                  },
        "pullPolicy": {
          "type": "string",
          "pattern": "^(Always|Never|IfNotPresent)$"
        }
      }
    }
  }
}

helm lint .

To generate schema:

convert values.yaml to json 
www.json2yaml.com


take the json file and converted to schema uusing 
www.jsonschema.net












las aplicaciones se modifican desde variables de entorno

https://github.com/kodekloudhub/webapp-color

