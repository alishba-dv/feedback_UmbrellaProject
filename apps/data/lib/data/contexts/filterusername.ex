defmodule Data.Contexts.FilterUserName do


  alias Data.Repo
  alias Data.Schema.UserDatas
  import Ecto.Query



  def filterusername(name) do

    query = from( u in UserDatas, where: u.name == ^name)
    case Repo.all(query) do

      nil-> {:error,"Not Found" }
      user -> {:ok,user}





    end
  end
end