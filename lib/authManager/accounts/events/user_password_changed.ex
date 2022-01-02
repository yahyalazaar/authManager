defmodule AuthManager.Accounts.Events.UserPasswordChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :password_hash
  ]
end
