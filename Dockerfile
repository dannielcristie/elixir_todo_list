FROM elixir:1.15

# Install build dependencies
# inotify-tools is useful for live reload in dev
RUN apt-get update && \
    apt-get install -y build-essential inotify-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files first to cache dependencies
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get

# Copy the rest of the application
COPY . .

# Ensure dependencies are up to date (fixes git dep issues)
RUN mix deps.get

# Compile the application
RUN mix compile

# Expose the Phoenix port
EXPOSE 4000

# Start the server
# We run setup to ensure assets and db are ready
CMD ["sh", "-c", "mix setup && mix phx.server"]
