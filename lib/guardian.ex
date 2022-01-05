defmodule AuthManager.Guardian do
  use Guardian, otp_app: :authManager

  def subject_for_token(user, _claims) do
    sub = to_string(user.uuid)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = AuthManager.Accounts.get_user!(id)
    {:ok,  resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
