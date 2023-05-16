# 8 - User Registration

Let's build our user registration system.

```html
- I want to be able to display the new user registration form
- I want to be able to register users in the system
```

So what would we need to complete these stories, make an inventory:

- [ ] A `User` object to model our user.  We already created a migration for it.
- [ ] Update our `UserService` so we can retrieve new users (`new()`) and save new users (`create()`)
- [ ] A handler and routing to control the display of our new registration form and the saving of such form.
- [ ] Hmm, since we are storing users now, we don't want to store passwords in plain text, so I guess we need to update our story to showcase storing secure passwords.

```html
- I want to be able to display the new user registration form
- I want to be able to register users in the system securely using bcrypt
```

## Install [BCyrpt](https://github.com/coldbox-modules/cbox-bcrypt)

Let's instally `bcrypt` since it's already a nice ColdBox module:

```bash
install bcrypt
```

> You can configure this module to do many work factors or custom salts. Read the readme for much more information on how to configure this module: https: //github.com/coldbox-modules/bcrypt#bcrypt-settings

## User Model

Let's create our `User` object:

```bash
coldbox create model name="User" properties="id,name,email,password,createdDate,modifiedDate"
```

### `User.cfc`

```js
/**
 * I am a user in My Admin
 */
component accessors="true" {

	// Properties
	property name = "id"           type = "numeric";
	property name = "name"         type = "string";
	property name = "email"        type = "string";
	property name = "password"     type = "string";
	property name = "createdDate"  type = "date";
	property name = "modifiedDate" type = "date";

	/**
	 * Constructor
	 */
	User function init(){
		return this;
	}

	/**
	 * Verify if this is a persisted or new user
	 */
	boolean function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

}
```

## User Service

- A way to build `User` objects
- A way to store a `User` object

### Injection

```js
// Properties
property name = "bcrypt" inject = "@BCrypt";
```

### New User

We will use a WireBox feature called virtual method providers.  It's really just a shortcut to calling `getInstance( "User" )` to produce `User` objects (https://wirebox.ortusbooks.com/advanced-topics/providers/virtual-provider-lookup-methods) so we don't have to type much:

```js
/**
 * Create a new empty User
 */
User function new() provider = "User"{}
```

This will tell WireBox to provide `User` objects whenever the `new()` method is called.

### Create User

Now we need to create the user using a secure password:

```js
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
```

## Resourceful Event Handlers

