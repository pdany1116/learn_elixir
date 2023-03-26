defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  describe "#create_deck" do
    test "returns an array with cards" do
      cards = ["Ace of Spades", "Ace of Clubs", "Two of Spades", "Two of Clubs"]

      assert Cards.create_deck == cards
    end
  end

  describe "#shuffle" do
    test "returns the same elements from deck but in different order" do
      deck = Cards.create_deck
      shuffled_deck =  Cards.shuffle(deck)

      assert Enum.empty?(deck -- shuffled_deck)
    end
  end

  describe "#contains?" do
    test "returns true when the card is in the deck" do
      deck = Cards.create_deck
      card = "Ace of Spades"

      assert Cards.contains?(deck, card)
    end

    test "returns false when the card is NOT in the deck" do
      deck = Cards.create_deck
      card = "Ace of Hearts"

      refute Cards.contains?(deck, card)
    end
  end

  describe "#deal" do
    test "returns a deck with a number of cards" do
      deck = Cards.create_deck

      { dealt_deck, rest } = Cards.deal(deck, 2)

      assert dealt_deck == ["Ace of Spades", "Ace of Clubs"]
      assert rest == ["Two of Spades", "Two of Clubs"]
    end
  end

  describe "#save" do
    test "creates a file with the deck" do
      deck = Cards.create_deck

      Cards.save(deck, "test/temp/test.txt")
      { _result, binary_deck } = File.read("test/temp/test.txt")

      assert deck == :erlang.binary_to_term(binary_deck)
    end
  end

  describe "#load" do
    test "returns the deck from a file" do
      deck = Cards.create_deck
      Cards.save(deck, "test/temp/test.txt")

      loaded_deck = Cards.load("test/temp/test.txt")

      assert deck == loaded_deck
    end

    test "returns error message when file does not exist" do
      error = Cards.load("test/temp/test12343.txt")

      assert error == "File [test/temp/test12343.txt] does not exist"
    end
  end
end
