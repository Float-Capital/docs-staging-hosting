%%raw("import '@testing-library/cypress/add-commands'")

// This code uses mocha instead of jest: https://github.com/cypress-io/cypress/issues/281
open BsMocha
open Mocha

// describe("Basic navigation demo", () => {
//   before_each(() => {
//     Cy.visit(CypressConfig.baseUrl)
//   })

//   it("Homepage should say 'start trading'", () => {
//     let _ = Cy.RTF.findByAltText("start-trading")
//   })

//   it("Clicking the 'start-trading' button should go to the markets page", () => {
//     Cy.RTF.findByAltText("start-trading")->Cy.Element.click
//     // NOTE: this is a terrible test to check if the user is on the markets page
//     let _ = Cy.RTF.findAllByText("Liquidity")

//     // Bindings not complete for this
//     %raw(`cy.location("pathname").should("eq", "/markets")`)
//   })
// })

describe("Minting", () => {
  before_each(() => {
    Cy.visit(`${CypressConfig.baseUrl}/markets`)
  })

  it("Clicking the 'start-trading' button should go to the markets page", () => {
    let longButtons = Cy.RTF.findAllByTextRe(%re("/mint long/i"))

    let firstButton = longButtons->Cy.Element.first

    let _ = firstButton->Cy.Element.click

    let _ = %raw(`cy.location().should((loc) => {
      expect(loc.pathname).to.include('/markets')

      expect(loc.search).to.include("actionOption=long")
      expect(loc.search).to.include("marketIndex=1")
    })`)

    let inputBox = Cy.RTF.findByPlaceholderTextRe(%re("/mint/i"))->Cy.Element.should(#exist)

    let _ = inputBox->Cy.Element.click->Cy.Element._type("1.3")

    let submitButton =
      Cy.RTF.findByRole(#button, {name: Some(%re("/mint/i"))})->Cy.Element.should(#exist)

    let _ = submitButton->Cy.Element.click

    let _ = %raw(`cy.location().should((loc) => {
      expect(loc.pathname).to.include('/wait here')

      expect(loc.search).to.include("actionOption=long")
      expect(loc.search).to.include("marketIndex=1")
    })`)
  })
  // %raw(`
  //   () => {
  //     const longNodes = cy.findAllByText(/mint long/i)
  //     longNodes.should("exist")

  //     longNodes.first().click()
  //     console.log("nodes",longNodes)
  //     // console.log("nodes",longNodes[1])
  //     console.log("keys", Object.keys(longNodes))
  //   }
  // `),
})
