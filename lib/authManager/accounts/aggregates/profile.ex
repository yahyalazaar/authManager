defmodule AuthManager.Accounts.Aggregates.Profile do
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

  alias AuthManager.Accounts.Aggregates.Profile

  alias AuthManager.Accounts.Commands.{
    CreateProfile,
    UpdateProfile
  }

  alias AuthManager.Accounts.Events.{
    ProfileFullAddressChanged,
    ProfileIsAdminChanged,
    ProfilePhoneChanged,
    ProfileCreated
  }

  @doc """
  Register a new profile
  """
  def execute(%Profile{uuid: nil}, %CreateProfile{} = register) do
    %ProfileCreated{
      uuid: register.uuid,
      user_uuid: register.user_uuid,
      name: register.name,
      phone: register.phone,
      role: register.role,
      is_admin: register.is_admin,
      address: register.address,
      city: register.city,
      zip: register.zip,
      country: register.country
    }
  end

  @doc """
  Update a profile
  """
  def execute(%Profile{} = profile, %UpdateProfile{} = update) do
    Enum.reduce([&phone_changed/2, &is_admin_changed/2, &full_address_changed/2], [], fn change,
                                                                                         events ->
      case change.(profile, update) do
        nil -> events
        event -> [event | events]
      end
    end)
  end

  # state mutators

  def apply(%Profile{} = profile, %ProfileCreated{} = registered) do
    %Profile{
      profile
      | uuid: registered.uuid,
        user_uuid: registered.user_uuid,
        name: registered.name,
        phone: registered.phone,
        role: registered.role,
        is_admin: registered.is_admin,
        address: registered.address,
        city: registered.city,
        zip: registered.zip,
        country: registered.country
    }
  end

  def apply(%Profile{} = profile, %ProfilePhoneChanged{phone: phone}) do
    %Profile{profile | phone: phone}
  end

  def apply(%Profile{} = profile, %ProfileIsAdminChanged{is_admin: is_admin, role: role}) do
    %Profile{profile | is_admin: is_admin, role: role}
  end

  def apply(%Profile{} = profile, %ProfileFullAddressChanged{
        address: address,
        city: city,
        zip: zip,
        country: country
      }) do
    %Profile{profile | address: address, city: city, zip: zip, country: country}
  end

  # private helpers

  defp phone_changed(%Profile{}, %UpdateProfile{phone: ""}), do: nil
  defp phone_changed(%Profile{phone: phone}, %UpdateProfile{phone: phone}), do: nil

  defp phone_changed(%Profile{uuid: uuid}, %UpdateProfile{phone: phone}) do
    %ProfilePhoneChanged{
      uuid: uuid,
      phone: phone
    }
  end

  defp is_admin_changed(%Profile{}, %UpdateProfile{is_admin: "", role: ""}), do: nil

  defp is_admin_changed(%Profile{is_admin: is_admin, role: role}, %UpdateProfile{
         is_admin: is_admin,
         role: role
       }),
       do: nil

  defp is_admin_changed(%Profile{uuid: uuid}, %UpdateProfile{is_admin: is_admin, role: role}) do
    %ProfileIsAdminChanged{
      uuid: uuid,
      is_admin: is_admin,
      role: role
    }
  end

  defp full_address_changed(%Profile{}, %UpdateProfile{
         address: "",
         city: "",
         zip: "",
         country: ""
       }),
       do: nil

  defp full_address_changed(
         %Profile{address: address, city: city, zip: zip, country: country},
         %UpdateProfile{address: address, city: city, zip: zip, country: country}
       ),
       do: nil

  defp full_address_changed(%Profile{uuid: uuid}, %UpdateProfile{
         address: address,
         city: city,
         zip: zip,
         country: country
       }) do
    %ProfileFullAddressChanged{
      uuid: uuid,
      address: address,
      city: city,
      zip: zip,
      country: country
    }
  end
end
