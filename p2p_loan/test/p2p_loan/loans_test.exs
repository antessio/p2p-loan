defmodule P2pLoan.LoansTest do
  use P2pLoan.DataCase

  alias P2pLoan.Loans
  alias P2pLoan.Loans.LoanRequest

  describe "loans" do
    alias P2pLoan.Loans.Loan
    alias P2pLoan.Loans.Contribution

    import P2pLoan.LoansFixtures
    import P2pLoan.TestUtils

    test "list_loans/0 returns all loans" do
      ## given
      loan = insert_loan(build_loan(:requested))
      ## when
      loans = Loans.list_loans()
      ## then
      assert loans == [loan]
    end

    test "get_loan!/1 returns the loan with given id" do
      ## given
      loan = insert_loan(build_loan(:requested))
      ## when
      result = Loans.get_loan!(loan.id)
      ## then
      assert result == loan
    end

    test "request loan/1 with valid data creates a loan in created status" do
      ## given
      loan_request = %LoanRequest{
        owner_id: unique_uuid(),
        amount: 300.20,
        duration: 10,
        currency: "EUR"
      }
      ## when
      {:ok, loan} = Loans.request_loan(loan_request)

      ## then
      assert loan.status == :requested
    end

    test "approve/2 updates the loan status and sets the interest rate" do
      ## given
      requested_loan = insert_loan(build_loan(:requested))
      interest_rate = 3.2

      ## when
      {:ok, loan} = Loans.approve(requested_loan, interest_rate)

      ## then
      {loan_map, requested_loan_map} = to_map_except_fields(loan, requested_loan, [:status, :interest_rate])
      assert loan_map == requested_loan_map
      assert loan.status == :approved
      assert Decimal.to_float(loan.interest_rate) == interest_rate
    end


    test "approve/2 fails if loans is not requested" do
      ## given
      issued_loan = insert_loan(build_loan(:issued))

      ## when
      ## then
      assert {:error, "invalid loan status issued"} == Loans.approve(issued_loan, 3.2)
    end

    test "approve/2 doesn't do anything if loan is already approved" do
      ## given
      approved_loan = insert_loan(build_loan(:approved))

      ## when
      ## then
      assert {:ok, approved_loan} == Loans.approve(approved_loan, 3.2)
    end

    test "issue/1 update the status" do
      ## given
      ready_to_be_issued_loan = insert_loan_with_contributions(build_loan(:ready_to_be_issued))
      ## when
      {:ok, loan} = Loans.issue(ready_to_be_issued_loan)
      ## then
      {loan_map, ready_to_be_issued_loan_map} = to_map_except_fields(loan, ready_to_be_issued_loan, [:status, :updated_at])
      assert loan_map == ready_to_be_issued_loan_map
      assert loan.status == :issued
    end

    test "issue/1 fails if loan status is not ready_to_be_issued" do
      ## given
      approved_loan = insert_loan(build_loan(:approved))

      ## when
      result = Loans.issue(approved_loan)

      ## then
      assert {:error, "loan is expected to be ready_to_be_issued but is approved"} == result

    end


  #   test "create_loan/1 with valid data creates a loan" do
  #     valid_attrs = %{status: "some status", currency: "some currency", owner_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5", interest_rate: "120.5"}

  #     assert {:ok, %Loan{} = loan} = Loans.create_loan(valid_attrs)
  #     assert loan.status == "some status"
  #     assert loan.currency == "some currency"
  #     assert loan.owner_id == "7488a646-e31f-11e4-aace-600308960662"
  #     assert loan.amount == Decimal.new("120.5")
  #     assert loan.interest_rate == Decimal.new("120.5")
  #   end

  #   test "create_loan/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Loans.create_loan(@invalid_attrs)
  #   end

  #   test "update_loan/2 with valid data updates the loan" do
  #     loan = loan_fixture()
  #     update_attrs = %{status: "some updated status", currency: "some updated currency", owner_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7", interest_rate: "456.7"}

  #     assert {:ok, %Loan{} = loan} = Loans.update_loan(loan, update_attrs)
  #     assert loan.status == "some updated status"
  #     assert loan.currency == "some updated currency"
  #     assert loan.owner_id == "7488a646-e31f-11e4-aace-600308960668"
  #     assert loan.amount == Decimal.new("456.7")
  #     assert loan.interest_rate == Decimal.new("456.7")
  #   end

  #   test "update_loan/2 with invalid data returns error changeset" do
  #     loan = loan_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Loans.update_loan(loan, @invalid_attrs)
  #     assert loan == Loans.get_loan!(loan.id)
  #   end

  #   test "delete_loan/1 deletes the loan" do
  #     loan = loan_fixture()
  #     assert {:ok, %Loan{}} = Loans.delete_loan(loan)
  #     assert_raise Ecto.NoResultsError, fn -> Loans.get_loan!(loan.id) end
  #   end

  #   test "change_loan/1 returns a loan changeset" do
  #     loan = loan_fixture()
  #     assert %Ecto.Changeset{} = Loans.change_loan(loan)
  #   end

  #   test "request_loan/1 creates a loan in status requested" do
  #     loan = Loans.request_loan(%LoanRequest{
  #       owner_id: "e9cd389a-5bd8-4c3d-9627-6edab216db02",
  #       currency: "EUR",
  #       amount: Decimal.new(2000),
  #       duration: 30 })
  #       assert loan.status == :requested
  #       assert loan.currency == "EUR"
  #       assert loan.owner_id == "e9cd389a-5bd8-4c3d-9627-6edab216db02"
  #       assert loan.amount == Decimal.new(2000)
  #       assert loan.duration == 30
  #   end
  # end

  # describe "contributions" do
  #   alias P2pLoan.Loans.Contribution

  #   import P2pLoan.LoansFixtures

  #   @invalid_attrs %{currency: nil, contributor_id: nil, amount: nil}

  #   test "list_contributions/0 returns all contributions" do
  #     contribution = contribution_fixture()
  #     assert Loans.list_contributions() == [contribution]
  #   end

  #   test "get_contribution!/1 returns the contribution with given id" do
  #     contribution = contribution_fixture()
  #     assert Loans.get_contribution!(contribution.id) == contribution
  #   end

  #   test "create_contribution/1 with valid data creates a contribution" do
  #     valid_attrs = %{currency: "some currency", contributor_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5"}

  #     assert {:ok, %Contribution{} = contribution} = Loans.create_contribution(valid_attrs)
  #     assert contribution.currency == "some currency"
  #     assert contribution.contributor_id == "7488a646-e31f-11e4-aace-600308960662"
  #     assert contribution.amount == Decimal.new("120.5")
  #   end

  #   test "create_contribution/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Loans.create_contribution(@invalid_attrs)
  #   end

  #   test "update_contribution/2 with valid data updates the contribution" do
  #     contribution = contribution_fixture()
  #     update_attrs = %{currency: "some updated currency", contributor_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7"}

  #     assert {:ok, %Contribution{} = contribution} = Loans.update_contribution(contribution, update_attrs)
  #     assert contribution.currency == "some updated currency"
  #     assert contribution.contributor_id == "7488a646-e31f-11e4-aace-600308960668"
  #     assert contribution.amount == Decimal.new("456.7")
  #   end

  #   test "update_contribution/2 with invalid data returns error changeset" do
  #     contribution = contribution_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Loans.update_contribution(contribution, @invalid_attrs)
  #     assert contribution == Loans.get_contribution!(contribution.id)
  #   end

  #   test "delete_contribution/1 deletes the contribution" do
  #     contribution = contribution_fixture()
  #     assert {:ok, %Contribution{}} = Loans.delete_contribution(contribution)
  #     assert_raise Ecto.NoResultsError, fn -> Loans.get_contribution!(contribution.id) end
  #   end

  #   test "change_contribution/1 returns a contribution changeset" do
  #     contribution = contribution_fixture()
  #     assert %Ecto.Changeset{} = Loans.change_contribution(contribution)
  #   end
  # end

  # describe "interest_chargges" do
  #   alias P2pLoan.Loans.InterestCharge

  #   import P2pLoan.LoansFixtures

  #   @invalid_attrs %{status: nil, debtor_id: nil, loan_id: nil, amount: nil, due_date: nil}

  #   test "list_interest_chargges/0 returns all interest_chargges" do
  #     interest_charge = interest_charge_fixture()
  #     assert Loans.list_interest_chargges() == [interest_charge]
  #   end

  #   test "get_interest_charge!/1 returns the interest_charge with given id" do
  #     interest_charge = interest_charge_fixture()
  #     assert Loans.get_interest_charge!(interest_charge.id) == interest_charge
  #   end

  #   test "create_interest_charge/1 with valid data creates a interest_charge" do
  #     valid_attrs = %{status: "some status", debtor_id: "7488a646-e31f-11e4-aace-600308960662", loan_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5", due_date: ~U[2024-07-14 13:16:00Z]}

  #     assert {:ok, %InterestCharge{} = interest_charge} = Loans.create_interest_charge(valid_attrs)
  #     assert interest_charge.status == "some status"
  #     assert interest_charge.debtor_id == "7488a646-e31f-11e4-aace-600308960662"
  #     assert interest_charge.loan_id == "7488a646-e31f-11e4-aace-600308960662"
  #     assert interest_charge.amount == Decimal.new("120.5")
  #     assert interest_charge.due_date == ~U[2024-07-14 13:16:00Z]
  #   end

  #   test "create_interest_charge/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Loans.create_interest_charge(@invalid_attrs)
  #   end

  #   test "update_interest_charge/2 with valid data updates the interest_charge" do
  #     interest_charge = interest_charge_fixture()
  #     update_attrs = %{status: "some updated status", debtor_id: "7488a646-e31f-11e4-aace-600308960668", loan_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7", due_date: ~U[2024-07-15 13:16:00Z]}

  #     assert {:ok, %InterestCharge{} = interest_charge} = Loans.update_interest_charge(interest_charge, update_attrs)
  #     assert interest_charge.status == "some updated status"
  #     assert interest_charge.debtor_id == "7488a646-e31f-11e4-aace-600308960668"
  #     assert interest_charge.loan_id == "7488a646-e31f-11e4-aace-600308960668"
  #     assert interest_charge.amount == Decimal.new("456.7")
  #     assert interest_charge.due_date == ~U[2024-07-15 13:16:00Z]
  #   end

  #   test "update_interest_charge/2 with invalid data returns error changeset" do
  #     interest_charge = interest_charge_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Loans.update_interest_charge(interest_charge, @invalid_attrs)
  #     assert interest_charge == Loans.get_interest_charge!(interest_charge.id)
  #   end

  #   test "delete_interest_charge/1 deletes the interest_charge" do
  #     interest_charge = interest_charge_fixture()
  #     assert {:ok, %InterestCharge{}} = Loans.delete_interest_charge(interest_charge)
  #     assert_raise Ecto.NoResultsError, fn -> Loans.get_interest_charge!(interest_charge.id) end
  #   end

  #   test "change_interest_charge/1 returns a interest_charge changeset" do
  #     interest_charge = interest_charge_fixture()
  #     assert %Ecto.Changeset{} = Loans.change_interest_charge(interest_charge)
  #   end
  end
end
