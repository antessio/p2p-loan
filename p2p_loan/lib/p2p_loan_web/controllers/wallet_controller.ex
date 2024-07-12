defmodule P2pLoanWeb.WalletController do
  use P2pLoanWeb, :controller

  alias P2pLoan.Wallets
  alias P2pLoan.Wallets.Wallet

  def index(conn, _params) do
    wallets = Wallets.list_wallets()
    render(conn, :index, wallets: wallets)
  end

  def new(conn, _params) do
    changeset = Wallets.change_wallet(%Wallet{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    case Wallets.create_wallet(wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet created successfully.")
        |> redirect(to: ~p"/wallets/#{wallet}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    wallet = Wallets.get_wallet!(id)
    render(conn, :show, wallet: wallet)
  end

  def show_my(conn, %{"owner_id" => owner_id}) do
    wallet = Wallets.get_wallet_by_owner_id(owner_id)
    render(conn, :show, wallet: wallet)
  end

  def edit(conn, %{"id" => id}) do
    wallet = Wallets.get_wallet!(id)
    changeset = Wallets.change_wallet(wallet)
    render(conn, :edit, wallet: wallet, changeset: changeset)
  end

  def editTopup(conn, %{"id" => id}) do
    wallet = Wallets.get_wallet!(id)
    changeset = Wallets.change_wallet(wallet)
    render(conn, :topup, wallet: wallet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Wallets.get_wallet!(id)

    case Wallets.update_wallet(wallet, wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet updated successfully.")
        |> redirect(to: ~p"/wallets/#{wallet}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, wallet: wallet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Wallets.get_wallet!(id)
    {:ok, _wallet} = Wallets.delete_wallet(wallet)

    conn
    |> put_flash(:info, "Wallet deleted successfully.")
    |> redirect(to: ~p"/wallets")
  end

  def topup(conn, %{"id" => id, "wallet" => %{"increase" => increase}})do
    wallet = Wallets.get_wallet!(id)
    |> Wallets.top_up(Decimal.new(increase))
    conn
        |> put_flash(:info, "Wallet topped up successfully.")
        |> redirect(to: ~p"/wallets/#{wallet}")
  end
end
