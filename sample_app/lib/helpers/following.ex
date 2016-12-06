defmodule SampleApp.Helpers.Following do
  import Ecto.Query, only: [from: 2]

  alias SampleApp.{Repo, Relationship}

  def follow!(signin_id, followed_id) do
    changeset = Relationship.changeset(
                  %Relationship{},
                  %{follower_id: signin_id, followed_id: followed_id})

    Repo.insert!(changeset)
  end

  def following?(signin_id, followed_id) do
    relationship = from(r in Relationship,
                     where: r.follower_id == ^signin_id and r.followed_id == ^followed_id,
                     limit: 1) |> Repo.all

    !Enum.empty?(relationship)
  end

  def unfollow!(signin_id, followed_id) do
    [relationship] = from(r in Relationship,
              where: r.follower_id == ^signin_id and r.followed_id == ^followed_id,
              limit: 1) |> Repo.all

    Repo.delete!(relationship)
  end
end
