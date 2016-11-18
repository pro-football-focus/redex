defmodule RedisEx do
  use Application

  # Define how many workers in the connection pool we want
  @worker_count 10

  # Handle the startup of the application
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Get the redis_ex configuration
    hostname = Application.get_env(:redis_ex, :hostname)
    port = Application.get_env(:redis_ex, :port)

    # Create our Redix worker pool
    redis_workers = for i <- 0..@worker_count do
      worker(Redix, ["redis://#{hostname}:#{port}", [name: :"redix_#{i}"]], id: {Redix, i})
    end

    # Start the worker pool
    Supervisor.start_link(redis_workers, strategy: :one_for_one, name: RedisEx.Supervisor)
  end

  # Select a random worker from the pool
  def random_worker do
    random = rem(System.unique_integer([:positive]), @worker_count)
    :"redix_#{random}"
  end

  # Flush items from the currently selected Redis server database
  def flush() do
    Redix.command!(random_worker, ["FLUSHDB"])
  end

  @default_expires cache_10_minutes

  # Read-through cache function
  def read_through(key, func, expires \\ @default_expires) do
    case RedisEx.Item.get(key) do
      nil ->
        case func.() do
          nil -> nil
          value ->
            RedisEx.Item.set(key, value, expires)
            value
        end
      value -> value
    end
  end

  # Readable cache times
  def cache_1_day, do: 60*60*24
  def cache_1_hour, do: 60*60
  def cache_10_minutes, do: 60*10
  def cache_1_minute, do: 60

end
