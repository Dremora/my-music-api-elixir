defmodule MyMusic.Helpers do
  import Ecto.Changeset

  def trim_fields(changeset, fields) do
    Enum.reduce(
      fields,
      changeset,
      &update_change(&2, &1, fn
        nil -> nil
        value -> String.trim(value)
      end)
    )
  end
end
