
<cfscript>
	pool = [];
	oApplicationReference = CreateObject("java","java.util.LinkedHashMap").init();
	ApplicationPoolStorage = createObject("java", "java.util.Collections").synchronizedMap ( oApplicationReference ) ;
	
	ApplicationPoolStorage['coo'] = 'fooooooo';
	

	oApplicationReference1 = CreateObject("java","java.util.LinkedHashMap").init();	
	ApplicationPoolStorage1 = createObject("java", "java.util.Collections").synchronizedMap ( oApplicationReference ) ;
	ApplicationPoolStorage1['coo'] = 'fooooooo';
	 //writeDump( IsInstanceOf(ApplicationPoolStorage,"java.util.Collections") );
	 
	 ArrayAppend(pool,ApplicationPoolStorage);
	 
	 poolStruct = {first='coo', apple='yes'};
</cfscript>

<cfdump var="#StructSort(poolStruct,'text','asc')#">
<cfdump var="#ArrayFind(pool,ApplicationPoolStorage1)#">
<cfabort>

<cfscript>
contentText = "{coo1} blah {coo2} blah blah (coo3) blah (coo4 blah)";

firstParse = ReFind("\((?:'|"").+?(?:'|"")\)",contentText);

writeDump(firstParse);
</cfscript>

