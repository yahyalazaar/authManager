defmodule AuthManager.Accounts.Events.ProfilePhoneChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :phone
  ]
end
