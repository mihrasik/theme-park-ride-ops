app - them ride - java spring boot app
db - added sql and connected with hybernate
Kubernetess - high availability?

gitlab ci/cd

Terraform IaC - later project which runs 1 load balanser, 3 apps, 1 db container

	internal ip addresses -
	security - ssh certificates, https connection -  SSL/TLS certificate -  Let's Encrypt
	? skip to the end - security - auth - spring security jwt tocken - user pass to login to the project 

Kubernetes - deploy to Kubernetes using gitlab ci-cd

Step 3
data management - db, log storage, Authentication, Authorization

Step 4 CI CD pipeline
Last Stage 
backup management , recovery disaster - 
repo github 
backup system script, script application

CLOUD
multi server - high availability
jenkins/ gitlab ci-cd -> AWS CodePipeline
IaC vagrant -> terraform -> AWS - AWS - CloudFormation 
nginx -> Elastic Load Balancing
backup management , recovery disaster - 

TODO: security, move db passwords from git to .env files
TODO: ci/cd with gitlab? or jenkins - 1) build app with gradlew 2) build docker imgages : app, db, lb
TODO: add Prometheus and Grafana
TODO: change insecure_private_key certificates to secure

We are doing a DataOps project. At the moment be have java boot spring application with hibernate connected to mariadb. The app is build with gradlew. It has 3 apps and load balancer. These 5 docker containers app1 app2 app3 db lb are running vie vagrant.

In our learning plan we have kubernetes, linux, nginx, jenkins devops, gitlab, terraform, ansible , prometheus, grafana, datadog .

What are our next project steps moving from vagrant IaC to IaC suitable for production deployment?

GitLab → CI/CD → Builds Docker images → Deploys to k3s (TODO: via Helm) 
