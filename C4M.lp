% Define the game state
% Define the game board in a matrix of 7x6
cell(1..7, 1..6).
% Declare the current player value
currentPlayer(true).
% Declare the tokens of the game, they can be placen on empty cells
value(X, Y, "X") :- cell(X, Y), not empty(X, Y).
value(X, Y, "O") :- cell(X, Y), not empty(X, Y).
% Evaluate if the current cell is empty only if there is no value on it
empty(X, Y) :- cell(X, Y), not value(X, Y, _).

% Generate possible moves
% The posible moves must be on empty cells, so we need to know which ones are empty
move(X) :- cell(X, 6), empty(X, 6).
% Moves cannot pass a height of 6 cells
move(X) :- cell(X, Y), Y < 6, empty(X, Y+1).

% Evaluate a move
% To know the best moves we give them a score over the columns
% The minimax function helps to give a better score
score(X, Score) :- currentPlayer(true), move(X), makeMove(X), minimax(1, Score).
score(X, Score) :- currentPlayer(false), move(X), makeMove(X), minimax(1, Score).

% Make a move
% The move is done when we already have choose a move
% Once the movement is done we change of turn
makeMove(X) :- currentPlayer(true), move(X), currentPlayer(false).
makeMove(X) :- currentPlayer(false), move(X),currentPlayer(true).


% Evaluate a position using minimax algorithm
% The minimax function evaluates the depth of the three, uses the heuristic to find all
% the possible cases
minimax(Depth, Score) :- Depth = 0, heuristic(Score).

% Evaluate a position using a heuristic function
% The heuristic gives a score depending of the position of where the token can be stored
heuristic(Score) :- horizontalScore(Score); verticalScore(Score); diagonalScore(Score).

% Evaluate a position based on the number of consecutive pieces in a row
% For every token in a diagonal, horizontal or vertical in a vertical line that does help to have more moves we add 100 to Score
% In the case there are moves eliminated by a move then we substract 100 to score
% In the case that Score goes to negative values we declare Score=0
% This proccess repeats itself for each turn

% Check for horizontal win
horizontalScore(Score) :- currentPlayer(true), value(X, Y, "X"), value(X+1, Y, "X"), value(X+2, Y, "X"), value(X+3, Y, "X"), Score = 100.
horizontalScore(Score) :- currentPlayer(false), value(X, Y, "O"), value(X+1, Y, "O"), value(X+2, Y, "O"), value(X+3, Y, "O"), Score = -100.
horizontalScore(Score) :- Score = 0.

% Check for vertical win
verticalScore(Score) :- currentPlayer(true), value(X, Y, "X"), value(X, Y+1, "X"), value(X, Y+2, "X"), value(X, Y+3, "X"), Score = 100.
verticalScore(Score) :- currentPlayer(false), value(X, Y, "O"), value(X, Y+1, "O"), value(X, Y+2, "O"), value(X, Y+3, "O"), Score = -100.
verticalScore(Score) :- Score = 0.

% Check for diagonal win
diagonalScore(Score) :- currentPlayer(true), value(X, Y, "X"), value(X+1, Y+1, "X"), value(X+2, Y+2, "X"), value(X+3, Y+3, "X"), Score = 100.
diagonalScore(Score) :- currentPlayer(false), value(X, Y, "O"), value(X+1, Y+1, "O"), value(X+2, Y+2, "O"), value(X+3, Y+3, "O"), Score = -100.
diagonalScore(Score) :- currentPlayer(true), value(X, Y, "X"), value(X-1, Y+1, "X"), value(X-2, Y+2, "X"), value(X-3, Y+3, "X"), Score = 100.
diagonalScore(Score) :- currentPlayer(false), value(X, Y, "O"), value(X-1, Y+1, "O"), value(X-2, Y+2, "O"), value(X-3, Y+3, "O"), Score = -100.
diagonalScore(Score) :- Score = 0.
