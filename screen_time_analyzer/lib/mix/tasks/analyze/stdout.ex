defmodule Mix.Tasks.Analyze.Stdout do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    screen_times = ScreenTimeAnalyzer.analyze(Enum.at(args, 0))

    Enum.each(screen_times, fn {date, screen_time} ->
      Mix.shell().info("#{Date.to_string(date)}: #{Time.to_string(screen_time)}")
    end)
  end
end
