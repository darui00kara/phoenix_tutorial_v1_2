defmodule SampleApp.Helpers.ViewHelper do
  alias SampleApp.{Repo, User}
  alias SampleApp.Helpers.Gravatar

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def current_user?(conn, %User{id: id}) do
    current_user(conn) == Repo.get(User, id)
  end

  def gravatar_for(%{email: email}) do
    Gravatar.get_gravatar_url(email, 50)
  end
end
