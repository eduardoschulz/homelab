/* Selection bar for horizon data tables. */
(function ($) {
  'use strict';

  function t(text) {
    return window.gettext ? window.gettext(text) : text;
  }

  function label(count) {
    var text = window.ngettext ?
      window.ngettext('%s selected', '%s selected', count) : '%s selected';
    return text.replace('%s', count);
  }

  var WRAPPER = '.table_wrapper, .hz-magic-search-context';
  var ROWS = 'tbody .table-row-multi-select, tbody input[hz-select]';
  var HEADER = '.multi-select-header, input[hz-select-all]';

  function update($wrapper) {
    var $actions = $wrapper.find('.table_actions, .hz-dynamic-table-preamble').first();
    var $rows = $wrapper.find(ROWS);
    var count = $rows.filter(':checked').length;
    $wrapper.find(HEADER)
      .prop('indeterminate', count > 0 && count < $rows.length);
    if (!$actions.length || !$rows.length) {
      return;
    }
    if (!$actions.children('.dm-selection-count').length) {
      $actions.prepend($('<span class="dm-selection-count" aria-live="polite"></span>'));
      $actions.append($('<button type="button" class="btn btn-link btn-sm dm-selection-clear"></button>')
        .text(t('Clear')));
    }
    $actions.children('.dm-selection-count').text(label(count));
    $wrapper.toggleClass('dm-has-selection', count > 0);
  }

  $(document).on('change', '.table-row-multi-select, input[hz-select], input[hz-select-all]', function () {
    var $wrapper = $(this).closest(WRAPPER);
    // horizon's own handler updates the other boxes first
    setTimeout(function () { update($wrapper); }, 0);
  });

  $(document).on('click', '.dm-selection-clear', function () {
    var $wrapper = $(this).closest(WRAPPER);
    var $header = $wrapper.find('.multi-select-header');
    if ($wrapper.is('.hz-magic-search-context')) {
      // angular binds the boxes with ng-model, so clicks keep its state in step
      $wrapper.find('tbody input[hz-select]:checked').each(function () { this.click(); });
    } else if ($header.length) {
      $header.prop('checked', false).trigger('change');
    } else {
      $wrapper.find('tbody .table-row-multi-select:checked')
        .prop('checked', false).trigger('change');
    }
  });

  $(function () {
    $('.table_wrapper').each(function () { update($(this)); });
  });
})(window.jQuery);
