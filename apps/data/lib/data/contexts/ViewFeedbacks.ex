defmodule Data.Contexts.ViewFeedbacks do

  import Ecto.Query
  alias Data.Repo
 alias Data.Schema.Users


  def view_feedbacks(fromDate \\ nil, toDate \\nil, email \\ nil,order \\ nil) do

    filter=
        dynamic([u],true)

     filter= if fromDate, do: dynamic([u], ^filter and fragment("date(?)",u.inserted_at)>=^fromDate), else: filter

    filter= if toDate, do:  dynamic([u], ^filter and  fragment("date(?)",u.inserted_at)<=^toDate), else: filter
     filter= if email, do: dynamic([u], ^filter and  u.email == ^email), else: filter

    query= from u in Users, where: ^filter
    query=
    case order do
      "asc" ->from u in query, order_by: [asc: u.fname]
      "desc" ->from u in query, order_by: [desc: u.fname]
       _ -> query
    end
    feedbacks=Repo.all(query)


    if feedbacks == [] do
          %{error: "No feedback found for these filters", message: "Not Found"}
        else
          %{feedbacks: feedbacks}
        end


#    query =
#
#        cond do
#          is_nil(from) && is_nil(to) && is_nil(email)  ->
#            from f in Users
#
#          is_nil(email) ->
#
#            from f in Users,
#                 where: fragment("date(?)", f.inserted_at) >= ^from,
#                 where: fragment("date(?)", f.inserted_at) <= ^to
#
#
#          is_nil(from) || is_nil(to)  ->
#            from f in Users,
#                 where: f.email == ^email
#
#          true ->
#            from f in Users,
#                 where: fragment("date(?)", f.inserted_at) >= ^from ,
#                 where: fragment("date(?)", f.inserted_at) <= ^to and f.email == ^email
#        end



#   query=
#    case order do
#
#      "asc"  -> from f in query, order_by: [asc: f.fname]
#
#      "desc" ->from f in query, order_by: [desc: f.fname]
#
#      _ -> query
#    end
#
#    feedbacks = Repo.all(query)
#
#    if feedbacks == [] do
#      %{error: "No feedback found for these filters", message: "Not Found"}
#    else
#      %{feedbacks: feedbacks}
#    end
  end



end