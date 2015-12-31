defmodule PhxFormRelay.SendController do
  use PhxFormRelay.Web, :controller

  alias PhxFormRelay.Email
  alias PhxFormRelay.Form
  alias PhxFormRelay.Mailer

  require Logger

  def send(conn, params) do
    case params["phx_form_id"] do 
      <<_::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96>> ->  
        if form = Repo.get_by Form, id: params["phx_form_id"], active: true do
          case { params |> Map.has_key?(form.honeypot), params |> Map.get(form.honeypot, "") |> String.length } do
            {true, 0} ->
              form |> Mailer.build_email_from_form_and_params(params) |> Mailer.deliver
            _ ->
              form |> Ecto.Changeset.change(count: form.count + 1) |> Repo.update
              Email.changeset(%Email{}, %{content: Mailer.format_params(form, params), ip: conn.remote_ip 
                |> Tuple.to_list 
                |> Enum.join(".")}) 
                |> Repo.insert!
          end
        end
      _ ->
    end
    render_or_redirect(conn, params, form)
  end

  defp render_or_redirect(conn, params, %Form{} = form), do: redirect conn, external: form.redirect_to
  defp render_or_redirect(conn, params, _) do
    render(conn, "not_found.html", layout: {PhxFormRelay.LayoutView, "not_found.html"}, id: params["phx_form_id"])
  end
end
