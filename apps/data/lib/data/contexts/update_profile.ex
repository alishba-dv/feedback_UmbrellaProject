defmodule Data.Contexts.UpdateProfile do

  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.UserDatas


  def update_profile(id,attrs) do

    case Repo.get(UserDatas,id) do

      nil -> {:error,"User with #{id} not found"}






       user ->

                    changeset=user|>UserDatas.changeset(attrs)
                  if(changeset.valid?) do
                    hashed_password = Bcrypt.hash_pwd_salt(attrs.password)

                    updated_data=%{
                           name: attrs.name,
                           email: attrs.email,
                           password: hashed_password
                            }
        user
        |> UserDatas.changeset(updated_data)
        |> Repo.update()

end


      end


      end

    end



