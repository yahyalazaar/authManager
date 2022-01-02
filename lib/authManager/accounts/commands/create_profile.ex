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
  import Ecto.Changeset
  alias AuthManager.Accounts.Commands.CreateProfile
  alias AuthManager.Accounts.Projections.{User, Profile}
  @doc false
  def validate_input(%CreateProfile{} = profile, attrs) do
  # def changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :uuid,
      :name,
      :phone,
      :role,
      :is_admin,
      :address,
      :zip,
      :country,
      :city,
      :user_uuid
    ])
    |> validate_required([
      :uuid,
      :name,
      :phone,
      :role,
      :is_admin,
      :address,
      :zip,
      :country,
      :city,
      :user_uuid
    ])
  end

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
