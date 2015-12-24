defmodule PhxFormRelay.SessionControllerTest do
  use PhxFormRelay.ConnCase

  alias PhxFormRelay.Password
  alias PhxFormRelay.User

  @login_params %{email: "admin@example.com", password: "P@ssw0rd"}

  setup do
    user_params = %{email: "admin@example.com", password: "P@ssw0rd", password_confirmation: "P@ssw0rd"}
    User.changeset(%User{}, user_params) |> Password.generate_password_in_changeset |> Repo.insert
    {:ok, conn: conn}
  end

  test "show the login page", %{conn: conn} do
    conn = get conn, session_path(conn, :index)
    assert html_response(conn, 200) =~ "Login"
  end

  test "logs in a valid user", %{conn: conn} do 
    conn = post conn, session_path(conn, :create), user: @login_params
    assert redirected_to(conn) == form_path(conn, :index)
  end

  test "does not log in an invalid user with a bad password", %{conn: conn} do 
    conn = post conn, session_path(conn, :create), user: %{@login_params | password: "bad-password"}
    assert html_response(conn, 200) =~ "Login"
  end

  test "does not log in an invalid user with a bad email", %{conn: conn} do 
    conn = post conn, session_path(conn, :create), user: %{@login_params | email: "bad-email"}
    assert html_response(conn, 200) =~ "Login"
  end

  test "logs out a logged in user", %{conn: conn} do 
    user = Repo.get_by(User, email: @login_params[:email])
    conn = conn |> assign(:current_user, user)
    conn = get conn, "/logout"
    assert redirected_to(conn) == session_path(conn, :index)
    refute get_session(conn, :current_user)
  end

end