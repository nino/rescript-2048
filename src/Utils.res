let lastId = ref(0)

let uid = () => {
  lastId := lastId.contents + 1
  Js.Int.toStringWithRadix(lastId.contents, ~radix=36)
}
