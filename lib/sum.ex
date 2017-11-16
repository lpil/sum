defmodule Sum do
  defmacro defsum({name, _, arg}) when arg in [nil, []] do
    quote bind_quoted: binding() do
      type_clauses =
        Module.get_attribute(__MODULE__, :type)
        |> Sum.get_clauses!(name)

      defmacro unquote(:"#{name}_case")(item, do: clauses) do
        # TODO: Check all cases are accounted for
        {:case, [], [item, [do: clauses]]}
      end
    end
  end

  @doc false
  def get_clauses!(types, name) do
    defs = parse_types(types)
    defs[name] || raise(Sum.TypeNotFound, {name, __MODULE__, defs})
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
      1 ->
        "one"

      _ ->
        "not one"
    end
  end
end
