defmodule AuthManager.Accounts.Commands.UpdateUser do
  defstruct uuid: "",
            email: "",
            password: "",
            password_confirmation: "",
            password_hash: ""

  use ExConstructor
  use Vex.Struct
  alias AuthManager.Accounts.Commands.UpdateUser
  alias AuthManager.Accounts.Projections.User
  alias AuthManager.Accounts.Validators.UniqueEmail

  validates(:uuid, uuid: true)

  validates(:email,
    presence: [message: "Email can't be empty"],
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true,
    by: &UniqueEmail.validate/2
  )

  validates(:password,
    presence: [message: "Password can't be empty"],
    length: [min: 8],
    confirmation: true
  )

  validates(:password_hash, presence: [message: "can't be empty"], string: true)

  @doc """
  Hash the password, clear the original password
  """
  def put_password_hash(
        %UpdateUser{password: password, password_confirmation: password_confirmation} =
          update_user
      ) do
    %UpdateUser{
      update_user
      | password: nil,
        password_confirmation: nil,
        password_hash: Comeonin.Bcrypt.hashpwsalt(password)
    }
  end

  @doc """
  Assign the user identity
  """
  def assign_user(%UpdateUser{} = update_user, %User{uuid: user_uuid}) do
    %UpdateUser{update_user | uuid: user_uuid}
  end

  @doc """
  Convert email address to lowercase characters
  """
  def downcase_email(%UpdateUser{email: email} = create_user) do
    %UpdateUser{create_user | email: String.downcase(email)}
  end

  @doc """
  Assign a unique identity for the user
  """
  def assign_uuid(%UpdateUser{} = create_user, uuid) do
    %UpdateUser{create_user | uuid: uuid}
  end
end
