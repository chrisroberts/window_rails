function window_rails(){
  if(!$('body').data('window_rails')){
    $('body').data('window_rails', {alert: {}, info: {}, confirm: {}, configuration: {}});
  }
  else if(!$('body').data('window_rails').initialized){
    $('body').data('window_rails').init();
    $('body').data('window_rails').initialized = true;
  }
  return $('body').data('window_rails');
}

window_rails.config = function(key, default_value){
  return window_rails.configuration[key] || default_value;
}

window_rails.namer = function(name){
  return 'window-rails-' + name;
}

window_rails.dom_ider = function(name){
  return '#' + window_rails.namer(name);
}

window_rails.window_for = function(name){
  return $(window_rails.dom_ider(name))[0];
}

window_rails.create_window = function(args){
  if(!window_rails.window_for(args[:name])){
    window_rails.initialize_window(args);
  }
}

window_rails.open_window = function(name, args){
  if(args){
    if(args.title){
      $(window_rails.dom_ider(name) + ' .modal-title').html(args.title);
    }
    if(args.content){
      $(window_rails.dom_ider(name) + ' .modal-body').html(args.content);
    }
  }
  window_rails.window_for(name).modal({keyboard: true, show: true});
}

window_rails.close_window = function(name){
  window_rails.window_for(name).modal({show: false});
}

window_rails.alert.open = function(args){
  window_rails.open_window('alert', args);
}

window_rails.alert.close = function(){
  window_rails.close_window('alert');
}

window_rails.info.open = function(args){
  window_rails.open_window('info', args);
}

window_rails.info.close = function(){
  window_rails.close_window('info');
}

window_rails.confirm.open = function(args){
  window_rails.open_window('confirm', args);
}

window_rails.confirm.close = function(){
  window_rails.close_window('confirm');
}

window_rails.initialize_window = function(args){
  if(args.size == 'large'){
    size = 'lg';
  } else {
    size = 'sm';
  }
  name = window_rails.namer(args.name);
  if(args.footer){
    footer = '
      <div class="modal-footer">
        ' + args.footer + '
      </div>
    ';
  } else {
    footer = '';
  }
  $('#window-rails-container').append('
    <div id="' + name + '" class="modal fade" role="modal" aria-labelledby="' + name + '" aria-hidden="true">
      <div class="modal-dialog modal-' + size + '">
        <div class="modal-content">
          <div class="modal-header">
            <button class="close" type="button" data-dismiss="modal" aria-hidden="true">
              &times;
            </button>
            <h4 class="modal-title">' + args.title + '</h4>
          </div>
          <div class="modal-body">
            ' + args.content + '
          </div>
        </div>
      </div>
    </div>
  ');
}

window_rails.init = function(){
  $('body').append('
    <div id="window-rails-container">
      <div id="window-rails-alert" class="modal fade" role="modal" aria-labelledby="window-rails-alert" aria-hidden="true">
        <div class="modal-dialog modal-sm">
          <div class="modal-content">
            <div class="modal-header bg-danger">
              <button class="close" type="button" data-dismiss="modal" aria-hidden="true">
                &times;
              </button>
              <h4 class="modal-title">Alert</h4>
            </div>
            <div class="modal-body">
              Alert message
            </div>
          </div>
        </div>
      </div>
      <div id="window-rails-info" class="modal fade" role="modal" aria-labelledby="window-rails-info" aria-hidden="true">
        <div class="modal-dialog modal-sm">
          <div class="modal-content">
            <div class="modal-header bg-info">
              <button class="close" type="button" data-dismiss="modal" aria-hidden="true">
                &times;
              </button>
              <h4 class="modal-title">Info</h4>
            </div>
            <div class="modal-body">
              Information message
            </div>
          </div>
        </div>
      </div>
      <div id="window-rails-confirm" class="modal fade" role="modal" aria-labelledby="window-rails-confirm" aria-hidden="true">
        <div class="modal-dialog modal-sm">
          <div class="modal-content">
            <div class="modal-header bg-warning">
              <h4 class="modal-title">Confirm</h4>
            </div>
            <div class="modal-body">
              Please confirm!
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  ');
}