@react.component
let make = (~onClick, ~children) =>
  <button className="border rounded px-1 min-w-[32px] w-full text-center" onClick> children </button>

@gentype
let \"Button" = make
