module Link = Next.Link

@react.component
let make = () => {
  <div className="floating w-full">
    <Link href="/markets">
      <span className="cursor-pointer hover:opacity-70 w-full flex justify-center">
        <img alt="start-trading" src="/img/start-trading.png" className="p-4" />
      </span>
    </Link>
  </div>
}
