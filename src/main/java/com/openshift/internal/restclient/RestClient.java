package com.openshift.internal.restclient;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.yaml.snakeyaml.Yaml;

import com.openshift.internal.restclient.model.List;
import com.openshift.restclient.ClientBuilder;
import com.openshift.restclient.IClient;
import com.openshift.restclient.ResourceKind;
import com.openshift.restclient.model.IConfigMap;
import com.openshift.restclient.model.IPod;
import com.openshift.restclient.model.IProject;

public class RestClient {

	public static void main(String args[]) {

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
		Configuration config = yaml.loadAs(targetStream, Configuration.class);

		Optional<String> optinal = config.getClusterInfo().entrySet().stream()
				.filter(e -> e.getKey().equalsIgnoreCase("consolePublicURL")).map(Map.Entry::getValue).findFirst();
		System.out.println(optinal.get().toString());

		// configMapValues.forEach((k, v) -> System.out.println((k + ":" + v)));

	}
}
