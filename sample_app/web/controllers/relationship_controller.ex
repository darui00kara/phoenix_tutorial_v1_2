defmodule SampleApp.RelationshipController do
  use SampleApp.Web, :controller

  alias SampleApp.Helpers.Following

  plug SampleApp.Plugs.SignedInUser

  def create(conn, %{"follow_id" => follow_id}) do
    IO.inspect [signin_id: conn.assigns[:current_user].id, follow_id: follow_id]
    Following.follow!(conn.assigns[:current_user].id, follow_id)

    conn
    |> put_flash(:info, "Follow successfully!")
    |> redirect(to: user_path(conn, :show, follow_id))
  end

  def delete(conn, %{"unfollow_id" => unfollow_id}) do
    Following.unfollow!(conn.assigns[:current_user].id, unfollow_id)

    conn
    |> put_flash(:info, "Unfollow successfully!")
    |> redirect(to: user_path(conn, :show, unfollow_id))
  end
end
