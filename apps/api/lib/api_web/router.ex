defmodule ApiWeb.Router do
  use ApiWeb, :router
  use PhoenixSwagger

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ApiWeb do
    pipe_through :browser

    get "/", PageController, :home
#    get "/feedback", FeedbackController, :feedback
#    get "/feedback/create", FeedbackController, :create
#    post "/submit", SubmitController, :submit
#    get "/feedback/greeting" , FeedbackController, :greet
#    get "/feedback/delete/:id" ,FeedbackController, :delete
#    get "/feedback/edit/:id" ,FeedbackController, :edit
#    post "/feedback/update/:id" ,FeedbackController, :update
#    get  "/signup" , SignUpController, :signup
#    post "/signup" , SignUpController, :signupuser
#    get  "/login", LoginFormController, :loginform
#    post  "/login", LoginFormController, :loginuser
#    get "/about" , FeedbackController, :about
#    get "/contact",FeedbackController, :contact
#    post "/feedback" , FeedbackController, :feedback
#    post "/submitnew",FeedbackController,:submitnew
#    get "/feedbackNewForm", FeedbackController, :newfeedback
#    get "/userfeedback",FeedbackController, :userfeedback
#    get "/feedback/:id",FeedbackController, :getfeedbackbyid
#    get "/loginrequired", FeedbackController, :loginrequired
#    get "/logout", LoginFormController, :logout
#    get  "/profile", LoginFormController, :profile

  end

  # Other scopes may use custom stacks.
   scope "/api", ApiWeb do
     pipe_through :api

     get "/users",UserController, :getusers
     post "/users",UserController, :signup
     delete "/users", UserController, :delete_user
     post"/login", UserController, :login
     patch "/user", UserController, :update_profile
     post "/user/{name}", UserController, :get_user_by_name



     post "/submit", FeedbackController, :feedback_submit
    get "/feedbacks", FeedbackController, :get_feedbacks
    delete "/delete/{id}", FeedbackController, :delete_feedback
    patch "/update", FeedbackController, :update_feedback
    post "/feedback", FeedbackController, :post_feedback





   end

#----------------------- create swagger UI path
  scope "/api" do
    # This serves the Swagger UI at /swagger
    forward "/docs",
            PhoenixSwagger.Plug.SwaggerUI,
            otp_app: :api,
            swagger_file: "swagger.json",
            disable_validator: true
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
