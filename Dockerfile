FROM elixir:1.9.4

ADD . /app
WORKDIR /app

RUN mix local.hex --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force
RUN mix deps.get --only prod
RUN mix local.rebar --force

ENV MIX_ENV=prod
RUN mix compile

ENV PORT=3000
EXPOSE 3000

CMD ["mix", "phx.server"]
