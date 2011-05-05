component {
	
	public string function sortByLen(string data) {
	
		var array = listToArray(data);		
		var lengths = {};		
		var i = "";
		var j = "";
		
		for (i = 1; i <= arrayLen(array); i++) {
			
			var length = len(array[i]);
			
			if (!structKeyExists(lengths, length)) {				
				lengths[length] = [];			
			}
			
			arrayAppend(lengths[length], array[i]);
		
		}
		
		var sorted = listToArray(listSort(structKeyList(lengths), "numeric", "desc"));
		
		var result = [];
		
		for (i = 1; i <= arrayLen(sorted); i++) {
		
			var length = sorted[i];
			
			for (j = 1; j <= arrayLen(lengths[length]); j++) {		
				arrayAppend(result, lengths[length][j]);			
			}
		
		}
		
		return arrayToList(result);
	
	}

	public void function onMissingMethod(string missingMethodName, struct missingMethodArguments) {
		if (left(missingMethodName, 3) == "set") {
			var property = replace(missingMethodName, "set", "");
			variables[property] = missingMethodArguments[1];
		}
	}	
}