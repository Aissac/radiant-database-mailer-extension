class CreateFormDataAssets < ActiveRecord::Migration
  def self.up
    create_table :form_data_assets do |t|
      t.references :form_data
      t.string :field_name
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
    
      t.timestamps
    end
    
    add_index :form_data_assets, :form_data_id
  end

  def self.down
    remove_index :form_data_assets, :form_data_id
    drop_table :form_data_assets
  end
end
