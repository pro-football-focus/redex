defmodule RedisEx do
  use Application

  # Define how many workers in the connection pool we want
  @worker_count 10

  # Handle the startup of the application
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Get the redis_ex configuration
    redis_hostname = Application.get_env(:redis_ex, :redis_hostname)
    redis_port = Application.get_env(:redis_ex, :redis_port)

    # Create our Redix worker pool
    redis_workers = for i <- 0..@worker_count do
      worker(Redix, ["redis://#{redis_hostname}:#{redis_port}", [name: :"redix_#{i}"]], id: {Redix, i})
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
end
