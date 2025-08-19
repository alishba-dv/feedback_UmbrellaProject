

defmodule Data.Contexts.DeleteUser do
  alias Data.Repo
  alias Data.Schema.UserDatas
  import Ecto.Query


  alias Data.Repo
  alias Data.Schema.UserDatas
  import Ecto.Query

  def delete_user(id) do
    query = from(u in UserDatas, where: u.id == ^id)

    case Repo.delete_all(query) do
      {0, _} ->
        {:error, :not_found}   # No row was deleted

      {1, _} ->
        {:ok, :deleted}        # One row deleted successfully

      _ ->
        {:error, :failed}      # Something unexpected happened
    end
  end

end
