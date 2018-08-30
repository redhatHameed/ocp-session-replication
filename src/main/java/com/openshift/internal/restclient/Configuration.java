package com.openshift.internal.restclient;

import java.util.Map;

public class Configuration {
	
	
	  

		private String apiVersion;
	    private Map< String, String > clusterInfo; 
	  
		private Map< String, String > extensions; 
	    private Map< String, String > features; 
	    private String kind;
	    private Map< String, String > servingInfo;
	    
		public String getApiVersion() {
			return apiVersion;
		}
		public void setApiVersion(String apiVersion) {
			this.apiVersion = apiVersion;
		}
	    
		public Map<String, String> getClusterInfo() {
			return clusterInfo;
		}
		public void setClusterInfo(Map<String, String> clusterInfo) {
			this.clusterInfo = clusterInfo;
		}
		public Map<String, String> getExtensions() {
			return extensions;
		}
		public void setExtensions(Map<String, String> extensions) {
			this.extensions = extensions;
		}
		public Map<String, String> getFeatures() {
			return features;
		}
		public void setFeatures(Map<String, String> features) {
			this.features = features;
		}
		public String getKind() {
			return kind;
		}
		public void setKind(String kind) {
			this.kind = kind;
		}
		public Map<String, String> getServingInfo() {
			return servingInfo;
		}
		public void setServingInfo(Map<String, String> servingInfo) {
			this.servingInfo = servingInfo;
		} 
	    
		  @Override
			public String toString() {
				return "Configuration [clusterInfo=" + clusterInfo + ", extensions=" + extensions + ", features=" + features
						+ ", kind=" + kind + ", servingInfo=" + servingInfo + "]";
			}
	    

	

}
