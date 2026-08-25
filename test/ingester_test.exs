defmodule SkyDataLake.IngesterTest do
  use ExUnit.Case, async: true
  alias SkyDataLake.Ingester

  test "accepts a bounded event and exposes metadata" do
    {:ok, :accepted, event, state} = Ingester.ingest(Ingester.new(), "analytics.api", "payload")
    assert event.source == "analytics.api"
    assert event.bytes == 7
    assert byte_size(event.sha256) == 64
    assert Ingester.count(state) == 1
  end

  test "deduplicates the same source and payload" do
    {:ok, :accepted, first, state} = Ingester.ingest(Ingester.new(), "source", "payload")
    {:ok, :duplicate, second, next} = Ingester.ingest(state, "source", "payload")
    assert first.id == second.id
    assert Ingester.count(next) == 1
  end

  test "rejects unsafe source and oversized payload" do
    assert_raise ArgumentError, fn -> Ingester.ingest(Ingester.new(), "bad source", "payload") end

    assert_raise ArgumentError, fn ->
      Ingester.ingest(Ingester.new(), "source", :binary.copy("x", 262_145))
    end
  end
end
