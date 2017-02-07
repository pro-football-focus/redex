defmodule RedisEx.Item do

  # Get a key from the Redis server using a random worker
  def get(key) do
    case Redix.command(RedisEx.random_worker(), ["GET", key]) do
      {:ok, value} when value != nil -> :erlang.binary_to_term(value)
      _ -> nil
    end
  end

  # Set a key in the Redis server using a random worker
  def set(key, value, expires \\ nil) do
    result = case expires do
      nil -> Redix.command(RedisEx.random_worker(), ["SET", key, :erlang.term_to_binary(value)])
      _ -> Redix.command(RedisEx.random_worker(), ["SETEX", key, expires, :erlang.term_to_binary(value)])
    end
    case result do
      {:ok, "OK"} -> true
      _ -> false
    end
  end

end
