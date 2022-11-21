module Board = {
  @react.component
  let make = (~state: BoardState.t, ~onMove: BoardState.direction => unit) =>
    <div>
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
                | other =>
                  if other === 0 {
                    "transparent"
                  } else {
                    "red"
                  }
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
      <div className="grid grid-cols-3 grid-rows-3 w-[180px]">
        <div className="col-start-2">
          <Button onClick={_ => onMove(Up)}> {"Up"->React.string} </Button>
        </div>
        <div className="col-start-2 row-start-3">
          <Button onClick={_ => onMove(Down)}> {"Down"->React.string} </Button>
        </div>
        <div className="row-start-2">
          <Button onClick={_ => onMove(Left)}> {"Left"->React.string} </Button>
        </div>
        <div className="row-start-2 col-start-3">
          <Button onClick={_ => onMove(Right)}> {"Right"->React.string} </Button>
        </div>
      </div>
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
