defmodule P2pLoanWeb.GraphQL.Schema do
  use Absinthe.Schema
  alias P2pLoan.Loans
  alias P2pLoan.Wallets

  import_types Absinthe.Type.Custom

  object :loan do
    field :id, non_null(:id)
    field :status, non_null(:string)
    field :user_id, non_null(:string)
    field :amount, non_null(:decimal)
    field :interest_rate, :decimal
  end

  object :wallet do
    field :id, non_null(:id)
    field :amount, non_null(:decimal)
    field :owner_id, non_null(:string)
  end

  query do

    field :get_loan, :loan do
      arg :id, non_null(:id)

      resolve fn %{id: id}, _ -> {:ok, Loans.get_loan!(id)} end
    end

    field :get_wallets, list_of(:wallet) do

      resolve fn _, _ -> {:ok, Wallets.list_wallets()} end
    end

  end

  mutation do
    field :create_wallet, non_null(:wallet) do
      arg :amount, non_null(:decimal)
      arg :owner_id, non_null(:string)
      arg :currency, non_null(:string)

      resolve &create_wallet/2
    end
  end

  def print_changeset_error(changeset)do
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)

    error_msg =
      errors
      |> Enum.map(fn {key, errors} -> "#{key}: #{Enum.join(errors, ", ")}" end)
      |> Enum.join("\n")
  end
  def create_wallet(args, _resolution) do
    case Wallets.create_wallet(args) do
      {:ok, wallet } -> {:ok, wallet}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, "Changeset error #{print_changeset_error(changeset)}"}
      _ -> {:error, "Unexpected error"}
    end
  end


end
