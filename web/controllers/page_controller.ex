defmodule UpsilonBattle.PageController do
  use UpsilonBattle.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
