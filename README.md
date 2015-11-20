# WindowRails

Rails helper for easy to use modals via bootstrap.

## Requirements

* jQuery
* Bootstrap

## Installation

Add window_rails to your application Gemfile:

```ruby
  gem 'window_rails'
```

and then update your application manifests:

```
// app/assets/javascripts/application.js
//= require window_rails
```

```
/*
* app/assets/stylesheets/application.css
*= require window_rails
*/
```

## Basic usage

The WindowRails library provides a simple interface to Bootstrap
based modals from Rails views removing the need for writing JavaScript
for integration. For simplicity of examples, lets assume the views
defined below are for JS formatted requests:

### Creating a new window

Create a new window:

```erb
<%=
  create_window(
    :name => 'my_window',
    :title => 'My window!',
    :content => 'Important things.'
  )
%>
```

Create a small window:

```erb
<%=
  create_window(
    :name => 'my_window',
    :title => 'My window!',
    :size => 'small',
    :content => 'Important things.'
  )
%>
```

Or create a large window:

```erb
<%=
  create_window(
    :name => 'my_window',
    :title => 'My window!',
    :size => 'large',
    :content => 'Important things.'
  )
%>
```

Perhaps the content is located in a partial:

```erb
<%=
  create_window(
    :name => 'my_window',
    :title => 'My window!',
    :size => 'large',
    :content => render(
      :partial => 'my_partial',
      :locals => {
        :thing1 => @thing1,
        :thing2 => @thing2
      }
    )
  )
%>
```

Include a footer on the window:

```erb
<%=
  create_window(
    :name => 'my_window',
    :title => 'My window!',
    :size => 'large',
    :content => render(
      :partial => 'my_partial',
      :locals => {
        :thing1 => @thing1,
        :thing2 => @thing2
      }
    ),
    :footer => render(
      :partial => 'my_footer_partial'
    )
  )
%>
```

### Close the window

Windows are referenced by name. We can close the
previously defined `my_window`:

```erb
<%= close_window('my_window') %>
```

### Open a closed window

Lets open that window back up:

```erb
<%= open_window('my_window') %>
```

Or lets open it and change the title and content:

```erb
<%=
  open_window(
    'my_window',
    :title => 'My Updated Window!',
    :content => 'New content.'
  )
%>
```

There's also options we can set:

```erb
<%=
  open_window(
    'my_window',
    :title => 'My Updated Window!',
    :content => 'New content.',
    :esc_close => true,
    :backdrop => true,
    :static_backdrop => true
  )
%>
```

### Alert window

#### Open alert window

Need to show an alert? Use the alert window:

```erb
<%= open_alert_window('This is an important alert!') %>
```

#### Close alert window

And to close the important alert:

```erb
<%= close_alert_window %>
```

### Information window

#### Open information window

Need to show some information:

```erb
<%= open_info_window('This is some information') %>
```

Want to provide a title for the informational window:

```erb
<%=
  open_info_window(
    'This is some information',
    :title => 'Information!'
  )
%>
```

Or automatically close the window after a set number of seconds:

```erb
<%=
  open_info_window(
    'This is some information',
    :title => 'Information!',
    :auto_close => 4
  )
%>
```

#### Close information window

```erb
<%= close_info_window %>
```

### Confirmation window

WindowRails provides a confirmation window to allow user
acceptance prior to running a task. The task can be provided
as a remote URL that is requested via AJAX, or a local callback
function. Upon user confirmation, WindowRails will display a
loading window while the action is processing and a completion
window once completed.

#### Open a confirmation window

Open a confirmation window before making a remote request:

```erb
<%=
  open_confirm_window(
    'Do this thing?',
    :url => '/do/thing'
  )
%>
```

Specify the HTTP method for the remote call when doing something
like a deletion:

```erb
<%=
  open_confirm_window(
    'Delete this thing?',
    :url => '/delete/thing',
    :ajax => 'delete'
  )
%>
```

Set title for the loading window:

```erb
<%=
  open_confirm_window(
    'Delete this thing?',
    :url => '/delete/thing',
    :ajax => 'delete',
    :progress => 'Deleting thing'
  )
%>
```

Set content for the completion window:

```erb
<%=
  open_confirm_window(
    'Delete this thing?',
    :url => '/delete/thing',
    :ajax => 'delete',
    :progress => 'Deleting thing',
    :complete => 'Thing has been deleted!'
  )
%>
```

Use a callback instead of making a remote request:

```erb
<%=
  open_confirm_window(
    'Delete this thing?',
    :callback => 'my_javascript_callback',
    :progress => 'Deleting thing',
    :complete => 'Thing has been deleted!'
  )
%>
```

And the javascript function `my_javascript_callback` will
be executed.

#### Close the confirmation window

```erb
<%= close_confirm_window %>
```

#### Confirmation window via link

The confirmation window can be generated using information defined within
a link. Using the rails link helper:

```erb
<%=
  link_to('Thing', do_thing_path,
    'class' => 'window-rails',
    'window-rails-url' => do_thing_path,
    'window-rails-confirm' => 'Do the thing?',
    'window-rails-title' => 'Thing Doer',
    'window-rails-ajax' => 'post'
  )
%>
```

Or use a callback:

```erb
<%=
  link_to('Thing', do_thing_path,
    'class' => 'window-rails',
    'window-rails-callback' => 'my_javascript_function',
    'window-rails-confirm' => 'Do the thing?',
    'window-rails-title' => 'Thing Doer',
  )
%>
```

## Infos

* Repository: https://github.com/chrisroberts/window_rails

## License

* WindowRails is released under an MIT license
