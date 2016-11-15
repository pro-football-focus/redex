defmodule RedisExTest do
  use ExUnit.Case
  doctest RedisEx

  setup do
    RedisEx.flush
    :ok
  end

  test "can flush cache items" do
    RedisEx.Item.set("foo", "foo")
    assert RedisEx.Item.get("foo") == "foo"
    assert RedisEx.flush == "OK"
    assert RedisEx.Item.get("foo") == nil
  end

  test "can set cache item" do
    assert RedisEx.Item.set("bar", "bar") == true
  end

  test "can set an expiring cache item" do
    RedisEx.Item.set("baz", "baz", 1)
    assert RedisEx.Item.get("baz") == "baz"
    :timer.sleep(1500)
    assert RedisEx.Item.get("baz") == nil
  end

  test "can get cache item" do
    RedisEx.Item.set("baz", "baz")
    assert RedisEx.Item.get("baz") == "baz"
  end

  test "read-through function returns function value when not cached" do
    value = RedisEx.read_through("foo", fn -> 1 end)
    assert value == 1
  end

  test "read-through function returns cached value when cached" do
    RedisEx.Item.set("foo", 2)
    value = RedisEx.read_through("foo", fn -> 1 end)
    assert value == 2
  end
end
