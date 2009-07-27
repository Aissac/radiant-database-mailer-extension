class MailersDataset < Dataset::Base
  uses :home_page
  
  def load    
    create_page "Contact" do
      create_page_part "contact_body", 
        :name => "body", 
        :content => %Q{
          <r:mailer:form>
            <label for="name">Name:</label><br/>
            <r:mailer:text name="name" /><br/>

            <label for="email">Email:</label><br/>
            <r:mailer:text name="email" /><br/>
            
            <label for="message">Message:</label><br/>
            <r:mailer:textarea name="message" /> <br/>
            
            <label for="attachment">Image:</label><br/>
            <r:mailer:file name="attachment" /><br/>
            
            <input type="submit" value="Send" />
          </r:mailer:form>}          
          
      create_page_part "contact_mailer",
        :name => "mailer",
        :content =>  %Q{
          subject: Contact email
          from: website@example.com
          redirect_to: /contact/thank-you
          recipients:
            - contact@example.com
          }
      create_page "Thank you"
    end
    
    create_page "Contact No Save" do
      create_page_part "contact_body_no_save", 
        :name => "body", 
        :content => %Q{
          <r:mailer:form>
            <label for="name">Name:</label><br/>
            <r:mailer:text name="name" /><br/>

            <label for="email">Email:</label><br/>
            <r:mailer:text name="email" /><br/>
            
            <label for="message">Message:</label><br/>
            <r:mailer:textarea name="message" /> <br/>
            
            <label for="attachment">Image:</label><br/>
            <r:mailer:file name="attachment" /><br/>
            
            <input type="submit" value="Send" />
          </r:mailer:form>}
          
      create_page_part "mailer_no_save",
        :name => 'mailer',
        :content =>  %Q{
          subject: Contact email
          from: website@example.com
          redirect_to: /contact/thank-you
          save_to_database: false
          recipients:
            - contact@example.com
          }
    end
  end  
end