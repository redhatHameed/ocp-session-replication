<%@page import="java.util.Optional"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="com.openshift.internal.restclient.Configuration"%>
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
<%@page import="java.io.File,java.io.BufferedReader,java.io.FileReader" %>

<html>
<head>
<title>Testing OpenShift WebConsole URL</title>

<link rel="stylesheet" type="text/css" href="css/styles.css">

</head>
<body>

    <%
        // gear name
        // String gearId = System.getenv("OPENSHIFT_GEAR_UUID");
        File hostnameFile = new File("/etc/hostname");
        BufferedReader br = new BufferedReader(new FileReader(hostnameFile));
        String hostname = br.readLine();

    
        // get counter
        Integer counter = (Integer) session.getAttribute("demo.counter");
        if (counter == null) {
            counter = 0;
            session.setAttribute("demo.counter", counter);
        }

        // check for increment action
        String action = request.getParameter("action");

        if (action != null && action.equals("increment")) {
            // increment number
            counter = counter.intValue() + 1;

            // update session
            session.setAttribute("demo.counter", counter);
            session.setAttribute("demo.timestamp", new Date());
        }
        
        
        IClient client = new ClientBuilder("https://babak-master.cloud.lab.eng.bos.redhat.com:8443").build();
		client.getAuthorizationContext().setToken("MfA3rQ21RvmTeUjvvussUyOv5ZwTS4k3Dh8DyMgJhyo");

		System.out.println("\n========================Openshift Project====================================");
		IProject project = (IProject) client.getResourceFactory().stub(ResourceKind.PROJECT, "openshift-web-console");
		System.out.println("Openshift API version : " + project.getApiVersion() + ", Project namespace : "
				+ project.getNamespace() + ", Project name : " + project.getName());

		System.out.println("\n========================Openshift Pods==============================");
		java.util.List<IPod> pods = client.list(ResourceKind.POD, "openshift-web-console");
		IPod pod = (IPod) pods.stream().filter(p -> p.getName().startsWith("webconsole")).findFirst().orElse(null);

		// System.out.println("Pod Host Name========================" + pod.getHost());

		java.util.List<IConfigMap> configMapList = client.list(ResourceKind.CONFIG_MAP, "openshift-web-console");

		java.util.List<Entry<String, String>> webconsoleConfigData = configMapList.stream()
				.map(p -> p.getData().entrySet().iterator().next()).collect(Collectors.toList());

		// String
		// yam=webconsoleConfigData.stream().map(p->p.getKey().contains("webconsole-config.yaml")).collect(Collectors.toList());

		String yamlFile = "";
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
				.filter(e -> e.getKey().equalsIgnoreCase("consolePublicURL")).map(Map.Entry::getValue).findFirst();
		
		
		String consolePublicURL=optinal.get().toString();
		
		System.out.println(consolePublicURL.toString());

		// configMapValues.forEach((k, v) -> System.out.println((k + ":" + v)));
        
        
        
    %>
    <h3>Testing OpenShift WebConsole URL</h3>
    <hr>

    <br> <b>URL DATA</b>

    <br>
    <br>

    Yaml File: <%=yamlFile%>

    <br>
    <br>

    <table>
        <tr>
            <th>Description</th>
           
            <th>URL</th>
        </tr>

        <tr>
            <td>Console Public URL</td>
         
            <td><%= consolePublicURL %></td>
        </tr>

       
    </table>

    <br>
    <br> Page served by Server: <%= hostname %> at <%= new java.util.Date() %>

    <br>
    <br>

    <a href="<%= consolePublicURL %>">Get Open Web Console</a> |
    <a href="index.jsp">Refresh</a>

</body>
</html>
