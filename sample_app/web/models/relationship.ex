defmodule SampleApp.Relationship do
  use SampleApp.Web, :model

  schema "relationships" do
    belongs_to :followed_user, SampleApp.User, foreign_key: :follower_id
    belongs_to :follower, SampleApp.User, foreign_key: :followed_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:follower_id, :followed_id])
    |> validate_required([:follower_id, :followed_id])
  end
end
