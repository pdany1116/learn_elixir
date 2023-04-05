defmodule Row do
  defstruct app_name: nil, date: nil, time: nil, duration: nil

  def parse_time(string_time) do
    [hour, minutes, seconds] = String.split(string_time, ":") |> map_strings_to_ints
    {_error, time} = Time.new(hour, minutes, seconds)
    time
  end

  def parse_date(string_date) do
    [day, month, year] = String.split(string_date, "/") |> map_strings_to_ints
    {_error, date} = Date.new(year, month, day)
    date
  end

  defp map_strings_to_ints(strings) do
    Enum.map(strings, fn value ->
      {int_value, _rest} = Integer.parse(value)
      int_value
    end)
  end
end
