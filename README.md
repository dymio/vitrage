Vitrage
=======

Vitrage allows store and manage your Rails application web-pages content as separated pieces of different types: text, image, slider, several-columned text etc. Pieces are objects of different Rails models having their specific views for show and edit. Vitrage allows you inline editing of content pieces.

<img src="http://www.vitroart.ru/upload/information_system_35/4/2/2/item_422/information_items_1242584051.jpg" alt="vitrage of glass" height="600" width="379">


Installation
------------

Put this line in your Gemfile:

    gem 'vitrage'

Then run `bundle install`.

After installing the gem, you need to run the generator.

    bin/rails generate vitrage:install

The generator adds these files:

    app/models/vitrage_piece.rb
    db/migrate/[timestamp]_create_vitrage_pieces.rb

Now, migrate your database: `bin/rake db:migrate`


Use vitrage content blocks for your model
-----------------------------------------

Add to any models you want to use vitrage content pieces line:

    acts_as_vitrage_owner

Add render call to the `show` view:

    <%= render partial: 'vitrage/show', locals: { owner: @object } %>

Add render call to the `edit` view:

    <%= render partial: 'vitrage/edit', locals: { owner: @object } %>


Add content piece
-----------------

Content pieces it is necessary parts of Vitrage. By default we have no pieces.
Describes process of creating simple content piece only with text field.

    bin/rails generate vitrage:piece Text body:text

The generator adds these files:

    app/models/vitrage/vtpc_text.rb
    app/views/vitrage/_vtpc_text.html.erb
    app/views/vitrage/forms/_vtpc_text.html.erb
    db/migrate/[timestamp]_create_vtpc_texts.rb

Migrate your database: `bin/rake db:migrate`

Add name of content piece model to `BLOCKS_KINDS` array constant
of VitragePiece model.


License
-------
Vitrage is released under the [MIT License](MIT-LICENSE).


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Feel free to use code of the project as you want, [create issues](https://github.com/dymio/vitrage/issues) or make pull requests.
