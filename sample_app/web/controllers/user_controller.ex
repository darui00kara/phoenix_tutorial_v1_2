defmodule SampleApp.UserController do
  use SampleApp.Web, :controller

  alias SampleApp.User
  alias SampleApp.Micropost

  plug SampleApp.Plugs.SignedInUser when action
    in [:show, :edit, :update, :index, :delete, :following, :followers]
  plug :correct_user? when action in [:edit, :update, :delete]

  def show(conn, %{"id" => id} = params) do
    user  = Repo.get(User, id)
            |> Repo.preload(:relationships)
            |> Repo.preload(:reverse_relationships)
    posts = from(m in Micropost,
                   where: m.user_id == ^user.id,
                     order_by: [desc: :inserted_at])
            |> Repo.paginate(params)

    if posts do
      render(conn, "show.html", user: user, posts: posts)
    else
      conn
      |> put_flash(:error, "Invalid page number!!")
      |> render("show.html", user: user, posts: [])
    end
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

  def following(conn, %{"id" => id} = params) do
    user  = Repo.get(User, id)
            |> Repo.preload(:relationships)
            |> Repo.preload(:reverse_relationships)
    id_list = Enum.reduce(user.followed_users, [], fn(followed_user, acc) ->
                case Map.get(followed_user, :followed_id) do
                  nil -> acc
                  followed_id -> [followed_id | acc]
                end
              end) |> Enum.reverse
    users = from(u in SampleApp.User,
              where: u.id in ^id_list,
              order_by: [asc: :name])
            |> Repo.paginate(params)

    if users do
      render(conn, "following.html", user: user, users: users)
    else
      conn
      |> put_flash(:error, "Invalid page number!!")
      |> render("following.html", user: user, users: [])
    end
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
