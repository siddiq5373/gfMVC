<table>
	<thead>
		<tr>
			<th>Date</th>
			<th>Title</th>
			<th>Type</th>
		</tr>
	</thead>
	
	<tbody>
	<cfoutput query="vc.qListing">
		<tr>
			<td>#vc.qListing.Date#</td>
			<td>#vc.qListing.Title#</td>
			<td>#vc.qListing.Type#</td>
		</tr>
	</cfoutput>
	</tbody>
	
</table>