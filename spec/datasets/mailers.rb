class MailersDataset < Dataset::Base
  uses :home_page
  
  def load
    create_page "Contact" do
      create_page_part "contact_body", 
        :name => "body", 
        :content => %Q{
          <r:mailer:form>
            Name:<br/>
            <r:mailer:text name="name" /> <br/>
            Email:<br/>
            <r:mailer:text name="email" /> <br/>
            Message:<br/>
            <r:mailer:textarea name="message" /> <br/>
            Image:<br/>
            <r:mailer:file name="attachment" /><br/>
            <input type="submit" value="Send" />
          </r:mailer:form>}          
          
      create_page_part "contact_mailer",
        :name => "mailer",
        :content =>  %Q{
          subject: Contact email
          from: test@example.com
          redirect_to: /contact-success
          recipients:
            - foo@bar.com
          }
    end
    
    create_page "Contact No Save" do
      create_page_part "mailer_no_save",
        :name => 'mailer',
        :content =>  %Q{
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