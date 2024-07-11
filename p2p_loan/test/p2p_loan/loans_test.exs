defmodule P2pLoan.LoansTest do
  use P2pLoan.DataCase

  alias P2pLoan.Loans

  describe "loans" do
    alias P2pLoan.Loans.Loan

    import P2pLoan.LoansFixtures

    @invalid_attrs %{status: nil, currency: nil, owner_id: nil, amount: nil, interest_rate: nil}

    test "list_loans/0 returns all loans" do
      loan = loan_fixture()
      assert Loans.list_loans() == [loan]
    end

    test "get_loan!/1 returns the loan with given id" do
      loan = loan_fixture()
      assert Loans.get_loan!(loan.id) == loan
    end

    test "create_loan/1 with valid data creates a loan" do
      valid_attrs = %{status: "some status", currency: "some currency", owner_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5", interest_rate: "120.5"}

      assert {:ok, %Loan{} = loan} = Loans.create_loan(valid_attrs)
      assert loan.status == "some status"
      assert loan.currency == "some currency"
      assert loan.owner_id == "7488a646-e31f-11e4-aace-600308960662"
      assert loan.amount == Decimal.new("120.5")
      assert loan.interest_rate == Decimal.new("120.5")
    end

    test "create_loan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loans.create_loan(@invalid_attrs)
    end

    test "update_loan/2 with valid data updates the loan" do
      loan = loan_fixture()
      update_attrs = %{status: "some updated status", currency: "some updated currency", owner_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7", interest_rate: "456.7"}

      assert {:ok, %Loan{} = loan} = Loans.update_loan(loan, update_attrs)
      assert loan.status == "some updated status"
      assert loan.currency == "some updated currency"
      assert loan.owner_id == "7488a646-e31f-11e4-aace-600308960668"
      assert loan.amount == Decimal.new("456.7")
      assert loan.interest_rate == Decimal.new("456.7")
    end

    test "update_loan/2 with invalid data returns error changeset" do
      loan = loan_fixture()
      assert {:error, %Ecto.Changeset{}} = Loans.update_loan(loan, @invalid_attrs)
      assert loan == Loans.get_loan!(loan.id)
    end

    test "delete_loan/1 deletes the loan" do
      loan = loan_fixture()
      assert {:ok, %Loan{}} = Loans.delete_loan(loan)
      assert_raise Ecto.NoResultsError, fn -> Loans.get_loan!(loan.id) end
    end

    test "change_loan/1 returns a loan changeset" do
      loan = loan_fixture()
      assert %Ecto.Changeset{} = Loans.change_loan(loan)
    end
  end
end
