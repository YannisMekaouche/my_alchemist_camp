defmodule MinimalTodo do

  def start() do
    answer = IO.gets("Do you want to create a new .csv ?  y/n")
      |> String.trim
      |> String.downcase
    if answer == "y" do
      create_initial_todo()
    else
      load_csv()
    end
  end

  def create_header(headers) do
    new_header = IO.gets("Header : ") |> String.trim
    case new_header do
      "end"
        -> headers
      _
        -> create_header([new_header | headers])
    end
  end

  def create_headers() do
    IO.puts("Enter headers, and finish with the keyword end ")
    create_header([])
  end

  def create_initial_todo() do
    titles = create_headers()
    todo = get_item_name(%{})
    field_values = Enum.map(titles, fn field -> fields_from_user field end)
    new_csv = %{todo => Enum.into(field_values, %{})} #data map returned, with the first todo

      new_csv
      |> save_csv
      |> get_command
  end

  def load_csv() do
    filename = IO.gets("CSV file : ") |> String.trim
    parsed_data = read filename
    get_command(parsed_data)
  end

  def get_command(data) do
    prompt = """
    Choose one of those command
    R) Todo A) Todo D) Todo L) csv S) csv
    """
    command = IO.gets(prompt)
    |> String.trim
    |> String.downcase

    case command do
      "r" -> show_todos(data)
      "a" -> add_todo(data)
      "d" -> delete_todo(data)
      "s" -> save_csv(data)
      "data" -> IO.inspect data
      _   -> get_command(data)
    end
  end

  def get_item_name(data) do
    name = IO.gets("Item name : ") |> String.trim
    if Map.has_key?(data, name) do
      IO.puts("This item already exist ! ")
      get_item_name(data)
    else
      name
    end
  end

  def prepare_save(data) do
    headers = ["Item" | get_fields data]
    items = Map.keys(data)
    items_rows = Enum.map(items, fn item ->
      [ item | Map.values(data[item])]
    end)
    rows = [headers | items_rows]
    rows_string = Enum.map(rows, &(Enum.join(&1, ",")))
    Enum.join(rows_string, "\n")
  end

  def save_csv(data) do
    filename = IO.gets("name of the file : ")
      |> String.trim
    filedata = prepare_save data
    case File.write(filename, filedata) do
      :ok
        -> IO.puts("file saved !")
           data
      {:error, reason}
        -> IO.puts "Save failed"
           IO.puts ~s("#{reason}")
           get_command(data)
    end
  end

  def get_fields(data) do
    data[hd Map.keys data] |> Map.keys
  end

  def add_todo(data) do
    todo_name = get_item_name(data)
    titles = get_fields data
    field_values = Enum.map(titles, fn field -> fields_from_user field end)
    new_todo = %{todo_name => Enum.into(field_values, %{})}
    data = Map.merge(data, new_todo)
    IO.puts ~s(New todo "#{todo_name}" added)
    get_command data
  end

  def fields_from_user(field) do
    field_value = IO.gets("#{field}: ")
    case field_value do
      _ ->  {field, field_value}
    end
  end

  def delete_todo(data) do
    todo = IO.gets("which todo delete ?")
      |> String.trim

      if Map.has_key? data, todo do
        IO.puts("todo found on the list ...")
        new_map = Map.drop(data, [todo])
        IO.puts(" #{todo} deleted !")
        get_command(new_map)
      else
        IO.puts("todo not found ! ")
        show_todos(data, false)
        delete_todo(data)
      end
  end

  def read(filename) do
    case File.read(filename) do
       {:ok, body} ->  parse body
       {:error, reason } -> IO.puts ~s(Could not open file #{filename})
                            <> "#{reason}"
                             start()
    end
  end

  def parse(body) do
    [head | lines] = String.split(body, ~r{(\n)})
    titles = tl String.split(head, ~r{(,)}) # MARCHE
    parse_lines(titles, lines)
  end

  def parse_lines(titles, lines) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ~r{(,)})
      if Enum.count(titles) == Enum.count(fields) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys data
    Enum.each items, fn item -> IO.puts item end
    IO.puts("\n")

    if next_command? do
      get_command(data)
    end
  end

end
