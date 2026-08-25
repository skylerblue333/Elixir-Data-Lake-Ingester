FROM elixir:1.17-alpine AS builder
WORKDIR /workspace
COPY mix.exs ./
COPY lib ./lib
RUN mix escript.build

FROM elixir:1.17-alpine
RUN addgroup -g 10001 appuser \
    && adduser -D -u 10001 -G appuser appuser
WORKDIR /app
COPY --from=builder /workspace/sky_data_lake /app/sky_data_lake
USER 10001:10001
ENTRYPOINT ["/app/sky_data_lake"]
