FROM elixir:1.10.3

ADD . /app
WORKDIR /app

COPY /prod.secret.exs /app/config/

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod

ENV MIX_ENV=prod
RUN mix compile

ENV PORT=3000
EXPOSE 3000

CMD ["mix", "phx.server"]
