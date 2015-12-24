defmodule PhxFormRelay.FormControllerTest do
  use PhxFormRelay.ConnCase

  alias PhxFormRelay.Form
  alias PhxFormRelay.Password
  alias PhxFormRelay.User

  @valid_attrs %{active: true, count: 42, honeypot: "some content", name: "some name", redirect_to: "some content", to: "some content"}
  @invalid_attrs %{}

  setup do
    user_params = %{email: "admin@example.com", password: "P@ssw0rd", password_confirmation: "P@ssw0rd"}
    user = User.changeset(%User{}, user_params) |> Password.generate_password_in_changeset |> Repo.insert
    conn = conn() |> assign(:current_user, user)
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, form_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing forms"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, form_path(conn, :new)
    assert html_response(conn, 200) =~ "New form"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, form_path(conn, :create), form: @valid_attrs
    assert redirected_to(conn) == form_path(conn, :index)
    assert Repo.get_by(Form, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, form_path(conn, :create), form: @invalid_attrs
    assert html_response(conn, 200) =~ "New form"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    form = Repo.insert! %Form{}
    conn = get conn, form_path(conn, :edit, form)
    assert html_response(conn, 200) =~ "Edit form"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    form = Repo.insert! %Form{}
    conn = put conn, form_path(conn, :update, form), form: @valid_attrs
    assert redirected_to(conn) == form_path(conn, :index)
    assert Repo.get_by(Form, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    form = Repo.insert! %Form{}
    conn = put conn, form_path(conn, :update, form), form: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit form"
  end

  test "deletes chosen resource", %{conn: conn} do
    form = Repo.insert! %Form{}
    conn = delete conn, form_path(conn, :delete, form)
    assert redirected_to(conn) == form_path(conn, :index)
    refute Repo.get(Form, form.id)
  end
end
