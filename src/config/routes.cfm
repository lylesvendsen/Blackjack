<cfscript>
	/*
		Here you can add routes to your application and edit the default one.
		The default route is the one that will be called on your application's "home" page.
	*/

	addRoute(name="playeractions", pattern="game/action/do/[do]/playerid/[playerid]", controller="game", action="action");
	addRoute(name="home", pattern="", controller="wheels", action="wheels");
</cfscript>