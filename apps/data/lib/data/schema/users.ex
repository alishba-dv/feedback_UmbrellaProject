defmodule Data.Schema.Users do


 use Ecto.Schema
 import Ecto.Changeset

 schema "users" do

   field :fname, :string
   field :lname, :string
   field :email, :string
   field :feedback, :string
   timestamps(type: :utc_datetime)


   belongs_to :userdatas, Data.Contexts.UserDatas, foreign_key: :user_id

   def changeset(user, attrs) do

     user
     |> cast(attrs, [:fname,:lname, :feedback, :email,])
     |> validate_required([:fname,:lname, :feedback, :email])
     |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")

   end

 end




end