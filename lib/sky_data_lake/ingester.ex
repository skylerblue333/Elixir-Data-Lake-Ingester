defmodule SkyDataLake.Ingester do
  @moduledoc "Bounded in-memory ingestion primitive for engineering use."

  @max_source_bytes 64
  @max_payload_bytes 262_144
  @max_events 10_000

  def new, do: %{events: %{}, order: []}

  def ingest(state, source, payload) when is_map(state) and is_binary(source) and is_binary(payload) do
    validate_source!(source)
    validate_payload!(payload)

    if map_size(state.events) >= @max_events do
      {:error, :capacity_reached, state}
    else
      hash = :crypto.hash(:sha256, source <> <<0>> <> payload) |> Base.encode16(case: :lower)

      case Map.fetch(state.events, hash) do
        {:ok, event} -> {:ok, :duplicate, event, state}
        :error ->
          event = %{id: hash, source: source, bytes: byte_size(payload), sha256: sha256(payload)}
          next = %{events: Map.put(state.events, hash, event), order: state.order ++ [hash]}
          {:ok, :accepted, event, next}
      end
    end
  end

  def list(state) do
    Enum.map(state.order, &Map.fetch!(state.events, &1))
  end

  def count(state), do: map_size(state.events)

  defp validate_source!(source) do
    if source == "" or byte_size(source) > @max_source_bytes or not Regex.match?(~r/^[A-Za-z0-9_.:-]+$/, source) do
      raise ArgumentError, "source must be 1-64 safe characters"
    end
  end

  defp validate_payload!(payload) do
    if byte_size(payload) == 0 or byte_size(payload) > @max_payload_bytes do
      raise ArgumentError, "payload must contain 1-262144 bytes"
    end
  end

  defp sha256(value), do: :crypto.hash(:sha256, value) |> Base.encode16(case: :lower)
end
