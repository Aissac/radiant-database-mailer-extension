Database Mailer
===

About
---

A [Radiant][rd] Extension by [Aissac][ai] that adds database persistence to emailed forms. It works on top of the Radiant [Mailer Extension][ma] and the fields recorded to the database are user defined. The extension adds a tab to the Radiant admin interface allowing you to browse saved records.

Features
---

* Record sent forms to the database
* Skip mail delivery (only record to database)
* Add fields to be saved without loosing data

Installation
---

First you need to install the `mailer` extension:

    cd /path/to/radiant
    git clone git://github.com/radiant/radiant-mailer-extension.git vendor/extensions/mailer
    
Edit `config/environment.rb` and add desired fields to be recorded:

    DATABASE_MAILER_COLUMNS = {
      :name => :string,
      :message => :text,
      :email => :string
    }

Next, migrate and update the extension:

    rake radiant:extensions:database_mailer:migrate
    rake radiant:extensions:database_mailer:update

Adding fields to the `DATABASE_MAILER_COLUMNS` hash and re-running `rake radiant:extensions:database_mailer:migrate` nondestructively adds fields to be saved. Fields removed from the hash are not deleted.

Finally, create your Mailer pages and make sure to use the same field names:

    <r:mailer:form>
      <r:mailer:hidden name="subject" value="Email from my Radiant site!" /> <br/>
      Name:<br/>
      
      <r:mailer:text name="name" /> <br/>
      Message:<br/>
      
      <r:mailer:textarea name="message" /> <br/>
      <input type="submit" value="Send" />
    </r:mailer:form>
    
Look at the Mailer Extension README for information on how to configure mail delivery.

Fields that are not specified by `DATABASE_MAILER_COLUMNS` are silently ignored.

TODO
---

* CSV export

[rd]: http://radiantcms.org/
[ai]: http://www.aissac.ro/
[ma]: http://github.com/radiant/radiant-mailer-extension