defmodule SkyDataLake.MixProject do
  use Mix.Project

  def project do
    [
      app: :sky_data_lake,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: [],
      escript: [main_module: SkyDataLake.CLI]
    ]
  end

  def application do
    [extra_applications: [:crypto]]
  end
end
