defmodule ApiWeb.UserController do
  use ApiWeb, :controller
  use PhoenixSwagger

  alias Data.Contexts.UserDatas
  alias Data.Contexts.SignUp
  alias Data.Contexts.DeleteUser
  alias Data.Contexts.Login
  alias Data.Contexts.UpdateProfile
  alias Data.Contexts.FilterUserName

  # ===================================
  # Swagger Paths
  # ===================================
  swagger_path :login do
    post("/api/login")

    summary("Logs in a user")
    description("Logs in a user in the database")
#    consumes "application/json"
    produces "application/json"

    parameters do
      user :body, Schema.ref(:login), "User login credentials", required: true
    end

    response 200, "User logged in successfully", Schema.ref(:login_response)
    response 400, "Bad Request"
    response 401, "Invalid credentials"
  end

  swagger_path :getusers do
    get("/api/users")
    summary("List all users")
    description("Fetches all users from the database")
    produces "application/json"
    response 200, "Success", Schema.ref(:user)
    response 400, "Bad Request"
  end

  swagger_path :signup do
    post("/api/users")
    summary("Add a new user")
    description("Adds a new user in the database")
    consumes "application/json"
    produces "application/json"

    parameters do
      user :body, Schema.ref(:create_user), "User details", required: true
    end

    response 201, "Created", Schema.ref(:create_user)
    response 400, "Bad Request"
  end


  swagger_path :delete_user do
    delete("/api/users/{id}")
    summary("Delete a user")
    description("Deletes a user by ID")
    produces "application/json"

#    parameters do
#      id :path, :integer, "User ID", required: true
#    end

    response 200, "User deleted", Schema.ref(:delete_user)
    response 404, "User not found"
  end


 swagger_path :update_profile do
   patch("/api/user")
   summary("Updates a user")
   description("A user can update his/her profile")
   consumes "application/json"
   produces "application/json"

   parameters do

   user :body, Schema.ref(:update_profile), "User details", required: true

     end


   response 200, "User profile updated successfully", Schema.ref(:update_profile)
   response 400, "User not found"
   response 500, "Internal Server Error"

   end

   swagger_path :get_user_by_name do
     post("/api/user/{name}")
     summary("Filter by user name")
     description("Filter users by name")
     consumes "application/json"
     produces "application/json"

     parameters do
       user :body, Schema.ref(:getUserByName), "Filter user by name", required: true
       end

       response 200, "Filter user by name", Schema.ref(:getUserByName)
       response 400, "Error filtering user"
       response 500, "Internal Server Error"

   end

  # ===================================
  # Swagger Definitions (Combined)
  # ===================================

  def swagger_definitions do
    %{
      user: swagger_schema do
        title "User"
        description "A user record"
        properties do
          id :integer, "ID", required: true
          email :string, "Email"
          name :string, "First name"
        end
        example %{
          id: 1,
          email: "john@example.com",
          name: "John Doe"
        }
      end,

      create_user: swagger_schema do
        title "Create User"
        description "Schema for creating a new user"
        properties do
          email :string, "Email", required: true
          name :string, "First name", required: true
          password :string, "Password", required: true
        end
        example %{
          email: "new@example.com",
          name: "New User",
          password: "newpassword123@"
        }

end,
      delete_user: swagger_schema do
      title "Delete User"
      description "A user"
      properties do
        id :integer, "id", required: true

      end
      example %{
        id: 3,

      }
    end,


      login: swagger_schema do
        title "Log in user"
        description "Schema to log in  a new user"
        properties do
          email :string, "Email", required: true
          password :string, "Password", required: true
        end
        example %{
          email: "new@example.com",
          password: "newpassword123@"
        }

      end,


      login_response: swagger_schema do
        title "Login Response"
        properties do
          user :map, "User info"
        end
      end,

    update_profile: swagger_schema do
      title "Update Profile"
      properties do

     id :integer, "Id", required: true
     name :string, " Name", required: true
     email :string, "Email", required: true


      end

      example %{
      id: "12",
      name: "tester",
      email: "tester@gmail.com",
      password: "Tester123@"
      }

      end,



      getUserByName: swagger_schema do

        title "Filter user by name"
        properties do

          name :string, "Name", required: true

        end
        example %{
        Name: "Tester"
        }

      end

}

end



  # ===================================
  # Controller Actions
  # ===================================



  def getusers(conn, _params) do
    users = UserDatas.userdatas()  #

    conn
    |> put_status(:ok)
    |> render(:getusers,

         %{
      status: "success",
      data: users

    })
  end





  def signup(conn, params) do
    case Data.Context.SignUp.signup(conn,params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(:signup,%{
          status: "success",
          user: %{
            email: user.email,
            name: user.name,
            password: "[FILTERED]"
          }
        })

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        conn
        |> put_status(:bad_request)
        |> render(:signup,%{status: "error", errors: errors})  # ✅ Only a map here
    end
  end


  def delete_user(conn, %{"id" => id}) do
    case Data.Context.DeleteUser.delete_user(id) do
      {:ok, :deleted} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "User deleted successfully"})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      {:error, :failed} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to delete user"})
    end
  end



  def login(conn,params) do

    case Data.Contexts.Login.login(params) do

      {:ok,user} ->

        conn
        |> put_status(:ok)
        |> render(:login,%{message: "User found successfully"})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:login,%{error: "User not found"})

      {:error, :failed} ->
        conn
        |> put_status(:internal_server_error)
        |> render(:login,%{error: "Something happened"})
    end


      end


      def update_profile(conn,params) do

        id=params["id"]
        name=params["name"]
        email=params["email"]
        password=params["password"]


        data=%{
        name: name,
        email: email,
        password: password
        }

      case  UpdateProfile.update_profile(id,data) do

          {:error,:not_found} ->
          conn
          |> put_status(400)
          |> render(:update_profile,
          %{
          status: "Error",
          message: "User not found with #{id}"
          })

          user ->
          conn
          |> put_status(200)
          |>render(:update_profile,
          %{status: "OK",
          message: "User with #{id} updated successfully"})


        end





      end


      def  get_user_by_name(conn,params) do

        name=params["Name"]
        case FilterUserName.filterusername(name) do


          {:error,"Not Found"} ->
          conn
          |> put_status(400)
          |>render(:filterusername,

          %{ status: 400,
            message: "No user found with #{name}"
          })


         {:ok,user} ->
            conn
            |>put_status(200)
            |>render(:filterusername,
            %{status: 200,
            message: "User filtered successfully",
            user: user})


          _ -> json(conn,"Internal Server Error")

        end


        end

  end








