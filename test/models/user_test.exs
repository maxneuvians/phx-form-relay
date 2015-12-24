defmodule PhxFormRelay.UserTest do
  use PhxFormRelay.ModelCase

  alias PhxFormRelay.User

  @valid_attrs %{email: "test@test.com", password: "some content", password_confirmation: "some content"}
  @invalid_attrs %{email: "bad-email", password: "some content", password_confirmation: "does not match"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with email in bad format" do 
    changeset = User.changeset(%User{}, %{@valid_attrs | email: @invalid_attrs.email })
    refute changeset.valid?
  end

  test "changeset with non-matching passwords" do 
    changeset = User.changeset(%User{}, %{@valid_attrs | password: @invalid_attrs.password, password_confirmation: @invalid_attrs.password_confirmation })
    refute changeset.valid?
  end

  test "changeset with non-unique email" do 
    Repo.insert! User.changeset(%User{}, @valid_attrs)
    assert_raise Ecto.InvalidChangesetError, fn -> 
      Repo.insert! User.changeset(%User{}, @valid_attrs)
    end
  end

end
