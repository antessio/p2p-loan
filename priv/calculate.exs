target_date = Date.from_iso8601!("2024-07-21")
interest_charges = [
  %{id: 1, due_date: Date.from_iso8601!("2024-06-01"), amount: 300, status: :pending},
  %{id: 2, due_date: Date.from_iso8601!("2024-07-22"), amount: 500, status: :pending},
  %{id: 3, due_date: Date.from_iso8601!("2024-07-10"), amount: 100, status: :pending}
]
owner_wallet = %{id: 1, amount: 230}
interest_charges
|> Enum.filter(fn interest_charge -> interest_charge.due_date < target_date end)
|> Enum.reduce({owner_wallet,[]}, fn interest_charge_elem, {wallet, updated_interest_charges} ->
  case interest_charge_elem do
    i when i.amount <= wallet.amount -> {%{id: wallet.id, amount: wallet.amount - i.amount}, [Map.merge(i, %{status: :paid }) | updated_interest_charges]}
    i when i.amount > wallet.amount -> {wallet, [Map.merge(i, %{status: :expired}) | updated_interest_charges]}
  end
  end)
