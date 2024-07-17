defmodule P2pLoanWeb.Router do
  use P2pLoanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {P2pLoanWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", P2pLoanWeb do
    pipe_through :api
    forward "/api", GraphQl.Router
  end

  scope "/", P2pLoanWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/wallets", WalletController, only: [:create, :delete, :show, :index, :new]
    get "/wallets/:owner_id/my", WalletController, :show_my
    resources "/loans", LoanController
    put "/loans/:id/contributors", LoanController, :add_contributor
    get "/loans/:id/add_contributor", LoanController, :get_add_contributor
    delete "/loans/:id/contributors/:contributor_id", LoanController, :delete_contributor
    post "/loans/:id/issue", LoanController, :issue
    get "/loans/:id/interest_charges", LoanController, :get_interest_charges
    put "/wallets/:id/topup", WalletController, :topup
    get "/wallets/:id/editTopUp", WalletController, :editTopup
  end

  # Other scopes may use custom stacks.
  # scope "/api", P2pLoanWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:p2p_loan, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: P2pLoanWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
