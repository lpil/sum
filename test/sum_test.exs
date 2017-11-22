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
    import Sum, only: [matches?: 2]

    test "variable pattern matches anything" do
      assert matches?(quote(do: var), 1)
      assert matches?(quote(do: var), 1.2)
      assert matches?(quote(do: var), :ok)
      assert matches?(quote(do: var), {})
      assert matches?(quote(do: var), {1})
      assert matches?(quote(do: var), {1, []})
      assert matches?(quote(do: var), {1, [], %{}})
      assert matches?(quote(do: var), [])
      assert matches?(quote(do: var), [1])
      assert matches?(quote(do: var), [1, []])
      assert matches?(quote(do: var), [1, [], %{}])
      assert matches?(quote(do: var), %{})
      assert matches?(quote(do: var), %{name: "Sarah"})
      assert matches?(quote(do: var), %__MODULE__{})
      assert matches?(quote(do: var), %__MODULE__{field: 1})
      assert matches?(quote(do: var), quote(do: whatever))
    end

    test "atom pattern with atoms" do
      assert matches?(:ok, :ok)
      refute matches?(:ok, :nope)
    end

    test "atom pattern with types" do
      assert matches?(:ok, quote(do: atom))
      assert matches?(:ok, quote(do: atom()))
      refute matches?(:ok, quote(do: integer))
      refute matches?(:ok, quote(do: integer()))
      refute matches?(:ok, quote(do: non_neg_integer))
      refute matches?(:ok, quote(do: non_neg_integer()))
      refute matches?(:ok, quote(do: pos_integer))
      refute matches?(:ok, quote(do: pos_integer()))
    end

    test "atom pattern with ints" do
      refute matches?(:ok, 1)
    end

    test "atom pattern with floats" do
      refute matches?(:ok, 1.1)
      refute matches?(:ok, 1.1)
    end

    test "atom pattern with tuples" do
      refute matches?(:ok, {})
      refute matches?(:ok, {1})
      refute matches?(:ok, {1, []})
      refute matches?(:ok, {1, [], %{}})
    end

    test "atom pattern with lists" do
      refute matches?(:ok, [])
      refute matches?(:ok, [1])
      refute matches?(:ok, [1, []])
      refute matches?(:ok, [1, [], %{}])
    end

    test "atom pattern with maps" do
      refute matches?(:ok, %{})
      refute matches?(:ok, %{name: "Sarah"})
      refute matches?(:ok, %__MODULE__{})
      refute matches?(:ok, %__MODULE__{field: 1})
    end

    test "atom pattern with variables" do
      refute matches?(:ok, quote(do: whatever))
    end

    test "atom pattern with calls" do
      refute matches?(:ok, quote(do: whatever()))
    end

    test "positive integer pattern with ints" do
      assert matches?(1, 1)
      refute matches?(1, 2)
      refute matches?(1, 0)
      refute matches?(1, -1)
    end

    test "positive integer pattern with types" do
      assert matches?(1, quote(do: integer))
      assert matches?(1, quote(do: integer()))
      assert matches?(1, quote(do: non_neg_integer))
      assert matches?(1, quote(do: non_neg_integer()))
      assert matches?(1, quote(do: pos_integer))
      assert matches?(1, quote(do: pos_integer()))
      refute matches?(1, quote(do: neg_integer))
      refute matches?(1, quote(do: neg_integer()))
      refute matches?(1, quote(do: atom()))
    end

    test "positive integer pattern with atoms" do
      refute matches?(1, :nope)
    end

    test "positive integer pattern with floats" do
      refute matches?(1, 1.1)
      refute matches?(1, 1.0)
    end

    test "positive integer pattern with tuples" do
      refute matches?(1, {})
      refute matches?(1, {1})
      refute matches?(1, {1, []})
      refute matches?(1, {1, [], %{}})
    end

    test "positive integer pattern with lists" do
      refute matches?(1, [])
      refute matches?(1, [1])
      refute matches?(1, [1, []])
      refute matches?(1, [1, [], %{}])
    end

    test "positive integer pattern with maps" do
      refute matches?(1, %{})
      refute matches?(1, %{name: "Sarah"})
      refute matches?(1, %__MODULE__{})
      refute matches?(1, %__MODULE__{field: 1})
    end

    test "positive integer pattern with variables" do
      refute matches?(1, quote(do: whatever))
    end

    test "positive integer pattern with calls" do
      refute matches?(1, quote(do: whatever()))
    end

    test "0 integer pattern with integers" do
      assert matches?(0, 0)
      refute matches?(0, 1)
      refute matches?(0, -1)
    end

    test "0 integer pattern with types" do
      assert matches?(0, quote(do: integer))
      assert matches?(0, quote(do: integer()))
      assert matches?(0, quote(do: non_neg_integer))
      assert matches?(0, quote(do: non_neg_integer()))
      refute matches?(0, quote(do: neg_integer))
      refute matches?(0, quote(do: neg_integer()))
      refute matches?(0, quote(do: pos_integer))
      refute matches?(0, quote(do: pos_integer()))
      refute matches?(0, quote(do: atom()))
    end

    test "0 integer pattern with atoms" do
      refute matches?(0, :nope)
    end

    test "0 integer pattern with floats" do
      refute matches?(0, 1.1)
      refute matches?(0, 1.1)
    end

    test "0 integer pattern with tuples" do
      refute matches?(0, {})
      refute matches?(0, {1})
      refute matches?(0, {1, []})
      refute matches?(0, {1, [], %{}})
    end

    test "0 integer pattern with lists" do
      refute matches?(0, [])
      refute matches?(0, [1])
      refute matches?(0, [1, []])
      refute matches?(0, [1, [], %{}])
    end

    test "0 integer pattern with maps" do
      refute matches?(0, %{})
      refute matches?(0, %{name: "Sarah"})
      refute matches?(0, %__MODULE__{})
      refute matches?(0, %__MODULE__{field: 1})
    end

    test "0 integer pattern with variables" do
      refute matches?(0, quote(do: whatever))
    end

    test "0 integer pattern with calls" do
      refute matches?(0, quote(do: whatever()))
    end

    test "negative integer pattern matches itself" do
      assert matches?(-1, -1)
      refute matches?(-1, 0)
      refute matches?(-1, -2)
    end

    test "negative integer pattern matches negative int type" do
      assert matches?(-1, quote(do: neg_integer))
      assert matches?(-1, quote(do: neg_integer()))
    end

    test "negative integer pattern matches int type" do
      assert matches?(-1, quote(do: integer))
      assert matches?(-1, quote(do: integer()))
    end

    test "negative integer pattern with types" do
      refute matches?(-1, quote(do: non_neg_integer))
      refute matches?(-1, quote(do: non_neg_integer()))
      refute matches?(-1, quote(do: pos_integer))
      refute matches?(-1, quote(do: pos_integer()))
      refute matches?(-1, quote(do: atom()))
    end

    test "negative integer pattern with atoms" do
      refute matches?(-1, :nope)
    end

    test "negative integer pattern with floats" do
      refute matches?(-1, 1.1)
    end

    test "negative integer pattern with lists" do
      refute matches?(-1, [])
      refute matches?(-1, [1])
      refute matches?(-1, [1, []])
      refute matches?(-1, [1, [], %{}])
    end

    test "negative integer pattern with tuples" do
      refute matches?(-1, {1})
      refute matches?(-1, {})
      refute matches?(-1, {1})
      refute matches?(-1, {1, []})
      refute matches?(-1, {1, [], %{}})
    end

    test "negative integer pattern with maps" do
      refute matches?(-1, %{})
      refute matches?(-1, %{name: "Sarah"})
      refute matches?(-1, %__MODULE__{})
      refute matches?(-1, %__MODULE__{field: 1})
    end

    test "negative integer pattern with variables" do
      refute matches?(-1, quote(do: whatever))
    end

    test "negative integer pattern with calls" do
      refute matches?(-1, quote(do: whatever()))
    end
  end
end
