defmodule SampleApp.Micropost do
  use SampleApp.Web, :model

  schema "microposts" do
    field :content, :string
    belongs_to :user, SampleApp.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, min: 1)
    |> validate_length(:content, max: 140)
  end
end
