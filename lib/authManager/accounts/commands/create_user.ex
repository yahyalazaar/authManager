defmodule AuthManager.Accounts.Commands.CreateUser do
  defstruct uuid: "",
            email: "",
            password: "",
            password_confirmation: "",
            password_hash: ""

  use ExConstructor
  import Ecto.Changeset
  alias AuthManager.Accounts.Commands.CreateUser

  @doc false
  def validate_input(%CreateUser{} = user, attrs) do
    user
    # Remove hash, add pw + pw confirmation
    |> cast(attrs, [:uuid, :email, :password, :password_confirmation])
    # Remove hash, add pw + pw confirmation
    |> validate_required([:uuid, :email, :password, :password_confirmation])
    # Check that email is valid
    |> validate_format(:email, ~r/@/)
    # Check that password length is >= 8
    |> validate_length(:password, min: 8)
    # Check that password === password_confirmation
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  @doc """
  Hash the password, clear the original password
  """
  def put_password_hash(%CreateUser{password: password, password_confirmation: password_confirmation} = create_user) do
    %CreateUser{create_user | password: nil, password_confirmation: nil, password_hash: Comeonin.Bcrypt.hashpwsalt(password)}
  end
  @doc """
  Convert email address to lowercase characters
  """
  def downcase_email(%CreateUser{email: email} = create_user) do
    %CreateUser{create_user | email: String.downcase(email)}
  end

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%CreateUser{} = create_user, uuid) do
    %CreateUser{create_user | uuid: uuid}
  end
end
