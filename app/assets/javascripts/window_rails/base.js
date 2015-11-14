var window_rails = {alert: {}, info: {}, confirm: {action: {}}, loading: {}, configuration: {}, hooks: {}};

/**
 * Access configuration
 *
 * @param key [String] configuration name
 * @param default_value [Object] default value if no value found
 * @return [Object]
 **/
window_rails.config = function(key, default_value){
  if(window_rails.configuration[key] == undefined){
    return default_value;
  } else {
    return window_rails.configuration[key];
  }
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
 * @option args [true,false] :esc_close allow escape key window close
 * @option args [true,false] :show show by default
 * @option args [true,false] :backdrop show backdrop
 * @option args [true,false] :static_backdrop do not allow backdrop click close
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

  backdrop = args && args.backdrop == undefined ? true : args.backdrop;
  if(backdrop && args.static_backdrop){
    backdrop = 'static';
  }

  window_rails.window_for(name).modal({
    keyboard: args.esc_close == undefined ? window_rails.config('default_esc_close', true) : args.esc_close,
    show: args.show == undefined ? window_rails.config('default_open_show', true) : args.show,
    backdrop: backdrop
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
  args.static_backdrop = true;
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
 * @option args [Integer] :auto_close close info after given seconds
 **/
window_rails.info.open = function(args){
  window_rails.open_window('info', args);
  if(args.auto_close){
    setTimeout(
      function(){ window_rails.info.close(); },
      args.auto_close * 1000
    )
  }
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
 * @option args [String] :title content for title
 * @option args [String] :content content for content
 * @option args [String] :url URL to load on acceptance
 * @option args [String] :ajax AJAX method to use (get, post, etc)
 * @option args [String] :progress title for loading window while in progres
 * @option args [String] :complete content for info window upon completion
 **/
window_rails.confirm.open = function(args){
  window_rails.confirm.action = args;
  args.static_backdrop = true;
  window_rails.open_window('confirm', args);
}

/**
 * Close confirm window
 **/
window_rails.confirm.close = function(){
  window_rails.close_window('confirm');
}

/**
 * Execute defined action for confirmation
 **/
window_rails.confirm.execute = function(){
  args = window_rails.confirm.action;
  window_rails.confirm.close();
  window_rails.confirm.action = {};
  window_rails.loading.open({
    title: args.progress
  });
  if(args.ajax){
    $.ajax({
      url: args.url,
      type: args.ajax.toUpperCase()
    }).error(function(data, status){
      window_rails.loading.close();
      if(args.error){
        msg = args.error;
      } else {
        msg = data.responseText;
      }
      window_rails.alert.open({
        title: args.title,
        content: msg
      });
    }).success(function(data){
      window_rails.loading.close();
      window_rails.info.open({
        title: args.title,
        content: args.complete || 'Action complete',
        auto_close: window_rails.config('confirm_info_auto_close', 5)
      });
    });
  } else if(args.url) {
    document.location = args.url;
  } else if(args.callback) {
    window[args.callback]();
  }
}

/**
 * Open loading window
 *
 * @param style [String] style of spinner (valid class in csspinner or progress)
 * @param title [String] title of window
 **/
window_rails.loading.open = function(style, title){
  if(style){
    if(typeof style === 'object'){
      title = style.title;
      style = style.style;
    }
  }
  if(!style){
    style = 'standard';
  }
  if(!title){
    title = 'Loading...';
  }
  if(style == 'progress'){
    content = '<div class="progress progress-striped active look-busy"><div class="progress-bar progress-bar-info" aria-valuemax="100" aria-valuemin="0" aria-valuenow="5" role="progressbar" style="width: 5%"></div></div>';
  } else {
    content = '<div style="height: 50px" class="' + style + ' csspinner no-overlay standard" />';
  }
  window_rails.open_window('loading', {
    esc_close: false,
    title: title,
    static_backdrop: true,
    content: content
  });
  if(style == 'progress'){
    window_rails.loading.progress_look_busy();
  }
}

/**
 * Start progress bar busy action on loading display
 **/
window_rails.loading.progress_look_busy = function(){
  $('body').data(
    'window-rails-loading-progress',
    window_rails.config('loading_progress_increments', 3)
  );
  window_rails.loading.run_look_busy();
}

/**
 * Perform busy action
 * @note this should generally not be called directly
 * @see window_rails.loading.progress_look_busy
 **/
window_rails.loading.run_look_busy = function(){
  setTimeout(function(){
    allowed_max = window_rails.config('loading_progress_max', 90);
    elm = $('#window-rails-loading .progress-bar-info');
    if(elm.length > 0){
      completed = Number(elm.attr('aria-valuenow'));
      busy_by = $('body').data('window-rails-loading-progress');
      addition = (100 - completed) / busy_by;
      if(busy_by < 9){
        $('body').data('window-rails-loading-progress', busy_by / 0.75);
      }
      completed_now = completed + addition;
      if(completed_now > allowed_max){
        completed_now = allowed_max;
      }
      elm.attr('aria-valuenow', completed_now);
      elm.attr('style', 'width: ' + completed_now + '%');
      window_rails.loading.run_look_busy();
    }
  }, 2500);
}

/**
 * Close loading window
 **/
window_rails.loading.close = function(){
  window_rails.close_window('loading');
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
                <button type="button" class="btn btn-danger window-rails-confirm-cancel">Cancel</button>\
                <button type="button" class="btn btn-success window-rails-confirm-ok">OK</button>\
              </div>\
            </div>\
          </div>\
        </div>\
      </div>\
        <div id="window-rails-loading" class="modal fade" role="modal" aria-labelledby="window-rails-loading" aria-hidden="true">\
          <div class="modal-dialog modal-sm">\
            <div class="modal-content">\
              <div class="modal-header">\
                <b class="modal-title">Loading...</b>\
              </div>\
              <div class="modal-body">\
                <div style="height: 50px" class="csspinner no-overlay standard" />\
              </div>\
            </div>\
          </div>\
        </div>\
      </div>\
    ');
    window_rails.hooks.init();
    window_rails.initialized = true
  }
}

/**
 * Hook for displaying the confirmation window
 **/
window_rails.hooks.open_window = function(){
  window_rails.confirm.open({
    title: $(this).attr('window-rails-title'),
    content: $(this).attr('window-rails-confirm'),
    ajax: $(this).attr('window-rails-ajax'),
    url: $(this).attr('window-rails-url'),
    progress: $(this).attr('window-rails-progress'),
    complete: $(this).attr('window-rails-complete'),
    error: $(this).attr('window-rails-error'),
    callback: $(this).attr('window-rails-callback')
  });
}

/**
 * Hook for closing confirm window
 **/
window_rails.hooks.close_confirm = function(){
  window_rails.confirm.action = {};
  window_rails.confirm.close();
}

/**
 * Hook into interesting events
 **/
window_rails.hooks.init = function(){
  window_rails.hooks.init_links();
  $('.window-rails-confirm-cancel').on('click', window_rails.hooks.close_confirm)
  $('.window-rails-confirm-ok').on('click', window_rails.confirm.execute);
}

/**
 * Hook links to handle window rails
 *
 * @param dom_filter [String]
 **/
window_rails.hooks.init_links = function(dom_filter){
  if(!dom_filter){
    dom_filter = '';
  }
  $(dom_filter + ' .window-rails').on('click', window_rails.hooks.open_window);
}

// Initialize once page has loaded
$(document).ready(window_rails.init);