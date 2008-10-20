class AddDataColumns < ActiveRecord::Migration
  def self.up
    DATABASE_MAILER_COLUMNS.each do |k, v|
      unless FormData.column_names.include?(k.to_s)
        add_column(:form_datas, k, v)
        add_index(:form_datas, k)
      end
    end
  end
  
  def self.down
  end
end