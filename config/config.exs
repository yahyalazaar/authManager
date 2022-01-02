# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :authManager,
  ecto_repos: [AuthManager.Repo],
  event_stores: [AuthManager.EventStore]

# Configures the endpoint
config :authManager, AuthManagerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: AuthManagerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: AuthManager.PubSub,
  live_view: [signing_salt: "K8MagJS/"]

# Guardian config

config :authManager, AuthManager.Guardian,
  issuer: "authManager",
  ttl: {1, :hour},
  verify_issuer: true,
  secret_key: "H4cUX1FdxGltXRK5VetiFklFW+ogf2a1NfnXjOEQIFvOiBPVFnaJuI0V/Ki2uSLn",
  verify_module: Guardian.JWT
  # allowed_algos: ["HS512"],
  # secret_key: %{
  #   "k" => "HKSltfgirbionzvKpginifqZEUNG3gTFkgnn14Vqo_T-FjSFIKqrRh8EfIXsgqYNTATnEL4wTJo6yFBaqXQOUw",
  #   "kty" => "oct"
  # }
  # allowed_algos: ["Ed25519"],
  # secret_fetcher: AuthManager.Guardian.KeyServer
  # "Secret key. Use `mix guardian.gen.secret` to generate one"
config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: AuthManager.Repo


config :authManager, AuthManager.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: AuthManager.EventStore
  ],
  pub_sub: :local,
  registry: :local
# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :authManager, AuthManager.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
