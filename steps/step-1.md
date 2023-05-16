# Step 1 - Scaffold Your Application

Create a folder for your app on your hard drive called `myadmin`.  Our just use the `src` folder from this repo.

## Scaffold the application

```sh
cd src
coldbox create app name=myadmin
```

Also run a `coldbox create app ?` to see all the different ways to generate an app.  You can also use `coldbox create app-wizard ?` and follow our lovely wizard.

## Start up a local server

We use a standard port, so that in the steps and in the training we can all use the same port.  It makes it easier for the class. However, please note that you can omit this and use whatever port is available in your machine.  If the `42518` port is already in use, please make sure you use another port.

```sh
server start port=42518 saveSettings=true
```

- Open `http://localhost:42518/` in your browser. You should see the default ColdBox app template
- Open `/tests` in your browser. You should see the TestBox test browser.  This is useful to find a specific test or group of tests to run _before_ running them.
- Open `/tests/runner.cfm` in your browser. You should see the TestBox test runner for our project

This is running all of our tests by default. We can create our own test runners as needed.

All your tests should be passing at this point. 😉
