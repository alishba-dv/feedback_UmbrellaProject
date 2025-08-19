defmodule Data.Contexts.Login do
  import Ecto.Query, warn: false
  alias Data.Repo
  alias Data.Schema.UserDatas
  alias Bcrypt

  def login(%{"email" => email, "password" => password}) do
    query = from(u in UserDatas, where: ilike(u.email, ^email))

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      user ->
        if Bcrypt.verify_pass(password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_password}
        end
    end
  end
end
