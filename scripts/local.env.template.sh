# Used only for local execution and not with CI
export ENVIRONMENT="<the name of the environment you want to build from the local machine>"

#################################################
# Template file coming from https://github.com/ovh/public-cloud-examples/blob/main/basics/ovhrc.template
#### Openstack vars from openrc file
export OS_AUTH_URL=https://auth.cloud.ovh.net/v3
export OS_IDENTITY_API_VERSION=3
export OS_USER_DOMAIN_NAME=${OS_USER_DOMAIN_NAME:-"Default"}
export OS_PROJECT_DOMAIN_NAME=${OS_PROJECT_DOMAIN_NAME:-"Default"}
export OS_TENANT_ID="<OVH OpenStack tenant ID that is also the ID of the project on the OVH project web page>"
export OS_TENANT_NAME="<OVH OpenStack tenant>"
export OS_USERNAME="<OVH OpenStack username>"
export OS_PASSWORD="<OVH OpenStack password for username>"
export OS_REGION_NAME="<OVH Openstack region that is also for the cluster (from https://www.ovhcloud.com/en/public-cloud/regions-availability/): GRA1, GRA7 ...>"
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi

#### OVH API vars from OVHcloud manager
export OVH_ENDPOINT="<the ovh endpoint>"
export OVH_BASEURL="<the ovh baseurl for the API>"
export OVH_APPLICATION_KEY="<the AK value>"
export OVH_APPLICATION_SECRET="<the AS value>"
export OVH_CONSUMER_KEY="<the CS value>"
export OVH_CLOUD_PROJECT_SERVICE="$OS_TENANT_ID"

### OVHcloud API endpoints
#   OVH_ENDPOINT 	: 	OVH_BASEURL
#   ovh-eu		:	https://eu.api.ovh.com/1.0
#   ovh-us		:	https://api.us.ovhcloud.com/1.0
#   ovh-ca		:	https://ca.api.ovh.com/1.0
#   kimsufi-eu		:	https://eu.api.kimsufi.com/1.0
#   kimsufi-ca		:	https://ca.api.kimsufi.com/1.0
#   soyoustart-eu	:	https://eu.api.soyoustart.com/1.0
#   soyoustart-ca	:	https://ca.api.soyoustart.com/1.0
#################################################

# configure access to S3 where tfstates are stored
export AWS_ACCESS_KEY_ID="<the access key id>"
export AWS_SECRET_ACCESS_KEY="<the secret access key>"
export AWS_ENDPOINT_URL_S3="<the OVH s3 endpoint URL with https : Ex: https://s3.gra.perf.cloud.ovh.net>"
export AWS_S3_MEDIA_REPO_ENDPOINT="< could be another endpoint for s3 media repo, without https : Ex: s3.gra.io.cloud.ovh.net>"
export AWS_REGION="<the OVH s3 region>"
# variables used by infrastructure components
export ENV_IN_URL="<part of the URL that will be specific for each environment>"
export CLUSTER_VERSION="<kubernetes version of the cluster: 1.23, 1.24, ...>"
export INGRESS_SERVICE_PORT_WEBSECURE="<port of the ingress NodePort service e.g. 30695 for https>"
export INGRESS_SERVICE_PORT_WEB="<port of the ingress NodePort service e.g. 30696 for http>"
export NODEPOOL_FLAVOR="<flavor set to each node : b2-7, b2-15, R2-30, ...>"
export DESIRED_NODES_NUM="<Desired number of kubernetes nodes>"
export MAX_NODES_NUM="<Maximum number of kubernetes nodes>"
export MIN_NODES_NUM="<Minimum number of kubernetes nodes>"
export DNS_ZONE="<domain name : eimis.incubateur.net, eimis.fr, ...>"
export ISSUER_MAIL="<email address used for letsEncrypt/ACME registration>"
export GLOBALE_REGION="<OVH global location for PostGreSQL and VPC e.g. 'GRA'>"
export DATABASE_VERSION="<Version of postgresql>"
export DATABASE_PLAN="<OVH plan for database : essential = 1 nodes, business = 2 nodes, enterprise = 3 nodes>"
export DATABASE_FLAVOR="<OVH flavor of the VM on which the database is installed : db1-4, db1-7, db1-15, db1-30, ...>"
export DATABASE_DISK_SIZE="<Size of the disk for the database VM>"

# App Network configuration
export APP_VLAN_NAME="${ENVIRONMENT}-app-network"
export APP_VLAN_CIDR="<Sets the CIDR block for the application VLAN e.g. 192.168.20.0/24>"
export APP_VLAN_GATEWAY="<Sets the gateway IP for the application VLAN e.g. 192.168.20.1>"
export APP_VLAN_DNS="<Sets the DNS servers for the application VLAN e.g. \"1.1.1.1\",\"1.0.0.1\">"

# Admin Network configuration
export ADMIN_VLAN_NAME="${ENVIRONMENT}-admin-network"
export ADMIN_VLAN_CIDR="<Sets the CIDR block for the admin VLAN e.g. 192.168.100.0/24>"
export ADMIN_VLAN_GATEWAY="<Sets the gateway IP for the admin VLAN e.g. 192.168.100.1>"
export ADMIN_VLAN_DNS="<Sets the DNS servers for the admin VLAN e.g. \"1.1.1.1\",\"1.0.0.1\>"

