defmodule PhxFormRelay.EmailController do
  use PhxFormRelay.Web, :controller

  alias PhxFormRelay.Email
  alias PhxFormRelay.Form

  def index(conn, params) do
    emails = Repo.all(Email)
    form = Repo.get!(Form, params["form_id"])
    render(conn, "index.html", emails: emails, form: form)
  end
end
