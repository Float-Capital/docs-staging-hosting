type teamMember = {
  frameNumber: int,
  name: string,
  path: string,
  placardNumber: int,
  twitter: string,
  github: string,
}

let teamMembers = [
  {
    name: "Denham Preen",
    frameNumber: 1,
    placardNumber: 3,
    path: "denham",
    github: "DenhamPreen",
    twitter: "DenhamPreen",
  },
  {
    name: "Jason Smythe",
    frameNumber: 4,
    placardNumber: 1,
    path: "jason",
    github: "JasoonS",
    twitter: "JasoonSmythe",
  },
  {
    name: "JonJon Clark",
    frameNumber: 3,
    placardNumber: 3,
    path: "jonjon",
    github: "moose-code",
    twitter: "jonjonclark",
  },
  {
    name: "Chris Tritton",
    frameNumber: 3,
    placardNumber: 1,
    path: "chris",
    github: "ChrisTritton",
    twitter: "chris_tritton",
  },
  {
    name: "Michael Young",
    frameNumber: 2,
    placardNumber: 2,
    path: "mike",
    github: "MJYoung114",
    twitter: "mjyoungsta",
  },
  {
    name: "Stentonian",
    frameNumber: 0,
    placardNumber: 3,
    path: "stent",
    github: "Stentonian",
    twitter: "",
  },
  {
    name: "Jordyn Laurier",
    frameNumber: 2,
    placardNumber: 2,
    path: "jordyn",
    github: "Jordy-Baby",
    twitter: "j_o_r_d_y_s",
  },
  {
    name: "Woo Sung Dong",
    frameNumber: 35,
    placardNumber: 1,
    path: "woosung",
    github: "WooSungD",
    twitter: "WooSung40265546",
  },
  {
    name: "Paul Freund",
    frameNumber: 4,
    placardNumber: 3,
    path: "paul",
    github: "paulfreund94",
    twitter: "PaulFreund18",
  },
]

module TeamMember = {
  @react.component
  let make = (~teamMember, ~screenWidth, ~screenHeight) => {
    let {frameNumber, name, path, placardNumber, github, twitter} = teamMember

    let frame = ref(frameNumber)

    let isMobile = screenWidth < 768
    if isMobile {
      frame := 4
    }
    let frameNumber = frame.contents

    let width = isMobile
      ? Js.Math.min_int(screenWidth / 4, screenHeight / 5)
      : Js.Math.min_int(screenWidth / 8, screenHeight / 6)

    let hasTwitter = twitter != ""

    let avatarMargin = switch frameNumber {
    | 4 => "mb-7"
    | 3 => "mb-0"
    | _ => "mb-3"
    }

    let iconsPlacement = switch frameNumber {
    | 35 => "right-7"
    | 3 => ""
    | _ => "right-5"
    }
    let iconsFlex = frameNumber != 3 ? "end" : "center"

    let iconsBottom = width / 6 + 5

    <div
      className="relative flex items-center"
      style={ReactDOM.Style.make(~width=`${width->Int.toString}px`, ())}>
      <img
        src={`/img/team/frames/frame${frameNumber->Int.toString}.png`} className="w-full h-auto"
      />
      <div className="absolute left-0 top-0 w-full h-full z-10 flex items-center justify-center">
        <img
          src={`/img/team/avatars/${path}.png`} className={`w-half h-auto pixel ${avatarMargin}`}
        />
      </div>
      <div className="absolute z-10 bottom-0 w-28 left-half ml-minus-12 mb-minus-1">
        <img src={`/img/team/placards/placard${placardNumber->Int.toString}.png`} />
      </div>
      <div
        className={`absolute ${iconsPlacement} w-full z-10`}
        style={ReactDOM.Style.make(~bottom=`${iconsBottom->Int.toString}px`, ())}>
        <div className={`w-full flex justify-${iconsFlex}`}>
          <a target="_blank" href={`https://github.com/${github}`} className="mr-2 w-1/8">
            <img className="w-full h-auto" src="/icons/github-sq.svg" />
          </a>
          {hasTwitter
            ? <a target="_blank" href={`https://twitter.com/${twitter}`} className="w-1/8">
                <img className="w-full h-auto" src="/icons/twitter-sq-gray.svg" />
              </a>
            : React.null}
        </div>
      </div>
      <div
        className="absolute z-10 bottom-0 w-28 left-half ml-minus-12 mb-minus-1 h-6 text-center text-white text-xxxs md:text-xxs">
        {name->React.string}
      </div>
    </div>
  }
}

