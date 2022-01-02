defmodule AuthManager.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
    application: AuthManager.App,
    name: "Accounts.Projectors.User",
    consistency: :strong

  alias AuthManager.Accounts.Events.{
    UserEmailChanged,
    UserPasswordChanged,
    UserCreated
  }

  alias AuthManager.Accounts.Projections.User

  project(%UserCreated{} = registered, fn multi ->
    Ecto.Multi.insert(multi, :user, %User{
      uuid: registered.uuid,
      email: registered.email,
      password_hash: registered.password_hash
    })
  end)

  project(%UserEmailChanged{uuid: uuid, email: email}, fn multi ->
    update_user(multi, uuid, email: email)
  end)

  project(
    %UserPasswordChanged{uuid: uuid, password_hash: password_hash},
    fn multi ->
      update_user(multi, uuid, password_hash: password_hash)
    end
  )

  defp update_user(multi, uuid, changes) do
    Ecto.Multi.update_all(multi, :user, user_query(uuid), set: changes)
  end

  defp user_query(uuid) do
    from(u in User, where: u.uuid == ^uuid)
  end
end
