class CreateFormDatas < ActiveRecord::Migration
  def self.up
    create_table :form_datas do |t|
      t.column :url, :string
      t.column :blob, :text
      t.column :exported, :datetime
      t.timestamps
    end
    
    add_index :form_datas, :url
  end

  def self.down
    drop_table :form_datas
  end
end
