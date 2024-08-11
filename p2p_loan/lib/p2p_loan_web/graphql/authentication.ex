defmodule P2pLoanWeb.Graphql.Authentication do

  @salt Application.compile_env(:p2p_loan, :salt)

  @max_age 60 * 60 * 24

  alias P2pLoanWeb.Endpoint

  def create(user) do
    Phoenix.Token.sign(Endpoint, @salt, user.id)
  end

  def verify(token) do
    Phoenix.Token.verify(Endpoint, @salt, token, max_age: @max_age)
  end

end
