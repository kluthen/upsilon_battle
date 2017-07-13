defmodule UpsilonBattle.Router do
  use UpsilonBattle.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash

  end



  scope "/", UpsilonBattle do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/battle/", BattleController, :index
    get "/battle/map", BattleController, :map
    post "/battle/new_user", BattleController, :new_player
  end

  scope "/api/", UpsilonBattle do 
    pipe_through :api # On accept le json

    get "/battle/map", BattleController, :map_refresh
    get "/battle/move", BattleController, :move
    get "/battle/position", BattleController, :position
    get "/battle/attack", BattleController, :attack
    get "/battle/pass", BattleController, :pass
  end

  # Other scopes may use custom stacks.
  # scope "/api", UpsilonBattle do
  #   pipe_through :api
  # end
end
