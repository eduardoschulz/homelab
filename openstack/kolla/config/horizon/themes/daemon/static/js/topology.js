/* Network topology balloons placed beside the device they describe. */
(function ($, horizon) {
  'use strict';

  if (!$ || !horizon) {
    return;
  }

  var GAP = 12;
  // the arrow's centre, from the top of the balloon
  var ARROW = 37;

  // horizon places balloons from its own header and sidebar sizes, which this theme changes
  function place($balloon, anchor) {
    var parent = $balloon.offsetParent()[0].getBoundingClientRect();
    var box = anchor.getBoundingClientRect();
    var width = $balloon.outerWidth();
    var left = box.right + GAP;
    var flip = left + width > window.innerWidth - GAP;
    if (flip) {
      left = box.left - GAP - width;
    }
    $balloon.toggleClass('leftPosition', flip).css({
      left: left - parent.left,
      top: box.top + box.height / 2 - ARROW - parent.top
    });
  }

  function wrap(topology, anchorFor) {
    if (!topology || !topology.show_balloon) {
      return;
    }
    var show = topology.show_balloon;
    topology.show_balloon = function (d) {
      var result = show.apply(this, arguments);
      var $balloon = $('#bl_' + d.id);
      var anchor = anchorFor.apply(this, arguments);
      if ($balloon.length && anchor) {
        place($balloon, anchor);
      }
      return result;
    };
  }

  wrap(horizon.flat_network_topology, function (d, $element) {
    return $element.find('.frame')[0] || $element[0];
  });
  wrap(horizon.network_topology, function (d, d2, $element) {
    return $element[0];
  });
})(window.jQuery, window.horizon);
