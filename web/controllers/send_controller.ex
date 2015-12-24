defmodule PhxFormRelay.SendController do
  use PhxFormRelay.Web, :controller

  alias PhxFormRelay.Email
  alias PhxFormRelay.Form
  alias PhxFormRelay.Mailer

  require Logger

  def send(conn, params) do
    try do # Cast errors return a 400 instead of a 404, which we want in this case
      form = Repo.get_by Form, id: params["phx_form_id"], active: true
      case { Map.has_key?(params, form.honeypot), Map.get(params, form.honeypot, "") |> String.length } do
        {true, 0} ->
          Mailer.build_email_from_form_and_params(form, params)
            |> Mailer.deliver
        _ ->
          updated_form = Ecto.Changeset.change form, count: form.count + 1
          Repo.update updated_form
          Email.changeset(%Email{}, %{content: Mailer.format_params(form, params), ip: conn.remote_ip |> Tuple.to_list |> Enum.join(".")}) |> Repo.insert!
      end
      redirect conn, external: form.redirect_to
    rescue
      e in _ -> e
      render(conn, "not_found.html", layout: {PhxFormRelay.LayoutView, "not_found.html"}, id: params["phx_form_id"])
    end
  end
end
