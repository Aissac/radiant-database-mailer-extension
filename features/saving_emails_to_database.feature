Feature: Database Mailer
  In order to add database persistency to emailed forms
  As an admin
  I want to manage form fields
  
  Background:
    Given I am logged in as an admin

  Scenario: Saving an email to database if 'save_to_database' is true
    Given I am on the contact page
      And I fill in "Name" with "Stan Marsh"
      And I fill in "Email" with "stan_marsh@example.com"
      And I fill in "Message" with "Hello from South Park"
      And I fill in "attachment"
     When I press "Send"
          # email is sent
     Then I should be on the thank you page
      And "contact@example.com" should receive 1 email
          # email is saved to database
     When I go to the form datas index
     Then I should see "Stan Marsh"
      And I should see "Hello from South Park"
          # email attachment is saved to database
     When I follow "Show"
     Then I should see "attachment.jpg"

  Scenario: Sending an email without saving it to the database
    Given I am on the contact no save page
      And I fill in "Name" with "Stan Marsh"
      And I fill in "Email" with "stan_marsh@example.com"
      And I fill in "Message" with "Hello from South Park"
      And I fill in "attachment"
     When I press "Send"
     Then I should be on the thank you page
      And "contact@example.com" should receive 1 email
     When I go to the form datas index
     Then I should not see "Stan Marsh"
      And I should not see "Hello from South Park"
  
  Scenario: Deleting an existing form data
    Given I am on the form datas index
     When I follow "Delete"
     Then I should be on the form datas index
      And I should see "Record deleted!"
      And I should not see "Eric Cartman"
