defmodule Mix.Tasks.Analyze.Csv do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    screen_times = ScreenTimeAnalyzer.analyze(Enum.at(args, 0))

    rows = Enum.map(screen_times, fn {date, screen_time} ->
      [date, screen_time]
    end)

    file = File.open!(Enum.at(args, 1), [:write, :utf8])
    rows |> CSV.encode |> Enum.each(&IO.write(file, &1))
  end
end
