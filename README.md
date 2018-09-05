OpenShift console URL discovery
===================

Here are the steps to get OpenShift console URL  (WebConsole Project) , which can be useful for Integration with any Deployed Application.

Steps:

Step 1: Create Service Account named in your OpenShift project:

1-Create a project : 
oc new-project <name-of-project>

2-Create service account 
oc create serviceaccount <name-of-service-account>

3-Make sure that your default service account has sufficient privileges to communicate with the Kubernetes/OpenShift REST API by adding the view/admin role to the service account:

oc policy add-role-to-user cluster-admin  system:serviceaccount:$(oc project -q):<name-of-service-account> -n $(oc project -q)

or run the command : 

oc policy add-role-to-user <role_name> -z <serviceaccount_name>.

reference for creating Service Account:
https://docs.openshift.com/container-platform/3.6/dev_guide/service_accounts.html



Step 2: Explore the Kubernetes/OpenShift REST API

1- Get the token of service account:
oc serviceaccounts get-token  <name-of-service-account>
or from location by acessing with podname  oc rsh <podname> : var/run/secrets/kubernetes.io/serviceaccount/token

2-Run the commands to verify the access of REST API :

curl -k     -H "Authorization: Bearer $TOKEN"     -H 'Accept: application/json'     https://$ENDPOINT/oapi/v1/projects

should be able to see Project List, make sure you have view access on openshift-web-console project.

3-View the configmaps configuration and consolePublicURL:

curl -k     -H "Authorization: Bearer $TOKEN"     -H 'Accept: application/json'     https://$ENDPOINT/api/v1/namespaces/openshift-web-console/configmaps

"data": {
        "webconsole-config.yaml": "apiVersion:   consolePublicURL: https://   loggingPublicURL: \n  logoutPublicURL: ''\n  masterPublicURL: \n  metricsPublicURL: ''\nextensions:\n  properties: {}\n  scriptURLs: []\n  stylesheetURLs: []\nfeatures:\n  clusterResourceOverridesEnabled: false\n  inactivityTimeoutMinutes: 0\nkind: WebConsoleConfiguration\nservingInfo:\n  bindAddress: 0.0.0.0:8443\n  bindNetwork: tcp4\n  certFile: /var/serving-cert/tls.crt\n  clientCA: ''\n  keyFile: /var/serving-cert/tls.key\n  maxRequestsInFlight: 0\n  namedCertificates: null\n  requestTimeoutSeconds: 0\n"
        
        
Step 3: Test with Simple JEE application: 



        








  
  






























