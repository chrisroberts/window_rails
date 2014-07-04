var window_rails = {alert: {}, info: {}, confirm: {}, configuration: {}};

/**
 * Access configuration
 *
 * @param key [String] configuration name
 * @param default_value [Object] default value if no value found
 * @return [Object]
 **/
window_rails.config = function(key, default_value){
  return window_rails.configuration[key] || default_value;
}

/**
 * Generate internal name
 *
 * @param name [String]
 * @return [String] internal name
 **/
window_rails.namer = function(name){
  return 'window-rails-' + name;
}

/**
 * Generate DOM ID for name
 *
 * @param name [String]
 * @return [String] DOM ID
 **/
window_rails.dom_ider = function(name){
  return '#' + window_rails.namer(name);
}

/**
 * Provide window DOM element for name
 *
 * @param name [String]
 * @return [jQuery Element]
 **/
window_rails.window_for = function(name){
  return $(window_rails.dom_ider(name));
}

/**
 * Create a new window
 *
 * @param args [Hash]
 * @option args [String] :name window name
 * @option args [String] :title
 * @option args [String] :content
 * @option args [String] :size size of window (large or small)
 **/
window_rails.create_window = function(args){
  if(window_rails.window_for(args.name).length == 0){
    window_rails.initialize_window(args);
  }
}

/**
 * Open a window
 *
 * @param name [String] window name
 * @param args [Hash]
 * @option args [String] :title
 * @option args [String] :content
 **/
window_rails.open_window = function(name, args){
  if(args){
    if(args.title){
      $(window_rails.dom_ider(name) + ' .modal-title').html(args.title);
    }
    if(args.content){
      $(window_rails.dom_ider(name) + ' .modal-body').html(args.content);
    }
  }
  window_rails.window_for(name).modal({
    keyboard: window_rails.config('default_esc_close', true),
    show: true
  });
}

/**
 * Close window
 *
 * @param name [String] window name
 **/
window_rails.close_window = function(name){
  window_rails.window_for(name).modal('hide');
}

/**
 * Open alert window
 *
 * @param args [Hash]
 * @option args [String] :title
 * @option args [String] :content
 **/
window_rails.alert.open = function(args){
  window_rails.open_window('alert', args);
}

/**
 * Close alert window
 **/
window_rails.alert.close = function(){
  window_rails.close_window('alert');
}

/**
 * Open info window
 *
 * @param args [Hash]
 * @option args [String] :title
 * @option args [String] :content
 **/
window_rails.info.open = function(args){
  window_rails.open_window('info', args);
}

/**
 * Close info window
 **/
window_rails.info.close = function(){
  window_rails.close_window('info');
}

/**
 * Open confirm window
 *
 * @param args [Hash]
 * @option args [String] :title
 * @option args [String] :content
 **/
window_rails.confirm.open = function(args){
  window_rails.open_window('confirm', args);
}

/**
 * Close confirm window
 **/
window_rails.confirm.close = function(){
  window_rails.close_window('confirm');
}

/**
 * Initialize a new window. Creates DOM elements required for modal.
 *
 * @param args [Hash]
 * @option args [String] :name window name
 * @option args [String] :size large or small
 * @option args [String] :title
 * @option args [String] :content
 * @option args [String] :footer
 **/
window_rails.initialize_window = function(args){
  if(!args.name){
    throw new Error('Name must be set when initializing a new window!');
  }
  name = window_rails.namer(args.name);
  if(args.size == 'large'){
    size = 'lg';
  } else {
    size = window_rails.config('default_size', 'sm');
  }
  if(args.footer){
    footer = '\
      <div class="modal-footer">\
        ' + args.footer + '\
      </div>\
    ';
  } else {
    footer = '';
  }
  $('#window-rails-container').append('\
    <div id="' + name + '" class="modal fade" role="modal" aria-labelledby="' + name + '" aria-hidden="true">\
      <div class="modal-dialog modal-' + size + '">\
        <div class="modal-content">\
          <div class="modal-header">\
            <button class="close" type="button" data-dismiss="modal" aria-hidden="true">\
              &times;\
            </button>\
            <h4 class="modal-title">' + args.title + '</h4>\
          </div>\
          <div class="modal-body">\
            ' + args.content + '\
          </div>\
        </div>\
      </div>\
    </div>\
  ');
}

/**
 * Initialize the document for window rails
 **/
window_rails.init = function(){
  if(!window_rails.initialized){
    $('body').append('\
      <div id="window-rails-container">\
        <div id="window-rails-alert" class="modal fade" role="modal" aria-labelledby="window-rails-alert" aria-hidden="true">\
          <div class="modal-dialog modal-sm">\
            <div class="modal-content">\
              <div class="modal-header bg-danger">\
                <button class="close" type="button" data-dismiss="modal" aria-hidden="true">\
                  &times;\
                </button>\
                <h4 class="modal-title">Alert</h4>\
              </div>\
              <div class="modal-body">\
                Alert message\
              </div>\
            </div>\
          </div>\
        </div>\
        <div id="window-rails-info" class="modal fade" role="modal" aria-labelledby="window-rails-info" aria-hidden="true">\
          <div class="modal-dialog modal-sm">\
            <div class="modal-content">\
              <div class="modal-header bg-info">\
                <button class="close" type="button" data-dismiss="modal" aria-hidden="true">\
                  &times;\
                </button>\
                <h4 class="modal-title">Info</h4>\
              </div>\
              <div class="modal-body">\
                Information message\
              </div>\
            </div>\
          </div>\
        </div>\
        <div id="window-rails-confirm" class="modal fade" role="modal" aria-labelledby="window-rails-confirm" aria-hidden="true">\
          <div class="modal-dialog modal-sm">\
            <div class="modal-content">\
              <div class="modal-header bg-warning">\
                <h4 class="modal-title">Confirm</h4>\
              </div>\
              <div class="modal-body">\
                Please confirm!\
              </div>\
              <div class="modal-footer">\
                <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>\
              </div>\
            </div>\
          </div>\
        </div>\
      </div>\
    ');
    window_rails.initialized = true
  }
}

// Initialize once page has loaded
$(document).ready(window_rails.init);