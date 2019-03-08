defmodule GuessingGame do

  def guess(low, high)  do
    answer = IO.gets("It is #{middle(low,high)} ?")

    case String.trim(answer) do
    "bigger" ->
      bigger(low,high)

    "smaller" ->
      smaller(low,high)

    "yes" ->
      "YES I WIN ! "
    _
    ->
      IO.puts("NOPE")
      guess(low, high)

    end
  end

  def middle(low, high) do
    div(low + high, 2)
  end

  def bigger(low, high) do
    new_low = min(high, middle(low, high) + 1)
    guess(new_low, high)
  end

  def smaller(low, high) do
    new_high = max(low, middle(low, high) - 1)
    guess(low, new_high)
  end

end
