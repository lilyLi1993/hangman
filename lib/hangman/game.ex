defmodule Hangman.Game do


  @spec new_game :: state
  def new_game do
    random_word = Hangman.Dictionary.random_word
  %{
    word: random_word,
    turns_left: 10,
    guessed: MapSet.new,
    letter_left: dictionary_letters(random_word) 
   }
  end



  def new_game(word) do
  %{
    word: word,
    turns_left: 10,
    guessed: MapSet.new,
    letter_left: dictionary_letters(word) 
   }
  end


  @doc """
  `{game, status, guess} = make_move(game, guess)`
  Accept a guess. Return a three element tuple containing the updated
  game state, an atom giving the status at the end of the move, and
  the letter that was guessed.
  The status can be:
  * `:won` — the guess correct and completed the game. The client won
  * `:lost` — the guess was incorrect and the client has run out of
     turns. The game has been lost.
  * `:good_guess` — the guess occurs one or more turns in the word
  * `:bad_guess` — the word does not contain the guess. The number
     of turns left has been reduced by 1
  """

  @spec make_move(state, ch) :: { state, atom, optional_ch }
  def make_move(state, guess) do
    {match_guessed, state} = state |> pop_in([:letter_left, guess])
    if !match_guessed do
       state = %{state | turns_left: state.turns_left - 1}
    end
    state = %{state | guessed: MapSet.put(state.guessed, guess)}
    cond do 
        state.turns_left == 0
      -> {state, :lost, nil}
      !match_guessed
      -> {state, :bad_guess, guess}
      state.letter_left |> Map.keys |> length == 0
      -> {state, :won, nil}
      match_guessed
      -> {state, :good_guess, guess}

    # I tried the following codes at the first time, but it didn't work, maybe the value could not be transitted to the :lost and so on
    #state.turns_left == 0
    #-> :lost
    #!match_guessed
    #-> :bad_guess
    #state.letter_left |> Map.keys |> length == 0
    #-> :won
    #match_guessed
    #-> :good_guess

    end
  end


  @doc """
  `len = Hangman.Game.word_length(game)`
  Return the length of the current word.
  """
  @spec word_length(state) :: integer
  def word_length(%{ word: word }) do
    String.length(word)
  end

  @doc """
  `list = letters_used_so_far(game)`
  The letters that have been guessed so far, returned as a list of
  single character strings. (This includes both correct and
  incorrect guessed.
  """

  @spec letters_used_so_far(state) :: [ binary ]
  def letters_used_so_far(state) do
    MapSet.to_list(state.guessed)
  end

  @doc """
  `count = turns_left(game)`
  #here I wanan changed the name, but seems like some functions are unique in the test.ex
  Returns the number of turns remaining before the game is over.
  For our purposes, a game starts with a generous 10 turns. Each
  _incorrect_ guess decrements this.
  """

  @spec turns_left(state) :: integer
  def turns_left(state) do
    state.turns_left
  end


  @spec word_as_string(state, boolean) :: binary
  def word_as_string(state, reveal \\ false) do
    guessed = [" "| letters_used_so_far(state)] |> Enum.join
    word = if !reveal do
      String.replace(state.word, ~r/[^#{guessed}]/, "_")
    else
      state.word
    end
    word |> String.graphemes |> Enum.join(" ")
  end

  ###########################
  # end of public interface #
  ###########################

  # Your private functions go here
  defp dictionary_letters(word), do: word |> String.graphemes |> Map.new(&{&1, true})

end
  *  `{game, status, guess} = make_move(game, guess)`

     Accept a guess. Return a three element tuple containing the updated
     game state, an atom giving the status at the end of the move, and
     the letter that was guessed.

     The status can be:

     * `:won` — the guess correct and completed the game. The client won

     * `:lost` — the guess was incorrect and the client has run out of
        turns. The game has been lost.

     * `:good_guess` — the guess occurs one or more times in the word

     * `:bad_guess` — the word does not contain the guess. The number
       of turns left has been reduced by 1

## Example of use

Here's this module being exercised from an iex session:

    iex(1)> alias Hangman.Game, as: G
    Hangman.Game

    iex(2)> game = G.new_game
    . . .

    iex(3)> G.word_length(game)
    6

    iex(4)> G.word_as_string_string(game)
    "_ _ _ _ _ _"

    iex(5)> { game, state, guess } = G.make_move(game, "e")
    . . .

    iex(6)> state
    :good_guess

    iex(7)> G.word_as_string(game)
    "_ _ e e _ e"

    iex(8)> { game, state, guess } = G.make_move(game, "q")
    . . .

    iex(9)> state
    :bad_guess

    iex(10)> { game, state, guess } = G.make_move(game, "r")
    . . .

    iex(11)> state
    :good_guess

    iex(12)> G.word_as_string(game)
    "_ r e e _ e"

    iex(13)> { game, state, guess } = G.make_move(game, "b")
    . . .
    iex(14)> state                                          
    :bad_guess

    iex(15)> { game, state, guess } = G.make_move(game, "f")
    . . .

    iex(16)> state
    :good_guess

    iex(17)> G.word_as_string(game)
    "f r e e _ e"

    iex(18)> { game, state, guess } = G.make_move(game, "z")
    . . .

    iex(19)> state
    :won

    iex(20)> G.word_as_string(game)
    "f r e e z e"


  """

  @type state :: map
  @type ch    :: binary
  @type optional_ch :: ch | nil

  @doc """
  Run a game of Hangman with our user. Use the dictionary to
  find a random word, and then let the user make guesses.
  """

  @spec new_game :: state
  def new_game do
  end


  @doc """
  This version of `new_game` doesn't look the word up in the
  dictionary. Instead, it is passed as a parameter. This is
  used for testing
  """
  @spec new_game(binary) :: state
  def new_game(word) do
  end


  @doc """
  `{game, status, guess} = make_move(game, guess)`

  Accept a guess. Return a three element tuple containing the updated
  game state, an atom giving the status at the end of the move, and
  the letter that was guessed.

  The status can be:

  * `:won` — the guess correct and completed the game. The client won

  * `:lost` — the guess was incorrect and the client has run out of
     turns. The game has been lost.

  * `:good_guess` — the guess occurs one or more times in the word

  * `:bad_guess` — the word does not contain the guess. The number
     of turns left has been reduced by 1
  """

  @spec make_move(state, ch) :: { state, atom, optional_ch }
  def make_move(state, guess) do
  end


  @doc """
  `len = Hangman.Game.word_length(game)`

  Return the length of the current word.
  """
  @spec word_length(state) :: integer
  def word_length(%{ word: word }) do
  end

  @doc """
  `list = letters_used_so_far(game)`

  The letters that have been guessed so far, returned as a list of
  single character strings. (This includes both correct and
  incorrect guessed.
  """

  @spec letters_used_so_far(state) :: [ binary ]
  def letters_used_so_far(state) do
  end

  @doc """
  `count = turns_left(game)`

  Returns the number of turns remaining before the game is over.
  For our purposes, a game starts with a generous 10 turns. Each
  _incorrect_ guess decrements this.
  """

  @spec turns_left(state) :: integer
  def turns_left(state) do
  end

  @doc """
  `word = word_as_string(game, reveal \\ false)`

  Returns the word to be guessed. If the optional second argument is
  false, then any unguessed letters will be returned as underscores.
  If it is true, then the word will be returned complete, showing
  all letters. Letters and underscores are separated by spaces.
  """

  @spec word_as_string(state, boolean) :: binary
  def word_as_string(state, reveal \\ false) do
  end

  ###########################
  # end of public interface #
  ###########################

  # Your private functions go here

 end
