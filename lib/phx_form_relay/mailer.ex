defmodule PhxFormRelay.Mailer do
  
  def deliver(email) do
    Mailman.deliver(email, config)
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
              tls: :never,
              auth: :never
            }
        }
      end
  end

  def build_email_from_form_and_params(form, params) do 
    %Mailman.Email
      {
        subject: "You have received a new form request for: #{form.name}",
        from: Application.get_env(:phx_form_relay, :from_email),
        reply_to: Application.get_env(:phx_form_relay, :from_email),
        to: parse_emails(form.to),
        text: format_params(form, params)
      }
  end

  def format_params(form, params) do
    Enum.filter(params, fn {k, v} -> k != "phx_form_id" and k != form.honeypot end)
      |> Enum.map(fn {k, v} -> {k, "#{k}: #{v}"} end) 
      |> Dict.values 
      |> Enum.join "\n"
  end

  defp parse_emails(emails) do 
    String.split(emails, ",") |> Enum.map(fn(e) -> String.strip(e) end)
  end
end