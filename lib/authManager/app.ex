defmodule AuthManager.App do
  use Commanded.Application, otp_app: :authManager

  router AuthManager.Router
end
