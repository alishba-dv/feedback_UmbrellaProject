defmodule Data.Contexts.DeleteFeedback do

  import Ecto.Query
  alias Data.Repo
  alias Data.Schema.Users


  def delete_feedback(id) do

    query=from(f in Users, where: f.id == ^id)
   case Repo.delete_all(query) do

     {0,_}-> {:error,:not_found}

     {1,_}->{:ok,:deleted}

    _ ->{:error,:failed}

   end

  end

end