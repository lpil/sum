defmodule Sum.UnhandledClauseTest do
  use ExUnit.Case, async: true
  alias Sum.UnhandledClause

  test "exception/1" do
    types =
      [
        {:ok, {:term, [line: 37], nil}},
        :error,
        :maybe_ok
      ]

    exception = UnhandledClause.exception({Client, :result, types})

    assert exception.message == """
           The Elixir.Client.result_case does not
           have patterns that match all values of Elixir.Client.result.

           The following values are not handled:

               * {:ok, term}
               * :error
               * :maybe_ok

           Add new clauses to the result_case to match these.
           """
  end
end
