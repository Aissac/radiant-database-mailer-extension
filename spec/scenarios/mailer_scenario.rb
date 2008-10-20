class MailerScenario < Scenario::Base
  uses :home_page
  
  def load
    create_page "Contact" do
      create_page_part "mailer", :id => 1, :content => %Q{
        subject: Contact email
        from: test@example.com
        redirect_to: /contact-success
        recipients:
          - foo@bar.com
      }
    end
    
    create_page "ContactNoSave" do
      create_page_part "mailer", :id => 2, :content => %Q{
        subject: Contact email
        from: test@example.com
        redirect_to: /contact-success
        save_to_database: false
        recipients:
          - foo@bar.com
      }
    end
  end
end