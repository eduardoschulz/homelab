/* Steppers and quota labels in horizon's modal forms. */
(function ($, horizon) {
  'use strict';

  if (!$ || !horizon || !horizon.modals || !horizon.forms) {
    return;
  }

  // horizon reads the value attribute, which keeps the rendered value, so minus stayed disabled
  horizon.forms.checkSpinnerValue = function ($inputs) {
    $inputs.each(function () {
      var $input = $(this);
      var value = parseFloat($input.val());
      var min = horizon.forms.getSpinnerValue($input.attr('min'), 0);
      var max = horizon.forms.getSpinnerValue($input.attr('max'), Number.MAX_SAFE_INTEGER);
      var $spinner = $input.closest('.themable-spinner');
      $spinner.find('.spinner-down').prop('disabled', value <= min);
      $spinner.find('.spinner-up').prop('disabled', value >= max);
    });
  };

  // horizon only binds spinners present at page load, so steppers in modals stayed dead
  horizon.modals.addModalInitFunction(function (modal) {
    horizon.forms.init_themable_spinner($(modal));
  });

  $(document).on('input', '.themable-spinner input', function () {
    horizon.forms.checkSpinnerValue($(this));
  });

  var NUMBER = /\d[\d,.]*/g;

  // rewrite the used figure in "used of quota" titles as used plus requested
  function label($bar, requested) {
    var $value = $bar.prev('.quota_title').children('.pull-right');
    var original = $value.data('sbOriginal');
    if (!$value.length) {
      return;
    }
    if (original === undefined) {
      original = $value.text().trim();
      $value.data('sbOriginal', original);
    }
    if ((original.match(NUMBER) || []).length < 2) {
      return;
    }
    var used = parseInt($bar.attr('data-quota-used'), 10) || 0;
    var total = (used + requested).toLocaleString();
    $value.text(original.replace(/\d[\d,.]*/, total));
  }

  if (horizon.Quota) {
    var updateUsageFor = horizon.Quota.updateUsageFor;
    horizon.Quota.updateUsageFor = function (element, incrementBy) {
      updateUsageFor.apply(this, arguments);
      label($(element), incrementBy || 0);
    };

    var init = horizon.Quota.init;
    horizon.Quota.init = function () {
      init.apply(this, arguments);
      // count the form's initial values, which horizon leaves out until the first edit
      $(this.user_value_form_inputs).each(function (index, selector) {
        $(selector).trigger('input');
      });
      // bars nothing updates show their requested share as rendered
      $('.quota_bar').not('[data-progress-indicator-for]').each(function () {
        var $bar = $(this);
        var limit = parseInt($bar.attr('data-quota-limit'), 10);
        var percent = parseFloat($bar.find('.progress-bar').eq(1).attr('aria-valuenow'));
        if (limit > 0 && percent > 0) {
          label($bar, Math.round(percent * limit / 100));
        }
      });
    };
  }
})(window.jQuery, window.horizon);
