defmodule AuthManager.Accounts.Events.UserEmailChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :email
  ]
end
