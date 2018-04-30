FROM elixir:1.6.4

ADD . /app
WORKDIR /app

RUN mix local.hex --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force
RUN mix deps.get --only prod

ENV MIX_ENV=prod
RUN mix compile

CMD ["mix", "phx.server"]
