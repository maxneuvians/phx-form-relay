defmodule PhxFormRelay.EmailController do
  use PhxFormRelay.Web, :controller

  alias PhxFormRelay.Email
  alias PhxFormRelay.Form

  def index(conn, params) do
    form = Repo.get!(Form, params["form_id"])
    emails = Repo.all(assoc(form, :emails))
    render(conn, "index.html", emails: emails, form: form)
  end
end
