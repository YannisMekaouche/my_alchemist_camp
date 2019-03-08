defmodule MinimalMarkdown do

  def to_html(text) do
      text
      |> String.trim
      |> bold
      |> italic
      |> p
      |> big
      |> small
  end

  def test_str do
    """
    Ceci est une -première- ligne
    Ceci est une -deuxième- ligne
    Ceci est une +troisième+ ligne
    """
  end

  def p(text) do
    Regex.replace(~r/(.*)(\n)+/, text, "<p>\\1</p>")
  end

  def bold(text) do
    Regex.replace(~r/\*(.*)\*/, text, "<bold>\\1<bold>")
  end

  def italic(text) do
    Regex.replace(~r/\*\*(.*)\*\*/, text, "<em>\\1<em>")
  end

  def big(text) do
    Regex.replace(~r/\+(.*)\+/, text, "<big>\\1<big>")
  end

  def small(text) do
    Regex.replace(~r/\-(.*)\-/, text, "<small>\\1<small>")
  end

end
