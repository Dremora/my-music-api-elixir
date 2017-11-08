# MyMusic

To start the app:

  * In a separate terminal, run postgres: `docker-compose up postgres`
  * In a separate terminal, run ElasticSearch: `docker-compose up elastisearch`
  * Install dependencies with `mix deps.get`
  * Initialize the database and ElasticSearch: `mix ecto.setup`
  * Import seed data: `mix ecto.import`
  * Populate ElasticSearch: `mix elasticsearch.populate`
  * Start Phoenix endpoint with `mix phx.server`

To migrate the database:

`mix ecto.migrate`

To drop the database:

`mix elasticsearch.drop && mix ecto.drop`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
