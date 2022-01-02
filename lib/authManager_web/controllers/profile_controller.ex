defmodule AuthManagerWeb.ProfileController do
  use AuthManagerWeb, :controller

  alias AuthManager.Accounts
  alias AuthManager.Accounts.Projections.Profile

  action_fallback(AuthManagerWeb.FallbackController)

  def index(conn, _params) do
    profiles = Accounts.list_profiles()
    render(conn, "index.json", profiles: profiles)
  end

  def create(conn, %{"profile" => profile_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    with {:ok, %Profile{} = profile} <- Accounts.create_profile(current_user, profile_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.profile_path(conn, :show, profile))
      |> render("show.json", profile: profile)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    profile = Accounts.get_profile!(uuid)
    render(conn, "show.json", profile: profile)
  end

  def update(conn, %{"uuid" => uuid, "profile" => profile_params}) do
    profile = Accounts.get_profile!(uuid)

    with {:ok, %Profile{} = profile} <- Accounts.update_profile(profile, profile_params) do
      render(conn, "show.json", profile: profile)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    profile = Accounts.get_profile!(uuid)

    with {:ok, %Profile{}} <- Accounts.delete_profile(profile) do
      send_resp(conn, :no_content, "")
    end
  end
end
