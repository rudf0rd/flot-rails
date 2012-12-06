# Flot Rails #
Rails 3 Wrapper for flot an ...

Attractive JavaScript charts for jQuery
http://www.flotcharts.org/
https://github.com/flot/flot


## Install ##
Just add the line 
```ruby
gem 'flot-rails' 
```
in your Gemfile and run 
```sh
bundle install
```

## Example Usage ##

Modify the `application.js` like shown below:

```js
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.flot
//= require jquery.flot.pie
```

Then use the pure javascript as shown here: https://github.com/flot/flot/blob/master/API.md
or with my little RailsHelper:

```ruby
module ApplicationHelper
  include Flot
end
```

```erb
<!-- views/my_controller/index.html -->
<%= pie_chart [{label: 'Hello World', data: 50}, {label: 'Foo', data: 25}, {label: 'Bar', data: 25}] %>
```