defmodule ApiWeb.FeedbackJSON do


  def submitfeedback(%{message: message}) do

    %{

    status: "Success",
    message: message

    }

  end


  def submitfeedback(%{error: errors}) do


    %{
    status: "Error",
    Error: errors
    }
  end


  def viewfeedbacks(%{feedbacks: %{feedbacks: feedbacks}}) when is_list(feedbacks) do
    %{
    status: "Success",
    message: "Fetched feedbacks successfully",
    feedbacks: Enum.map(feedbacks, fn u ->
  u
  |> Map.from_struct()
  |> Map.put(:name, u.fname <> " " <> u.lname)
  |> Map.update!(:inserted_at, &DateTime.to_date/1)
  |> Map.take([:name, :email, :feedback,:inserted_at])
end)

  }
end



  def viewfeedbacks(%{feedbacks: %{error: errors, message: message}}) do
    %{
      status: "Error",
      message: message,
      error: errors
    }
  end



  def delete_feedback(%{message: message, status: status}) do

     %{
     message: message ,
     status: status
     }
  end

  def update_feedback(%{message: message, status: status}) do

    %{

    message: message,


    }
  end
end