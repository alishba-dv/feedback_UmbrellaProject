

defmodule Data.Contexts.SignUp do
  alias Data.Repo
  alias Data.Schema.UserDatas
  import Ecto.Query

  def signup(conn, %{"email" => email, "name" => name, "password" => password}) do
    hashed_password = Bcrypt.hash_pwd_salt(password)

    changeset =
      %UserDatas{}
      |> UserDatas.changeset(%{
        "email" => email,
        "name" => name,
        "password" => hashed_password
      })

    case Repo.insert(changeset) do

      {:ok, user} -> {:ok, user}          # Just return the user
      {:error, changeset} -> {:error, changeset}  # Return errors



    end

end

end