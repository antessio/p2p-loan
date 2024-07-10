defmodule P2pLoanWeb.ErrorJSONTest do
  use P2pLoanWeb.ConnCase, async: true

  test "renders 404" do
    assert P2pLoanWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert P2pLoanWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
