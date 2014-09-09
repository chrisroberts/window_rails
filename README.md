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

### Show an alert

```erb
<%= open_alert_window('This is an alert!') %>
```

### Close alert

```erb
<%= close_alert_window %>
```

### Create a new window

```erb
<%= create_window(:name => 'my-window', :title => 'My Window!', :content => 'Some Content') %>
```

### Close window

```erb
<%= close_window('my-window') %>
```

## Infos

* Repository: https://github.com/chrisroberts/window_rails

## License

* WindowRails is released under an MIT license
