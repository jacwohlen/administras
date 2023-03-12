/// <reference types="cypress" />

describe('Login Screen', () => {
  it('should show login screen', () => {
    cy.visit('/')
    cy.contains('Welcome to Administra')
  })
})