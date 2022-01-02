defmodule AuthManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias AuthManager.Repo
  alias AuthManager.App

  alias AuthManager.Accounts.Projections.{User, Profile}
  alias AuthManager.Accounts.Commands.{CreateUser, UpdateUser, CreateProfile, UpdateProfile}
  alias AuthManager.Accounts.Queries.UserByEmail
  alias AuthManager.Guardian
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        {Guardian.encode_and_sign(user, token_type: :access), user}

      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
         do: verify_password(password, user)
  end

  def get_by_email(email) when is_binary(email) do
    get_by_email =
      email
      |> String.downcase()
      |> UserByEmail.new()
      |> Repo.one!()

    case get_by_email do
      nil ->
        dummy_checkpw()
        {:error, "Login error."}

      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(uuid), do: Repo.get!(User, uuid)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    # %User{}
    # |> User.changeset(attrs)
    # |> Repo.insert()
    uuid = UUID.uuid4()

    create_user =
      attrs
      |> CreateUser.new()
      |> CreateUser.assign_uuid(uuid)
      |> CreateUser.downcase_email()
      |> CreateUser.put_password_hash()

    # |> CreateUser.validate_input(attrs)

    with :ok <- App.dispatch(create_user, consistency: :strong) do
      get(User, uuid)
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{uuid: uuid} = user, attrs) do
    # user
    # |> User.changeset(attrs)
    # |> Repo.update()
    update_user =
      attrs
      |> UpdateUser.new()
      |> UpdateUser.assign_user(user)
      |> UpdateUser.downcase_email()

    # |> UpdateUser.validate_input(attrs)

    with :ok <- App.dispatch(update_user, consistency: :strong) do
      get(User, uuid)
    end
  end

  defp get(schema, uuid) do
    case Repo.get!(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """

  # def change_user(%User{} = user, attrs \\ %{}) do
  #   User.changeset(user, attrs)
  # end

  alias AuthManager.Accounts.Projections.Profile

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(uuid), do: Repo.get!(Profile, uuid)

  def get_profile_by_user(user_uuid) do
    Repo.get_by(Profile, user_uuid: user_uuid)
  end

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(%User{} = user, attrs \\ %{}) do
    # %Profile{}
    # |> Profile.changeset(attrs)
    # |> Repo.insert()
    uuid = UUID.uuid4()

    create_profile =
      attrs
      |> CreateProfile.new()
      |> CreateProfile.assign_uuid(uuid)
      |> CreateProfile.assign_user(user)

    # |> CreateProfile.validate_input(attrs)

    with :ok <- App.dispatch(create_profile, consistency: :strong) do
      get(Profile, uuid)
    end
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{uuid: uuid} = profile, attrs) do
    update_profile =
      attrs
      |> UpdateProfile.new()
      |> UpdateProfile.assign_profile(profile)

    # |> UpdateProfile.validate_input(attrs)

    with :ok <- App.dispatch(update_profile, consistency: :strong) do
      get(Profile, uuid)
    end
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{data: %Profile{}}

  """
  # def change_profile(%Profile{} = profile, attrs \\ %{}) do
  #   Profile.changeset(profile, attrs)
  # end
end
