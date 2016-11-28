defmodule SampleApp.UserController do
  use SampleApp.Web, :controller

  alias SampleApp.User

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> put_session(:user_id, user.id)
        |> redirect(to: static_page_path(conn, :home))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user)
    render conn, "edit.html", user: user, changeset: changeset
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user.id))
      {:error, failed_changeset} ->
        render(conn, "edit.html", user: user, changeset: failed_changeset)
    end
  end
end
