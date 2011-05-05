<cfimport prefix="" taglib="../tags" />
<h1>Page</h1>
<cfoutput>
<cfform action="#getLink('save')#" id="formContent" name="formContent" method="post">
<table class="mytable fixedWidth" cellpadding="0" cellspacing="0">
	<tr>
    	<th colspan="2" class="top"></th>
    </tr>	
	<tr>
		<td nowrap="nowrap"><label for="Title"><b>Title:</b></label> &nbsp;</td>
		<td>
        	<Title value="#vc.page.getTitle()#" />
    	</td>
	</tr>
	<tr>
		<td nowrap="nowrap"><label for="Abstract"><b>Abstract:</b></label> &nbsp;</td>
		<td>
        	<Abstract value="#vc.page.getAbstract()#" />
    	</td>
	</tr>
	<tr>
		<td nowrap="nowrap"><label for="Abstract"><b>Body:</b></label> &nbsp;</td>
		<td>
        	<HTMLText value="#vc.page.getHTMLText()#" />
    	</td>
	</tr>
	<tr>
		<td nowrap="nowrap"><label for="StatusID"><b>Status:</b></label> &nbsp;</td>
		<td>
    	    <input type="checkbox" id="StatusID" name="StatusID"  value="1" #vc.page.getStatusAsHTML()# /> Active
	    </td>
	</tr>
	<tr>
		<td class="td1">&nbsp;</td>
		<td class="td1">
			<input type="submit" value="#vc.page.getButtonText()# Page" class="submit">
			<cfif val(vc.page.getContentID()) GT 0>
				<input type="hidden" name="ContentID" value="#val(vc.page.getContentID())#">
			</cfif>
		</td>
	</tr>
</table>
</cfform>
</cfoutput>

<script>
$(document).ready(function(){
	$("#formContent").validate();
});
</script>