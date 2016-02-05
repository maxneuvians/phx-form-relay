defmodule PhxFormRelay.Mailer do
  
  def deliver(email) do
    email |> Mailman.deliver(config, :send_cc_and_bcc)
  end

  def config do
      if Mix.env == :test do 
        %Mailman.Context{config: %Mailman.TestConfig{}}
      else
        %Mailman.Context{
          config: %Mailman.SmtpConfig
            {
              username: Application.get_env(:phx_form_relay, :smtp_username),
              password: Application.get_env(:phx_form_relay, :smtp_password),
              relay: Application.get_env(:phx_form_relay, :smtp_host),
              port: Application.get_env(:phx_form_relay, :smtp_port),
              tls: Application.get_env(:phx_form_relay, :smtp_tls),
              auth: Application.get_env(:phx_form_relay, :smtp_auth)
            }
        }
      end
  end

  def build_email_from_form_and_params(form, params) do 
    %Mailman.Email
      {
        subject: "You have received a new form request for: #{form.name}",
        from: Application.get_env(:phx_form_relay, :from_email),
        reply_to: form.reply_to |> reply_to,
        to: form.to |> parse_emails,
        cc: form.cc |> parse_emails,
        bcc: form.bcc |> parse_emails,
        text: form |> format_params(params),
        attachments: params |> Enum.map(fn {_, v} -> add_attachment(v) end) |> Enum.filter(fn e -> e != nil end)
      }
  end

  def format_params(form, params) do 
    params |> Enum.filter(fn {k, _} -> k != "phx_form_id" and k != form.honeypot end)
      |> Enum.map(fn i -> join_map_items(i) end) 
      |> Enum.filter(fn e -> e != nil end)
      |> Enum.join("\n")
  end
  
  defp add_attachment(%Plug.Upload{} = file), do: Mailman.Attachment.inline!(file.path, file.filename)
  defp add_attachment(_), do: nil

  defp join_map_items({k, %Plug.Upload{} = file}), do: "#{k}: See attached #{file.filename}"
  defp join_map_items({k, v}) when is_map(v), do: "#{k}: -> #{v |> Enum.map(fn i -> join_map_items(i) end)} "
  defp join_map_items({k, v}) when is_list(v), do: "#{k}: #{v |> Enum.join(", ")} "
  defp join_map_items({k, v}), do: "#{k}: #{v} "

  defp parse_emails(nil), do: []
  defp parse_emails(""), do: []
  defp parse_emails(emails), do: emails |> String.split(",") |> Enum.map(fn(e) -> String.strip(e) end)

  defp reply_to(nil), do: Application.get_env(:phx_form_relay, :from_email)
  defp reply_to(""), do: Application.get_env(:phx_form_relay, :from_email)
  defp reply_to(email), do: email
end