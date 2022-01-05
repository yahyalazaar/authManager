defmodule AuthManager.Accounts.Commands.CreateUser do
  defstruct uuid: "",
            email: "",
            password: "",
            password_confirmation: "",
            password_hash: ""

  use ExConstructor
  use Vex.Struct
  alias AuthManager.Accounts.Commands.CreateUser
  alias AuthManager.Accounts.Validators.UniqueEmail

  validates(:uuid, uuid: true)

  validates(:email,
    presence: [message: "Email can't be empty"],
    format: [with: ~r/\S+@\S+\.\S+/, allow_nil: true, allow_blank: true, message: "is invalid"],
    by: &UniqueEmail.validate/2
  )

  validates(:password,
    # presence: [message: "Password can't be empty"],
    # length: [min: 6],
    confirmation: true
  )

  validates(:password_hash, presence: [message: "can't be empty"])

  @doc """
  Hash the password, clear the original password
  """
  def put_password_hash(
        %CreateUser{password: password, password_confirmation: password_confirmation} =
          create_user
      ) do
    %CreateUser{
      create_user
      | password: nil,
        password_confirmation: nil,
        password_hash: Comeonin.Bcrypt.hashpwsalt(password)
    }
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
