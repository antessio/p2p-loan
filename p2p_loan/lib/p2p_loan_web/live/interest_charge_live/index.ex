defmodule P2pLoanWeb.InterestChargeLive.Index do
  use P2pLoanWeb, :live_view

  alias P2pLoan.Loans
  alias P2pLoan.Loans.InterestCharge

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :interest_chargges, Loans.list_interest_chargges())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Interest charge")
    |> assign(:interest_charge, Loans.get_interest_charge!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Interest charge")
    |> assign(:interest_charge, %InterestCharge{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interest chargges")
    |> assign(:interest_charge, nil)
  end

  @impl true
  def handle_info({P2pLoanWeb.InterestChargeLive.FormComponent, {:saved, interest_charge}}, socket) do
    {:noreply, stream_insert(socket, :interest_chargges, interest_charge)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interest_charge = Loans.get_interest_charge!(id)
    {:ok, _} = Loans.delete_interest_charge(interest_charge)

    {:noreply, stream_delete(socket, :interest_chargges, interest_charge)}
  end
end