# variables used by matrix components
export SERVER_SUBDOMAIN_NAME="<the matrix serverName will be : SERVER_SUBDOMAIN_NAME.ENV_IN_URL.DNS_ZONE>"
export ELEMENT_SUBDOMAIN_NAME="<the front-end url will be : ELEMENT_SUBDOMAIN_NAME.ENV_IN_URL.DNS_ZONE>"
export SMTP_HOST="<configuration to send mail : host of the SMTP server>"
export SMTP_PORT="<configuration to send mail : port of the SMTP server>"
export SMTP_USER="<configuration to send mail : user to connect to the SMTP server>"
export SMTP_PASS="<configuration to send mail : password of connect to the SMTP server>"
export SMTP_FROM="<just the e-mail e.g. 'email@example.org'>"
export SMTP_DISPLAY_NAME="<Only the display name like in : 'Display name<email@example.org>' (without <email@example.org> got it?)>"
export SYNAPSE_DB_INSTANCE_NAME="<database name of the postgresql database linked to synapse>"
export SYNAPSE_DB_USER="<username to access the postgresql database linked to synapse>"
export FIRST_EIMIS_USERNAME="<username of the first eimis user created when bootstraping>"
export FIRST_EIMIS_PASSWORD="<password of the first eimis user created when bootstraping>"
export DUMMY_USERNAME="<dummy user used with the discovery room mecanism>"
export DUMMY_PASSWORD="<password for the dummy user>"
export FEDERATION_SERVERS_LIST="<list of comma separated URI of synapse servers included in federation. Ex : ['preprod.eimis.incubateur.net','matrix.pandalab.fr']>"
export SYNAPSE_AUTO_REGISTRATION="<if set to true, users can auto register. If set to false, they can only be registered by admin>"
export SYNAPSE_ENABLE_PASSWORD_LOGIN="<`true`: users can login with password.`false`, they can only login with SSO>"
export SYNAPSE_MEDIA_UPLOAD_MAX_SIZE_MB="<max size of media in MB>"
export SYNAPSE_WELCOME_ROOM="<alias of a room that will be joined by default by every user. ex: 'welcome-room'. Optional>"
export SYNAPSE_IMAGE_TAG="<docker image tag>"
# variables used to connect to Pro Santé Connect.
# see : https://industriels.esante.gouv.fr/produits-et-services/pro-sante-connect/documentation-technique
export PROSANTE_CONNECT_ENABLED="<true to login with PSC>"
export PROSANTE_CONNECT_ISSUER="<Used to validate tokens and to discover the Pros Santé Connect's endpoints (required but unused)>"
export PROSANTE_CONNECT_AUTHORIZATION_ENDPOINT="<Authorization endpoint used to connect to Pro Santé Connect>"
export PROSANTE_CONNECT_TOKEN_ENDPOINT="<Token endpoint used to retrieve token from Pro Santé Connect>"
export PROSANTE_CONNECT_USERINFO_ENDPOINT="<Userinfo endpoint used to retrieve info on user from Pro Santé Connect>"
export PROSANTE_CONNECT_JKWS_URI="<URI where to fetch the JWKS from Pro Santé Connect>"
export PROSANTE_CONNECT_CLIENT_ID="<Client ID used to identify the client against Pro Santé Connect>"
export PROSANTE_CONNECT_CLIENT_SECRET="<Client secret associated with client ID used to identify the client against Pro Santé Connect>"
# variables used by the MS Teams bridge
export TEAMS_BRIDGE_ENABLED="<true or false>"
export TEAMS_BRIDGE_SUBDOMAIN_NAME="<the MS Teams bridge serverName will be : TEAMS_BRIDGE_SUBDOMAIN_NAME.ENVIRONMENT.DNS_ZONE>"
export TEAMS_OAUTH_CLIENT_ID="<Application (client) ID coming from the azure portal app registration>"
export TEAMS_OAUTH_CLIENT_SECRET="<Application secret coming from the azure portal app registration>"
# monitoring
export MONITORING_SUBDOMAIN_NAME="<the grafana serverName will be : SERVER_SUBDOMAIN_NAME.ENV_IN_URL.DNS_ZONE>"
export MONITORING_GRAFANA_PASSWORD="<password for the grafana admin user>"
export MONITORING_PROMETHEUS_VOLUME_SIZE="<Prometheus database size in a k8s format e.g. 10Gi>"
# stunner
export STUNNER_ENABLED="<true or false>"
export STUNNER_SHARED_SECRET="<shared secret for stunner>"
# keycloak
export KEYCLOAK_IMAGE_TAG="<docker image tag>"
export KEYCLOAK_SUBDOMAIN_NAME="<keycloak url : KEYCLOAK_SUBDOMAIN_NAME.ENV_IN_URL.DNS_ZONE>"
export KEYCLOAK_CLIENT_ID="<client ID used by keycloak to identify synapse client>"
export KEYCLOAK_CLIENT_SECRET="<secret used in conjunction with client ID to identify synapse client>"