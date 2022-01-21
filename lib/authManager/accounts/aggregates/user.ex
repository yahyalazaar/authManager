defmodule AuthManager.Accounts.Aggregates.User do
  defstruct [
    :uuid,
    :email,
    :password_hash
  ]

  alias AuthManager.Accounts.Aggregates.User

  alias AuthManager.Accounts.Commands.{
    CreateUser,
    UpdateUser
  }

  alias AuthManager.Accounts.Events.{
    UserEmailChanged,
    UserPasswordChanged,
    UserCreated
  }

  @doc """
  Register a new user
  """
  def execute(%User{uuid: nil}, %CreateUser{} = register) do
    %UserCreated{
      uuid: register.uuid,
      email: register.email,
      password_hash: register.password_hash
    }
  end

  @doc """
  Update a user's username, email, and password
  """
  def execute(%User{} = user, %UpdateUser{} = update) do
    Enum.reduce([&email_changed/2, &password_changed/2], [], fn change, events ->
      case change.(user, update) do
        nil -> events
        event -> [event | events]
      end
    end)
  end

  # state mutators

  def apply(%User{} = user, %UserCreated{} = registered) do
    %User{
      user
      | uuid: registered.uuid,
        email: registered.email,
        password_hash: registered.password_hash
    }
  end

  def apply(%User{} = user, %UserEmailChanged{email: email}) do
    %User{user | email: email}
  end

  def apply(%User{} = user, %UserPasswordChanged{password_hash: password_hash}) do
    %User{user | password_hash: password_hash}
  end

  # private helpers

  defp email_changed(%User{}, %UpdateUser{email: ""}), do: nil
  defp email_changed(%User{email: email}, %UpdateUser{email: email}), do: nil

  defp email_changed(%User{uuid: uuid}, %UpdateUser{email: email}) do
    %UserEmailChanged{
      uuid: uuid,
      email: email
    }
  end

  defp password_changed(%User{}, %UpdateUser{password_hash: ""}), do: nil

  defp password_changed(%User{password_hash: password_hash}, %UpdateUser{
         password_hash: password_hash
       }),
       do: nil

  defp password_changed(%User{uuid: uuid}, %UpdateUser{password_hash: password_hash}) do
    %UserPasswordChanged{
      uuid: uuid,
      password_hash: password_hash
    }
  end
end
