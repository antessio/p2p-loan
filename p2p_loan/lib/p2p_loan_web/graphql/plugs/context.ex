defmodule P2pLoanWeb.Graphql.Plugs.Context do
  alias P2pLoanWeb.Graphql.Authentication
  alias P2pLoan.Accounts
  @behaviour Plug
  import Plug.Conn
  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    IO.inspect(context)
    # Absinthe.Plug calls Absinthe.run() with the options added to the `conn`.
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  # Note this is a simple token auth strategy. This is should not be used in production.
  defp authorize(token) do
    Authentication.verify(token)
    |> case do
      nil -> {:error, "invalid authorization token"}
      {:error} -> {:error, "invalid authorization token"}
      {:ok, user_id} -> {:ok, Accounts.get_user!(user_id)}
    end
  end

end
