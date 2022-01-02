defmodule AuthManager.Accounts.Projectors.Profile do
  use Commanded.Projections.Ecto,
    application: AuthManager.App,
    name: "Accounts.Projectors.Profile",
    consistency: :strong

  alias AuthManager.Accounts.Events.{
    ProfileFullAddressChanged,
    ProfileIsAdminChanged,
    ProfilePhoneChanged,
    ProfileCreated
  }

  alias AuthManager.Accounts.Projections.Profile

  project(%ProfileCreated{} = registered, fn multi ->
    Ecto.Multi.insert(multi, :Profile, %Profile{
      uuid: registered.uuid,
      user_uuid: registered.user_uuid,
      name: registered.name,
      phone: registered.phone,
      role: registered.role,
      is_admin: registered.is_admin,
      address: registered.address,
      city: registered.city,
      zip: registered.zip,
      country: registered.country
    })
  end)

  project(%ProfileFullAddressChanged{uuid: uuid, address: address, city: city, zip: zip, country: country}, fn multi ->
    update_profile(multi, uuid, address: address, city: city, zip: zip, country: country)
  end)

  project(%ProfilePhoneChanged{uuid: uuid, phone: phone}, fn multi ->
    update_profile(multi, uuid, phone: phone)
  end)

  project(
    %ProfileIsAdminChanged{uuid: uuid, is_admin: is_admin, role: role},
    fn multi ->
      update_profile(multi, uuid, is_admin: is_admin, role: role)
    end
  )

  defp update_profile(multi, uuid, changes) do
    Ecto.Multi.update_all(multi, :Profile, profile_query(uuid), set: changes)
  end

  defp profile_query(uuid) do
    from(p in Profile, where: p.uuid == ^uuid)
  end
end
