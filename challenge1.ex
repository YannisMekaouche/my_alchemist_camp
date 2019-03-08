defmodule Challenge1 do

  def greetings() do

    name = IO.gets("Hi, whats your name ?")

    case String.trim(name) do
      "Yannis" ->
        "Woaw, such an amazing name !"

      _ ->
        "Greetings, #{name}"
    end
  end

end
