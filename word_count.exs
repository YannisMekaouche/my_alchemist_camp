defmodule WordCount do

  def choose_option() do
    choice = IO.gets("What do you want to count ?")

    case String.trim(choice) do
      "characters" ->
        count_characters()
      "lines" ->
        count_lines()
      "words" ->
        count_words()
      _ ->
        choose_option()
    end
  end

  def count_words() do
    filename = IO.gets("Filename: ") |> String.trim
    file_content = File.read!(filename)
    |> String.split(~r{\\n|[^\w']+})
    |> Enum.filter(fn  x -> x != "" end)
    print_count(file_content)
  end

  def count_characters() do
    filename = IO.gets("Filename: ") |> String.trim
    file_content = File.read!(filename)
    |> String.split(~r{[*]*})
    |> Enum.filter(fn  x -> x != "" end)
    print_count(file_content)
  end

  def count_lines() do
    filename = IO.gets("Filename: ") |> String.trim
    file_content = File.read!(filename)
    |> String.split(~r{[^\n]*})
    |> Enum.filter(fn  x -> x != "" end)
    print_count(file_content)
  end

  def print_count(content) do
    content
    |> IO.inspect
    |> Enum.count
    |> IO.puts
  end
end

