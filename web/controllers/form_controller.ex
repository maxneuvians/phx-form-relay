defmodule PhxFormRelay.FormController do
  use PhxFormRelay.Web, :controller

  alias PhxFormRelay.Form

  plug :scrub_params, "form" when action in [:create, :update]

  def index(conn, _params) do
    forms = Repo.all(Form)
    render(conn, "index.html", forms: forms)
  end

  def new(conn, _params) do
    changeset = Form.changeset(%Form{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"form" => form_params}) do
    changeset = Form.changeset(%Form{}, form_params)

    case Repo.insert(changeset) do
      {:ok, _form} ->
        conn
        |> put_flash(:info, "Form created successfully.")
        |> redirect(to: form_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    form = Repo.get!(Form, id)
    changeset = Form.changeset(form)
    render(conn, "edit.html", form: form, changeset: changeset)
  end

  def update(conn, %{"id" => id, "form" => form_params}) do
    form = Repo.get!(Form, id)
    changeset = Form.changeset(form, form_params)

    case Repo.update(changeset) do
      {:ok, form} ->
        conn
        |> put_flash(:info, "Form updated successfully.")
        |> redirect(to: form_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", form: form, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    form = Repo.get!(Form, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(form)

    conn
    |> put_flash(:info, "Form deleted successfully.")
    |> redirect(to: form_path(conn, :index))
  end
end
