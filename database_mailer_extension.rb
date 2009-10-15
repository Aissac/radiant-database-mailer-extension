require_dependency 'application_controller'

class DatabaseMailerExtension < Radiant::Extension
  version "1.0"
  description "Save fields from mailer forms to the database."
  url "http://blog.aissac.ro/radiant/database-mailer-extension/"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources :form_datas do |form_data|
        form_data.resources :form_data_assets
      end
    end
  end
  
  def activate
    throw "MailerExtension must be loaded before DatabaseMailerExtension" unless defined?(MailerExtension)
    MailController.class_eval do
      include DatabaseMailerProcessing
      alias_method_chain :process_mail, :database
    end
    admin.nav["content"] << admin.nav_item(:database_mailer, "Database Mailer", "/admin/form_datas")
        
    Mime::Type.register "application/vnd.ms-excel", :xls
  end
  
  def deactivate
  end
end