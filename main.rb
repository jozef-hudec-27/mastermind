require_relative 'game'

COLORS = %w[Red Blue Yellow Green White Black]
ROUNDS = 12

game_board = Board.new

catch :main_loop do
  loop do
    puts "\n=> Do you want to play as the Code Breaker (1) or the Code Maker (2)?"
    code_breaker = CodeBreaker.new

    begin
      option = gets.chomp.strip
      p option
      break if option == 'q'
      raise 'Invalid option.' unless %w[1 2].include?(option)
    rescue
      puts "Invalid option. Please enter only '1' or '2'."
      retry
    else
      if option == '2'
        puts "\n=> You are the Code Maker. Please enter a valid code (e.g. 'red green blue red'): "

        begin
          secret_code = gets.chomp.strip
          p secret_code
          break if secret_code == 'q'
          raise 'Invalid code.' unless CodeMaker.code_valid?(secret_code)
        rescue
          puts 'Code entered is invalid. Please enter valid code: '
          retry
        else
          secret_code = secret_code.split.map(&:capitalize)

          ROUNDS.times do |round|
            sleep(1)
            
            puts "\n=> ROUND #{round + 1}. The computer is making a guess..."
            computer_guess = code_breaker.guess_computer(game_board.board, round + 1)
            puts "\n=> The computer's guess is: #{computer_guess}"

            feedback = CodeMaker.guess_feedback(computer_guess.split, secret_code)
            feedback_pegs = [feedback[0].length, feedback[1].length] == [0, 0] ? '⚫⚫⚫⚫' :
            ('🔴' * feedback[0].length) + ('⚪' * feedback[1].length)

            game_board.board[round].push(feedback_pegs)

            game_board.print_board

            if feedback[0].length == 4
              puts "\n\n😔😔😔 The computer guessed your code (#{secret_code[0]}, #{secret_code[1]}, #{secret_code[2]}, #{secret_code[3]}). Better luck next time! 😔😔😔"

              break
            end

            puts "\n\n🎉🎉🎉 The computer wasn't able to guess your code. Good job! 🎉🎉🎉" if round == ROUNDS - 1
          end
        end
      else
        secret_code = CodeMaker.generate_random_code
        ROUNDS.times do |round|
          puts "\n=> ROUND #{round + 1}. Please make a guess."
          game_board.print_board

          begin
            my_guess = gets.chomp.strip
            throw :main_loop if my_guess == 'q'
            raise 'Invalid guess.' unless code_breaker.guess_valid?(my_guess)
          rescue
            puts "Oops, that's not a valid guess. Please, try again!"
            retry
          else
            code_breaker.guess(game_board.board, my_guess.split)

            feedback = CodeMaker.guess_feedback(my_guess.split, secret_code)
            feedback_pegs = [feedback[0].length, feedback[1].length] == [0, 0] ? '⚫⚫⚫⚫' :
            ('🔴' * feedback[0].length) + ('⚪' * feedback[1].length)

            game_board.board[round].push(feedback_pegs)

            puts "=> Clues: #{feedback_pegs}"

            if feedback[0].length == 4
              puts "\n\n🎉🎉🎉 You guessed the code! Congratulations 🎉🎉🎉"
              break
            end

            puts "\n\n😔😔😔 You didn't guess the code in time. It was: #{secret_code[0]}, #{secret_code[1]}, #{secret_code[2]}, #{secret_code[3]}  😔😔😔" if round == ROUNDS - 1
          end
        end
      end

      puts "\nWanna play again? Enter 'y' if yes."
      play_again = gets.chomp

      break unless play_again.downcase == 'y'

      game_board.refresh_board
    end
  end
end

puts "\n❤️ Thank you for playing Mastermind ❤️"
