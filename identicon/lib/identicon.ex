require Integer

defmodule Identicon do
  def generate(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_grid_values
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Image{hex: hex}
  end

  def pick_color(%Image{hex: [r, g, b | _rest]} = image) do
    %Image{ image | color: {r, g, b} }
  end

  def build_grid(%Image{hex: hex} = image) do
    grid_values =
      hex
        |> Enum.chunk_every(3, 3, :discard)
        |> Enum.map(&mirror_row/1)
        |> List.flatten
        |> Enum.with_index

    %Image{ image | grid: %Grid{values: grid_values} }
  end

  def mirror_row([first, second, _middle] = row) do
    row ++ [second, first]
  end

  def filter_odd_grid_values(%Image{grid: %Grid{values: values}} = image) do
    odd_values = Enum.filter(values, fn({value, _index}) -> Integer.is_odd(value) end)

    %Image{image | grid: %Grid{values: odd_values}}
  end

  def build_pixel_map(%Image{grid: %Grid{values: values}} = image) do
    pixel_map = Enum.map(values, fn({_value, index}) ->
      x = rem(index, 5) * 50
      y = div(index, 5) * 50

      top_left = {x, y}
      bottom_right = {x + 50, y + 50}

      {top_left, bottom_right}
    end)

    %Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill_color = :egd.color(color)

    Enum.each(pixel_map, fn({top_left, bottom_right}) ->
      :egd.filledRectangle(image, top_left, bottom_right, fill_color)
    end)

    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("images/#{input}.png", image)
  end
end
