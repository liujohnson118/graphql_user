defmodule CommunicationProcess do
  require IEx
  @five_seconds :timer.seconds(5)

  def create_process do
    IO.inspect "Starting process from #{inspect self()}"

    spawn(fn ->
      current_pid = self()

      receive do
        msg -> IO.inspect "#{inspect current_pid} - Received message: #{inspect msg}"
      after
        @five_seconds -> IO.puts "#{inspect current_pid} - Timeout"
      end
    end)
  end
end
