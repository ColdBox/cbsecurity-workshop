/**
 * I am a new handler
 * Implicit Functions: preHandler, postHandler, aroundHandler, onMissingAction, onError, onInvalidHTTPMethod
 */
component extends="coldbox.system.EventHandler"{

	property name = "userService" inject;

	/**
	 * Show the form for creating a new resource
	 */
	function new( event, rc, prc ){
		event.setView( "registration/new" );
	}

	/**
	 * Store a newly created resource in storage
	 */
	function create( event, rc, prc ){
		prc.oUser = userService.create( populateModel( "User" ) );

		auth().login( prc.oUser );

		flash.put(
			"notice",
			{
				type   : "success",
				message: "The user #encodeForHTML( prc.oUser.getEmail() )# with id: #prc.oUser.getId()# was created!"
			}
		);

		relocate( "/" );
	}



}
