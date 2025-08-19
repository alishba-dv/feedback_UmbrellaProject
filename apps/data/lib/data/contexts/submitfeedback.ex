defmodule Data.Contexts.SubmitFeedback do


alias Data.Schema.Users
alias Data.Repo
import Ecto.Query


  def submitfeedback(conn,%{"email"=> email,"fname"=> fname, "lname"=> lname, "feedback"=> feedback}) do

    feedback = %{
      fname: fname,
      lname: lname,
      email: email,
      feedback: feedback
    }

    changeset=Users.changeset(%Users{},feedback)

    case Repo.insert(changeset) do

      {:ok,response}->  {:ok,response}

      {:error,changeset} -> {:error,changeset}



    end


    end

end