defmodule AuthManager.Accounts.Commands.UpdateProfile do
  defstruct uuid: "",
            user_uuid: "",
            name: "",
            phone: "",
            role: "",
            address: "",
            city: "",
            zip: "",
            country: "",
            is_admin: false

  use ExConstructor
  use Vex.Struct
  alias AuthManager.Accounts.Commands.UpdateProfile
  alias AuthManager.Accounts.Projections.{User, Profile}

  validates(:uuid, uuid: true)

  validates(:name,
    presence: [message: "name can't be empty"]
  )

  validates(:phone,
    presence: [message: "phone can't be empty"]
  )

  validates(:country,
    presence: [message: "country can't be empty"]
  )

  validates(:address,
    presence: [message: "address can't be empty"]
  )

  validates(:city,
    presence: [message: "city can't be empty"]
  )

  validates(:zip,
    presence: [message: "zip can't be empty"]
  )

  validates(:role,
    presence: [message: "role can't be empty"]
  )

  validates(:is_admin,
    presence: [message: "is_admin can't be empty"]
  )

  @doc """
  Assign a user to profile
  """
  def assign_user(%UpdateProfile{} = update_profile, %User{uuid: user_uuid}) do
    %UpdateProfile{update_profile | user_uuid: user_uuid}
  end

  @doc """
  Assign the profile identity
  """
  def assign_profile(%UpdateProfile{} = update_profile, %Profile{uuid: profile_uuid}) do
    %UpdateProfile{update_profile | uuid: profile_uuid}
  end

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%UpdateProfile{} = update_profile, uuid) do
    %UpdateProfile{update_profile | uuid: uuid}
  end
end
