defmodule Data.Schema.Feedback do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feedbacks" do
    field :email, :string
    field :feedback, :string
    field :file_url, :string
    field :name, :string

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

