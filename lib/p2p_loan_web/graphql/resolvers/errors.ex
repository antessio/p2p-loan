defmodule P2pLoanWeb.GraphQL.Error do

  def charset_error_to_string(changeset)do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
      |> Enum.map(fn {key, errors} -> "#{key}: #{Enum.join(errors, ", ")}" end)
      |> Enum.join("\n")
  end

end
