defmodule AuthManagerWeb.UserController do
  use AuthManagerWeb, :controller

  alias AuthManager.Accounts
  alias AuthManager.Accounts.User
  alias AuthManager.Guardian

  action_fallback(AuthManagerWeb.FallbackController)

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    profile = Accounts.get_profile_by_user(user.id)

    case profile.is_admin do
      true ->
        users = Accounts.list_users()
        render(conn, "index.json", users: users)

      false ->
        {:error, :not_admin}
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, token_type: :access) do
      conn
      |> put_status(:ok)
      |> render("jwt.json", %{jwt: token, email: user.email})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", %{jwt: token, email: email})

      _ ->
        {:error, :unauthorized}
    end
  end

  def sign_out(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> configure_session(drop: true)
    |> render("signout.json", %{})
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def my_user(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    profile = Accounts.get_profile_by_user(user.id)
    conn |> render("user_details.json", user: user, profile: profile)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
