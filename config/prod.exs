use Mix.Config
config :phx_form_relay, PhxFormRelay.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: System.get_env("PRODUCTION_URL"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :phx_form_relay, PhxFormRelay.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20

# Configure Mailer
config :phx_form_relay, 
  smtp_username: System.get_env("MAILGUN_SMTP_LOGIN"),
  smtp_password: System.get_env("MAILGUN_SMTP_PASSWORD"),
  smtp_host: System.get_env("MAILGUN_SMTP_SERVER"),
  smtp_port: System.get_env("MAILGUN_SMTP_PORT"),
  from_email: System.get_env("SENDER_EMAIL"),
  smtp_tls: :always,
  smtp_auth: :always