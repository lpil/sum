defmodule SumTest do
  use ExUnit.Case
  doctest Sum

  defstruct [:field]

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

  describe "build_case!/4" do
    # TODO
  end

  describe "matches?" do
    test "variable matches anything" do
      assert Sum.matches?(quote(do: var), 1)
      assert Sum.matches?(quote(do: var), 1.2)
      assert Sum.matches?(quote(do: var), :ok)
      assert Sum.matches?(quote(do: var), {})
      assert Sum.matches?(quote(do: var), {1})
      assert Sum.matches?(quote(do: var), {1, []})
      assert Sum.matches?(quote(do: var), {1, [], %{}})
      assert Sum.matches?(quote(do: var), [])
      assert Sum.matches?(quote(do: var), [1])
      assert Sum.matches?(quote(do: var), [1, []])
      assert Sum.matches?(quote(do: var), [1, [], %{}])
      assert Sum.matches?(quote(do: var), %{})
      assert Sum.matches?(quote(do: var), %{name: "Sarah"})
      assert Sum.matches?(quote(do: var), %__MODULE__{})
      assert Sum.matches?(quote(do: var), %__MODULE__{field: 1})
      assert Sum.matches?(quote(do: var), quote(do: whatever))
    end

    test "matching atoms" do
      assert Sum.matches?(:ok, :ok)
      assert Sum.matches?(:ok, quote(do: atom))
      assert Sum.matches?(:ok, quote(do: atom()))
    end

    test "unmatching atom patterns" do
      refute Sum.matches?(:ok, :nope)
      refute Sum.matches?(:ok, 1)
      refute Sum.matches?(:ok, 1.1)
      refute Sum.matches?(:ok, 1.1)
      refute Sum.matches?(:ok, [1])
      refute Sum.matches?(:ok, {1})
      refute Sum.matches?(:ok, {})
      refute Sum.matches?(:ok, {1})
      refute Sum.matches?(:ok, {1, []})
      refute Sum.matches?(:ok, {1, [], %{}})
      refute Sum.matches?(:ok, [])
      refute Sum.matches?(:ok, [1])
      refute Sum.matches?(:ok, [1, []])
      refute Sum.matches?(:ok, [1, [], %{}])
      refute Sum.matches?(:ok, %{})
      refute Sum.matches?(:ok, %{name: "Sarah"})
      refute Sum.matches?(:ok, %__MODULE__{})
      refute Sum.matches?(:ok, %__MODULE__{field: 1})
      refute Sum.matches?(:ok, quote(do: whatever))
    end
  end
end
