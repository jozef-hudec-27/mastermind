class Board
  attr_reader :board

  def initialize
    @board = Array.new(ROUNDS) { Array.new(4, 'XXXX') }
  end

  def print_board
    printed = "\n"

    (ROUNDS * 2).times do |i|
      if i.even?
        printed += "#{board[i / 2][0]}   #{board[i / 2][1]}   #{board[i / 2][2]}   #{board[i / 2][3]}       #{board[i / 2][4]} \n"
      else
        printed += "------------------------- \n"
      end
    end

    puts printed
  end

  def refresh_board
    self.board = Array.new(ROUNDS) { Array.new(4, 'XXXX') }
  end

  private

  attr_writer :board
end

class CodeBreaker
  def initialize
    @available_colors = %w[Red Blue Yellow Green White Black]
  end

  def guess(board, guess)
    ROUNDS.times do |i|
      if board[i][0] == 'XXXX'
        board[i] = guess
        break
      end
    end
  end

  def guess_computer(board, current_round)
    prev_round_index = current_round - 2

    if prev_round_index >= 0
      prev_round_feedback = board[prev_round_index][-1]

      perfect_matches_count = prev_round_feedback.count('🔴')
      no_match = prev_round_feedback.count('⚫') > 0

      if perfect_matches_count.positive?
        new_guess = [nil, nil, nil, nil]

        [0, 1, 2, 3].shuffle.each_with_index do |i, j|
          new_guess[i] = board[prev_round_index][i]
          break if j == perfect_matches_count - 1
        end

        4.times { |i| new_guess[i] = @available_colors.sample if new_guess[i].nil? }

        guess(board, new_guess)
        return new_guess.join(' ')
      elsif no_match
        board[prev_round_index].each { |color| @available_colors.delete(color) }
      end
    end

    a = @available_colors.sample
    b = @available_colors.sample
    c = @available_colors.sample
    d = @available_colors.sample
    random_guess = "#{a} #{b} #{c} #{d}"
    guess(board, random_guess.split)
    random_guess
  end

  def guess_valid?(guess)
    words = guess.split

    return false if words.length != 4

    words = words.map(&:capitalize)

    words.each do |word|
      return false unless COLORS.include?(word)
    end

    true
  end
end

module CodeMaker
  def self.generate_random_code
    code = []
    4.times { code.push(COLORS.sample) }
    code
  end

  def self.code_valid?(code)
    code = code.split.map(&:capitalize)

    code.each { |word| return false unless COLORS.include?(word) }

    true
  end

  def self.guess_feedback(guess, secret_code)
    guess = guess.map(&:capitalize)

    exact_matches = []
    color_matches = []

    4.times { |i| exact_matches.push(i) if guess[i] == secret_code[i] }

    non_exact_indexes = ([0, 1, 2, 3] - exact_matches)

    secret_code = non_exact_indexes.map { |i| secret_code[i] }

    non_exact_indexes.each do |i|
      if secret_code.include?(guess[i])
        color_matches.push(i)
        secret_code.delete_at(secret_code.index(guess[i]))
      end
    end

    [exact_matches, color_matches]
  end
end
