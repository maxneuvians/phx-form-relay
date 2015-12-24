defmodule PhxFormRelay.SendControllerTest do
  use PhxFormRelay.ConnCase

  alias PhxFormRelay.Email
  alias PhxFormRelay.Form

  @bot_attrs %{trigger_me: "yes"}
  @normal_attrs %{trigger_me: "", content: "Here is some content for you"}
  @form_attrs %{active: true, honeypot: "trigger_me", name: "some name", redirect_to: "http://google.com", to: "max@neuvians.io"}

  setup_all do 
    Mailman.TestServer.start
    :ok
  end

  setup do
    form = Repo.insert! Form.changeset(%Form{}, @form_attrs)
    inactive_form = Repo.insert! Form.changeset(%Form{}, %{@form_attrs | active: false})
    {:ok, conn: conn, form: form, inactive_form: inactive_form}
  end

  test "shows a not found page if the form does not exist", %{conn: conn} do
    conn = post conn, "send/nil"
    assert html_response(conn, 200) =~ "Form could not be found"
  end

  test "shows a not found page if the form is not active", %{conn: conn, inactive_form: inactive_form} do
    conn = post conn, "send/#{inactive_form.id}"
    assert html_response(conn, 200) =~ "Form could not be found"
  end

  test "redirects to the redirect page if the form exists", %{conn: conn, form: form} do
    conn = post conn, "send/#{form.id}"
    assert redirected_to(conn) == form.redirect_to
  end

  test "increases the honeypot counter by one if the honeypot it triggered", %{conn: conn, form: form} do
    conn = post conn, "send/#{form.id}", @bot_attrs
    assert Repo.get_by(Form, count: 1)
    assert redirected_to(conn) == form.redirect_to
  end

  test "logs the email bodu if the honeypot it triggered", %{conn: conn, form: form} do
    conn = post conn, "send/#{form.id}", @bot_attrs
    assert Repo.one!(Email)
    assert redirected_to(conn) == form.redirect_to
  end

  test "does not increase the honeypot counter by one if the honeypot it empty", %{conn: conn, form: form} do
    conn = post conn, "send/#{form.id}", @normal_attrs
    assert Repo.get_by(Form, count: 0, id: form.id)
    assert redirected_to(conn) == form.redirect_to
  end

  test "it sends an email if the honeypot it empty", %{conn: conn, form: form} do
    post conn, "send/#{form.id}", @normal_attrs
    assert Mailman.TestServer.deliveries() |> length > 0
  end

end