defmodule PhoenixTutorialV12.PageController do
  use PhoenixTutorialV12.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
