module DatabaseMailerProcessing
    
  def process_mail_with_database(mail, config)
    page = mail.page
    plain_body = (page.part( :email ) ? page.render_part( :email ) : page.render_part( :email_plain ))
    
    if config[:save_to_database] || config[:save_to_database].nil?
      fd = FormData.create(mail.data.merge(:url => mail.page.url, :blob => plain_body))    
      mail.data.each do |k, v|
        if v.class.to_s == "Tempfile"
          FormDataAsset.create(:form_data_id => fd.id, :field_name => k, :attachment => v)
        end
      end
    end
    process_mail_without_database(mail, config)
  end
end