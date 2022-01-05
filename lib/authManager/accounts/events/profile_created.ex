defmodule AuthManager.Accounts.Events.ProfileCreated do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :user_uuid,
    :name,
    :phone,
    :role,
    :is_admin,
    :address,
    :city,
    :zip,
    :country
  ]
end
