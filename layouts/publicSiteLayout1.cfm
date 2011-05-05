<cfimport prefix="" taglib="/gfmvc/renderer" />
<html>
	<head>
		<title></title>
	</head>
	<body>
		<div>
			<header>
		      <h1>Site header</h1>
		    </header>
		    <nav>
		    	<renderView name="vwSiteNavigation" event="site.navigation" vc='{"FOO":"additional param from layout"}' />
		     	<!---<cfset renderView('vwSiteNavigation','site.navigation') />--->
		    </nav>
		    <div>
				<article>
					<renderView vc='{"FOO":"coo"}' />
					<!---<cfset renderView() />--->
				</article>   
		    </div>
		
		    <footer>
		    	Test Site
		    </footer>
		</div>
		
		
	</body>
</html>