defmodule Firmware do
  @moduledoc """
  Documentation for Firmware.
  """
  alias Blinkchain.Color

  @doc """
  Hello world.

  ## Examples
      iex> Firmware.hello
      :world
  """
  def hello do
    :world
  end

  # compute colors at compile time instead of every time
  # the `colors` function gets called.
  @colors [
    Color.parse("#9400D3"),  #purple
    Color.parse("#4B0082"),  #light purple
    Color.parse("#0000FF"),  #blue
    Color.parse("#00FF00"),  #green
    Color.parse("#FFFF00"),  #yellow green
    Color.parse("#FF7F00"),  #orange
    Color.parse("#FF0000"),   #red
    Color.parse("#F0F0F0")   #white
  ]

  @doc """
  Get a list of nice-looking rainbow colors
  """
  def colors, do: @colors
end
