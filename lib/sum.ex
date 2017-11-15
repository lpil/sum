defmodule Sum do
  defmacro defsum({name, _, arg}) when arg in [nil, []] do
    quote do
      name = unquote(name)

      types =
        Module.get_attribute(__MODULE__, :type)
        |> Sum.parse_types()

      clauses = types[name] || raise Sum.TypeNotFound, {name, __MODULE__, types}
    end
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
  @type t ::
          {:ok, term}
          | :error
          | :not_found
          | :another_one
          | :and_another
          | :one_last_one
          | :do_i_seriously_need_another
  Sum.defsum(t)
end
