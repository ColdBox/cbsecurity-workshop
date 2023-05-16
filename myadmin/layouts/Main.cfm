<cfoutput>
	<!doctype html>
	<html lang = "en">
	<head>
		<!--- Metatags --->
		<meta charset = "utf-8">
		<meta name    = "viewport" content    = "width=device-width, initial-scale=1">
		<meta name    = "description" content = "ColdBox Application Template">
		<meta name    = "author" content      = "Ortus Solutions, Corp">

		<!---Base URL --->
		<base href = "#event.getHTMLBaseURL()#" />

		<!---
			CSS
			- Bootstrap
			- Alpine.js
			- App
		--->
		<link href = "https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel = "stylesheet" integrity = "sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin = "anonymous">
		<link rel  = "stylesheet" href                                                             = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
		<link rel  = "stylesheet" href                                                             = "/includes/css/app.css">

		<!--- Title --->
		<title>My Admin</title>
	</head>
	<body
		data-spy    = "scroll"
		data-target = ".navbar"
		data-offset = "50"
		style       = "padding-top: 60px"
		class       = "d-flex flex-column h-100"
	>
		<!---Top NavBar --->
		<header>
			<nav class = "navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
			<div class = "container-fluid">

					<!---Brand --->
					<a class = "navbar-brand text-info" href = "#event.buildLink( 'main' )#">
						<i class="bi bi-file-earmark-lock-fill"></i>
						<strong>My Admin</strong>
					</a>

					<!--- Mobile Toggler --->
					<button
						class          = "navbar-toggler"
						type           = "button"
						data-bs-toggle = "collapse"
						data-bs-target = "##navbarSupportedContent"
						aria-controls  = "navbarSupportedContent"
						aria-expanded  = "false"
						aria-label     = "Toggle navigation"
					>
						<span class = "navbar-toggler-icon"></span>
					</button>

					<div class = "collapse navbar-collapse" id = "navbarSupportedContent">
						<!--- Left Aligned --->
						<ul class = "navbar-nav me-auto mb-2 mb-lg-0">
							<!--- Logged In --->
							<cfif cbsecure().guest()>
								<li class = "nav-item">
									<a
										class = "nav-link #event.urlMatches( "registration/new" ) ? 'active' : ''#"
										href  = "#event.buildLink( 'registration.new' )#"
										>
										Register
									</a>
								</li>
								<li class = "nav-item">
									<a
										class = "nav-link #event.routeIs( "login" ) ? 'active' : ''#"
										href  = "#event.route( 'login' )#"
										>
										Log in
									</a>
								</li>
							<cfelse>
								<li class = "nav-item me-2">
									<a
										class = "nav-link #event.routeIs( "users" ) ? 'active' : ''#"
										href  = "#event.buildLink( 'Users' )#"
										>
										Users
									</a>
								</li>
							</cfif>

							<li class = "nav-item me-2">
								<a
									class = "nav-link #event.routeIs( "about" ) ? 'active' : ''#"
									href  = "#event.buildLink( 'about' )#"
									>
									About
								</a>
							</li>
						</ul>

						<!--- Right Aligned --->
						<div class = "ms-auto d-flex">
							<cfif cbsecure().isLoggedIn()>
								<form   method = "POST" action                  = "#event.buildLink( "logout" )#">
								<input  type   = "hidden" name                  = "_method" value = "DELETE" />
								<button class  = "btn btn-outline-success" type = "submit">Log Out</button>
								</form>
							</cfif>
						</div>
					</div>
				</div>
			</nav>
		</header>

		<!---Container And Views --->
		<main class = "flex-shrink-0">

			<cfif flash.exists( "notice" )>
				<div class = "alert alert-#flash.get( "notice" ).type#" role = "alert">
					#flash.get( "notice" ).message#
				</div>
			</cfif>

			#view()#
		</main>

		<!--- Footer --->
		<footer class = "w-100 bottom-0 position-fixed border-top py-3 mt-5 bg-light">
		<div    class = "container">
		<p      class = "float-end">
		<a      href  = "##" class                            = "btn btn-info rounded-circle shadow" role = "button">
		<i      class = "bi bi-arrow-bar-up"></i> <span class = "visually-hidden">Top</span>
					</a>
				</p>
				<p>
					<a href = "https://github.com/ColdBox/coldbox-platform/stargazers">ColdBox Platform</a> is a copyright-trademark software by
					<a href = "https://www.ortussolutions.com">Ortus Solutions, Corp</a>
				</p>

				<span
					class          = "badge rounded-pill text-bg-dark"
					data-bs-toggle = "tooltip"
					title          = "Environment"
				>
					<i class = "bi bi-hdd-stack"></i>
					#getSetting( "environment" )#
				</span>

				<span
					class          = "badge rounded-pill text-bg-dark"
					data-bs-toggle = "tooltip"
					title          = "Debug Mode"
				>
					<i class = "bi bi-bug"></i>
					#isDebugMode()#
				</span>

				<span
					class          = "badge rounded-pill text-bg-dark"
					data-bs-toggle = "tooltip"
					title          = "Request Date/Time"
				>
					<i class = "bi bi-calendar"></i>
					#getIsoTime()#
				</span>
			</div>
		</footer>

		<!---
			JavaScript
			- Bootstrap
			- Alpine.js
		--->
		<script src       = "https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity = "sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin = "anonymous"></script>
		<script defer src = "https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
		<script>
			// self executing function here
			(function() {
			// your page initialization code here
			// the DOM will be available here
				const aTooltips   = document.querySelectorAll( '[data-bs-toggle="tooltip"]' );
				const tooltipList = [...aTooltips ].map( el => new bootstrap.Tooltip( el ) );
			})();
		</script>
	</body>
	</html>
	</cfoutput>
