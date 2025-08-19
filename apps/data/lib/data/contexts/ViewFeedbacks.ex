defmodule Data.Contexts.ViewFeedbacks do

  import Ecto.Query
  alias Data.Repo
 alias Data.Schema.Users


  def view_feedbacks(from \\ nil, to \\nil, email \\ nil,order \\ nil) do
    query =

        cond do
          is_nil(from) && is_nil(to) && is_nil(email)  ->
            from f in Users

          is_nil(email) ->

            from f in Users,
                 where: fragment("date(?)", f.inserted_at) >= ^from,
                 where: fragment("date(?)", f.inserted_at) <= ^to


          is_nil(from) || is_nil(to)  ->
            from f in Users,
                 where: f.email == ^email

          true ->
            from f in Users,
                 where: fragment("date(?)", f.inserted_at) >= ^from ,
                 where: fragment("date(?)", f.inserted_at) <= ^to and f.email == ^email
        end



   query=
    case order do

      "asc"  -> from f in query, order_by: [asc: f.fname]

      "desc" ->from f in query, order_by: [desc: f.fname]

      _ -> query
    end

    feedbacks = Repo.all(query)

    if feedbacks == [] do
      %{error: "No feedback found for these filters", message: "Not Found"}
    else
      %{feedbacks: feedbacks}
    end
  end



end