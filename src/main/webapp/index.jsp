<%@page import="com.openshift.internal.config.Configuration"%>
<%@page import="java.util.Optional"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.yaml.snakeyaml.Yaml"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="com.openshift.restclient.model.IConfigMap"%>
<%@page import="com.openshift.restclient.ResourceKind"%>
<%@page import="com.openshift.restclient.model.IPod"%>
<%@page import="com.openshift.restclient.model.IProject"%>
<%@page import="com.openshift.restclient.ClientBuilder"%>
<%@page import="com.openshift.restclient.IClient"%>
<%@page import="java.util.stream.Collectors"%>

<%@page import="java.util.Date"%>
<%@page import="java.io.File,java.io.BufferedReader,java.io.FileReader"%>

<html>
<head>
<title>Testing OpenShift WebConsole URL</title>

<link rel="stylesheet" type="text/css" href="css/styles.css">

</head>
<body>




	<%
		String tokenValue = null;
		String urlRestClient = null;
		String tokenFilePath = null;
		BufferedReader br = null;
		String consolePublicURL = null;
		String yamlFile = null;
		try {

			tokenFilePath = "/var/run/secrets/kubernetes.io/serviceaccount/token";
			urlRestClient = "https://babak-master.cloud.lab.eng.bos.redhat.com:8443";
			File tokenFile = new File(tokenFilePath);

			br = new BufferedReader(new FileReader(tokenFile));
			tokenValue = br.readLine();

			IClient client = new ClientBuilder(urlRestClient).build();
			client.getAuthorizationContext().setToken(tokenValue);

			System.out.println("\n========================Openshift Project====================================");
			IProject project = (IProject) client.getResourceFactory().stub(ResourceKind.PROJECT,
					"openshift-web-console");
			System.out.println("Openshift API version : " + project.getApiVersion() + ", Project namespace : "
					+ project.getNamespace() + ", Project name : " + project.getName());

			System.out.println("\n========================Openshift Pods==============================");
			java.util.List<IPod> pods = client.list(ResourceKind.POD, "openshift-web-console");
			IPod pod = (IPod) pods.stream().filter(p -> p.getName().startsWith("webconsole")).findFirst()
					.orElse(null);

			// System.out.println("Pod Host Name========================" + pod.getHost());

			java.util.List<IConfigMap> configMapList = client.list(ResourceKind.CONFIG_MAP,
					"openshift-web-console");

			java.util.List<Entry<String, String>> webconsoleConfigData = configMapList.stream()
					.map(p -> p.getData().entrySet().iterator().next()).collect(Collectors.toList());

			// String
			// yam=webconsoleConfigData.stream().map(p->p.getKey().contains("webconsole-config.yaml")).collect(Collectors.toList());

			for (Entry<String, String> entry : webconsoleConfigData) {
				System.out.println("Found URL" + entry.getKey());
				if (entry.getKey().equalsIgnoreCase("webconsole-config.yaml")) {

					yamlFile = entry.getValue();
					System.out.print(yamlFile);
				}
			}

			Yaml yaml = new Yaml();
			InputStream targetStream = new ByteArrayInputStream(yamlFile.getBytes());
			Configuration configuration = yaml.loadAs(targetStream, Configuration.class);

			Optional<String> optinal = configuration.getClusterInfo().entrySet().stream()
					.filter(e -> e.getKey().equalsIgnoreCase("consolePublicURL")).map(Map.Entry::getValue)
					.findFirst();

			consolePublicURL = optinal.get().toString();

			System.out.println(consolePublicURL.toString());

			// configMapValues.forEach((k, v) -> System.out.println((k + ":" + v)));

		} catch (Exception e) {

			e.printStackTrace();

		} finally {
			br.close();
		}
	%>
	<h3>Testing OpenShift WebConsole URL</h3>
	<hr>

	<br>
	<b>URL DATA</b>

	<br>
	<br> Yaml File:
	<%=yamlFile%>

	<br>
	<br>

	<table>
		<tr>
			<th>Description</th>

			<th>URL</th>
		</tr>

		<tr>
			<td>Console Public URL</td>

			<td><%=consolePublicURL%></td>
		</tr>


	</table>

	<br>
	<br> Token Value:
	<%=tokenValue%>
	at tody date: 
	<%=new java.util.Date()%>

	<br>
	<br>

	<a href="<%=consolePublicURL%>">Get Open Web Console</a> |
	<a href="index.jsp">Refresh</a>

</body>
</html>



