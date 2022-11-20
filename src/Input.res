@react.component
let make = (~label, ~value, ~onChange, ~type_) =>
  <div className="m-1">
    <label className="flex flex-col">
      {label->React.string}
      <input type_ value onChange className="border-black border" />
    </label>
  </div>
