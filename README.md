Database Mailer
===

About
---

A [Radiant][rd] Extension by [Aissac][ai] that adds database persistence to emailed forms. It works on top of the Radiant [Mailer Extension][ma] and the fields recorded to the database are user defined. The extension adds a tab to the Radiant admin interface allowing you to browse saved records.

Features
---

* Save posted form fields and entire mail message to the database
* Configurable save-to-database for mailer forms
* Add fields to be saved without loosing data
* Admin interface to browse saved records
* Export data to CSV and XLS

Installation
---

Radiant Database Mailer Extension has two dependecies, the Radiant Mailer Extension and `will_paginate` gem/plugin

Install the `mailer` extension:

    git submodule add git://github.com/radiant/radiant-mailer-extension.git\
      vendor/extensions/mailer

and the `will_paginate` gem/plugin:   

    git submodule add git://github.com/mislav/will_paginate.git\
      vendor/plugins/will_paginate
    
or

    sudo gem install mislav-will_paginate --source http://gems.github.com

Next edit `config/environment.rb` and add desired fields to be recorded:

    DATABASE_MAILER_COLUMNS = {
      :name => :string,
      :message => :text,
      :email => :string
    }

Migrate and update the extension:

    rake radiant:extensions:database_mailer:migrate
    rake radiant:extensions:database_mailer:update

Configuration
---

Adding fields to the `DATABASE_MAILER_COLUMNS` hash and re-running `rake radiant:extensions:database_mailer:migrate` nondestructively adds fields to be saved. Fields removed from the hash are not deleted.

Look at the Mailer Extension README for information on how to configure mail delivery.

If you set `save_to_database` to false in the Mailer config, saving to the database is skipped and just mail delivery takes place. Example (in the `mailer` page part):

    subject: From the website of Whatever
    from: noreply@example.com
    redirect_to: /contact/thank-you
    save_to_database: false
    recipients:
      - one@one.com
      - two@two.com

If you want to take advantage of the blob field you need to create a `email` page part. The blob field keeps the sent version of the email.

Fields that are not specified by `DATABASE_MAILER_COLUMNS` are silently ignored.

Usage
---

Create your Mailer pages and make sure to use the same field names:

    <r:mailer:form>
      <r:mailer:hidden name="subject" value="Email from my Radiant site!" /> <br/>
      Name:<br/>
      <r:mailer:text name="name" /> <br/>
      Email:<br/>
      <r:mailer:text name="email" /> <br/>
      
      Message:<br/>
      <r:mailer:textarea name="message" /> <br/>
      <input type="submit" value="Send" />
    </r:mailer:form>

Contributors
---

* Cristi Duma
* Istvan Hoka

[rd]: http://radiantcms.org/
[ai]: http://www.aissac.ro/
[ma]: http://github.com/radiant/radiant-mailer-extension