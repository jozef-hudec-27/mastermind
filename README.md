# Mastermind

This repo contains code for a project that is a part of [The Odin Project's](https://www.theodinproject.com) Ruby course, [Mastermind](https://en.wikipedia.org/wiki/Mastermind_(board_game)).

## Game Rules
- Each game consists of at most 12 rounds
- Each game, you can choose to be the Code Maker or Code Breaker
- Available colors are: **Black**, **Blue**, **Green**, **Red**, **White**, **Yellow**
- When asked for code, please enter space-separated combination of available colors (e.g. ``` red green blue red ```)
- Code must have *exactly 4* colors (no blank colors allowed)
- Duplicate colors are allowed (i.e. secret code ``` red red red red ``` is totally valid)
- You can quit the game at any time by entering ``` q ``` into the terminal

## Secret Code feedback meaning
When guessing the secret code, you will come across some symbols that determine the quality of your guess. They are the following:
- ⚫⚫⚫⚫, meaning that none of the colors from the guess are in the secret code. In other words, don't use these colors again, unless you want to lose.
- 🔴, meaning that the guess has both correct color ***and*** position in it. (e.g. if the secret code is ``` blue red green black ``` and the guess is ``` blue red yellow white ```, the feedback will be ``` 🔴🔴 ```, because the guess has 2 perfect matches (``` blue ``` and ``` red ```))
- ⚪, meaning that the guess includes a color from the secret code, but at a wrong position (e.g. with the secret code ``` red blue black black ``` and guess ``` blue red white white ``` the feedback would be ``` ⚪⚪ ```)

Please note that the feedback is in ***no particular order***. So if the feedback is ``` 🔴🔴⚪⚪ ```, it doesn't mean that the first 2 values from the guess are actually perfect matches, it merely means that there are 2 perfect matches *somewhere* in the guess.

[![Run on Repl.it](https://replit.com/badge/github/jozef-hudec-27/mastermind)](https://replit.com/new/github/jozef-hudec-27/mastermind)