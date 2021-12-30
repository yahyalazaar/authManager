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
      id: user.id,
      email: user.email,
      # password_hash: user.password_hash
    }
  end

  def render("user_details.json", %{user: user, profile: profile}) do
    %{
      id: user.id,
      email: user.email,
      # password_hash: user.password_hash,
      profile: %{
        id: profile.id,
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

  def render("jwt.json", %{jwt: jwt, email: email}) do
    %{jwt: jwt, email: email}
  end

  def render("signout.json", %{}) do
    %{info: "You're successfully disconected!"}
  end
end
