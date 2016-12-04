defmodule SampleApp.MicropostController do
  use SampleApp.Web, :controller

  alias SampleApp.Micropost

  plug SampleApp.Plugs.SignedInUser

  def create(conn, %{"micropost_param" => %{"content" => content}}) do
    changeset =  Ecto.build_assoc(conn.assigns[:current_user], :microposts, content: content)

    conn = case Repo.insert(changeset) do
      {:ok, _} ->
        put_flash(conn, :info, "Post successfully.")
      {:error, _} ->
        put_flash(conn, :error, "Post Failed.")
    end

    redirect conn, to: user_path(conn, :show, conn.assigns[:current_user])
  end

  def delete(conn, %{"id" => id}) do
    Repo.get(Micropost, id) |> Repo.delete

    conn
    |> put_flash(:info, "Micropost deleted successfully.")
    |> redirect(to: user_path(conn, :show, conn.assigns[:current_user]))
  end
end
