@react.component
let make = (~href, ~children) =>
  <Next.Link href>
    <a className="text-blue-600 underline"> children </a>
  </Next.Link>
