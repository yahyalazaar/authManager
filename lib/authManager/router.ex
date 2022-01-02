defmodule AuthManager.Router do
  use Commanded.Commands.Router

  alias AuthManager.Accounts.Aggregates.{User, Profile}
  alias AuthManager.Accounts.Commands.{CreateUser, UpdateUser, CreateProfile, UpdateProfile}

  identify(User, by: :uuid, prefix: "user-")
  identify(Profile, by: :uuid, prefix: "profile-")
  dispatch(
    [
      CreateUser,
      UpdateUser
    ],
    to: User
  )

  dispatch(
    [
      CreateProfile,
      UpdateProfile
    ],
    to: Profile
  )
end
