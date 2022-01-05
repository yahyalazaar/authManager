defmodule AuthManager.Accounts.Events.ProfileIsAdminChanged do
  @derive Jason.Encoder
  defstruct [
    :uuid,
    :is_admin,
    :role
  ]
end
