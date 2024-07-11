defmodule P2pLoanWeb.LoanControllerTest do
  use P2pLoanWeb.ConnCase

  import P2pLoan.LoansFixtures

  @create_attrs %{status: "some status", currency: "some currency", owner_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5", interest_rate: "120.5"}
  @update_attrs %{status: "some updated status", currency: "some updated currency", owner_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7", interest_rate: "456.7"}
  @invalid_attrs %{status: nil, currency: nil, owner_id: nil, amount: nil, interest_rate: nil}

  describe "index" do
    test "lists all loans", %{conn: conn} do
      conn = get(conn, ~p"/loans")
      assert html_response(conn, 200) =~ "Listing Loans"
    end
  end

  describe "new loan" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/loans/new")
      assert html_response(conn, 200) =~ "New Loan"
    end
  end

  describe "create loan" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/loans", loan: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/loans/#{id}"

      conn = get(conn, ~p"/loans/#{id}")
      assert html_response(conn, 200) =~ "Loan #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/loans", loan: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Loan"
    end
  end

  describe "edit loan" do
    setup [:create_loan]

    test "renders form for editing chosen loan", %{conn: conn, loan: loan} do
      conn = get(conn, ~p"/loans/#{loan}/edit")
      assert html_response(conn, 200) =~ "Edit Loan"
    end
  end

  describe "update loan" do
    setup [:create_loan]

    test "redirects when data is valid", %{conn: conn, loan: loan} do
      conn = put(conn, ~p"/loans/#{loan}", loan: @update_attrs)
      assert redirected_to(conn) == ~p"/loans/#{loan}"

      conn = get(conn, ~p"/loans/#{loan}")
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, loan: loan} do
      conn = put(conn, ~p"/loans/#{loan}", loan: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Loan"
    end
  end

  describe "delete loan" do
    setup [:create_loan]

    test "deletes chosen loan", %{conn: conn, loan: loan} do
      conn = delete(conn, ~p"/loans/#{loan}")
      assert redirected_to(conn) == ~p"/loans"

      assert_error_sent 404, fn ->
        get(conn, ~p"/loans/#{loan}")
      end
    end
  end

  defp create_loan(_) do
    loan = loan_fixture()
    %{loan: loan}
  end
end
