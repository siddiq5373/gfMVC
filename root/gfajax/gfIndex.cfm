<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<style type="text/css">
		
	</style>
</head>
<body>
	<div>
		<div class="navigation" style="float:left;">
			<div id="navigation">site Navigation</div>
		</div>
		<div style="clear:left;"></div>
		<div class="body" style="float:left;width:70%">
			<div class="breadcrumb" style="height:20px;border:1px solid;padding:1px">
				<div id="breadcrumb">bread crumb</div>
			</div>
		
			<div id="pageContent" style="height:500px;border:1px solid;padding:1px">Page Content</div>
		</div
		
		<div name="relatedContent" style="float:left;width:25%;height:525px;border:2px solid;padding:1px">
			<div id="relatedContent">Related Content</div>
		</div>
	</div>
	<br /><br /><br />
	
	<!---<cfoutput>
	<form id="editContact" method="post">
	<table style="width:40%;">
		<!---<caption>Add New Contact <a href="##" style="font-size:10px;">close</a></caption>--->
		<tbody>
		 	<tr>
				<td>First Name</td>
				<td><input type="text" name="fname" maxlength="20" value="" /></td>
			</tr>	
		 	 <tr class="odd">
				<td>Last Name</td>
				<td><input type="text" name="lname" maxlength="20" value="" /></td>
			</tr>
		 	<tr>
				<td>Age</td>
				<td><input type="text" name="age" maxlength="3" value="" /></td>
			</tr>	
		 	<tr>
				<td>Phone</td>
				<td><input type="text" name="phone" maxlength="10" value="" /></td>
			</tr>	
		 	 <tr class="odd">
				<td>Fax</td>
				<td><input type="text" name="fax" maxlength="10" value="" /></td>
			</tr>
		 	<tr>
				<td>&nbsp;</td>
				<td><input class="button" id="bttn1" type="submit" value="Submit Contact Info" /></td>
			</tr>
		</tbody>
	</table>
	</form>
</cfoutput>--->
	
	<!---<form id="firstFrm" name="firstFrm">
		<input type="hidden" id="form1HiddenValue" name="form1HiddenValue" value="1" />
		<div>
			<div id="navigation1">site Navigation</div>	
			<div id="breadcrumb1">bread crumb</div>
			<div id="pageContent1">Page Content</div>
			<div id="relatedContent1">Related Content</div>
		</div>
		<input type="button" id="bttn11" value="button 11" />
	</form>--->
	<!---<form id="form2" name="form2">
		<input type="hidden" id="form2HiddenValue" name="form2HiddenValue" value="2" />
		<div>
			<div id="navigation2">site Navigation</div>	
			<div id="breadcrumb2">bread crumb</div>
			<div id="pageContent2">Page Content</div>
			<div id="relatedContent2">Related Content</div>
		</div>
		<input type="button" id="bttn2" value="button 2" />
	</form>--->
</body>
<!--- Load all the javascripts at the end --->
<script type="text/javascript" src="/assets/js/jquery-1.4.3.min.js"></script>
<script type="text/javascript" src="/assets/js/gfAjax.js"></script>


<script type="text/javascript">
function Site() {
	var gfMVCEvent = new GFMVCEvent();
	gfMVCEvent.addEvent('site.navigationAjax', 'navigation');
	
	var gfMVCPageEvent = new GFMVCEvent();
	gfMVCPageEvent.addEvent('site.page', 'pageContent');
	gfMVCPageEvent.addEvent('site.breadcrumb', 'breadcrumb');
	gfMVCPageEvent.addEvent('site.relatedContent', 'relatedContent');
	
	this.list = function(params){
		postData = {};
		postData.additionalData ='Foo';
		gfMVCEvent.dispatchEvent(postData);
	}
	this.get = function(ContentID){
		gfMVCPageEvent.dispatchEvent({'ContentID':ContentID});
	}

	this.navigationAjaxResponse = function(response){
		alert('Here @ navigationAjaxResponse');
		//console.debug(response);
	}
	this.listResponse1 = function(response){
		alert('Here @ Navigation Listener');
		
		//console.debug(response);
	}
	this.pageResponse = function(response){
		console.log('Here @ pageContentResponse');
		//console.debug(response);
	}
	this.breadcrumbResponse = function(response){
		console.log('Here @ breadcrumbResponse');
		//console.debug(response);
	}
	this.relatedContentResponse = function(response){
		console.log('Here @ relatedContentResponse');
		//console.debug(response);
	}
}
var site = new Site();

$(document).ready(function(){
	site.list();
});
</script>


<!---

<!---
/* based on the a view create the events */
function Nav() {
	var gfMVCEvent = new GFMVCEvent();
	gfMVCEvent.addEvent('site.page', 'pageContent','pageResponse');
	gfMVCEvent.addEvent('site.breadcrumb', 'breadcrumb');
	
	this.get = function(ContentID){
		gfMVCEvent.dispatchEvent({'ContentID':ContentID});
	}
	
	this.pageResponse = function(response){
		alert('Here @ pageContentResponse');
		
		//console.debug(response);
	}
}
var nav = new Nav();

--->
 
if (fld.addEventListener)
	fld.addEventListener('keyup',eventkeyup,false );
	
		/*function getUsers(){
	dispatchGFMVCEvent('user.list', {context : 'pageContent'});
}*/


	$("#bttn1,#bttn2").bind({
		click :function(){
			var frm = jQuery(this).parents('form').attr('id');
			console.debug(frm);
			postData = serializeForm(frm);
			console.debug(postData);
			//oPage.save();
		}
	
	});
	
	jQuery('#bttn111').click(function(){
		var frm = jQuery(this).parents('form').attr('id');
		console.debug(frm);
	}
	)

function user() {
	this.list = function(params){
		var postData = {};
		if (params){
			if (jQuery.isObject(params) )
				postData = data;
			else{
				var formData = serializeForm(params);
				console.debug(formData);
			}

		}
		else {
			//var currentFormID = jQuery(this).parents('form').attr('id');
			//if (currentFormID != 'undefined')
			//	postData = serializeForm(currentFormID);
		}	
		
		/*var eventInfo = [
							{eventName:'page.content',context:'pageContent',data:postData},
							{eventName:'page.breadcrumb',context:'breadcrumb',data:postData}
						];*/

		var gfMVCEvent = new GFMVCEvent();
		gfMVCEvent.addEvent('page.list', 'pageContent');
		//gfMVCEvent.addEvent('page.breadcrumb', 'breadcrumb');
		//gfMVCEvent.addEvent('page.relatedContent', 'relatedContent');
		
		postData = serializeForm('firstFrm');
		
		gfMVCEvent.dispatchEvent(postData);
		
		//dispatchGFMVCEvent(eventInfo,);
		//dispatchGFMVCEvent('user.list', {context : ['pageContent','breadcrumb']});
	}
	this.listResponse = function(response){
		alert('Here @ listResponse');
		console.debug(response);
	} 
}

 --->
</html>
