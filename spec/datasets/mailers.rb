class MailersDataset < Dataset::Base
  uses :home_page
  
  def load
    create_record :page, :contact, 
      {:title => "Contact", 
      :breadcrumb => "contact", 
      :slug => "/contact", 
      :class_name => nil}
                                    
    create_record :page_part, :mailer, 
      {:id => 1,
      :name => "mailer", 
      :content =>  %Q{
        subject: Contact email
        from: test@example.com
        redirect_to: /contact-success
        recipients:
          - foo@bar.com
        },
      :page_id => page_id(:contact)}
      
    create_record :page, :contact_no_save, 
      {:title => "Contact",
      :breadcrumb => "contact",
      :slug => "/contact",
      :class_name => nil}
      
    create_record :page_part, :mailer, 
      {:id => 2,
      :name => "mailer",
      :content =>  %Q{
        subject: Contact email
        from: test@example.com
        redirect_to: /contact-success
        save_to_database: false
        recipients:
          - foo@bar.com
        },
      :page_id => page_id(:contact_no_save)}
  end  
end