defmodule Lab1Test do
  use ExUnit.Case
  doctest Lab1

  test "greets the world" do
    assert Lab1.hello() == :world
  end
end