@react.component
let make = () => {
  let {height: screenHeight, width: screenWidth} = View.useViewDimensions()

  let teamMargin = screenHeight / 20

  let headingMargin = screenHeight / 15

  <section
    id="team" className="min-h-screen w-screen flex flex-col items-center justify-center bg-team">
    <div className="w-full h-screen">
      <div
        className="w-full flex justify-center"
        style={ReactDOM.Style.make(
          ~marginTop=`${headingMargin->Int.toString}px`,
          ~marginBottom=`${headingMargin->Int.toString}px`,
          (),
        )}>
        <Heading title="team" />
      </div>
      {if screenWidth >= 768 {
        // not mobile
        <div className="w-full flex items-center justify-center">
          <div className="w-1/8 flex flex-col justify-between mb-20 mr-20">
            <div
              className="self-end"
              style={ReactDOM.Style.make(~marginBottom=`${teamMargin->Int.toString}px`, ())}>
              <TeamMember teamMember={teamMembers->Array.getUnsafe(0)} screenWidth screenHeight />
            </div>
            <div className="self-start">
              <TeamMember teamMember={teamMembers->Array.getUnsafe(7)} screenWidth screenHeight />
            </div>
          </div>
          <div className="w-1/8 flex flex-col justify-between mr-20">
            <div
              className="self-end"
              style={ReactDOM.Style.make(~marginBottom=`${teamMargin->Int.toString}px`, ())}>
              <TeamMember teamMember={teamMembers->Array.getUnsafe(2)} screenWidth screenHeight />
            </div>
            <div className="self-start">
              <TeamMember teamMember={teamMembers->Array.getUnsafe(5)} screenWidth screenHeight />
            </div>
          </div>
          <div className="w-1/8 flex flex-col justify-between mr-20">
            <div
              className="self-end"
              style={ReactDOM.Style.make(~marginBottom=`${teamMargin->Int.toString}px`, ())}>
              <TeamMember teamMember={teamMembers->Array.getUnsafe(1)} screenWidth screenHeight />
            </div>
            <div
              className="self-center"
              style={ReactDOM.Style.make(~marginBottom=`${teamMargin->Int.toString}px`, ())}>
              <TeamMember teamMember={teamMembers->Array.getUnsafe(6)} screenWidth screenHeight />
            </div>
            <div className="self-start">
              <TeamMember teamMember={teamMembers->Array.getUnsafe(8)} screenWidth screenHeight />
            </div>
          </div>
          <div className="w-1/8 flex flex-col justify-between">
            <div
              className="self-end"
              style={ReactDOM.Style.make(~marginBottom=`${teamMargin->Int.toString}px`, ())}>
              <TeamMember teamMember={teamMembers->Array.getUnsafe(4)} screenWidth screenHeight />
            </div>
            <div className="self-start">
              <TeamMember teamMember={teamMembers->Array.getUnsafe(3)} screenWidth screenHeight />
            </div>
          </div>
        </div>
      } else {
        <div className="w-full flex flex-wrap mr-10 items-center justify-center">
          {teamMembers
          ->Array.map(member => {
            <div className="mb-10 mx-2">
              <TeamMember teamMember={member} screenWidth screenHeight />
            </div>
          })
          ->React.array}
        </div>
      }}
    </div>
  </section>
}
