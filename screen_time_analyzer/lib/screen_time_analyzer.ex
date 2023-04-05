defmodule ScreenTimeAnalyzer do
  def analyze(csv_file_path) do
    csv_file_path
    |> decode_csv_file
    |> drop_free_time
    |> drop_screen_off
    |> calculate_daily_screen_time
  end

  defp decode_csv_file(csv_file_path) do
    csv_file_path
    |> Path.expand(__DIR__)
    |> File.stream!
    |> CSV.decode
    |> drop_empty_rows
    |> drop_header_and_last_2_rows
    |> map_to_rows
  end

  defp drop_empty_rows(stream) do
    Enum.reject(stream, fn {_key, x} ->
      x == [""]
    end)
  end

  defp drop_header_and_last_2_rows(stream) do
    stream
    |> Enum.slice(1..-3)
  end

  defp map_to_rows(stream) do
    Enum.map(stream, fn {_key, [app_name, date, time, duration]} ->
      %Row{app_name: app_name, date: Row.parse_date(date), time: Row.parse_time(time), duration: Row.parse_time(duration)}
    end)
  end

  defp drop_free_time(rows) do
    Enum.reject(rows, fn %Row{date: date, time: time} ->
      Date.day_of_week(date) == 6 ||
        Date.day_of_week(date) == 7 ||
        Time.compare(time, ~T[09:00:00]) == :lt ||
        Time.compare(time, ~T[18:00:00]) == :gt
    end)
  end

  defp drop_screen_off(rows) do
     Enum.reject(rows, fn %Row{app_name: app_name} -> app_name == "Screen off (locked)" end)
  end

  defp calculate_daily_screen_time(rows) do
    Enum.reduce(rows, %{}, fn %Row{date: date, duration: duration}, screen_times ->
      old_duration = case Map.fetch(screen_times, date) do
        {:ok, old_duration} -> old_duration
        _ -> ~T[00:00:00]
      end

      {seconds, _} = Time.to_seconds_after_midnight(duration)
      Map.put(screen_times, date, Time.add(old_duration, seconds))
    end)
  end
end
