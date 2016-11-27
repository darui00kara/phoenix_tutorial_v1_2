defmodule SampleApp.SessionController do
  use SampleApp.Web, :controller

  import SampleApp.Helpers.Signin

  alias SampleApp.User

  def new(conn, _params) do
    render conn, "signin_form.html"
  end

  def create(conn, %{"signin_params" => %{"email" => email, "password" => password}}) do
    case Repo.get_by(User, email: email) |> signin(password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User signin is success!")
        |> put_session(:user_id, user.id)
        |> redirect(to: static_page_path(conn, :home))
      :error ->
        conn
        |> put_flash(:error, "User signin is failed! email or password is incorrect.")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    redirect(conn, to: static_page_path(conn, :home))
  end
end
