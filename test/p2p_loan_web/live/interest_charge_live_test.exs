defmodule P2pLoanWeb.InterestChargeLiveTest do
  use P2pLoanWeb.ConnCase

  import Phoenix.LiveViewTest
  import P2pLoan.LoansFixtures

  @create_attrs %{status: "some status", debtor_id: "7488a646-e31f-11e4-aace-600308960662", loan_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5", due_date: "2024-07-14T13:16:00Z"}
  @update_attrs %{status: "some updated status", debtor_id: "7488a646-e31f-11e4-aace-600308960668", loan_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7", due_date: "2024-07-15T13:16:00Z"}
  @invalid_attrs %{status: nil, debtor_id: nil, loan_id: nil, amount: nil, due_date: nil}

  defp create_interest_charge(_) do
    interest_charge = interest_charge_fixture()
    %{interest_charge: interest_charge}
  end

  describe "Index" do
    setup [:create_interest_charge]

    test "lists all interest_chargges", %{conn: conn, interest_charge: interest_charge} do
      {:ok, _index_live, html} = live(conn, ~p"/interest_chargges")

      assert html =~ "Listing Interest chargges"
      assert html =~ interest_charge.status
    end

    test "saves new interest_charge", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/interest_chargges")

      assert index_live |> element("a", "New Interest charge") |> render_click() =~
               "New Interest charge"

      assert_patch(index_live, ~p"/interest_chargges/new")

      assert index_live
             |> form("#interest_charge-form", interest_charge: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#interest_charge-form", interest_charge: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/interest_chargges")

      html = render(index_live)
      assert html =~ "Interest charge created successfully"
      assert html =~ "some status"
    end

    test "updates interest_charge in listing", %{conn: conn, interest_charge: interest_charge} do
      {:ok, index_live, _html} = live(conn, ~p"/interest_chargges")

      assert index_live |> element("#interest_chargges-#{interest_charge.id} a", "Edit") |> render_click() =~
               "Edit Interest charge"

      assert_patch(index_live, ~p"/interest_chargges/#{interest_charge}/edit")

      assert index_live
             |> form("#interest_charge-form", interest_charge: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#interest_charge-form", interest_charge: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/interest_chargges")

      html = render(index_live)
      assert html =~ "Interest charge updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes interest_charge in listing", %{conn: conn, interest_charge: interest_charge} do
      {:ok, index_live, _html} = live(conn, ~p"/interest_chargges")

      assert index_live |> element("#interest_chargges-#{interest_charge.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#interest_chargges-#{interest_charge.id}")
    end
  end

  describe "Show" do
    setup [:create_interest_charge]

    test "displays interest_charge", %{conn: conn, interest_charge: interest_charge} do
      {:ok, _show_live, html} = live(conn, ~p"/interest_chargges/#{interest_charge}")

      assert html =~ "Show Interest charge"
      assert html =~ interest_charge.status
    end

    test "updates interest_charge within modal", %{conn: conn, interest_charge: interest_charge} do
      {:ok, show_live, _html} = live(conn, ~p"/interest_chargges/#{interest_charge}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Interest charge"

      assert_patch(show_live, ~p"/interest_chargges/#{interest_charge}/show/edit")

      assert show_live
             |> form("#interest_charge-form", interest_charge: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#interest_charge-form", interest_charge: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/interest_chargges/#{interest_charge}")

      html = render(show_live)
      assert html =~ "Interest charge updated successfully"
      assert html =~ "some updated status"
    end
  end
end
