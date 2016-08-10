defmodule DemoApp.Micropost do
  use DemoApp.Web, :model

  schema "microposts" do
    field :content, :string
    belongs_to :user, DemoApp.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
    |> validate_length(:content, max: 140)
  end
end
