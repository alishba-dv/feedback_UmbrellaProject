defmodule ApiWeb.FeedbackController do
  use ApiWeb, :controller


  use PhoenixSwagger
  alias Data.Contexts.SubmitFeedback
 alias Data.Contexts.ViewFeedbacks
 alias Data.Contexts.DeleteFeedback
 alias Data.Contexts.UpdateFeedback
 alias Data.Contexts.Feedback

  swagger_path :feedback_submit do
    post("/api/submit")
#hi this is new commmit
    summary "Submit Feedback"
    description "A user can submit feedback"
    produces "application/json"
    consumes "application/json"

    parameters do
      feedback :body, Schema.ref(:feedbackSubmit), "User feedback for submission", required: true
    end

    response 200, "User feedback submitted successfully", Schema.ref(:feedbackSubmit)
    response 400, "Error submitting feedback"
    response 500, "Internal Server Error"
  end


  swagger_path :post_feedback do

    post ("/api/feedback")
    summary("Submit a feedback along with a file url for upload")
    description("User can submit a feedback along with  a file ")
    produces "application/json"
    consumes "multipart/form-data"

    parameters do
      name :formData, :string, "Name", required: true
    email :formData, :string, "Email", required: true
    feedback :formData, :string, "Feedback", required: true
    file_url :formData, :file, "File to upload", required: false
      end



      response 200, "user Feedback Sbmitted successfully", Schema.ref(:filefeedbacksubmit)
      response 400, "Error submitting feedback"
      response 500, "Internal Server Error
"
    end

  swagger_path :post_feedback do
    post "/api/feedback"
    summary "Submit feedback along with a file"
    description "User can submit feedback and optionally upload a file"
    produces "application/json"
    consumes "multipart/form-data"

    parameters do
      name :formData, :string, "Name", required: true
      email :formData, :string, "Email", required: true
      feedback :formData, :string, "Feedback", required: true
      file_url :formData, :file, "File to upload", required: true
    end

    response 200, "Feedback submitted successfully", Schema.ref(:filefeedbacksubmit)
    response 400, "Validation error"
    response 500, "Internal server error"
  end

  swagger_path :delete_feedback do

      delete("/api/delete/{id}")
      summary("Deletes a feedback ")
      description("Deletes a feedback with given id")
      produces "application/json"
      consumes "application/json"

      parameters do

        id :body, Schema.ref(:delete_feedback), "Feedback deleted successfully", required: true
      end

      response 200, " Feedback Deleted successfully", Schema.ref(:delete_feedback)
      response 400, "Error deleting feedback"
      response 500, "Internal Server error"


    end

   swagger_path :update_feedback do

      patch("/api/update/")
      summary("Updates a feedback")
      description("Update a feedback by given id")
      produces "application/json"
      consumes "application/json"

      parameters do

       data :body, Schema.ref(:update_feedback), "Feedback Updated Successfully", required: true

      end

      response 200, "Feedback updated successfully", Schema.ref(:update_feedback)
      response 400, "Error updating feedback"
      response 500, "Internal server error"

end
  # ==================================swagger definitions

  def swagger_definitions do
    %{
      feedbackSubmit: swagger_schema do
        title("Feedback Submission")
        description("Schema of feedback submission by user")

        properties do
          fname :string, "fname", required: true
          lname :string, "lname", required: true
          email :string, "email", required: true, format: :email
          feedback :string, "feedback", required: true
        end

        example %{
          fname: "tester",
          lname: "tester",
          email: "tester@gmail.com",
          feedback: "This is the feedback"
        }
      end,
filefeedbacksubmit: swagger_schema do
  title("Feedback Submission")
  description("Schema of feedback submission by user along with a file upload")

  properties do
    name :string, "Name", required: true
    email :string, "Email", required: true
    feedback :string, "Feedback", required: true
    file_url :file, "The file to upload", required: true
  end

  example %{
    name: "Tester",
    email: "tester@gmail.com",
    feedback: "This is the feedback",
    file_url: "final-image.jpg"  # example file name
  }
end,



     view_feedbacks: swagger_schema do


        title(" View All Feedback OR filter on basis of date ")
        description("Schema for viewing feedbacks")

        properties do


          name  :string, " Name", required: true
          email :string, "email", required: true
          feedback :string, "feedback", required: true
          from :string, "from" , required: false
          to :string, "to", required: false


        end

        example %{
        name: "Tester 1",
        email: "tester@gmail.com",
        feedback: "This is the feedback",
        inserted_at: "2025-08-07"
        }


       end,


      delete_feedback: swagger_schema do

        title("Delete a feedback")
        description("Schema for deleting a feedback by id")
        properties do
          id :string, "Id", required: true
        end

        example %{
        id: "02"
        }

      end,

    update_feedback: swagger_schema do

      title("Updates a feedback ")
      description("Schema for updating a feedback")
      properties do
          id :string, "Id", required: true
          fname  :string, "First Name", required: true
          lname  :string, "Last Name", required: true
          email :string, "email", required: true
          feedback :string, "feedback", required: true

        end

        example %{

        id: "12",
        fname: "Tester",
        lname: "1",
        email: "tester@gmail.com",
        feedback: "This is the feedback"


        }


        end

}
  end

