defmodule P2pLoanWeb.ContributionControllerTest do
  use P2pLoanWeb.ConnCase

  import P2pLoan.LoansFixtures

  @create_attrs %{currency: "some currency", contributor_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5"}
  @update_attrs %{currency: "some updated currency", contributor_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7"}
  @invalid_attrs %{currency: nil, contributor_id: nil, amount: nil}

  describe "index" do
    test "lists all contributions", %{conn: conn} do
      conn = get(conn, ~p"/contributions")
      assert html_response(conn, 200) =~ "Listing Contributions"
    end
  end

  describe "new contribution" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/contributions/new")
      assert html_response(conn, 200) =~ "New Contribution"
    end
  end

  describe "create contribution" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/contributions", contribution: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/contributions/#{id}"

      conn = get(conn, ~p"/contributions/#{id}")
      assert html_response(conn, 200) =~ "Contribution #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/contributions", contribution: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Contribution"
    end
  end

  describe "edit contribution" do
    setup [:create_contribution]

    test "renders form for editing chosen contribution", %{conn: conn, contribution: contribution} do
      conn = get(conn, ~p"/contributions/#{contribution}/edit")
      assert html_response(conn, 200) =~ "Edit Contribution"
    end
  end

  describe "update contribution" do
    setup [:create_contribution]

    test "redirects when data is valid", %{conn: conn, contribution: contribution} do
      conn = put(conn, ~p"/contributions/#{contribution}", contribution: @update_attrs)
      assert redirected_to(conn) == ~p"/contributions/#{contribution}"

      conn = get(conn, ~p"/contributions/#{contribution}")
      assert html_response(conn, 200) =~ "some updated currency"
    end

    test "renders errors when data is invalid", %{conn: conn, contribution: contribution} do
      conn = put(conn, ~p"/contributions/#{contribution}", contribution: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Contribution"
    end
  end

  describe "delete contribution" do
    setup [:create_contribution]

    test "deletes chosen contribution", %{conn: conn, contribution: contribution} do
      conn = delete(conn, ~p"/contributions/#{contribution}")
      assert redirected_to(conn) == ~p"/contributions"

      assert_error_sent 404, fn ->
        get(conn, ~p"/contributions/#{contribution}")
      end
    end
  end

  defp create_contribution(_) do
    contribution = contribution_fixture()
    %{contribution: contribution}
  end
end
