defmodule Sum.TypeNotFound do
  defexception [:message]

  def exception({name, mod, types}) do
    message =
      """
      No typedef was found for defsum #{name}.

      Please add a typedef to #{mod}

          @type #{name} :: any()
      """ <> type_info(mod, types)

    %__MODULE__{message: message}
  end

  defp type_info(_, types) when map_size(types) == 0 do
    ""
  end

  defp type_info(mod, types) do
    build_li = fn {name, clauses} ->
      doc =
        clauses
        |> Enum.map(&Macro.to_string(&1))
        |> Enum.join(" | ")

      "    * #{name} :: #{doc}\n"
    end

    list =
      types
      |> Enum.map(build_li)
      |> Enum.join()

    """

    Known #{mod} types are:

    """ <> list
  end
end
