module DatabaseMailerProcessing
    
  def process_mail_with_database(mail, config)
    FormData.create(mail.data.merge(:url => mail.page.url)) if config[:save_to_database] || config[:save_to_database].nil?
    process_mail_without_database(mail, config)
  end

end