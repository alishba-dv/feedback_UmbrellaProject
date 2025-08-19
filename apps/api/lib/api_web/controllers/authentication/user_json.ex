defmodule ApiWeb.UserJSON do

  def getusers (%{data: user}) do


    %{user: Enum.map(user, fn u ->
      %{
        id: u.id,
        email: u.email,
        name: u.name
      }
    end)}
  end

  def signup(%{user: user}) do
    %{
      status: "success",
      user: %{
        email: user.email,
        name: user.name,
        password: "[FILTERED]"
      }
    }
  end

  # For errors
  def signup(%{errors: errors}) do
    %{
      status: "error",
      errors: errors
    }
  end


  def delete(%{user: user}) do
    %{
      status: "success",
      user: %{
        email: user.email,
        name: user.name,
        password: "[FILTERED]"
      }
    }
  end

  # For errors
  def delete(%{errors: errors}) do
    %{
      status: "error",
      errors: errors
    }
  end


  def login(%{message: message}) do

    %{
       status: "success",
        message: message
    }


    end


    def login(%{error: error}) do


      %{status: "error",
        message: error
      }
    end


#    def update_profile(%{message:  message, status: status}) do
#
#      %{message: message,
#      status: status
#      }
#
#    end


  def filterusername(%{message: message, status: status, user: users}) do
    users =
      case users do
        users when is_list(users) ->
          Enum.map(users, fn u ->
            u
            |> Map.from_struct()
            |> Map.take([:name, :email])
          end)

        u when is_map(u) ->
          [u |> Map.from_struct() |> Map.take([:name, :email])]

        _ ->
          []
      end
      final_message=
      if users ==[] do

        "No users found"

      else message end

    %{
      message: final_message,
      status: status,
      users: users
    }
  end



end