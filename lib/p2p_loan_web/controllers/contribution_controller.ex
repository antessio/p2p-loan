defmodule P2pLoanWeb.ContributionController do
  use P2pLoanWeb, :controller

  alias P2pLoan.Loans
  alias P2pLoan.Loans.Contribution

  def index(conn, _params) do
    contributions = Loans.list_contributions()
    render(conn, :index, contributions: contributions)
  end

  def new(conn, _params) do
    changeset = Loans.change_contribution(%Contribution{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"contribution" => contribution_params}) do
    case Loans.create_contribution(contribution_params) do
      {:ok, contribution} ->
        conn
        |> put_flash(:info, "Contribution created successfully.")
        |> redirect(to: ~p"/contributions/#{contribution}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contribution = Loans.get_contribution!(id)
    render(conn, :show, contribution: contribution)
  end

  def edit(conn, %{"id" => id}) do
    contribution = Loans.get_contribution!(id)
    changeset = Loans.change_contribution(contribution)
    render(conn, :edit, contribution: contribution, changeset: changeset)
  end

  def update(conn, %{"id" => id, "contribution" => contribution_params}) do
    contribution = Loans.get_contribution!(id)

    case Loans.update_contribution(contribution, contribution_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Contribution updated successfully.")
        |> redirect(to: ~p"/loans")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, contribution: contribution, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contribution = Loans.get_contribution!(id)
    {:ok, _contribution} = Loans.delete_contribution(contribution)

    conn
    |> put_flash(:info, "Contribution deleted successfully.")
    |> redirect(to: ~p"/loans")
  end
end
