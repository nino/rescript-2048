// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Utils from "./Utils.mjs";
import * as Js_math from "rescript/lib/es6/js_math.js";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";

function setTileValue(tile, value) {
  return {
          value: value,
          id: tile.id
        };
}

function padRight(arr, size) {
  var neededElements = Belt_Array.map(Belt_Array.range(1, size - arr.length | 0), (function (param) {
          return {
                  value: 0,
                  id: Utils.uid(undefined)
                };
        }));
  return Belt_Array.concat(arr, neededElements);
}

function padLeft(arr, size) {
  var neededElements = Belt_Array.map(Belt_Array.range(1, size - arr.length | 0), (function (param) {
          return {
                  value: 0,
                  id: Utils.uid(undefined)
                };
        }));
  return Belt_Array.concat(neededElements, arr);
}

function compactLeft(arr) {
  if (arr.length < 2) {
    return arr;
  }
  var first = Belt_Array.getExn(arr, 0);
  var second = Belt_Array.getExn(arr, 1);
  if (first.value === second.value) {
    return Belt_Array.concat([setTileValue(first, (first.value << 1))], compactLeft(Belt_Array.sliceToEnd(arr, 2)));
  } else {
    return Belt_Array.concat([first], compactLeft(Belt_Array.sliceToEnd(arr, 1)));
  }
}

function transpose(arr) {
  var size = arr.length;
  return Belt_Array.map(Belt_Array.range(0, size - 1 | 0), (function (idx) {
                return Belt_Array.map(arr, (function (subArray) {
                              return Belt_Array.getExn(subArray, idx);
                            }));
              }));
}

function rows(t) {
  return t.tiles;
}

function setRows(t, rows) {
  return {
          size: t.size,
          tiles: rows
        };
}

function setColumns(t, cols) {
  return {
          size: t.size,
          tiles: transpose(cols)
        };
}

function make(size) {
  var rows = Belt_Array.map(Belt_Array.range(1, size), (function (param) {
          return Belt_Array.map(Belt_Array.range(1, size), (function (param) {
                        return {
                                value: 0,
                                id: Utils.uid(undefined)
                              };
                      }));
        }));
  return {
          size: size,
          tiles: rows
        };
}

function move(t, direction) {
  var shiftedStrips;
  switch (direction) {
    case /* Up */0 :
        shiftedStrips = Belt_Array.map(transpose(t.tiles), (function (col) {
                return padRight(compactLeft(Belt_Array.keep(col, (function (el) {
                                      return el.value !== 0;
                                    }))), t.size);
              }));
        break;
    case /* Down */1 :
        shiftedStrips = Belt_Array.map(transpose(t.tiles), (function (col) {
                var arr = Belt_Array.keep(col, (function (el) {
                        return el.value !== 0;
                      }));
                return padLeft(Belt_Array.reverse(compactLeft(Belt_Array.reverse(arr))), t.size);
              }));
        break;
    case /* Left */2 :
        shiftedStrips = Belt_Array.map(t.tiles, (function (row) {
                return padRight(compactLeft(Belt_Array.keep(row, (function (el) {
                                      return el.value !== 0;
                                    }))), t.size);
              }));
        break;
    case /* Right */3 :
        shiftedStrips = Belt_Array.map(t.tiles, (function (row) {
                var arr = Belt_Array.keep(row, (function (el) {
                        return el.value !== 0;
                      }));
                return padLeft(Belt_Array.reverse(compactLeft(Belt_Array.reverse(arr))), t.size);
              }));
        break;
    
  }
  var t$1 = direction >= 2 ? setRows(t, shiftedStrips) : setColumns(t, shiftedStrips);
  var emptySlots = [];
  Belt_Array.forEachWithIndex(t$1.tiles, (function (rowIdx, row) {
          Belt_Array.forEachWithIndex(row, (function (colIdx, cell) {
                  if (cell.value === 0) {
                    emptySlots.push([
                          rowIdx,
                          colIdx
                        ]);
                    return ;
                  }
                  
                }));
        }));
  if (emptySlots.length !== 0) {
    var param = Belt_Array.getExn(emptySlots, Js_math.random_int(0, emptySlots.length));
    var value = {
      value: 2,
      id: Utils.uid(undefined)
    };
    var targetCol = param[1];
    var targetRow = param[0];
    var rows = Belt_Array.mapWithIndex(t$1.tiles, (function (rowIdx, row) {
            if (rowIdx === targetRow) {
              return Belt_Array.mapWithIndex(row, (function (colIdx, cell) {
                            if (colIdx === targetCol) {
                              return value;
                            } else {
                              return cell;
                            }
                          }));
            } else {
              return row;
            }
          }));
    return setRows(t$1, rows);
  } else {
    return t$1;
  }
}

function isGameOver(t) {
  if (Caml_obj.equal(t, move(t, /* Up */0)) && Caml_obj.equal(t, move(t, /* Down */1)) && Caml_obj.equal(t, move(t, /* Left */2))) {
    return Caml_obj.equal(t, move(t, /* Right */3));
  } else {
    return false;
  }
}

export {
  make ,
  rows ,
  move ,
  isGameOver ,
}
/* No side effect */