#  ============================================================================================

  def feedback_submit(conn, params) do
    case SubmitFeedback.submitfeedback(conn, params) do
      {:ok, _response} ->
        conn
        |> put_status(:ok)
        |> render(:submitfeedback, %{
          status: "success",
          message: "Feedback Submitted Successfully"
        })

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        conn
        |> put_status(400)
        |> render(:submitfeedback, %{
          status: "error",
          message: "Error submitting feedback",
          error: errors
        })
    end
  end


  def post_feedback(conn, params) do

#    extract path of file

    upload=params["file_url"]
    IO.puts("This is file URL from params: ")
    IO.inspect(upload)

#    apply a case on path if exist or not
    file_url =
      case upload do
        %Plug.Upload{filename: filename, path: tmp_path} ->
          dest = Path.join(["priv/static/uploads", filename])
          File.mkdir_p!("priv/static/uploads") # ensure folder exists
          File.cp!(tmp_path, dest)
          "/uploads/#{filename}"

        _ -> nil
      end




attrs=
params
 |>Map.drop(["file_url"])
 |>Map.put("file_url", file_url )

IO.puts("this is file url: ")
IO.inspect(file_url)

IO.puts("This is attrs: ")
IO.inspect(attrs)

    case Feedback.feedback( attrs) do
      {:ok, feedback} ->
        json(conn, "Inserted successfully")

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        conn
        |> put_status(400)
        |> json(errors)
    end
  end


  def get_feedbacks(conn, params) do
    from = params["from"]
    to = params["to"]

    email = params["email"]
    order=params["order"]

    fromDate =
      case from  do
        nil -> nil
        d ->
          case Date.from_iso8601(d) do
            {:ok, from} -> from
            {:error,reason} -> conn|>put_status(400)|>json("Date format is invalid")

            _ -> nil   # or handle invalid date properly
          end
      end

      toDate=
    case    to do
      nil -> nil
      d ->
        case Date.from_iso8601(d) do
          {:ok, to} ->to
          {:error,reason} -> {:error, "Date format is invalid"}

          _ -> nil   # or handle invalid date properly
        end
    end
    feedbacks = ViewFeedbacks.view_feedbacks(fromDate,toDate, email,order)

    case feedbacks do
      [] ->
        conn
        |> put_status(404)
        |> render(:viewfeedbacks, %{
          status: "Error",
          message: "No feedbacks found for given filters",
          error: []
        })

      _ ->
        conn
        |> render(:viewfeedbacks, %{feedbacks: feedbacks})
    end
end



def delete_feedback(conn,%{"id"=>id}) do


  case DeleteFeedback.delete_feedback(id) do

    {:ok,:deleted} ->

    conn
    |>put_status(200)
    |>render(:delete_feedback,
    %{status: "ok",
      message: "Feedback Deleted Successfully",
          })


    {:error,:not_found} ->
    conn
    |>put_status(400)
    |>render(:delete_feedback,
    %{
     status: "Error",
    message: "Record not found"

})

    {:error, :failed} ->

    conn
    |> put_status(500)
    |>render(:delete_feedback,
    %{status: "Error",
      message: "Internal Server Error"
    })

  end


end




def update_feedback(conn,params) do

  id = params["id"]
  fname=params["fname"]
  lname=params["lname"]
  email=params["email"]
  feedback = params["feedback"]

  data=%{
  fname: fname,
  lname: lname,
  email: email,
  feedback: feedback
  }

 case UpdateFeedback.update_feedback(id,data) do

    {:error,"Feedback not found"} ->

    conn
    |> put_status(400)
    |> render(:update_feedback, %{status: "Error", message: "Feedback with #{id} not found"})

    feedback ->
    conn
    |> put_status(200)
    |> render(:update_feedback, %{status: "Success", message: "feedback with #{id} updated successfully"})



    _ ->

    conn
    |>put_status(500)
    |> render(:update_feedbackk, %{status: "Error", message: "Internal server error"})

 end


end



end