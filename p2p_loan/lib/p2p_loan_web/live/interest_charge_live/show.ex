defmodule P2pLoanWeb.InterestChargeLive.Show do
  use P2pLoanWeb, :live_view

  alias P2pLoan.Loans

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:interest_charge, Loans.get_interest_charge!(id))}
  end

  defp page_title(:show), do: "Show Interest charge"
  defp page_title(:edit), do: "Edit Interest charge"
end
