#!/bin/sh

# Note: !/bin/sh must be at the top of the line,
# Alpine doesn't have bash so we need to use sh.
# Docker entrypoint script.
# Don't forget to give this file execution rights via `chmod +x entrypoint.sh`
# which I've added to the Dockerfile but you could do this manually instead.
# Wait until Postgres is ready before running the next step.
while ! pg_isready -q -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER
do
  echo "$(date) - waiting for database to start."
  sleep 2
done

# Create the database if it doesn't exist.
# -z flag returns true if string is null.
if [[ -z `psql -Atqc "\\list $DATABASE_EVENTSTORE_NAME"` ]]; then
  echo "Database $DATABASE_EVENTSTORE_NAME does not exist. Creating..."
  # mix event_store.create
  mix event_store.init
  echo "Database $DATABASE_EVENTSTORE_NAME created."
fi

if [[ -z `psql -Atqc "\\list $DATABASE_NAME"` ]]; then
  echo "Database $DATABASE_NAME does not exist. Creating..."
  mix ecto.create
  echo "Database $DATABASE_NAME created."
fi
# Runs migrations, will skip if migrations are up to date.
echo "Database $DATABASE_NAME exists, running migrations..."
mix ecto.migrate
mix run priv/repo/seeds.exs
echo "Migrations finished."

# Start the server.
exec mix phx.server
