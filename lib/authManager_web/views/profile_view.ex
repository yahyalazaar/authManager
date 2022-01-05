defmodule AuthManagerWeb.ProfileView do
  use AuthManagerWeb, :view
  alias AuthManagerWeb.ProfileView

  def render("index.json", %{profiles: profiles}) do
    render_many(profiles, ProfileView, "profile.json")
  end

  def render("show.json", %{profile: profile}) do
    render_one(profile, ProfileView, "profile.json")
  end

  def render("profile.json", %{profile: profile}) do
    %{
      uuid: profile.uuid,
      user_uuid: profile.user_uuid,
      name: profile.name,
      phone: profile.phone,
      role: profile.role,
      is_admin: profile.is_admin,
      address: profile.address,
      zip: profile.zip,
      country: profile.country,
	    city: profile.city
    }
  end
end
