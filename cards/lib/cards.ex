defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  def create_deck do
    values = ["Ace", "Two"]
    suits = ["Spades", "Clubs"]

    for value <- values, suit <- suits do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  def deal(deck, count) do
    Enum.split(deck, count)
  end

  def save(deck, file_path) do
    binary_deck = :erlang.term_to_binary(deck)
    File.write(file_path, binary_deck)
  end

  def load(file_path) do
     result = File.read(file_path)

    case result do
      { :ok, binary_deck } -> :erlang.binary_to_term(binary_deck)
      { :error, _error_type } -> "File [#{file_path}] does not exist"
    end
  end

  def create_hand(hand_size) do
    Cards.create_deck |> Cards.shuffle |> Cards.deal(hand_size)
  end
end
