defmodule Mix.Tasks.Casino.Run do
  use Mix.Task

  @doc false
  def run(_args) do
    Application.ensure_all_started(:casino)

    {:ok, pid} = Casino.Table.start_link(self())

    receive do
      {:done, _state} ->
        GenServer.stop(pid, :shutdown)
    end
  end
end
