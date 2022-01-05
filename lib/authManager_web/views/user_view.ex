defmodule AuthManagerWeb.UserView do
  use AuthManagerWeb, :view
  alias AuthManagerWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      uuid: user.uuid,
      email: user.email
      # password_hash: user.password_hash
    }
  end

  def render("user_details.json", %{user: user, profile: profile}) do
    %{
      uuid: user.uuid,
      email: user.email,
      # password_hash: user.password_hash,
      profile: %{
        uuid: profile.uuid,
        name: profile.name,
        phone: profile.phone,
        role: profile.role,
        is_admin: profile.is_admin,
        address: profile.address,
        zip: profile.zip,
        country: profile.country,
        city: profile.city
      }
    }
  end

  def render("jwt.json", %{user: user, jwt: jwt}) do
    %{user: user |> render_one(UserView, "user.json") |> Map.merge(%{token: jwt})}
  end

  def render("signout.json", %{}) do
    %{info: "You're successfully disconected!"}
  end
end
