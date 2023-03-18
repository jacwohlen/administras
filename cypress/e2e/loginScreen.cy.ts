/// <reference types="cypress" />

describe('Login Screen', () => {

  beforeEach(function () {
  });

  it('should show login screen', () => {
    cy.visit('/');
    cy.contains('Welcome to Administra');
    cy.get('button').contains('Login');
  });

  it('should show Open Dashboard which allows to access dashboard', () => {
    cy.visit('/');
    cy.login({email: 'info@jacwohlen.ch', password: '12345678'});
    cy.get('a[href*="/dashboard"]').click({ force:true })
    cy.get('div').contains('Today')
    cy.get('div').contains('Trainings')
    cy.get('div').contains('Members')
    cy.get('div').contains('Stats')
  });
});
