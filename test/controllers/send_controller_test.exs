defmodule PhxFormRelay.SendControllerTest do
  use PhxFormRelay.ConnCase

  alias PhxFormRelay.Email
  alias PhxFormRelay.Form

  @bot_attrs %{trigger_me: "yes"}
  @normal_attrs %{trigger_me: "", content: "Here is some content for you"}
  @form_attrs %{active: true, honeypot: "trigger_me", name: "some name", redirect_to: "http://google.com", to: "max@neuvians.io", reply_to: "max@neuvians.net"}

  setup_all do 
    Mailman.TestServer.start
    :ok
  end

  setup do
    form = Repo.insert! Form.changeset(%Form{}, @form_attrs)
    inactive_form = Repo.insert! Form.changeset(%Form{}, %{@form_attrs | active: false})
    no_reply_to_form = Repo.insert! Form.changeset(%Form{}, %{@form_attrs | reply_to: nil})
    {:ok, conn: conn, form: form, inactive_form: inactive_form, no_reply_to_form: no_reply_to_form}
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

  test "logs the email body if the honeypot it triggered", %{conn: conn, form: form} do
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
    Mailman.TestServer.clear_deliveries
    post conn, "send/#{form.id}", @normal_attrs 
    :timer.sleep(100) # Allow for the Mail process to complete
    assert Mailman.TestServer.deliveries |> Enum.count == 1
  end

  test "sets the reply-to field based on the reply_to attribute", %{conn: conn, form: form} do
    Mailman.TestServer.clear_deliveries
    post conn, "send/#{form.id}", @normal_attrs
    :timer.sleep(100) # Allow for the Mail process to complete
    assert Mailman.TestServer.deliveries |> List.first |> String.contains? "reply-to: #{form.reply_to}"
  end

  test "sets the reply-to field based on the sender field if reply_to does not exist attribute", %{conn: conn, no_reply_to_form: no_reply_to_form} do
    Mailman.TestServer.clear_deliveries
    post(conn, "send/#{no_reply_to_form.id}", @normal_attrs)
    :timer.sleep(100) # Allow for the Mail process to complete
    assert Mailman.TestServer.deliveries |> List.first |> String.contains? "reply-to: #{Application.get_env(:phx_form_relay, :from_email)}"
  end

end