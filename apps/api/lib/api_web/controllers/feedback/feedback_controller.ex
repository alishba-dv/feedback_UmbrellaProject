defmodule ApiWeb.FeedbackController do
  use ApiWeb, :controller


  use PhoenixSwagger
  alias Data.Contexts.SubmitFeedback
 alias Data.Contexts.ViewFeedbacks
 alias Data.Contexts.DeleteFeedback
 alias Data.Contexts.UpdateFeedback

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

  swagger_path :get_feedbacks do

    get("/api/feedbacks")
    summary("View All feedbacks")
    description("All feedbacks can be viewed ")
    produces "application/json"

    parameters do
      email :query, :string, "Filter feedbacks by this email", required: false
      from :query, :string,  "Filter feedbacks from this date (YYYY-MM-DD)",required: false
      to :query, :string,  "Filter feedbacks  till this date (YYYY-MM-DD)",required: false
      order :query, :string, "Order feedbacks by ASC or DESC", required: false, enum: ["asc", "desc"]
    end

   response 200, "User feedbacks fetched successfully" , Schema.ref(:view_feedbacks)
   response 400, "Error fetching feedbacks"
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
            {:error,reason} -> {:error, reason}

            _ -> nil   # or handle invalid date properly
          end
      end

      toDate=
    case    to do
      nil -> nil
      d ->
        case Date.from_iso8601(d) do
          {:ok, to} ->to
          {:error,reason} -> {:error, reason}

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