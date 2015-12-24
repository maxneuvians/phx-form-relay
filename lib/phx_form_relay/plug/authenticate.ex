defmodule PhxFormRelay.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, default) do
    case conn.assigns[:current_user] do
      nil -> find_user(conn)
      _     -> conn
    end
  end

  defp find_user(conn) do
    case get_session(conn, :current_user) do
      id when is_integer(id) -> assign(conn, :current_user, id)
      nil   -> conn
                |> put_flash(:error, 'You need to be signed in to view this page')
                |> redirect(to: "/")
                |> halt
    end
  end
end
