defmodule Data.Repo.Migrations.CreateFeedbacks do
  use Ecto.Migration

  def change do
    create table(:feedbacks) do
      add :name, :string
      add :email, :string
      add :feedback, :string
      add :file_url, :string

      timestamps(type: :utc_datetime)
    end

    @doc false
    def changeset(feedback, attrs) do
      feedback
      |> cast(attrs, [:name, :email, :feedback, :file_url])
      |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")

      |> validate_required([:name, :email, :feedback])
    end
  end
end
