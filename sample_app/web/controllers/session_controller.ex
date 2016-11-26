defmodule SampleApp.SessionController do
  use SampleApp.Web, :controller

  def new(conn, _params) do
    render conn, "signin_form.html"
  end

  def create(conn, _params) do
    redirect(conn, to: static_page_path(conn, :home))
  end

  def delete(conn, _params) do
    redirect(conn, to: static_page_path(conn, :home))
  end
end
