Vitrage
=======

Vitrage allows store and manage your Rails application web-pages content as separated pieces of different types: text, image, slider, several-columned text etc. Pieces are objects of different Rails models having their specific views for show and edit. Vitrage allows you inline editing of content pieces.

<img src="http://www.vitroart.ru/upload/information_system_35/4/2/2/item_422/information_items_1242584051.jpg" alt="vitrage of glass" height="600" width="379">

[![Gem Version](https://badge.fury.io/rb/vitrage.svg)](http://badge.fury.io/rb/vitrage)
[![vitrage API Documentation](https://www.omniref.com/ruby/gems/vitrage.png)](https://www.omniref.com/ruby/gems/vitrage)

Installation
------------

Put this line in your Gemfile:

    gem 'vitrage'

Then run `bundle install`.

After installing the gem, you need to run the generator.

    bin/rails generate vitrage:install

The generator adds these files:

    app/models/vitrage_owners_pieces_slot.rb
    db/migrate/[timestamp]_create_vitrage_owners_pieces_slots.rb

and line to the `routes.rb` file:

    Vitrage.routes(self)

Now, migrate your database: `bin/rake db:migrate`

Require js in your js file (`application.js` by default):

    //= require jquery
    //= require jquery_ujs
    //= require jquery.remotipart
    //= require vitrage/vitrage

Vitrage needs jquery, jquery_ujs and jquery.remotipart for correct work.
If you have this scripts already required, just skip inserting they strings.

Require vitrage css in your css file (`application.css` by default):

    *= require vitrage/vitrage


Use vitrage content pieces for your model and views
---------------------------------------------------

Add to any models you want to use vitrage content pieces line:

    acts_as_vitrage_owner

Add render call to the `show` view:

    <%= show_vitrage_for @object %>

Add render call to the `edit` view:

    <%= edit_vitrage_for @object %>


Add content piece
-----------------

Content pieces it is necessary parts of Vitrage. By default we have no pieces.
Describes process of creating simple content piece only with text field.

    bin/rails generate vitrage:piece Text body:text

The generator adds these files:

    db/migrate/[timestamp]_create_vtrg_texts.rb
    app/models/vitrage_pieces/vtrg_text.rb
    app/views/vitrage/_vtrg_text.html.erb
    app/views/vitrage/_vtrg_text_form.html.erb
    # ... and more

Migrate your database: `bin/rake db:migrate`

Add name of content piece model to `PIECE_CLASSES_STRINGS` array constant
of VitrageOwnersPiecesSlot model.

Add styles for add new block button:

    .vtrg-new-block-kinds .vtrg-text { background: red; }

Do not forget about piece view partials.


Custom Pieces Controller
------------------------

`PiecesController` have actions for vitrage pieces.
If you need to override controller, create new controller, inherited from `Vitrage::PiecesController`:

    class VitragePiecesController < Vitrage::PiecesController
      # add devise authorization as option
      before_action :authenticate_admin_user!
    end

And add parameter `controller` to routes method call with underscored and pluralized controller name:

    Vitrage.routes(self, controller: 'vitrage_pieces')



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
