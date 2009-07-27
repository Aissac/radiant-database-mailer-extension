Given /^I am logged in as an admin$/ do
  Given "I go to to \"the welcome page\""
  When "I fill in \"Username\" with \"admin\""
  When "I fill in \"Password\" with \"password\""
  When "I press \"Login\""
end