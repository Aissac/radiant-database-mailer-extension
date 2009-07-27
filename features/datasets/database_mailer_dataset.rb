class DatabaseMailerDataset < Dataset::Base
  
  def load
    create_record :form_datas, :eric_cartman, {
      :name => "Eric Cartman",
      :email => "eric_cartman@example.com",
      :message => "test message"
    }
    
    create_record :form_data_assets, :attachment, {
      :form_data_id => form_datas(:eric_cartman).id,
      :field_name => "attachment",
      :attachment_file_name => "attachment.jpg",
      :attachment_content_type => "image/jpg",
      :attachment_file_size => "1234"
    }
  end
  
end