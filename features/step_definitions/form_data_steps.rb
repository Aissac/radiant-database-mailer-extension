Given /^I fill in "([^\"]*)"$/ do |field|
  fill_in(field, :with => "#{RAILS_ROOT}/vendor/extensions/database_mailer/features/fixtures/attachment.jpg")
end