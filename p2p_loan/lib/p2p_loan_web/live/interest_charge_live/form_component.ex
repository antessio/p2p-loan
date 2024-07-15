defmodule P2pLoanWeb.InterestChargeLive.FormComponent do
  use P2pLoanWeb, :live_component

  alias P2pLoan.Loans

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage interest_charge records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="interest_charge-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:debtor_id]} type="text" label="Debtor" />
        <.input field={@form[:loan_id]} type="text" label="Loan" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:due_date]} type="datetime-local" label="Due date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Interest charge</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{interest_charge: interest_charge} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Loans.change_interest_charge(interest_charge))
     end)}
  end

  @impl true
  def handle_event("validate", %{"interest_charge" => interest_charge_params}, socket) do
    changeset = Loans.change_interest_charge(socket.assigns.interest_charge, interest_charge_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"interest_charge" => interest_charge_params}, socket) do
    save_interest_charge(socket, socket.assigns.action, interest_charge_params)
  end

  defp save_interest_charge(socket, :edit, interest_charge_params) do
    case Loans.update_interest_charge(socket.assigns.interest_charge, interest_charge_params) do
      {:ok, interest_charge} ->
        notify_parent({:saved, interest_charge})

        {:noreply,
         socket
         |> put_flash(:info, "Interest charge updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_interest_charge(socket, :new, interest_charge_params) do
    case Loans.create_interest_charge(interest_charge_params) do
      {:ok, interest_charge} ->
        notify_parent({:saved, interest_charge})

        {:noreply,
         socket
         |> put_flash(:info, "Interest charge created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
