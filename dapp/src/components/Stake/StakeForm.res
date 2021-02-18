@react.component
let make = () =>
<Card>
    <Form     
      className="this-is-required"
      onSubmit={() => {
        ()
      }}>
    <div className="px-8 pt-2">
     <div className="-mb-px flex justify-between">
         <div className="no-underline text-teal-dark border-b-2 border-teal-dark tracking-wide font-bold py-3 mr-8" href="#">
             {`Stake ↗️`->React.string}
         </div>
         <div className="no-underline text-grey-dark border-b-2 border-transparent tracking-wide font-bold py-3" href="#">
             {`Redeem ↗️`->React.string}
         </div>
     </div>
    </div>
      <MaxInput disabled={false} onBlur={_=>()} onChange={_=>()} onMaxClick={_=>()} placeholder="stake" value=""/>

      <Button onClick={(_)=>()} variant="large">
        {`STAKE GOLD`}
      </Button>
    </Form>
</Card>

