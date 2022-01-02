defmodule AuthManager.Accounts.Commands.UpdateProfile do
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
  alias AuthManager.Accounts.Commands.UpdateProfile
  alias AuthManager.Accounts.Projections.{User, Profile}
  @doc false
  def validate_input(%UpdateProfile{} = profile, attrs) do
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