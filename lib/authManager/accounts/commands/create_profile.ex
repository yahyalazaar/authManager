defmodule AuthManager.Accounts.Commands.CreateProfile do
  defstruct uuid: "",
            user_uuid: "",
            name: "",
            phone: "",
            role: "",
            is_admin: false,
            address: "",
            city: "",
            zip: "",
            country: ""

  use ExConstructor
  use Vex.Struct
  alias AuthManager.Accounts.Commands.CreateProfile
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
  def assign_user(%CreateProfile{} = create_profile, %User{uuid: user_uuid}) do
    %CreateProfile{create_profile | user_uuid: user_uuid}
  end

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%CreateProfile{} = create_profile, uuid) do
    %CreateProfile{create_profile | uuid: uuid}
  end
end
