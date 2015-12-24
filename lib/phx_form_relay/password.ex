defmodule PhxFormRelay.Password do
  alias PhxFormRelay.Repo
  import Ecto.Changeset, only: [put_change: 3]
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  def generate_password(password) do 
    hashpwsalt(password)
  end

  def generate_password_in_changeset(changeset) do
    put_change(changeset, :encrypted_password, generate_password(changeset.params["password"]))
  end

end