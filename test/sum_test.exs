defmodule SumTest do
  use ExUnit.Case
  doctest Sum

  describe "parse_types/1" do
    test "empty" do
      types = []
      assert Sum.parse_types(types) == %{}
    end

    test "single atom" do
      types = [
        {
          :type,
          quote(do: t :: :ok),
          {Mod, {18, 1}}
        }
      ]

      assert Sum.parse_types(types) == %{
               t: [:ok]
             }
    end

    test ":ok or :ko" do
      types = [
        {
          :type,
          quote(do: t :: :ok | :ko),
          {Mod, {18, 1}}
        }
      ]

      assert Sum.parse_types(types) == %{
               t: [:ok, :ko]
             }
    end

    test "many clauses" do
      types = [
        {
          :type,
          quote(do: t :: :a | :b | :c | :d | :e),
          {Mod, {18, 1}}
        }
      ]

      assert Sum.parse_types(types) == %{
               t: [:a, :b, :c, :d, :e]
             }
    end
  end
end
