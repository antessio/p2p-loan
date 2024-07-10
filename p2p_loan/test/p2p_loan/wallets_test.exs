defmodule P2pLoan.WalletsTest do
  use P2pLoan.DataCase

  alias P2pLoan.Wallets

  describe "wallets" do
    alias P2pLoan.Wallets.Wallet

    import P2pLoan.WalletsFixtures

    @invalid_attrs %{currency: nil, owner_id: nil, amount: nil}

    test "list_wallets/0 returns all wallets" do
      wallet = wallet_fixture()
      assert Wallets.list_wallets() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Wallets.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      valid_attrs = %{currency: "some currency", owner_id: "some owner_id", amount: "120.5"}

      assert {:ok, %Wallet{} = wallet} = Wallets.create_wallet(valid_attrs)
      assert wallet.currency == "some currency"
      assert wallet.owner_id == "some owner_id"
      assert wallet.amount == Decimal.new("120.5")
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallets.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      update_attrs = %{currency: "some updated currency", owner_id: "some updated owner_id", amount: "456.7"}

      assert {:ok, %Wallet{} = wallet} = Wallets.update_wallet(wallet, update_attrs)
      assert wallet.currency == "some updated currency"
      assert wallet.owner_id == "some updated owner_id"
      assert wallet.amount == Decimal.new("456.7")
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallets.update_wallet(wallet, @invalid_attrs)
      assert wallet == Wallets.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Wallets.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Wallets.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Wallets.change_wallet(wallet)
    end
  end

  describe "wallets" do
    alias P2pLoan.Wallets.Wallet

    import P2pLoan.WalletsFixtures

    @invalid_attrs %{currency: nil, owner_id: nil, amount: nil}

    test "list_wallets/0 returns all wallets" do
      wallet = wallet_fixture()
      assert Wallets.list_wallets() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Wallets.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      valid_attrs = %{currency: "some currency", owner_id: "7488a646-e31f-11e4-aace-600308960662", amount: "120.5"}

      assert {:ok, %Wallet{} = wallet} = Wallets.create_wallet(valid_attrs)
      assert wallet.currency == "some currency"
      assert wallet.owner_id == "7488a646-e31f-11e4-aace-600308960662"
      assert wallet.amount == Decimal.new("120.5")
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallets.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      update_attrs = %{currency: "some updated currency", owner_id: "7488a646-e31f-11e4-aace-600308960668", amount: "456.7"}

      assert {:ok, %Wallet{} = wallet} = Wallets.update_wallet(wallet, update_attrs)
      assert wallet.currency == "some updated currency"
      assert wallet.owner_id == "7488a646-e31f-11e4-aace-600308960668"
      assert wallet.amount == Decimal.new("456.7")
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallets.update_wallet(wallet, @invalid_attrs)
      assert wallet == Wallets.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Wallets.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Wallets.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Wallets.change_wallet(wallet)
    end
  end
end
