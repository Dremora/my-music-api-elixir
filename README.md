# MyMusic

## Installing language and dependencies

Install asdf and autoconf with brew:

`brew install asdf autoconf`

Install elixir and erlang:

`export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"`

`asdf install`

Install hex:

`mix local.hex --force`

Install rebar:

`mix local.rebar --force`

Install dependencies:

`mix deps.get`

## Starting the app

- In a separate terminal, run PostgreSQL: `docker-compose up postgres`
- In a separate terminal, run Elasticsearch: `docker-compose up elasticsearch`
- Initialize the database and Elasticsearch: `mix ecto.setup`
- Import seed data: `mix ecto.import`
- Populate Elasticsearch: `mix elasticsearch.populate`
- Start Phoenix endpoint with `mix phx.server`

To migrate the database:

`mix ecto.migrate`

To drop the database:

`mix elasticsearch.drop && mix ecto.drop`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

- Official website: http://www.phoenixframework.org/
- Guides: http://phoenixframework.org/docs/overview
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
