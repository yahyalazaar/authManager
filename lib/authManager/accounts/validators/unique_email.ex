defmodule AuthManager.Accounts.Validators.UniqueEmail do
  use Vex.Validator

  alias AuthManager.Accounts
  alias AuthManager.Accounts.Projections.User

  def validate(value, context) do
    user_uuid = Map.get(context, :uuid)

    case email_registered?(value, user_uuid) do
      true -> {:error, "Email has already been taken"}
      false -> :ok
    end
  end

  defp email_registered?(email, user_uuid) do
    case Accounts.get_by_email(email) do
      %User{uuid: ^user_uuid} -> false
      nil -> false
      _ -> true
    end
  end
end
