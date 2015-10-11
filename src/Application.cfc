<cfcomponent output="false">
	<cfscript>
		this.applicationTimeout 	= createTimeSpan(0,12,0,0);
		this.sessionManagement		= "true";
		this.sessionTimeout			= createTimeSpan(0,0,60,0);
		this.scriptProtect 			= "all";
		this.setClientCookies		= "true";
		this.setDomainCookies		= "false";

		this.mappings["com"]	= getDirectoryFromPath( getCurrentTemplatePath()) & "services";
	</cfscript>
	<cfinclude template="wheels/functions.cfm">
</cfcomponent>