defmodule Sum.UnhandledClause do
  defexception [:message]

  def exception({mod, name, unhandled}) do
    list_doc =
      unhandled
      |> Enum.map(&"    * #{Macro.to_string(&1)}")
      |> Enum.join("\n")

    message =
      """
      The #{mod}.#{name}_case does not
      have patterns that match all values of #{mod}.#{name}.

      The following values are not handled:

      #{list_doc}

      Add new patterns to the #{name}_case that match these.
      """

    %__MODULE__{message: message}
  end
end
