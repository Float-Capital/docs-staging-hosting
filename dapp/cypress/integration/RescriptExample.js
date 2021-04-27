// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var CypressConfig = require("./config/CypressConfig.js");
var Mocha$BsMocha = require("bs-mocha/src/Mocha.js");

import '@testing-library/cypress/add-commands'
;

Mocha$BsMocha.describe("Basic navigation demo")(undefined, undefined, undefined, (function (param) {
        Mocha$BsMocha.before_each(undefined)(undefined, undefined, undefined, (function (param) {
                cy.visit(CypressConfig.baseUrl);
                
              }));
        Mocha$BsMocha.it("Homepage should say 'start trading'")(undefined, undefined, undefined, (function (param) {
                cy.findByAltText("start-trading");
                
              }));
        return Mocha$BsMocha.it("Clicking the 'start-trading' button should go to the markets page")(undefined, undefined, undefined, (function (param) {
                      cy.findByAltText("start-trading").click();
                      cy.findAllByText("Liquidity");
                      return (cy.location("pathname").should("eq", "/markets"));
                    }));
      }));

/*  Not a pure module */
