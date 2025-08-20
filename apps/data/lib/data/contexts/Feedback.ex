defmodule Data.Contexts.Feedback do


  alias Data.Repo
  alias Data.Schema.Feedback
  import Ecto.Query

  def feedback(attrs \\%{}) do

#       feedback = %{
#         name: name,
#       email: email,
#       feedback: feedback,
#       file_url: fileurl
#               }

   changeset=Feedback.changeset(%Feedback{},attrs)

    case Repo.insert(changeset) do

      {:ok,response}->  {:ok,response}

      {:error,changeset} -> {:error,changeset}



    end

end


end