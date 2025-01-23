defmodule HeadsUp.Timer do
  def update(hr, min, sec) when sec == "59" and min != "59" do
    min = min |> parse_to_integer |> add |> parse_to_string

    [hr, min, "00"]
  end

  def update(hr, min, sec) when sec == "59" and min == "59" do
    hr =
      hr
      |> parse_to_integer
      |> add
      |> parse_to_string

    [hr, "00", "00"]
  end

  def update(hr, min, sec) do
    sec =
      sec
      |> parse_to_integer
      |> add
      |> parse_to_string

    [hr, min, sec]
  end

  def parse_to_integer(value), do: String.to_integer(value)
  def add(value), do: value + 1

  def parse_to_string(value) do
    value
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
