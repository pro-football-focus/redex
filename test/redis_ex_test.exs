defmodule RedisExTest do
  use ExUnit.Case
  doctest RedisEx

  setup do
    RedisEx.flush
    :ok
  end

  test "can flush cache items" do
    RedisEx.Key.set("foo", "foo")
    assert RedisEx.Key.get("foo") == "foo"
    assert RedisEx.flush == "OK"
    assert RedisEx.Key.get("foo") == nil
  end

  test "can set cache item" do
    assert RedisEx.Key.set("bar", "bar") == true
  end

  test "can set an expiring cache item" do
    RedisEx.Key.set("baz", "baz", 1)
    assert RedisEx.Key.get("baz") == "baz"
    :timer.sleep(1500)
    assert RedisEx.Key.get("baz") == nil
  end

  test "can get cache item" do
    RedisEx.Key.set("baz", "baz")
    assert RedisEx.Key.get("baz") == "baz"
  end
end
