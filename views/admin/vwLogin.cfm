<section class="grid_4"></section>
		<section class="grey-bg grid_4">
<cfoutput>
<form class="block-content form" id="frmLogin" name="frmLogin" method="post" action="#getLink('admin.login')#">
	<!---<h1>Login</h1>--->
	
	
	<dl class="one-line-input">
		<cfset renderView(viewName:'admin.vwValidationError') />
		<ul id="messageBox" class="message error no-margin" style="display:none;">
		</ul>
		
		<dt><label for="email">Email</label></dt>
		<dd>
			<span class="relative">
				<input type="text" name="email" id="email" value="" class="full-width longlength required email" maxlength="100">
				<span></span>
			</span>
		</dd>
		<dt><label for="password">Password</label></dt>
		<dd>
			<span class="relative">
				<input type="password" name="password" id="password" value="" class="full-width longlength required" minlength="4">
				<span></span>
			</span>
		</dd>
		
		<button type="button" name="loginBtn" id="loginBtn"> Login</button>
	</dl>
</form>
</cfoutput>
</section>
		<section class="grid_4"></section>
<script>
$(document).ready(function(){
	
	$("#loginBtn").click(function(){
		$("#frmLogin").validate({ 
		   showErrors: function(errorMap, errorList) {
		   		//console.debug(errorMap);
				var errorMsg = '';
				$.each(errorMap, function(key, value){
					errorMsg = errorMsg + '<li>'+ errorMap[key] +'</li>';
				});
				$("#messageBox").html(errorMsg);
				//$("#messageBox").html("Your form contains "
		          //                         + this.numberOfInvalids() 
		            //                      + " errors, see details below.");
				if (this.numberOfInvalids() > 0)
					$("#messageBox").show();
				else
					$("#messageBox").hide();
				this.defaultShowErrors();
			},
			highlight: function(element, errorClass, validClass) {
		     $(element).addClass(errorClass);
			 $(element).siblings().addClass('check-error');
		     $(element.form).find("label[for=" + element.id + "]").addClass(errorClass);
		  },
		  unhighlight: function(element, errorClass, validClass) {
		     $(element).removeClass(errorClass);
			 $(element).siblings().removeClass('check-error').addClass('check-ok');
		     $(element.form).find("label[for=" + element.id + "]")
		                  .removeClass(errorClass);
		  },
		  errorPlacement: function(error, element) {
		  		//console.debug(error);check-error
				//console.debug(element.siblings());
				//element.siblings().addClass('check-error');
     			//error.appendTo( element.parent("td").next("td") );
				$("#messageBox").show();
	 		}<!---,
			submitHandler: function(form) {
			   	$(form).submit();
			   }--->
			//debug: true
			<!---errorClass : "message error no-margin",
			errorElement : "li",
			wrapper: "ul",
			errorLabelContainer : "#messageBox"--->
		
		});
		$('#frmLogin').submit();
		}
	);
});
</script>