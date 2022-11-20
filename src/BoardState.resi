type t
type tile = {value: int, id: string}
type direction = Up | Down | Left | Right

/** Create a square grid with size*size cells */
let make: (~size: int) => t

/** Get the values of all the cells, in a two-dimensional array */
let rows: t => array<array<tile>>

/** Get the new game state after a given move */
let move: (t, direction) => t

/** The game is over if there are no possible moves left */
let isGameOver: t => bool
