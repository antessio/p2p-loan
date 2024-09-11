defmodule P2pLoanWeb.Graphql.Resolvers.Account.AccountResolver do
  alias P2pLoanWeb.Graphql.Authentication
  alias P2pLoan.Accounts

  def signin(_resolver, %{email: email, password: password}, _context) do
    case Accounts.get_user_by_email_and_password(email, password) do

      %Accounts.User{} = user ->
        {:ok, %{token: Authentication.create(user)}}

      nil -> {:error, message: "signin failed"}
    end

    # case Accounts.authenticate(email, password) do
    #   {:ok, %Accounts.User{} = user} ->
    #     {:ok, %{token: AuthToken.create(user), user: %{email: user.email}}}

    #   {:error, changeset} ->
    #     {:error, message: "Signin failed!", details: GraphQL.Errors.extract(changeset)}
  end
end
