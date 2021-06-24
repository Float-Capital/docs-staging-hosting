# Update System State Bot
------------------------

With next price execution we need a bot to call update system state "continuously". 
The current contracts require another transaction (mint for example) in order for the batch tx to distribute the tokens to the end users

### Timeline

               pending               time between price update    *time waiting for next mint in market*      
tx initiated |---------| txComplete |----------------------------|----------------------| complete

*The time waiting for next mint in market* can be avoided by the bot calling the `updateSystemState` on that market.

## Scripts to run
`yarn dev`
`yarn start`

## Improvements

- Convert to rescript
- Only execute on market oracle price update
- Dockerize