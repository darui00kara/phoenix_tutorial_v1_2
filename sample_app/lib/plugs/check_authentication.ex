defmodule SampleApp.Plugs.CheckAuthentication do
  import Plug.Conn

  alias SampleApp.{Repo, User}

  def init(options) do
    options
  end

  def call(conn, _) do
    case user_id = get_session(conn, :user_id) do
      nil ->
        conn
      _ ->
        conn
        |> assign(:current_user, Repo.get(User, user_id))
    end
  end
end
