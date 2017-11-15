defmodule Sum.TypeNotFoundTest do
  use ExUnit.Case, async: true
  alias Sum.TypeNotFound

  test "exception/1" do
    types =
      %{
        other: [ok: {:term, [line: 34], nil}],
        t: [
          {:ok, {:term, [line: 37], nil}},
          :error,
          :maybe_ok
        ],
        thing: [{:ok, {:term, [line: 35], nil}}, :ko]
      }

    exception = TypeNotFound.exception({:twist, String, types})

    assert exception.message == """
           No typedef was found for defsum twist.

           Please add a typedef to Elixir.String

               @type twist :: any()

           Known Elixir.String types are:

               * other :: {:ok, term}
               * t :: {:ok, term} | :error | :maybe_ok
               * thing :: {:ok, term} | :ko
           """
  end
end
