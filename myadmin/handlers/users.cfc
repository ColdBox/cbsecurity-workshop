/**
 * I am a new handler
 * Implicit Functions: preHandler, postHandler, aroundHandler, onMissingAction, onError, onInvalidHTTPMethod
 */
component extends="coldbox.system.EventHandler"{

	property name="userService" inject;

	/**
	 * Display a listing of the resource
	 */
	function index( event, rc, prc ){
		prc.aUsers = userService.list();
		event.setView( "users/index" );
	}

	/**
	 * Show the form for creating a new resource
	 */
	function new( event, rc, prc ){

	}

	/**
	 * Store a newly created resource in storage
	 */
	function create( event, rc, prc ){

	}

	/**
	 * Display the specified resource
	 */
	function show( event, rc, prc ){

	}

	/**
	 * Show the form for editing the specified resource
	 */
	function edit( event, rc, prc ){

	}

	/**
	 * Update the specified resource in storage
	 */
	function update( event, rc, prc ){

	}

	/**
	 * Remove the specified resource from storage
	 */
	function delete( event, rc, prc ){

	}



}
