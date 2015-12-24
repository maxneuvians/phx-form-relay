defmodule PhxFormRelay.Form do
  use PhxFormRelay.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "forms" do
    field :name, :string
    field :to, :string
    field :honeypot, :string
    field :redirect_to, :string
    field :active, :boolean, default: false
    field :count, :integer, default: 0

    has_many :emails, PhxFormRelay.Email

    timestamps
  end

  @required_fields ~w(active name to honeypot redirect_to count)
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
