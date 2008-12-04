module DatabaseMailerProcessing
    
  def process_mail_with_database(mail, config)
    page = mail.page
    plain_body = (page.part( :email ) ? page.render_part( :email ) : page.render_part( :email_plain ))
    
    FormData.create(mail.data.merge(:url => mail.page.url, :blob => plain_body)) if config[:save_to_database] || config[:save_to_database].nil?
    
    process_mail_without_database(mail, config)
  end

end