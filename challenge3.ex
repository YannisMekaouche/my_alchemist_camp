defmodule Challenge3 do

  def get_files() do
    {:ok, files} = File.ls
    Enum.each files, fn file ->
      extension = tl String.split(file, ".")
      string_extension = List.to_string(extension)

      if Regex.match?(~r/[jpg]|[png]|[bmp]|[gif]/, string_extension) do
        move_file(file)
      end

    end
  end

  def move_file(file) do
    if !File.dir?("images") do
      File.mkdir("images")
    end
    File.rename(file, "images/#{file}")
  end
end
