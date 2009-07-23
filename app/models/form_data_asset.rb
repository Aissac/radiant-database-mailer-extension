class FormDataAsset < ActiveRecord::Base
  belongs_to :form_data
  
  has_attached_file :attachment, :styles => { :thumb => '100x100>' }  
  
  IMAGE_CONTENT_TYPES = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg']
  
  def image?
    IMAGE_CONTENT_TYPES.include? attachment_content_type
  end
  
end
