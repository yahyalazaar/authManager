defmodule AuthManager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AuthManager.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password_hash: "some password_hash"
      })
      |> AuthManager.Accounts.create_user()

    user
  end

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        address: "some address",
        is_admin: true,
        name: "some name",
        phone: "some phone",
        role: "some role",
        zip: "some zip"
      })
      |> AuthManager.Accounts.create_profile()

    profile
  end
end