For the majority of our handler concerns we will use the standard called resourceful routes (https://coldbox.ortusbooks.com/the-basics/routing/routing-dsl/resourceful-routes).  This is a standard that exists in many MVC freameworks in many languages.  It allows a framework to keep routing, controllers and actions very consistent.

Resourceful routes are convention based to help you create routing with less boilerplate.  You declare your resources in your routers and ColdBox will take care of creating the routes for you.  In your router you can use the `resources()` or the `apiResources()` methods.  Let's check out what a simple router call can do:

```js
resources( "photos" );
```

### Created Routes

| HTTP Verb | Route                 | Event             | Route Name        |
|-----------|-----------------------|-------------------|-------------------|
| GET       | `/photos`             | `photos.index`    | `photos`          |
| GET       | `/photos/new`         | `photos.new`      | `photos.new`      |
| POST      | `/photos`             | `photos.create`   | `photos`          |
| GET       | `/photos/:id`         | `photos.show`     | `photos.process`  |
| GET       | `/photos/:id/edit`    | `photos.edit`     | `photos.edit`     |
| PUT/PATCH | `/photos/:id`         | `photos.update`   | `photos.process`  |
| DELETE    | `/photos/:id`         | `photos.delete`   | `photos.process`  |

This convention allows us to make very similar structures which can be easily grasped by anybody new to an MVC framework.

### Registration Resource

Let's create our registration flow.  We won't use all of the resourceful actions, so we can use the `actions` argument to select which ones we want.

```bash
coldbox create handler name = "registration" actions = "new,create"
```

- The `create` action does not have a view, so let's clean that up: `delete views/registration/create.cfm`
- Update the [`/config/Router.cfc`](../src/config/Router.cfc) file - insert a resources definition:

```js
resources( resource : "registration", only : "new,create" );
```

When working with routes it is essential to visualize them as they can become very complex.  We have just the module for that. Go to your shell and install our awesome route visualizer: `install route-visualizer --saveDev`.  Now issue a reinit: `coldbox reinit` and refresh your browser.  You can navigate to: http: //localhost:42518/route-visualizer and see all your wonderful routes.

### Event Handler `new()` Action

Revise the actions in the Registration Handler [`handlers/registration.cfc`](../src/handlers/registration.cfc)

```js
/**
 * User registration handler
 */
component {

	/**
	 * Show registration screen
	 */
	function new( event, rc, prc ){
		event.setView( "registration/new" );
	}

	/**
	 * Register a new user
	 */
	function create( event, rc, prc ){
	}

}
```

### Update the `new` View

Add the following into the registration form [`views/registration/new.cfm`](../src/views/registration/new.cfm)

```html
<cfoutput>
<div class = "vh-100 d-flex justify-content-center align-items-center">
<div class = "container">
<div class = "d-flex justify-content-center">
<div class = "col-8">
<div class = "card">
<div class = "card-header">
						My Admin Registration
					</div>
					<div class = "card-body">
						#html.startForm( action : "registration" )#

                            #html.inputField(
								name        : "name",
								class       : "form-control",
								placeholder : "Robert Box",
								groupWrapper: "div class='mb-3'",
								label       : "Full Name",
								labelClass  : "form-label"
							)#

							#html.emailField(
								name        : "email",
								class       : "form-control",
								placeholder : "email@myadmin.com",
								groupWrapper: "div class='mb-3'",
								label       : "Email",
								labelClass  : "form-label"
							)#

							#html.passwordField(
								name        : "password",
								class       : "form-control",
								groupWrapper: "div class='mb-3'",
								label       : "Password",
								labelClass  : "form-label"
							)#

							#html.passwordField(
								name        : "confirmPassword",
								class       : "form-control",
								groupWrapper: "div class='mb-3'",
								label       : "Confirm Password",
								labelClass  : "form-label"
							)#

							<div    class = "form-group">
							<button type  = "submit" class = "btn btn-primary">Register</button>
							</div>
						#html.endForm()#
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</cfoutput>
```

Hit http://127.0.0.1:42518/registration/new

Now you will see the form.

### NavBar Updates

Add a register link to the `navigation` partial for our registration page

```html
<div class = "collapse navbar-collapse" id = "navbarSupportedContent">
    <!--- Left Aligned --->
    <ul class = "navbar-nav me-auto mb-2 mb-lg-0">
        <li class = "nav-item">
            <a
                class = "nav-link #event.urlMatches( "registration/new" ) ? 'active' : ''#"
                href  = "#event.buildLink( 'registration.new' )#"
                >
                Register
            </a>
        </li>
        <li class="nav-item me-2">
			<a
                class="nav-link #event.routeIs( "about" ) ? 'active' : ''#"
                href="#event.buildLink( 'about' )#"
                >
                About
            </a>
        </li>
    </ul>

    <!--- Right Aligned --->
    <div class = "ms-auto d-flex">
    </div>
</div>
```

Refresh your page, click Register and fill out the form. Submit the form and you will see an error
`Messages: The event: Registration.create is not a valid registered event.`

Next we'll create the saving action. Which is what our test was written for.

### Event Handler `create()` action

We need to inject the `UserService` into the handler.

```js
// DI
property name = "userService" inject;
```

Ok, let's try it now:

```js
/**
 * Register a new user
 */
function create( event, rc, prc ){
    prc.oUser = userService.create( populateModel( "User" ) );

    flash.put(
        "notice",
        {
            type   : "success",
            message: "The user #encodeForHTML( prc.oUser.getEmail() )# with id: #prc.oUser.getId()# was created!"
        }
    );
```

> More info here: https: //coldbox.ortusbooks.com/digging-deeper/flash-ram

### Update Layout With Flash

What is new to you here? Flash scope baby! Let's open the `layouts/Main.cfm` and create the visualization of our flash messages right before the main view is rendered `view()`

```html
<main class="flex-shrink-0">

    <cfif flash.exists( "notice" )>
        <div class = "alert alert-#flash.get( "notice" ).type#" role = "alert">
            #flash.get( "notice" ).message#
        </div>
    </cfif>

    #view()#
</main>
```

Let's do a reinit and test again: `coldbox reinit`

### Verify Registration

Hit the url: http: //127.0.0.1:42518//registration/new and add a new user.

If you didn't reinit the framework, you will see the following error `Messages: variable [BCRYPT] doesn't exist` Dependency Injection changes require a framework init.

Now hit the url with frame reinit: http: //127.0.0.1:42518//registration/new?fwreinit=1

Add a new user, and see that the password is now encrypted. Bcrypt encrypted passwords look like the following:

`$2a$12$/w/nkNrV6W6qqZBNXdqb4OciGWNNS7PCv1psej5WTDiCs904Psa8S`
