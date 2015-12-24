defmodule PhxFormRelay.FormTest do
  use PhxFormRelay.ModelCase

  alias PhxFormRelay.Form

  @valid_attrs %{active: true, count: 42, honeypot: "some content", name: "some name", redirect_to: "some content", to: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Form.changeset(%Form{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Form.changeset(%Form{}, @invalid_attrs)
    refute changeset.valid?
  end
end
