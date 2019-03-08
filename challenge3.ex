defmodule Challenge3 do

  def get_files() do
    {:ok, files} = File.ls
    Enum.each files, fn file ->
      [ file_extension] = tl String.split(file, ".")
      file_extension = List.to_string(extension)
      if Regex.match?(~r/[jpg]|[png]|[bmp]|[gif]/, file_extension) do
        file_extension
        #move_file(file)
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
