defmodule PhxFormRelay.SessionController do
  use PhxFormRelay.Web, :controller

  alias PhxFormRelay.User

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    user = if is_nil(user_params["email"]) do
      nil
    else
      Repo.get_by(User, email: user_params["email"])
    end

    user
      |> sign_in(user_params["password"], conn)
  end

  def delete(conn, _) do
    delete_session(conn, :current_user)
      |> put_flash(:info, 'You have been logged out')
      |> redirect(to: session_path(conn, :index))
  end

  def index(conn, _params) do
    conn
      |> render "index.html", changeset: User.changeset(%User{})
  end

  defp sign_in(user, password, conn) when is_nil(user) do
    conn
      |> put_flash(:error, 'Could not find a user with that email.')
      |> render "index.html", changeset: User.changeset(%User{})
  end

  defp sign_in(user, password, conn) when is_map(user) do
    cond do
      Comeonin.Bcrypt.checkpw(password, user.encrypted_password) ->
        conn
          |> put_session(:current_user, user.id)
          |> put_flash(:info, 'You are now signed in.')
          |> redirect(to: form_path(conn, :index))
      true ->
        conn
          |> put_flash(:error, 'Email or password are incorrect.')
          |> render "index.html", changeset: User.changeset(%User{})
    end
  end
end