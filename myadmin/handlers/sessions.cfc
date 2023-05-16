/**
 * I am a new handler
 * Implicit Functions: preHandler, postHandler, aroundHandler, onMissingAction, onError, onInvalidHTTPMethod
 */
component extends="coldbox.system.EventHandler"{

	/**
	 * Show the login screen
	 */
	function new( event, rc, prc ){
		event.setView( "sessions/new" );
	}

	/**
	 * Login a user
	 */
	function create( event, rc, prc ){
		try {
			cbsecure().authenticate( rc.email ?: "", rc.password ?: "" );
			flash.put(
				"notice",
				{
					type   : "success",
					message: "Welcome back #encodeForHTML( rc.email )#"
				}
			);

			return relocate( uri = "/" );
		} catch ( InvalidCredentials e ) {
			flash.put(
				"notice",
				{
					type   : "danger",
					message: e.message
				}
			);
			return relocate( "login" );
		}
	}

	/**
	 * Logout a user
	 */
	function delete( event, rc, prc ){
		flash.put(
			"notice",
			{
				type   : "info",
				message: "Bye bye! See you soon!"
			}
		);
		cbsecure().logout();
		relocate( uri = "/" );
	}



}
