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
            File:<br/>
            <r:mailer:file name="attached_file" /> <br/>
            <input type="submit" value="Send" />
          </r:mailer:form>}
      create_page_part "mailer",
        :content => {
            'subject' => 'From the website of Whatever',
            'from' => 'no_reply@aissac.ro',
            'redirect_to' => '/contact/thank-you',
            'recipients' => 'example@aissac.ro'}.to_yaml
      create_page_part "email",
        :content => %Q{
          <r:mailer>
            Name: <r:get name="name" />
            Email: <r:get name="email" />
            Message: <r:get name="message" />
          </r:mailer>
        }
      create_page "Thank You", :body => "Thank you!"
    end
    
    
    create_page "Contact No Save" do
      create_page_part "mailer_no_save",
        :name => 'mailer',
        :content => {
            'subject' => 'From the website of Whatever',
            'from' => 'no_reply@aissac.ro',
            'redirect_to' => '/contact/thank-you',
            'recipients' => 'example@aissac.ro',
            'save_to_database' => 'false'}.to_yaml
      create_page "Thank You", :body => "Thank you!"
    end

    # create_record :page, :contact, 
    #   {:title => "Contact", 
    #   :breadcrumb => "contact", 
    #   :slug => "/contact", 
    #   :class_name => nil}
    #                                 
    # create_record :page_part, :mailer, 
    #   {:id => 1,
    #   :name => "mailer", 
    #   :content =>  %Q{
    #     subject: Contact email
    #     from: test@example.com
    #     redirect_to: /contact-success
    #     recipients:
    #       - foo@bar.com
    #     },
    #   :page_id => page_id(:contact)}
    #   
    # create_record :page, :contact_no_save, 
    #   {:title => "Contact",
    #   :breadcrumb => "contact",
    #   :slug => "/contact",
    #   :class_name => nil}
    #   
    # create_record :page_part, :mailer, 
    #   {:id => 2,
    #   :name => "mailer",
    #   :content =>  %Q{
    #     subject: Contact email
    #     from: test@example.com
    #     redirect_to: /contact-success
    #     save_to_database: false
    #     recipients:
    #       - foo@bar.com
    #     },
    #   :page_id => page_id(:contact_no_save)}
  end  
end