
defmodule Data.Contexts.UserDatas do


  import Ecto.Query
  alias Data.Repo
  alias Data.Schema.GetUsers




  def userdatas()  do

    query = from u in Data.Schema.UserDatas,
                 select: u

    Data.Repo.all(query)



  end




end