module AutoSessionTimeoutHelper
  def auto_session_timeout_js(options={})
    frequency = options[:frequency] || 60
    code = <<JS
if (typeof(Ajax) != 'undefined') {
  timeout = new Ajax.PeriodicalUpdater('', '/active', {frequency:#{frequency}, method:'get', onSuccess: function(e) {
    if (e.responseText == 'false') window.location.href = '/timeout';
  }});
} else {
  timeout = $.PeriodicalUpdater('/active', {minTimeout:#{frequency * 1000}, multiplier:0, method:'get', verbose:2}, function(remoteData, success) {
    if (success == 'success' && remoteData == 'false')
      window.location.href = '/timeout';
  });
}
JS
    javascript_tag(code)
  end
end

ActionView::Base.send :include, AutoSessionTimeoutHelper
