/**
 * I am a new Model Object
 */
component singleton accessors="true"{

	property name = "bcrypt" inject = "@BCrypt";
	// To populate objects from data
    property name="populator" inject="wirebox:populator";

	/**
	 * Constructor
	 */
	UserService function init(){

		return this;
	}

	/**
	 * Create a new empty User
	 */
	User function new() provider = "User"{}

	function list(){
		return queryExecute( "select * from users", {}, { returntype = "array" } );
	}

	/**
	 * Create a new user
	 *
	 * @user The user to persist
	 *
	 * @returns The persisted user
	 */
	User function create( required user ){
		// Store timestamps
		var now = now();
		arguments.user
			.setModifiedDate( now )
			.setCreatedDate( now )
		// Persist: You can use positional or named arguments
		queryExecute(
			"
				INSERT INTO `users` (`name`, `email`, `password`, `createdDate`, `modifiedDate`)
				VALUES (?, ?, ?, ?, ?)
			",
			[
				arguments.user.getName(),
				arguments.user.getEmail(),
				bcrypt.hashPassword( arguments.user.getPassword() ),
				{ value : arguments.user.getCreatedDate(), type : "timestamp" },
				{ value : arguments.user.getModifiedDate(), type : "timestamp" }
			],
			{ result = "local.result" }
		);
		// Seed id and return
		return arguments.user.setId( result.generatedKey );
	}

	/**
	 * Get a user by ID
	 *
	 * @id The id to retrieve
	 *
	 * @return The user matching the incoming id
	 */
	User function retrieveUserById( required id ){
		return populator.populateFromQuery(
			target : new (),
			qry : queryExecute( "SELECT * FROM `users` WHERE `id` = ?", [ arguments.id ] ),
			ignoreTargetLists : true
		);
	}

	/**
	 * Get a user by username, in our case we use the email as the username
	 *
	 * @username The required username
	 *
	 * @return The user matching the incoming the username
	 */
	User function retrieveUserByUsername( required username ){
		return populator.populateFromQuery(
			target : new (),
			qry :queryExecute( "SELECT * FROM `users` WHERE `email` = ?", [ arguments.username ] ),
			ignoreTargetLists : true
		);
	}

	/**
	 * Verify if the credentials are valid or not
	 *
	 * @username The required username
	 * @password The required password
	 *
	 * @return Are the credentials valid or not
	 */
	boolean function isValidCredentials( required username, required password ){
		var oUser = retrieveUserByUsername( arguments.username );
		if ( !oUser.isLoaded() ) {
			return false;
		}

		return bcrypt.checkPassword( arguments.password, oUser.getPassword() );
	}

}
