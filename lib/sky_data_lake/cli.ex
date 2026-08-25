defmodule SkyDataLake.CLI do
  alias SkyDataLake.Ingester

  def main(_args) do
    state = Ingester.new()
    {:ok, :accepted, event, state} = Ingester.ingest(state, "smoke", "hello")

    IO.puts(
      "{\"service\":\"sky-data-lake-ingester\",\"status\":\"ready\",\"events\":#{Ingester.count(state)},\"id\":\"#{event.id}\"}"
    )
  end
end
