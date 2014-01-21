#OOP Blackjack

# Make sure these two files are in the same folder as this one.
require_relative 'helpers.rb'
require_relative 'card_game.rb'

#Make sure to have name and cards in class using attr_accessor
module BlackjackHand
  def show_hand
    puts "#~#~#~#{name}'s hand~#~#~#"
    cards.each do |card|
      say card.show_card
    end
    say "Total value: #{hand_value} <="
    puts
  end

  def add_card(new_card)
    cards << new_card
  end

  def card_value(card)
    card_values_hash = {"Ace" => 1, "Two" => 2, "Three" => 3, "Four" => 4, "Five" => 5, "Six" => 6, "Seven" => 7, "Eight" => 8, "Nine" => 9, "Ten" => 10, "Jack" => 10, "Queen" => 10, "King" => 10}
    card_values_hash[card.show_card.split[0]]
  end

  def hand_value
    value = 0
    cards.each do |card| 
      value += card_value(card)
    end

    ace_check = []
    hand_has_ace = false
    cards.each do |card|
      ace_check << card.show_card.split[0]
    end
    if ace_check.include? "Ace"
      hand_has_ace = true
    else
      hand_has_ace = false
    end

    if hand_has_ace && (value + 10) <= 21
      value += 10
      value
    else
      value
    end
  end
end


class Player
  attr_accessor :name, :cards, :wins
  include BlackjackHand

  def initialize(name)
    @name = name
    @cards = []
    @wins = 0
  end
end

class Dealer < Player
  def show_hand_partial
    say "Dealer showing: #{cards[0].show_card}"
  end
end

class Blackjack
  attr_accessor :deck, :player1, :dealer, :winner

  @@num_of_games = 0

  def initialize
    welcome_and_names
    start_new_game
  end

  def welcome_and_names
    say "Welcome to Zac's OOP Blackjack!"
    say "What's your name?"
    player_name = gets.chomp
    @player1 = Player.new(player_name)
    say "Great to meet you #{player1.name}!"
    say "What would you like the dealer's name to be?"
    dealer_name = gets.chomp
    @dealer = Dealer.new(dealer_name)
    say "Awesome, so #{player1.name} and #{dealer.name} the Dealer will be playing blackjack today!"
  end

  def start_new_game
    @deck = Deck.new
    player1.cards = []
    dealer.cards = []
    2.times do player1.add_card(deck.deal) ; end
    2.times do dealer.add_card(deck.deal) ; end
    player1.show_hand
    dealer.show_hand_partial
    decision
  end

  def decision
    if player1.hand_value == 21
      say "#{player1.name} got a Blackjack!"
      @winner = "player1"
      wrap_up
    elsif player1.hand_value > 21
      say "Sorry #{player1.name}, you busted"
      @winner = "dealer"
      wrap_up
    else 
      say "Would you like to hit or stay?"
      answer = gets.chomp
      if answer.downcase == "hit"
        hit
      elsif answer.downcase == "stay"
        dealers_turn
      else 
        say "Please enter a valid choice, hit or stay."
        decision
      end
    end 
  end

  def hit
    card_dealt = deck.deal
    player1.add_card(card_dealt)
    say "Dealt a #{card_dealt.show_card}"
    press_enter_to_continue
    player1.show_hand
    decision
  end

  def dealers_turn
    say "Now it's the dealer's turn"
    say "The dealer turns over their cards:"
    dealer.show_hand
    press_enter_to_continue

    while dealer.hand_value < 17
      card_dealt = deck.deal
      say "Dealt a #{card_dealt.show_card}"
      dealer.add_card(card_dealt)
      press_enter_to_continue
      dealer.show_hand
    end

    if dealer.hand_value == 21
      say "The dealer got a blackjack!"
      @winner = "dealer"
    elsif dealer.hand_value > 21
      say "The dealer busted!"
      @winner = "player1"
    else 
      say "The dealer stayed because their hand is worth #{dealer.hand_value}"
      compare
    end
    wrap_up
  end

  def compare
    if player1.hand_value > dealer.hand_value
      @winner = "player1"
    else
      @winner = "dealer"
    end
  end

  def wrap_up
    @@num_of_games += 1
    if @winner == "player1"
      say "Congratulations #{player1.name}, you won!"
      player1.wins += 1
    else
      say "Sorry, you lost :("
      dealer.wins += 1
    end
    press_enter_to_continue
    score_board
    play_again
  end

  def score_board
    puts 
    puts "#~#~#~#~#~#~#~#Scoreboard#~#~#~#~#~#~#~#"
    puts "After #{@@num_of_games} game(s), the score is:"
    puts "#{player1.name} : #{player1.wins} ||||||| #{dealer.name} the Dealer : #{dealer.wins}"
    puts "#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#"
    puts
  end

  def play_again
    say "Would you like to 1) play again, 2) Clear the score board and play again, or 3) quit?"
    answer = gets.chomp
    if answer == "1"
      start_new_game
    elsif answer == "2"
      player1.wins = 0
      dealer.wins = 0
      @@num_of_games = 0
      player1.cards = []
      dealer.cards = []
      start_new_game

    elsif answer == "3"
      exit
    else
      say "Please enter a valid choice"
      play_again
    end
  end
end

Blackjack.new
