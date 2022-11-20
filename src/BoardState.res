type tile = {value: int, id: string}
type t = {size: int, tiles: array<array<tile>>}
type direction = Up | Down | Left | Right

let makeTile = value => {value, id: Utils.uid()}
let setTileValue = (tile, value) => {...tile, value}

module Helpers = {
  let padRight = (arr, size) => {
    let neededElements = Array.range(1, size - Array.length(arr))->Array.map(_ => makeTile(0))
    Array.concat(arr, neededElements)
  }

  let padLeft = (arr, size) => {
    let neededElements = Array.range(1, size - Array.length(arr))->Array.map(_ => makeTile(0))
    Array.concat(neededElements, arr)
  }

  let rec compactLeft = arr => {
    if Array.length(arr) >= 2 {
      let first = Array.getExn(arr, 0)
      let second = Array.getExn(arr, 1)
      if first.value === second.value {
        Array.concat([setTileValue(first, first.value * 2)], compactLeft(Array.sliceToEnd(arr, 2)))
      } else {
        Array.concat([first, second], compactLeft(Array.sliceToEnd(arr, 2)))
      }
    } else {
      arr
    }
  }

  let compactRight = arr => {
    Array.reverse(arr)->compactLeft->Array.reverse
  }

  let transpose = arr => {
    let size = Array.length(arr)
    Array.range(0, size - 1)->Array.map(idx =>
      Array.map(arr, subArray => subArray->Array.getExn(idx))
    )
  }
}

let rows = t => t.tiles
let columns = t => Helpers.transpose(t.tiles)

let setRows = (t, rows) => {...t, tiles: rows}
let setColumns = (t, cols) => {...t, tiles: Helpers.transpose(cols)}

let setAt = (t, (targetRow, targetCol), value) => {
  let rows = rows(t)->Array.mapWithIndex((rowIdx, row) => {
    if rowIdx === targetRow {
      row->Array.mapWithIndex((colIdx, cell) => {
        if colIdx === targetCol {
          value
        } else {
          cell
        }
      })
    } else {
      row
    }
  })
  setRows(t, rows)
}

let addRandomTile = t => {
  let emptySlots = []
  rows(t)->Array.forEachWithIndex((rowIdx, row) => {
    row->Array.forEachWithIndex((colIdx, cell) => {
      if cell.value === 0 {
        Array.push(emptySlots, (rowIdx, colIdx))
      }
    })
  })

  if Array.length(emptySlots) > 0 {
    setAt(t, Array.getExn(emptySlots, Js.Math.random_int(0, Array.length(emptySlots))), makeTile(2))
  } else {
    t
  }
}

let make = (~size) => {
  let rows = Array.range(1, size)->Array.map(_ => Array.range(1, size)->Array.map(_ => makeTile(0)))
  let empty = {size, tiles: rows}
  empty
}

let move = (t, direction) => {
  let shiftedStrips = switch direction {
  | Up =>
    columns(t)->Array.map(col =>
      Array.keep(col, el => el.value !== 0)->Helpers.compactLeft->Helpers.padRight(t.size)
    )
  | Down =>
    columns(t)->Array.map(col =>
      Array.keep(col, el => el.value !== 0)->Helpers.compactRight->Helpers.padLeft(t.size)
    )
  | Left =>
    rows(t)->Array.map(row =>
      Array.keep(row, el => el.value !== 0)->Helpers.compactLeft->Helpers.padRight(t.size)
    )
  | Right =>
    rows(t)->Array.map(row =>
      Array.keep(row, el => el.value !== 0)->Helpers.compactRight->Helpers.padLeft(t.size)
    )
  }
  let shiftedBoard = switch direction {
  | Up | Down => setColumns(t, shiftedStrips)
  | Left | Right => setRows(t, shiftedStrips)
  }
  addRandomTile(shiftedBoard)
}

let isGameOver = t =>
  // TODO this is obviously a terrible implementation and slow etc
  t == move(t, Up) && t == move(t, Down) && t == move(t, Left) && t == move(t, Right)
