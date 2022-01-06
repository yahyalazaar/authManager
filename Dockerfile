FROM elixir:latest

# install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && apt-get install -y postgresql-client
RUN mkdir /app
COPY . /app
WORKDIR /app

ARG mix_env
ARG get_deps

ENV MIX_ENV ${mix_env}
ENV MIX_HOME=/opt/mix
ENV HEX_HOME=/opt/hex
# ENV LANG=C.UTF-8

# install Hex + Rebar
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new --force


# install mix dependencies
RUN mix deps.clean --all
RUN mix ${get_deps}
RUN mix deps.compile
RUN mix compile


# EXPOSE 4000

ENV HOME=/app
RUN chmod +x entrypoint.sh
CMD ["bash", "/app/entrypoint.sh"]
