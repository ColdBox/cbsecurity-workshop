<cfoutput>
	<div class="vh-100 d-flex justify-content-center align-items-center">
		<div class="container">

			<h2>User Management</h2>

			#html.table(
				data : prc.aUsers,
				class : "table table-striped table-hover table-bordered",
				excludes : "password"
			)#

		</div>
	</div>
	</cfoutput>
