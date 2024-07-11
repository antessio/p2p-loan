defmodule P2pLoanWeb.LoanController do
  use P2pLoanWeb, :controller

  alias P2pLoan.Loans
  alias P2pLoan.Loans.Loan

  def index(conn, _params) do
    loans = Loans.list_loans()
    render(conn, :index, loans: loans)
  end

  def new(conn, _params) do
    changeset = Loans.change_loan(%Loan{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"loan" => loan_params}) do
    case Loans.request_loan(loan_params["owner_id"], loan_params["currency"], Decimal.new(loan_params["amount"])) do
      {:ok, loan} ->
        conn
        |> put_flash(:info, "Loan created successfully.")
        |> redirect(to: ~p"/loans/#{loan}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    loan = Loans.get_loan!(id)
    render(conn, :show, loan: loan)
  end

  def edit(conn, %{"id" => id}) do
    loan = Loans.get_loan!(id)
    changeset = Loans.change_loan(loan)
    render(conn, :edit, loan: loan, changeset: changeset)
  end

  def update(conn, %{"id" => id, "loan" => loan_params}) do
    loan = Loans.get_loan!(id)

    case Loans.approve(loan, Decimal.new(loan_params["interest_rate"])) do
      {:ok, loan} ->
        conn
        |> put_flash(:info, "Loan updated successfully.")
        |> redirect(to: ~p"/loans/#{loan}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, loan: loan, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    loan = Loans.get_loan!(id)
    {:ok, _loan} = Loans.delete_loan(loan)

    conn
    |> put_flash(:info, "Loan deleted successfully.")
    |> redirect(to: ~p"/loans")
  end
end
