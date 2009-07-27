Database Mailer
===

About
---

A [Radiant][rd] Extension by [Aissac][ai] that adds database persistence to emailed forms. It works on top of the Radiant [Mailer Extension][rme] and the fields recorded to the database are user defined. The extension adds a tab to the Radiant admin interface allowing you to browse saved records.

Tested on Radiant 0.7.1 and 0.8.

Features
---

* Save posted form fields and entire mail message to the database
* Save e-mail attachments using paperclip
* Configurable save-to-database for mailer forms
* Add fields to be saved without loosing data
* Admin interface to browse saved records
* Export data to CSV and XLS

Installation
---

Radiant Database Mailer Extension has three dependecies, the Radiant Mailer Extension, the `will_paginate` gem/plugin and the `paperclip` gem/plugin

Install the `mailer` extension:

    git submodule add git://github.com/radiant/radiant-mailer-extension.git\
      vendor/extensions/mailer

###Note

At the time being you will need Aissac's version of the [Radiant Mailer Extension][arme], as it incorporates sending e-mails with attachments.

the `will_paginate` gem/plugin:   

    git submodule add git://github.com/mislav/will_paginate.git\
      vendor/plugins/will_paginate
    
or

    sudo gem install mislav-will_paginate --source http://gems.github.com

and the `paperclip` gem/plugin 

    git submodule add git://github.com/thoughtbot/paperclip.git \
      vendor/plugins/will_paginate

or

    sudo gem install thoughtbot-paperclip --source http://gems.github.com

Next edit `config/environment.rb` and add desired fields to be recorded:

    DATABASE_MAILER_COLUMNS = {
      :name => :string,
      :message => :text,
      :email => :string
    }

Migrate and update the extension:

    rake radiant:extensions:database_mailer:migrate
    rake radiant:extensions:database_mailer:update

###Note

To get the Radiant 0.7.1 version tag you need to:

    cd vendor/extensions/database_mailer/
    git checkout v0.7


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

Any attachments that the e-mail might have will be saved on the file system. They can be downloaded from the details page of every record.

If you want to take advantage of the blob field you need to create a `email` page part. The blob field keeps the sent version of the email.

Fields that are not specified by `DATABASE_MAILER_COLUMNS` are silently ignored.

Usage
---

Create your Mailer pages and make sure to use the same field names:

    <r:mailer:form>
      <label for="name">Name:</label><br/>
      <r:mailer:text name="name" /><br/>

      <label for="email">Email:</label><br/>
      <r:mailer:text name="email" /><br/>
  
      <label for="message">Message:</label><br/>
      <r:mailer:textarea name="message" /> <br/>
  
      <label for="attachment">Image:</label><br/>
      <r:mailer:file name="attachment" /><br/>
  
      <input type="submit" value="Send" />
    </r:mailer:form>

Create the `mailer` page part:

    subject: From the website of Whatever
    from: noreply@example.com
    redirect_to: /contact/thank-you
    recipients:
      - one@one.com
      - two@two.com
      
Create an `email` page part (to take advantage of the blob field):

    <r:mailer>
      Name: <r:get name="name" />
      Email: <r:get name="email" />
      Message: <r:get name="message" />
    </r:mailer>

Contributors
---

* Cristi Duma
* Istvan Hoka

[rd]: http://radiantcms.org/
[ai]: http://www.aissac.ro/
[rme]: http://github.com/radiant/radiant-mailer-extension
[arme]: http://github.com/Aissac/radiant-mailer-extension