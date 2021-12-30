defmodule AuthManager.AccountsTest do
  use AuthManager.DataCase

  alias AuthManager.Accounts

  describe "users" do
    alias AuthManager.Accounts.User

    import AuthManager.AccountsFixtures

    @invalid_attrs %{email: nil, password_hash: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", password_hash: "some password_hash"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.password_hash == "some password_hash"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", password_hash: "some updated password_hash"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.password_hash == "some updated password_hash"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "profiles" do
    alias AuthManager.Accounts.Profile

    import AuthManager.AccountsFixtures

    @invalid_attrs %{address: nil, is_admin: nil, name: nil, phone: nil, role: nil, zip: nil}

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Accounts.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Accounts.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{address: "some address", is_admin: true, name: "some name", phone: "some phone", role: "some role", zip: "some zip"}

      assert {:ok, %Profile{} = profile} = Accounts.create_profile(valid_attrs)
      assert profile.address == "some address"
      assert profile.is_admin == true
      assert profile.name == "some name"
      assert profile.phone == "some phone"
      assert profile.role == "some role"
      assert profile.zip == "some zip"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{address: "some updated address", is_admin: false, name: "some updated name", phone: "some updated phone", role: "some updated role", zip: "some updated zip"}

      assert {:ok, %Profile{} = profile} = Accounts.update_profile(profile, update_attrs)
      assert profile.address == "some updated address"
      assert profile.is_admin == false
      assert profile.name == "some updated name"
      assert profile.phone == "some updated phone"
      assert profile.role == "some updated role"
      assert profile.zip == "some updated zip"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_profile(profile, @invalid_attrs)
      assert profile == Accounts.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Accounts.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Accounts.change_profile(profile)
    end
  end
end
