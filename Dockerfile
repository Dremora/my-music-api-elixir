FROM elixir:1.4.2

ADD . /app
WORKDIR /app

RUN mix local.hex --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force
RUN mix deps.get

CMD ["mix", "phx.server"]
