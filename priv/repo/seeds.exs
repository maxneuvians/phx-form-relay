# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhxFormRelay.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhxFormRelay.Password
alias PhxFormRelay.User

user_params = %{email: "admin@example.com", password: "P@ssw0rd", password_confirmation: "P@ssw0rd"}

PhxFormRelay.Repo.insert!(
  User.changeset(%User{}, user_params) |> Password.generate_password_in_changeset
)