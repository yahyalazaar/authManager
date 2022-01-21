defmodule AuthManagerWeb.UserController do
  use AuthManagerWeb, :controller

  alias AuthManager.Accounts
  alias AuthManager.Accounts.Projections.User
  alias AuthManager.Guardian

  action_fallback(AuthManagerWeb.FallbackController)

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    profile = Accounts.get_profile_by_user(user.uuid)

    case profile.is_admin do
      true ->
        users = Accounts.list_users()
        render(conn, "index.json", users: users)

      false ->
        {:error, :not_admin}
    end
  end

  def create(conn, %{"user" => user_params}) do
    # user_params = Map.put(user_params, "uuid", UUID.uuid4())
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, token_type: :access) do
      conn
      |> put_status(:ok)
      |> render("jwt.json", user: user, jwt: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.sign_in(email, password),
         {:ok, jwt} <- Accounts.generate_jwt(user) do
      conn |> render("jwt.json", user: user, jwt: jwt)
    else
      {:error, :unauthorized} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AuthManagerWeb.ValidationView)
        |> render("error.json",
          errors: %{"email or password" => ["is invalid"]}
        )
    end
  end

  def sign_out(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> configure_session(drop: true)
    |> render("signout.json", %{})
  end

  def show(conn, %{"uuid" => uuid}) do
    user = Accounts.get_user!(uuid)
    render(conn, "show.json", user: user)
  end

  def user_details(conn, %{"uuid" => uuid}) do
    user = Accounts.get_user!(uuid)
    profile = Accounts.get_profile_by_user(user.uuid)
    conn |> render("user_details.json", user: user, profile: profile)
  end

  def my_user(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    profile = Accounts.get_profile_by_user(user.uuid)
    conn |> render("user_details.json", user: user, profile: profile)
  end

  def update(conn, %{"uuid" => uuid, "user" => user_params}) do
    user = Accounts.get_user!(uuid)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    user = Accounts.get_user!(uuid)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
