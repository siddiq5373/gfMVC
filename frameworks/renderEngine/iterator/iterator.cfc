/*
LICENSE 
Copyright 2009 Brian Kotek

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

/**
* I act as an Iterator for any type of collection.
*/
component output="false" accessors="true"
{

	/**
	Constructor.
	@Parameter collection The collection to iterate.
	@Parameter delimiter An optional list delimiter value. Defaults to ','.
	*/
	public function init( required collection, delimiter=',' )
	{
		variables.instance.collection = arguments.collection;
		variables.instance.delimiter = arguments.delimiter;
		reset();
		return this;
	}

	/**
	Retruns true if the collection has more items left to iterate over.
	*/
	public function hasNext() 
	{
		var result = false;
		if( ( isQueryCollection() && hasNextQuery() ) ||
			( isArrayCollection() && hasNextArray() ) ||
			( isStructCollection() && hasNextStruct() ) ||
			( isListCollection() && hasNextList() ) )
		{
			result = true;
		}
		return result;
	}
	
	/**
	Returns the next item in the collection. If the collection is a query, it returns a structure with key/values for the next row in the result set.
	*/
	public function next() 
	{
		if( isQueryCollection() && hasNextQuery() )
		{
			var result = getNextQuery();
		}
		else if( isArrayCollection() && hasNextArray() )
		{
			var result = getNextArray();
		}
		else if( isStructCollection() && hasNextStruct() )
		{
			var result = getNextStruct();
		}
		else if( isListCollection() && hasNextList() )
		{
			var result = getNextList();
		}
		if( StructKeyExists( local, 'result') )
		{
			incrementIndex();
		}
		else
		{
			throw( 'There are no more items available in the collection, or the collection is empty. Use hasNext() to ensure that the collection has items to iterate over.', 'IteratorException.NoIterableValues' );
		}
		return result;
	}
	
	public function reset()
	{
		variables.instance.currentIndex = 1;
		variables.instance.countedKeys = [];
	}
	
	public function getCurrentIndex()
	{
		return variables.instance.currentIndex;
	}
	
	private function incrementIndex()
	{
		variables.instance.currentIndex++;
	}
	
	private function getNextQuery()
	{
		var i = 1;
	    var columns = ListToArray( variables.instance.collection.columnList );
	    var result = {};
	    for( i = 1; i <= ArrayLen( columns ); i++ )
		{
	        result[columns[i]] = variables.instance.collection[columns[i]][variables.instance.currentIndex];
	    }
	    return result;
	}
	
	private function getNextArray()
	{
		return variables.instance.collection[variables.instance.currentIndex];
	}
	
	private function getNextStruct()
	{
		var result = "";
		var thisKey = "";
		for ( thisKey in variables.instance.collection ) 
		{
			if( !ArrayContains( variables.instance.countedKeys, thisKey ) )
			{
				result = variables.instance.collection[thisKey];
				ArrayAppend( variables.instance.countedKeys, thisKey );
				break;
			}
		}
		return result;
	}
	
	private function getNextList()
	{
		return ListGetAt( variables.instance.collection, variables.instance.currentIndex, variables.instance.delimiter );
	}
	
	private function hasNextQuery()
	{
		return variables.instance.currentIndex <= variables.instance.collection.recordCount;
	}
	
	private function hasNextArray()
	{
		return variables.instance.currentIndex <= ArrayLen( variables.instance.collection );
	}
	
	private function hasNextStruct()
	{
		return variables.instance.currentIndex <= StructCount( variables.instance.collection );
	}
	
	private function hasNextList()
	{
		return variables.instance.currentIndex <= ListLen( variables.instance.collection, variables.instance.delimiter );
	}
	
	private function isQueryCollection()
	{
		return IsQuery( variables.instance.collection );
	}
	
	private function isArrayCollection()
	{
		return IsArray( variables.instance.collection );
	}
	
	private function isStructCollection()
	{
		return IsStruct( variables.instance.collection );
	}
	
	private function isListCollection()
	{
		return IsSimpleValue( variables.instance.collection );
	}
	
}