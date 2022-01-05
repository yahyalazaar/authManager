defmodule AuthManager.Accounts.Events.UserCreated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :email,
    :password_hash
  ]
end
