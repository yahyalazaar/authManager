defmodule AuthManager.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :AuthManager,
  module: AuthManager.Guardian,
  error_handler: AuthManager.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
