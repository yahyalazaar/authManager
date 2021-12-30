defmodule AuthManagerWeb.ProfileControllerTest do
  use AuthManagerWeb.ConnCase

  import AuthManager.AccountsFixtures

  alias AuthManager.Accounts.Profile

  @create_attrs %{
    address: "some address",
    is_admin: true,
    name: "some name",
    phone: "some phone",
    role: "some role",
    zip: "some zip"
  }
  @update_attrs %{
    address: "some updated address",
    is_admin: false,
    name: "some updated name",
    phone: "some updated phone",
    role: "some updated role",
    zip: "some updated zip"
  }
  @invalid_attrs %{address: nil, is_admin: nil, name: nil, phone: nil, role: nil, zip: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all profiles", %{conn: conn} do
      conn = get(conn, Routes.profile_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create profile" do
    test "renders profile when data is valid", %{conn: conn} do
      conn = post(conn, Routes.profile_path(conn, :create), profile: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.profile_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "address" => "some address",
               "is_admin" => true,
               "name" => "some name",
               "phone" => "some phone",
               "role" => "some role",
               "zip" => "some zip"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.profile_path(conn, :create), profile: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update profile" do
    setup [:create_profile]

    test "renders profile when data is valid", %{conn: conn, profile: %Profile{id: id} = profile} do
      conn = put(conn, Routes.profile_path(conn, :update, profile), profile: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.profile_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "is_admin" => false,
               "name" => "some updated name",
               "phone" => "some updated phone",
               "role" => "some updated role",
               "zip" => "some updated zip"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, profile: profile} do
      conn = put(conn, Routes.profile_path(conn, :update, profile), profile: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete profile" do
    setup [:create_profile]

    test "deletes chosen profile", %{conn: conn, profile: profile} do
      conn = delete(conn, Routes.profile_path(conn, :delete, profile))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.profile_path(conn, :show, profile))
      end
    end
  end

  defp create_profile(_) do
    profile = profile_fixture()
    %{profile: profile}
  end
end
