defmodule Sum do
  defmacro defsum({type_name, _, arg}) when arg in [nil, []] do
    quote bind_quoted: binding() do
      type_clauses =
        Module.get_attribute(__MODULE__, :type)
        |> Sum.get_clauses!(__MODULE__, type_name)

      defmacro unquote(:"#{type_name}_case")(subject, do: case_clauses) do
        Sum.build_case!(
          unquote(type_name),
          subject,
          unquote(Macro.escape(type_clauses)),
          case_clauses
        )
      end
    end
  end

  @doc false
  def build_case!(name, item, types, case_clauses) do
    patterns =
      for {:->, _, [[pattern], _]} <- case_clauses do
        pattern
      end

    unmatched =
      Enum.filter(types, fn type ->
        not Enum.any?(patterns, &matches?(&1, type))
      end)

    if unmatched == [] do
      {:case, [], [item, [do: case_clauses]]}
    else
      raise(Sum.UnhandledClause, {__MODULE__, name, unmatched})
    end
  end

  @doc false
  def matches?(pattern, {:integer, _, _}) when is_integer(pattern) do
    true
  end

  def matches?(pattern, {:non_neg_integer, _, _}) when is_integer(pattern) and pattern >= 0 do
    true
  end

  def matches?(pattern, {:neg_integer, _, _}) when is_integer(pattern) and pattern < 0 do
    true
  end

  def matches?(pattern, {:pos_integer, _, _}) when is_integer(pattern) and pattern > 0 do
    true
  end

  def matches?(pattern, type) when is_integer(pattern) do
    pattern === type
  end

  def matches?(pattern, {:atom, _, _}) when is_atom(pattern) do
    true
  end

  def matches?(atom_literal, type) when is_atom(atom_literal) do
    atom_literal == type
  end

  # TODO: handle when
  # {:when, [line: 81], [1, {:is_list, [line: 81], [{:thing, [line: 81], nil}]}]}
  def matches?(_pattern, _type) do
    true
  end

  @doc false
  def get_clauses!(types, mod, name) do
    defs = parse_types(types)
    defs[name] || raise(Sum.TypeNotFound, {name, mod, defs})
  end

  @doc false
  def parse_types(types) when is_list(types) do
    for {:type, {:::, _, [{name, _, _}, clauses]}, _} <- types, into: %{} do
      {name, expand_clauses(clauses)}
    end
  end

  defp expand_clauses({:|, _, [clause, rest]}) do
    [clause | expand_clauses(rest)]
  end

  defp expand_clauses(clause) do
    [clause]
  end
end

defmodule Thingy do
  require Sum

  @type other :: {:ok, term}
  @type thing :: {:ok, term} | :ko
  @type t :: {:ok, term} | :error | :not_found | :another_one
  Sum.defsum(t)

  def run(thing) do
    t_case thing do
      {:ok, _} ->
        1

      :error ->
        2

      :not_found ->
        2

      :another_one ->
        2

        # 1 when is_list(thing) ->
        #   "one"

        # _ ->
        #   "not one"
    end
  end
end
