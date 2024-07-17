defmodule P2pLoanWeb.GraphQl.Router do
  use Plug.Router

  plug :match
  plug :dispatch



  forward "/graphql",
    to: Absinthe.Plug,
    init_opts: [
      schema: P2pLoanWeb.GraphQL.Schema
    ]


  forward "/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [
      interface: :playground,
      schema: P2pLoanWeb.GraphQL.Schema
    ]

end
