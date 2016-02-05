defmodule PhxFormRelay.Email do
  use PhxFormRelay.Web, :model

  @foreign_key_type :binary_id

  schema "emails" do
    field :content, :string
    field :ip, :string
    belongs_to :form, PhxFormRelay.Form

    timestamps
  end

  @required_fields ~w(form_id content ip)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
