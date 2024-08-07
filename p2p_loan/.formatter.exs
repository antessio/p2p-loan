[
  import_deps: [:ecto, :ecto_sql, :phoenix, :absinthe],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter, Absinthe.Formatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs","{lib,priv}/**/*.{gql,graphql}"]
]
