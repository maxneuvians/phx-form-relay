defmodule PhxFormRelay.EmailTest do
  use PhxFormRelay.ModelCase

  alias PhxFormRelay.Email

  @valid_attrs %{content: "some content", ip: "some content", form_id: "b7d4ad5f-cbdf-4b0f-bf61-bf3144958892"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Email.changeset(%Email{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Email.changeset(%Email{}, @invalid_attrs)
    refute changeset.valid?
  end
end
