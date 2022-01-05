defmodule AuthManager.Accounts.Commands.CreateProfile do
  defstruct uuid: "",
            user_uuid: "",
            name: "",
            phone: "",
            role: "",
            is_admin: "",
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
    presence: [message: "Name can't be empty"]
  )

  validates(:phone,
    presence: [message: "Phone can't be empty"]
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
