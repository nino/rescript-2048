module Board = {
  @react.component
  let make = (~state: BoardState.t, ~onMove: BoardState.direction => unit) =>
    <div>
      <H1> {"Game board"->React.string} </H1>
      <div
        className="relative border border-grey-200 w-[400px] h-[400px] grid grid-cols-4 grid-rows-4">
        {BoardState.rows(state)
        ->Array.mapWithIndex((rowIdx, row) => {
          row->Array.mapWithIndex((colIdx, tile) =>
            <div
              key=tile.id
              className="absolute flex justify-center items-center text-white text-3xl border border-green rounded-xl transition-all"
              style={ReactDOMStyle.make(
                ~width="80px",
                ~height="80px",
                ~left=Int.toString(colIdx * 90 + 10) ++ "px",
                ~top=Int.toString(rowIdx * 90 + 10) ++ "px",
                ~backgroundColor=switch tile.value {
                | 2 => "#7CB5E2"
                | 4 => "#4495D4"
                | 8 => "#2F6895"
                | 16 => "#F5BD70"
                | 32 => "#F2A032"
                | _ => "transparent"
                },
                (),
              )}>
              {React.int(tile.value)}
            </div>
          )
        })
        ->Array.concatMany
        ->React.array}
      </div>
      {if BoardState.isGameOver(state) {
        <P> {"Game over"->React.string} </P>
      } else {
        <span />
      }}
      <Button onClick={_ => onMove(Up)}> {"Up"->React.string} </Button>
      <Button onClick={_ => onMove(Down)}> {"Down"->React.string} </Button>
      <Button onClick={_ => onMove(Left)}> {"Left"->React.string} </Button>
      <Button onClick={_ => onMove(Right)}> {"Right"->React.string} </Button>
    </div>
}

@react.component
let make = () => {
  let (boardState, setBoardState) = React.useState(() => BoardState.make(~size=4))
  let move = direction => setBoardState(state => BoardState.move(state, direction))

  <div>
    <Board state={boardState} onMove={move} />
  </div>
}

@gentype
let \"Game" = make
