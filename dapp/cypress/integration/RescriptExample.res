%%raw("import '@testing-library/cypress/add-commands'")

// This code uses mocha instead of jest: https://github.com/cypress-io/cypress/issues/281
open BsMocha
open Mocha

describe("Basic navigation demo", () => {
  before_each(() => {
    Cy.visit(CypressConfig.baseUrl)
  })

  it("Homepage should say 'start trading'", () => {
    let _ = Cy.RTF.findByAltText("start-trading")
  })

  it("Clicking the 'start-trading' button should go to the markets page", () => {
    Cy.RTF.findByAltText("start-trading")->Cy.Element.click
    // NOTE: this is a terrible test to check if the user is on the markets page
    let _ = Cy.RTF.findAllByText("Liquidity")

    // Bindings not complete for this
    %raw(`cy.location("pathname").should("eq", "/markets")`)
  })
})
