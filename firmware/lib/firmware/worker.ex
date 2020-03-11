defmodule Firmware.Worker do

  @moduledoc """
  routines that actually do the blinky lights
  """

  use GenServer

  #require IEx  ##for debugging

  alias Blinkchain.Point

  @moduledoc """
  State is the persistent state of the genserver
  e.g. the reference to the timer, some predetermined colors,
  a counter to tell how long you have iterating,
  the patten of the lights.
  """
  defmodule State do
    defstruct [:timer, :colors, :counter, :pattern]
  end

  #### public API

  @doc """
  public api to change to red pattern
  """
  def red() do
    GenServer.call(__MODULE__, :red)
  end


  @doc """
  public api to change to purple pattern
  """
  def purple() do
    GenServer.call(__MODULE__, :purple)
  end


  @doc """
  public api to change to rainbow pattern
  """
  def rainbow() do
    GenServer.call(__MODULE__, :rainbow)
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ### Genserver callbacks

  def init(_opts) do
    # Send ourselves a message to draw each frame every 200 ms,
    # which will end up being approximately 5 fps.
    {:ok, ref} = :timer.send_interval(200, :draw_frame)

    state = %State{
      timer: ref,
      colors: Firmware.colors(),
      counter: 0,
      pattern: :rainbow
    }

    {:ok, state}
  end

  @doc """
  genserver callback to handle the timer - ie update the lights
  """
  def handle_info(:draw_frame, state) do

    ## update counter
    counter = state.counter + 1

    case state.pattern do
      :rainbow ->

        [c1, c2, c3, c4, c5, c6, c7, c8 ] = Enum.slice(state.colors, 0..7)
        tail = Enum.slice(state.colors, 1..-1)

        # Shift all pixels to the right
        Blinkchain.copy(%Point{x: 0, y: 0}, %Point{x: 1, y: 0}, 7, 8)

        # Populate the six leftmost pixels with new colors
        Blinkchain.set_pixel(%Point{x: 0, y: 0}, c1)
        Blinkchain.set_pixel(%Point{x: 0, y: 1}, c2)
        Blinkchain.set_pixel(%Point{x: 0, y: 2}, c3)
        Blinkchain.set_pixel(%Point{x: 0, y: 3}, c4)
        Blinkchain.set_pixel(%Point{x: 0, y: 4}, c5)
        Blinkchain.set_pixel(%Point{x: 0, y: 5}, c6)
        Blinkchain.set_pixel(%Point{x: 0, y: 6}, c7)
        Blinkchain.set_pixel(%Point{x: 0, y: 7}, c8)

        Blinkchain.render()
        {:noreply, %State{state | colors: tail ++ [c1], counter: counter}}

      :red ->
        # fill with red
        Blinkchain.fill(%Point{x: 0, y: 0}, 8, 8, %Blinkchain.Color{r: 255, g: 0, b: 0})
        Blinkchain.render()
        {:noreply, %State{state | counter: counter}}

      :purple ->
        # fill with purple
        Blinkchain.fill(%Point{x: 0, y: 0}, 8, 8, %Blinkchain.Color{r: 130, g: 0, b: 75})
        Blinkchain.render()
        {:noreply, %State{state | counter: counter}}

      _ ->
        # default fill with purple
        Blinkchain.fill(%Point{x: 0, y: 0}, 8, 8, %Blinkchain.Color{r: 130, g: 0, b: 75})
        Blinkchain.render()
        {:noreply, %State{state | counter: counter}}
    end

  end

  @doc """
  genserver callback to change pattern to all red
  """
  def handle_call(:red, from, state) do
    {:reply, from, %State{state | pattern: :red}}
  end

  @doc """
  genserver callback to change pattern to all purple
  """
  def handle_call(:purple, from, state) do
    {:reply, from, %State{state | pattern: :purple}}
  end

  @doc """
  genserver callback to change or rainbow pattern
  """
  def handle_call(:rainbow, from, state) do
    {:reply, from, %State{state | pattern: :rainbow}}
  end


end
