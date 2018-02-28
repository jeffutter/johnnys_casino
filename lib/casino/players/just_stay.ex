defmodule Casino.Player.JustStay do
  use GenServer
  require Logger

  # Client

  def start_link([table_pid]) do
    GenServer.start_link(__MODULE__, [table_pid], [name: __MODULE__])
  end

  def init([table_pid]) do

    {:ok, %{table_pid: table_pid, history: [], current_hand: []}}
  end

  def dealt_card(card) do
    GenServer.cast(__MODULE__, {:dealt_card, card})
  end

  def deck_shuffled() do
    GenServer.cast(__MODULE__, :deck_shuffled)
  end

  def hit_or_stay() do
    GenServer.call(__MODULE__, :hit_or_stay)
  end

  def handle_call(:hit_or_stay, _from, state) do
    {:reply, :stay, state}
  end

  def handle_info({:card, card}, state) do
    Logger.info("(#{__MODULE__}) we were dealt a #{inspect(card)}")
    current_hand = state[:current_hand]
    history = state[:history]

    new_current_hand = current_hand ++ [card]
    new_history = history ++ [card]

    state = %{state | current_hand: new_current_hand, history: new_history}

    {:noreply, state}
  end

  def handle_info(:deck_shuffled, state) do
    {:noreply, %{state | history: [], current_hand: []}}
  end
end