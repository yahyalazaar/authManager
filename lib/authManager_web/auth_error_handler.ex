defmodule AuthManager.AuthErrorHandler do
  import Plug.Conn

  # def auth_error(conn, {type, _reason}, _opts) do
  #   body = Jason.encode!(%{error: to_string(type)})
  #   send_resp(conn, 401, body)
  # end
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
