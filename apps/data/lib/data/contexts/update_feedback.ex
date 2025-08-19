defmodule Data.Contexts.UpdateFeedback do



  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.Users


  def update_feedback(id,data) do

   case  Data.Repo.get(Users,id) do

     nil -> {:error, "Feedback not found"}

     feedback ->
     feedback
     |>Users.changeset(data)
     |>Repo.update!()

   end


  end

end