# v1.0.2
* Support custom callback on confirmation accept

# v1.0.0
* Migrate to bootstrap based modals
* Complete API refactor

# v0.2.12
* Fixes for proper loading in Rails 3.2

# v0.2.11
* Provides windowing methods to ActionView::Base for JS templates
* Removes deprecated rake tasks

# v0.2.10
* Fixes close window bug

# v0.2.9
* Let #window return raw string when passed :raw argument
* Check for window before attempting to close a window

# v0.2.8
* Request content as HTML when loading window

# v0.2.7
* Remove content holder element after window has been closed to prevent orphaned content

# v0.2.6
* Fixes for #link_to_window

# v0.2.5
* Better height/width determination for resize methods

# v0.2.4
* Add #resize_to_fit, #auto_resize and #center_window methods

# v0.2.3
* Add config directory to gemspec
* Provide Rails 3 compatible routing

# v0.2.2
* Fix bug in #close_window

# v0.2.1
* Enable #observe_dynamically_loaded_field for compatibility (outputs prototype)

# v0.2.0
* Rebuild off jquery-ui dialogs

# v0.1.4
* Fix to #update_window method to accept content not key

# v0.1.3
* Rails init inclusion within gem package

# v0.1.2
* Add rake task for install
* Pull window content from reference to prevent writing content multiple times

# v0.1.1
* Proper rails loading when included via gem
* Fix for window jumping when constraints applied
* Fix for #observe_dynamically_loaded_field when using a function instead of callback
* Make IFrame usage optional

# v0.1.0
* Lots of cleanup
* Better builders available
* #observe_dynamically_loaded_field to watch things that have been inserted into the DOM
* Better window handling
* Default class set to alphacube

# v0.0.1
* Initial release
