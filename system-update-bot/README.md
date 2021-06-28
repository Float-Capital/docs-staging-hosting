# Update System State Bot

---

With next price execution we need a bot to call update system state "continuously".
The current contracts require another transaction (mint for example) in order for the batch tx to distribute the tokens to the end users

### Timeline

               pending               time between price update    *time waiting for next mint in market*

tx initiated |---------| txComplete |----------------------------|----------------------| complete

_The time waiting for next mint in market_ can be avoided by the bot calling the `updateSystemState` on that market.

## Scripts to run

`yarn dev`
`yarn start`

## Docker scripts to run

`docker build -t system_update_bot .`
`docker run -d system_update_bot`
`docker container create system_update_bot`

`docker rename <default-docker-container-name> system_update_bot`

\*Don't forget to populate the secretsManager.js

## Improvements

- Convert to rescript
- Only execute on market oracle price update
