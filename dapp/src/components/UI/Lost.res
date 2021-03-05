@react.component
let make = () => {
    let router = Next.Router.useRouter()
    let (show, setShow) = React.useState(_ => false)
    
    switch(router.route){
        | "/"=> React.null
        | _ =>     
                <div className="fixed bottom-3 right-5 flex flex-col items-end">
                    <div 
                        className="font-alphbeta text-2xl cursor-pointer"
                        onClick={(_) => setShow(show => !show)}
                    >
                        {"Lost?"->React.string}
                    </div>
                    <div 
                        className="relative overflow-hidden transition-all duration-700"
                        style={ReactDOM.Style.make(~maxHeight=`${show ? "200px": "0"}`, ())}
                    >
                        <ul>
                        <li>
                            <a className="text-sm block text-right hover:bg-white" target="_blank" href="https://docs.float.capital">
                                {"View our docs"->React.string}
                            </a>
                        </li>
                        <li>
                            <a className="text-sm block text-right hover:bg-white" href="https://discord.gg/dqDwgrVYcU" target="_blank">
                                {"Join our discord"->React.string}
                            </a>
                        </li>
                        </ul>
                    </div>
                </div>
    }
}