defmodule AuthManagerWeb.ValidationView do
  use AuthManagerWeb, :view

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
