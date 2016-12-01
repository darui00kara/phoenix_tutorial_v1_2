defmodule SampleApp.UserController do
  use SampleApp.Web, :controller

  alias SampleApp.User

  plug SampleApp.Plugs.SignedInUser when action in [:show, :edit, :update, :index, :delete]
  plug :correct_user? when action in [:edit, :update, :delete]

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

  def index(conn, params) do
    users = from(u in User, order_by: [asc: :name])
            |> Repo.paginate(params)

    if users do
      render(conn, "index.html", users: users)
    else
      conn
      |> put_flash(:error, "Invalid page number!!")
      |> render("index.html", users: [])
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get(User, id) |> Repo.delete

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> delete_session(:user_id)
    |> redirect(to: static_page_path(conn, :home))
  end

  defp correct_user?(conn, _) do
    user = Repo.get(User, String.to_integer(conn.params["id"]))

    if current_user?(conn, user) do
      conn
    else
      conn
      |> put_flash(:info, "Please signin.")
      |> redirect(to: session_path(conn, :new))
      |> halt
    end
  end

  defp current_user?(conn, user) do
    conn.assigns[:current_user] == user
  end
end
