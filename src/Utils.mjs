// Generated by ReScript, PLEASE EDIT WITH CARE


var lastId = {
  contents: 0
};

function uid(param) {
  lastId.contents = lastId.contents + 1 | 0;
  return lastId.contents.toString(36);
}

export {
  uid ,
}
/* No side effect */
