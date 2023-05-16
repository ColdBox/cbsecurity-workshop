# 6 - List Users

```bash
coldbox create model name="UserService" methods="list" persistence="singleton"
```

## Querying our Database

```js
function list(){
    return queryExecute( "select * from users", {}, { returntype = "array" } );
}
```

## Mock Data Seeders

Ok, we tested with no data, so why not create some mock data. Let's create a database seeder we can use to populate our database with mock/fake data so our tests can cover those scenarios.

> Hint: Our mock generator is called `MockdataCFC` and is bundled with our `cfmigrations` and also with `TestBox`: https://github.com/ortus-solutions/mockdatacfc

Go to the shell and execute our seeder creation:

```bash
migrate seed create TestFixtures
```

Open the seeder: [resources/database/seeds/TestFixtures.cfc](../src/resources/database/seeds/TestFixtures.cfc).  The seeder method `run()` receives an instance of `qb` and `mockdata` so we can use for building out our database.

```js
component {

	// The bcrypt equivalent of the word test.
	bcrypt_test = "$2a$12$5d31nX1hRnkvP/8QMkS/yOuqHpPZSGGDzH074MjHk6u2tYOG5SJ5W";

    function run( qb, mockdata ) {
        qb.table( "users" ).insert(
			mockdata.mock(
                $num = 25,
                "id": "autoincrement",
                "name": "name",
                "email": "email",
                "password": "oneOf:#bcrypt_test#"
            )
		);
    }

}
```

This will populate the `users` table with 25 mocked users.  Please note that we use a `bcrypt_test`, this is the bcrypt equivalent of the word `test`.  How did we generate that?  Well here is a great online bcrypt generator: https://bcrypt.online/

To run this seeder, just do:

```bash
migrate seed run TestFixtures
```

And now we got data, verify the database that these records where created.
