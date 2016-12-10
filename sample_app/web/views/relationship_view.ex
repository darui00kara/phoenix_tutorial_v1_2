defmodule SampleApp.RelationshipView do
  use SampleApp.Web, :view

  alias SampleApp.User
  alias SampleApp.Helpers.{Following, ViewHelper}

  def following?(conn, %User{id: showing_user_id}) do
    current_user = ViewHelper.current_user(conn)
    Following.following?(current_user.id, showing_user_id)
  end
end
