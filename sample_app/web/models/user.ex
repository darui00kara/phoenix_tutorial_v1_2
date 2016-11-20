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
    |> set_password_digest
  end

  def set_password_digest(changeset) do
    password = get_change changeset, :password

    case password do
      nil ->
        changeset
        _ ->
        put_change changeset, :password_digest, Encryption.encrypt password
    end
  end
end
