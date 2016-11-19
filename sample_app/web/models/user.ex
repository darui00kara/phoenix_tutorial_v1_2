defmodule SampleApp.User do
  use SampleApp.Web, :model

  alias SampleApp.Helpers.Encryption

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_digest, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password, :password_digest])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
    |> unique_constraint(:name)
    |> unique_constraint(:email)
    |> validate_length(:name, min: 1)
    |> validate_length(:email, max: 50)
    |> validate_length(:password, min: 8)
    |> validate_length(:password, max: 72)
  end

  @doc """
  Using Ecto.Multi.run/3 before insert function.

  ## Examples

      Ecto.Multi.new
      |> Ecto.Multi.run(:set_password_digest, &User.set_password_digest/1)
      |> Ecto.Multi.insert(...)
  """
  def set_password_digest(changeset) do
    case Ecto.Changeset.get_change changeset, :password do
      nil ->
        {:error, changeset}
      _ ->
        password_digest = get_field(changeset, :password) |> Encryption.encrypt
        change(changeset, %{password_digest: password_digest})
        {:ok, changeset}
    end
  end
end
