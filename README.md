# Pact Broker
[![Gem Version](https://badge.fury.io/rb/pact_broker.svg)](http://badge.fury.io/rb/pact_broker)
 [![Build Status](https://travis-ci.org/pact-foundation/pact_broker.svg?branch=master)](https://travis-ci.org/pact-foundation/pact_broker)
 [![Join the chat at https://pact-foundation.slack.com/](https://img.shields.io/badge/chat-on%20slack-blue.svg?logo=slack)](https://slack.pact.io)
 [![security](https://hakiri.io/github/pact-foundation/pact_broker/master.svg)](https://hakiri.io/github/pact-foundation/pact_broker/master)
 [![Code Climate](https://codeclimate.com/github/pact-foundation/pact_broker/badges/gpa.svg)](https://codeclimate.com/github/pact-foundation/pact_broker)
 [![Test Coverage](https://codeclimate.com/github/pact-foundation/pact_broker/badges/coverage.svg)](https://codeclimate.com/github/pact-foundation/pact_broker/coverage)

The Pact Broker is an application for sharing of consumer driven contracts and verification results. It is optimised for use with "pacts" (contracts created by the [Pact][pact-docs] framework), but can be used for any type of contract that can be serialized to JSON.

<br/>
<a href="https:/pactflow.io/?utm_source=github&utm_campaign=pact_broker_intro"><img src="docs/images/Pactflow logo - black small.png"></a>
<br/>

You can try out a Pact Broker for free at <a href="https://pactflow.io/?utm_source=github&utm_campaign=pact_broker_intro"/>pactflow.io</a>. Built by a group of core Pact maintainers, Pactflow is a fork of the OSS Pact Broker with extra goodies like an improved UI, field level verification results and federated login.

**Why do I need a Pact Broker?**

Contract testing is an alternative approach to traditional integration testing that gives you tests that are quicker to execute, and that are more maintainable at scale. One down side of the approach is that the important information that would be available all in one place at the end of an integration test suite execution (that is, the version numbers of all the applications that were tested together, and whether the tests passed or failed) is now spread out across many different builds. The Pact Broker is a tool that brings all this information back together again, and allows you to deploy with safety.

It:

* allows you to release customer value quickly and confidently by [deploying your services independently][decouple] and avoiding the bottleneck of integration tests
* solves the problem of how to share contracts and verification results between consumer and provider projects
* tells you which versions of your applications can be deployed safely together
* automatically versions your contracts
* allows you to ensure backwards compatibility between multiple consumer and provider versions (eg. in a mobile or multi-tenant environment)
* provides API documentation of your applications that is guaranteed to be up-to date
* shows you real examples of how your services interact
* allows you to visualise the relationships between your services

Features:

* A RESTful API for publishing and retrieving pacts.
* An embedded API browser for navigating the API.
* Autogenerated documentation for each pact.
* Dynamically generated network diagrams so you can visualise your microservice network.
* Displays provider verificaton results so you know if you can deploy safely.
* Provides a "matrix" of compatible consumer and provider versions, so you know which versions can be safely deployed together.
* Provides badges to display pact verification statuses in your READMEs.
* Enables an application version to be tagged (ie. "prod", "feat/customer-preferences") to allow repository-like workflows.
* Provides webhooks to trigger actions when pacts change eg. run provider build, notify a Slack channel.
* View diffs between Pact versions so you can tell what expectations have changed.
* [Docker Pact Broker][docker]
* A [CLI][cli] for encorporating the Pact workflow into your continuous integration process.


### How would I use the Pact Broker?

#### Step 1. Consumer CI build
1. The consumer project runs its tests using the [Pact][pact] library to provide a mock service.
2. While the tests run, the mock service writes the requests and the expected responses to a JSON "pact" file - this is the consumer contract.
3. The generated pact is then published to the Pact Broker. Most Pact libraries will make a task available for you to do this easily, however, at its simplest, it is a `PUT` to a resource that specifies the consumer name and application version, and the provider name. eg `http://my-pact-broker/pacts/provider/Animal%20Service/consumer/Zoo%20App/version/1.0.0`
(Note that you are specifying the _consumer application version_ in the URL, not the pact version. The broker will take care of versioning the pact behind the scenes when its content changes. It is expected that the consumer application version will increment with every CI build.)
4. When a pact is published, a webhook in the Pact Broker kicks off a build of the provider project if the pact content has changed since the previous version.

#### Step 2. Provider CI build
1. The provider has a verification task that is configured with the URL to retrieve the latest pact between itself and the consumer. eg `http://my-pact-broker/pacts/provider/Animal%20Service/consumer/Zoo%20App/latest`.
2. The provider build runs the pact verification task, which retrieves the pact from the Pact Broker, replays each request against the provider, and checks that the responses match the expected responses.
3. If the pact verification fails, the build fails. The [Pact Broker CI Nerf Gun][nerf] magically determines who caused the verification to fail, and shoots them.
4. The results of the verification are published back to the Pact Broker by the pact verification tool, so the consumer team will know if the code they have written will work in real life.

If you don't have a [Pact Broker CI Nerf Gun][nerf], you'll probably want to read about using pact when the consumer and provider are being written by [different teams][different-teams].

#### Step 3. Back to the Consumer CI build

1. The Consumer CI determines if the pact has been verified by running `pact-broker can-i-deploy --pacticipant CONSUMER_NAME --version CONSUMER_VERSION ...` (see documentation [here](https://github.com/pact-foundation/pact_broker-client#can-i-deploy))
1. If the pact has been verified, the deployment can proceed.

Read more about how to use the Pact Broker in the [overview][overview] on the wiki page.

## Documentation

See the [wiki][wiki] for documentation on the Pact Broker. Please read the [overview][overview] page first to get an understanding of the HTTP resources in the broker, and how they relate to each other.

## Support

* Check the [wiki][wiki] first.
* See if there is an existing or closed [issue][issues] and raise a new issue if not.
* See if there is an existing question on [stackoverflow][stackoverflow] tagged with `pact-broker`, and ask a new question if not.
* Have a chat to us on the Pact [slack][slack].
* Tweet us at [@pact_up][twitter] on the twitters.

### Screenshots

#### Index

* * *
<img src="https://raw.githubusercontent.com/wiki/pact-foundation/pact_broker/images/index.png"/>

#### Autogenerated documentation

Paste the pact URL into a browser to view a HTML version of the pact.
* * *
<img src="https://raw.githubusercontent.com/wiki/pact-foundation/pact_broker/images/autogenerated_documentation.png"/>


#### Network diagram

* * *
<img src="https://raw.githubusercontent.com/wiki/pact-foundation/pact_broker/images/network_diagram.png"/>

#### HAL browser

Use the embedded HAL browser to navigate the API.
* * *
<img src="https://raw.githubusercontent.com/wiki/pact-foundation/pact_broker/images/hal_browser.png"/>

#### HAL documentation

Use the HAL browser to view documentation as you browse.
* * *
<img src="https://raw.githubusercontent.com/wiki/pact-foundation/pact_broker/images/hal_documentation.png"/>

## Usage

### To have a play around on your local machine

* Install ruby 2.2.0 or later and bundler >= 1.12.0
    * Windows users: get a Rails/Ruby installer from [RailsInstaller](http://railsinstaller.org/) and run it
    * unix users just use your package manager
* Run `git clone git@github.com:pact-foundation/pact_broker.git && cd pact_broker/example`
* Run `bundle install`
* Run `bundle exec rackup -p 9292 -o 0.0.0.0` (this will use a Sqlite database. If you want to try it out with a Postgres database, see the [README](https://github.com/pact-foundation/pact_broker/tree/master/example) in the example directory.)
* Open [http://localhost:9292](http://localhost:9292) and you should see a list containing the pact between the Zoo App and the Animal Service.
* Click on the arrow to see the generated HTML documentation.
* Click on either service to see an autogenerated network diagram.
* Click on the HAL Browser link to have a poke around the API.
* Click on the book icon under "docs" to view documentation related to a given relation.


### For reals

#### Hosted

In a hurry? Hate having to run your own infrastructure? Check out [pactflow.io][pactflow] - it's fast, it's secure and it's free to trial!

#### Container solutions

You can use the [Pact Broker Docker image][docker] or [Terraform on AWS][terraform]. See the [wiki][reverse-proxy-docs] for instructions on using a reverse proxy with SSL.

#### Rolling your own

* Are you sure you don't just want to use the [Pact Broker Docker image][docker]? No Docker at your company yet? Ah well, keep reading.
* Create a PostgreSQL (recommended) or MySQL (not _as_ recommended because of @bethesque's personal prejudices, but still fully supported) database.
 * To ensure you're on a supported version of the database that you choose, check the [travis.yml][travisyml] file to see which versions we're currently running our tests against.
* If you're using PostgreSQL (did we mention this was _recommended!_) you'll find the database creation script in the [example/config.ru](https://github.com/pact-foundation/pact_broker/blob/master/example/config.ru).
* Install ruby 2.4 or later and the latest version of bundler (if you've come this far, I'm assuming you know how to do both of these. Did I mention there was a [Docker][docker] image?)
* Copy the [pact\_broker](https://github.com/DiUS/pact_broker-docker/tree/master/pact_broker) directory from the Pact Broker Docker project. This will have the recommended settings for database connections, logging, basic auth etc. Note that the Docker image uses Phusion Passenger as the web application server in front of the Pact Broker Ruby application, which is the recommended set up.
* Modify the config.ru and Gemfile as desired (eg. choose database driver gem, set your database credentials. Use the "pg" gem if using Postgres and the "mysql2" gem if using MySQL)
    * example Sequel configuration for postgres `{adapter: "postgres", database: "pact_broker", username: 'pact_broker', password: 'pact_broker', :encoding => 'utf8'}`
    * example Sequel configuration for mysql `{adapter: "mysql2", database: "pact_broker", username: 'pact_broker', password: 'pact_broker', :encoding => 'utf8'}`
`
* Please ensure you use `encoding: 'utf8'` in your Sequel options to avoid encoding issues.
* For production usage, use a web application server like [Phusion Passenger](https://www.phusionpassenger.com) or [Nginx](http://nginx.org/) to serve the Pact Broker application. You'll need to read up on the documentation for these yourself as it is beyond the scope of this documentation. See the [wiki][reverse-proxy-docs] for instructions on using a reverse proxy with SSL.
* Ensure the environment variable `RACK_ENV` is set to `production`.
* Deploy to your location of choice.

## Upgrading

Please read the [UPGRADING.md](UPGRADING.md) documentation before upgrading your Pact Broker, for information on the supported upgrade paths.

[decouple]: http://techblog.realestate.com.au/enter-the-pact-matrix-or-how-to-decouple-the-release-cycles-of-your-microservices/
[pact]: https://github.com/pact-foundation/pact-ruby
[nerf]: https://github.com/pact-foundation/pact_broker/wiki/pact-broker-ci-nerf-gun
[different-teams]: https://github.com/pact-foundation/pact-ruby/wiki/Using-pact-where-the-consumer-team-is-different-from-the-provider-team
[docker]: https://github.com/pact-foundation/pact-broker-docker
[terraform]: https://github.com/nadnerb/terraform-pact-broker
[pactflow]: https:/pactflow.io/?utm_source=github&utm_campaign=pact_broker_usage
[wiki]: https://github.com/pact-foundation/pact_broker/wiki
[reverse-proxy-docs]: https://github.com/pact-foundation/pact_broker/wiki/Configuration#running-the-broker-behind-a-reverse-proxy
[stackoverflow]: http://stackoverflow.com/questions/tagged/pact-broker
[twitter]: https://twitter.com/pact_up
[slack]: https://slack.pact.io/
[issues]: https://github.com/pact-foundation/pact_broker/issues
[pact-docs]: http://docs.pact.io
[cli]: https://github.com/pact-foundation/pact-ruby-standalone/releases
[travisyml]: https://github.com/pact-foundation/pact_broker/blob/master/.travis.yml
[overview]: https://github.com/pact-foundation/pact_broker/wiki/Overview
