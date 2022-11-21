let default = () =>
  <div className="container mx-auto">
    <H1> {React.string("2048")} </H1>
    <Game />
    <footer className="mt-16">
      <a href="https://github.com/nino/rescript-2048/" className="text-blue-700 underline">
        {"https://github.com/nino/rescript-2048/"->React.string}
      </a>
    </footer>
  </div>
