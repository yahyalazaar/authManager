defmodule AuthManagerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AuthManagerWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AuthManagerWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(AuthManagerWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :secret_not_found}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Secret not found"})
  end

  # def call(conn, {:message, :sign_out}) do
  #   conn
  #   |> put_status(:ok)
  #   |> json(%{message: "Sign out successfully!"})
  # end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Email/Password not valid!"})
  end

  def call(conn, {:error, :not_admin}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Sorry! you don't have the permission to execute this request!"})
  end

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AuthManagerWeb.ValidationView)
    |> render("error.json", errors: errors)
  end
end
