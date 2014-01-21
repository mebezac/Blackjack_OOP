# Card and Deck class that can be reused in other card games.

class Card
  attr_reader :suit, :value
  def initialize(v, s)
    @suit = s
    @value = v
  end

  def show_card
    "#{value} of #{suit}"
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    suits = ["Clubs", "Spades", "Diamonds", "Hearts"]
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    values.each do |value|
      suits.each do |suit|
        @cards << Card.new(value, suit)
      end
    end 
    shuffle
  end

  def deal
    cards.pop
  end

  def shuffle
    cards.shuffle!
  end 
end
