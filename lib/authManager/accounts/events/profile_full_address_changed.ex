defmodule AuthManager.Accounts.Events.ProfileFullAddressChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :address,
    :zip,
    :city,
    :country
  ]
end
