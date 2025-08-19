defmodule Data.Schema.UserDatas do



    use Ecto.Schema
    import Ecto.Changeset

    schema "userdatas" do

      field :email, :string
      field :password, :string
      field :name, :string

      has_many :users, Data.Users


      ## here is an association --> a feedback must belongs to a user
#      belongs_to :userdatas, Data.UserData, foreign_key: :user_id
      timestamps(type: :utc_datetime)

    end

    @doc false
    def changeset(user_data, attrs) do
      user_data
      |> cast(attrs, [:name, :password, :email,])
      |> validate_required([:name, :password, :email])
      |> unique_constraint(:email, message: "Email already taken")

      |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
      |>validate_password()


end



    defp validate_password(changeset) do
      changeset
      |> validate_length(:password, min: 8, message: "Password must be at least 8 characters long")
      |> validate_format(:password, ~r/[A-Z]/, message: "Must contain uppercase letter")
      |> validate_format(:password, ~r/[a-z]/, message: "Must contain lowercase letter")
      |> validate_format(:password, ~r/\d/, message: "Must contain a digit")
      # |> validate_format(:password, ~r/[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]/, message: "Must contain special character")
    end

    end