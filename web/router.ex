defmodule PhxFormRelay.Router do
  use PhxFormRelay.Web, :router

  pipeline :authenticate do
    plug PhxFormRelay.Plugs.Authenticate
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :remote_post do 
    plug :accepts, ["html"]
  end

  scope "/", PhxFormRelay do
    pipe_through :browser

    get "/", SessionController, :index
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
  end

  scope "/forms", PhxFormRelay do 
    pipe_through [:browser, :authenticate]

    resources "/", FormController do 
      resources "emails", EmailController
    end
  end

  scope "/users", PhxFormRelay do 
    pipe_through [:browser, :authenticate]
    
    resources "/", UserController
  end

  scope "/send", PhxFormRelay do
    pipe_through :remote_post
    post "/:phx_form_id", SendController, :send
    get "/:phx_form_id", SendController, :send
  end

end
