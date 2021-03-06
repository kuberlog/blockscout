# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :block_scout_web,
  namespace: BlockScoutWeb,
  ecto_repos: [Explorer.Repo],
  version: System.get_env("BLOCKSCOUT_VERSION"),
  release_link: System.get_env("RELEASE_LINK"),
  decompiled_smart_contract_token: System.get_env("DECOMPILED_SMART_CONTRACT_TOKEN")

config :block_scout_web, BlockScoutWeb.Chain,
  network: System.get_env("NETWORK"),
  subnetwork: System.get_env("SUBNETWORK"),
  network_icon: System.get_env("NETWORK_ICON"),
  logo: System.get_env("LOGO"),
  logo_footer: System.get_env("LOGO_FOOTER"),
  has_emission_funds: false

config :block_scout_web,
  link_to_other_explorers: System.get_env("LINK_TO_OTHER_EXPLORERS") == "true",
  other_explorers: %{
    "Etherscan" => "https://etherscan.io/",
    "EtherChain" => "https://www.etherchain.org/",
    "Bloxy" => "https://bloxy.info/"
  },
  other_networks: System.get_env("SUPPORTED_CHAINS")

config :block_scout_web, BlockScoutWeb.Counters.BlocksIndexedCounter, enabled: true

# Configures the endpoint
config :block_scout_web, BlockScoutWeb.Endpoint,
  instrumenters: [BlockScoutWeb.Prometheus.Instrumenter, SpandexPhoenix.Instrumenter],
  url: [
    host: System.get_env("BLOCKSCOUT_HOST") || "localhost",
    path: System.get_env("NETWORK_PATH") || "/"
  ],
  render_errors: [view: BlockScoutWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BlockScoutWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :block_scout_web, BlockScoutWeb.Tracer,
  service: :block_scout_web,
  adapter: SpandexDatadog.Adapter,
  trace_key: :blockscout

# Configures gettext
config :block_scout_web, BlockScoutWeb.Gettext, locales: ~w(en), default_locale: "en"

config :block_scout_web, BlockScoutWeb.SocialMedia,
  twitter: "PoaNetwork",
  telegram: "poa_network",
  facebook: "PoaNetwork",
  instagram: "PoaNetwork"

# Configures History
config :block_scout_web,
chart_config: %{market: [:price,:market_cap], transactions: [:transactions_per_day]}

config :block_scout_web, BlockScoutWeb.Chain.TransactionHistoryChartController,
  history_size: 30 #days


config :ex_cldr,
  default_locale: "en",
  locales: ["en"],
  gettext: BlockScoutWeb.Gettext

config :logger, :block_scout_web,
  # keep synced with `config/config.exs`
  format: "$dateT$time $metadata[$level] $message\n",
  metadata:
    ~w(application fetcher request_id first_block_number last_block_number missing_block_range_count missing_block_count
       block_number step count error_count shrunk import_id transaction_id)a,
  metadata_filter: [application: :block_scout_web]

config :prometheus, BlockScoutWeb.Prometheus.Instrumenter,
  # override default for Phoenix 1.4 compatibility
  # * `:transport_name` to `:transport`
  # * remove `:vsn`
  channel_join_labels: [:channel, :topic, :transport],
  # override default for Phoenix 1.4 compatibility
  # * `:transport_name` to `:transport`
  # * remove `:vsn`
  channel_receive_labels: [:channel, :topic, :transport, :event]

config :spandex_phoenix, tracer: BlockScoutWeb.Tracer

config :wobserver,
  # return only the local node
  discovery: :none,
  mode: :plug

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
