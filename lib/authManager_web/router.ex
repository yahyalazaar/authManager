defmodule AuthManagerWeb.Router do
  use AuthManagerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :jwt_authenticated do
    plug(AuthManager.Guardian.AuthPipeline)
    plug(:fetch_session)
    plug(:fetch_flash)
  end

  scope "/api/v1", AuthManagerWeb do
    pipe_through(:api)
    #Create account & session
    post("/signup", UserController, :create)
    post("/signin", UserController, :sign_in)
  end

  scope "/api/v1", AuthManagerWeb do
    pipe_through([:api, :jwt_authenticated])

    #User route
    get("/users", UserController, :index)
    get("/me", UserController, :my_user)
    get("/users/:uuid", UserController, :show)
    patch("/users/:uuid", UserController, :update)
    put("/users/:uuid", UserController, :update)
    #Close session
    post("/signout", UserController, :sign_out)
    #Profile route
    get("/profiles", ProfileController, :index)
    get("/profiles/:uuid", ProfileController, :show)
    patch("/profiles/:uuid", ProfileController, :update)
    put("/profiles/:uuid", ProfileController, :update)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: AuthManagerWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
