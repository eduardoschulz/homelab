/*
 * PatternFly 6 theme for Horizon -- light / dark / system mode controller.
 *
 * The initial mode is already resolved by the inline script in
 * templates/base.html (before first paint). This file owns everything after
 * that: persistence, the user-menu radio group, reacting to OS changes and the
 * d3 chart palette shim.
 *
 * Contract with the templates:
 *   - <html> carries `data-theme-mode`    = light | dark | system
 *   - <html> carries `data-theme-resolved` = light | dark
 *   - <html> carries class `pf-v6-theme-dark` when the resolved mode is dark
 *   - elements with [data-theme-mode-set="light|dark|system"] act as the radio
 *     group; their `aria-checked` attribute is kept in sync.
 *
 * License: Apache-2.0
 */
(function (window, document) {
  'use strict';

  var COOKIE_NAME = 'patternfly_theme_mode';
  var STORAGE_KEY = 'patternfly-theme-mode';
  var DARK_CLASS = 'pf-v6-theme-dark';
  var MEDIA_QUERY = '(prefers-color-scheme: dark)';
  var VALID_MODES = {light: true, dark: true, system: true};
  var EVENT_NAME = 'hz:theme-mode-change';

  var mediaQuery = null;
  try {
    mediaQuery = window.matchMedia ? window.matchMedia(MEDIA_QUERY) : null;
  } catch (e) {
    mediaQuery = null;
  }

  function normalizeMode(mode) {
    return VALID_MODES.hasOwnProperty(mode) ? mode : 'system';
  }

  function readCookie() {
    var match = document.cookie.match(
      new RegExp('(?:^|;\\s*)' + COOKIE_NAME + '=([^;]+)'));
    return match ? decodeURIComponent(match[1]) : null;
  }

  function readStorage() {
    try {
      return window.localStorage ? window.localStorage.getItem(STORAGE_KEY) : null;
    } catch (e) {
      return null; // private mode / disabled storage
    }
  }

  function writeCookie(mode) {
    try {
      // 1 year, path-wide so the pre-paint script sees it on every request,
      // including the login page.
      var expires = new Date();
      expires.setFullYear(expires.getFullYear() + 1);
      document.cookie = COOKIE_NAME + '=' + encodeURIComponent(mode) +
        '; path=/; expires=' + expires.toUTCString() + '; SameSite=Lax';
    } catch (e) {
      /* ignore: persistence is best effort */
    }
  }

  function writeStorage(mode) {
    try {
      if (window.localStorage) {
        window.localStorage.setItem(STORAGE_KEY, mode);
      }
    } catch (e) {
      /* ignore */
    }
  }

  function storedMode() {
    return normalizeMode(readCookie() || readStorage() || 'system');
  }

  function systemPrefersDark() {
    return !!(mediaQuery && mediaQuery.matches);
  }

  function resolve(mode) {
    if (mode === 'dark' || mode === 'light') {
      return mode;
    }
    return systemPrefersDark() ? 'dark' : 'light';
  }

  function apply(mode) {
    var root = document.documentElement;
    var resolved = resolve(mode);

    root.setAttribute('data-theme-mode', mode);
    root.setAttribute('data-theme-resolved', resolved);
    if (resolved === 'dark') {
      root.classList.add(DARK_CLASS);
    } else {
      root.classList.remove(DARK_CLASS);
    }

    syncControls(mode);

    var event;
    try {
      event = new CustomEvent(EVENT_NAME, {detail: {mode: mode, resolved: resolved}});
    } catch (e) {
      event = document.createEvent('CustomEvent');
      event.initCustomEvent(EVENT_NAME, true, false, {mode: mode, resolved: resolved});
    }
    document.dispatchEvent(event);

    return resolved;
  }

  function setMode(mode) {
    mode = normalizeMode(mode);
    writeCookie(mode);
    writeStorage(mode);
    return apply(mode);
  }

  function syncControls(mode) {
    var controls = document.querySelectorAll('[data-theme-mode-set]');
    for (var i = 0; i < controls.length; i++) {
      var control = controls[i];
      var isActive = control.getAttribute('data-theme-mode-set') === mode;
      control.setAttribute('aria-checked', isActive ? 'true' : 'false');
    }
  }

  function bindControls() {
    document.addEventListener('click', function (event) {
      var target = event.target;
      while (target && target !== document) {
        if (target.hasAttribute && target.hasAttribute('data-theme-mode-set')) {
          event.preventDefault();
          setMode(target.getAttribute('data-theme-mode-set'));
          // Bootstrap 3 keeps a dropdown open when the click target is not a
          // link it knows about; close the user menu ourselves.
          var menu = target.closest ? target.closest('.dropdown') : null;
          if (menu && menu.classList.contains('open')) {
            menu.classList.remove('open');
          }
          return;
        }
        target = target.parentNode;
      }
    }, false);
  }

  function bindSystemChanges() {
    if (!mediaQuery) {
      return;
    }
    var handler = function () {
      // Only re-resolve while the user follows the OS setting; an explicit
      // choice always wins.
      if (storedMode() === 'system') {
        apply('system');
      }
    };
    if (mediaQuery.addEventListener) {
      mediaQuery.addEventListener('change', handler);
    } else if (mediaQuery.addListener) {
      mediaQuery.addListener(handler);
    }
  }

  function bindCrossTab() {
    window.addEventListener('storage', function (event) {
      if (event.key === STORAGE_KEY && event.newValue) {
        apply(normalizeMode(event.newValue));
      }
    }, false);
  }

  // ---------------------------------------------------------------------------
  // d3 chart palette shim
  //
  // `horizon.d3linechart.js` builds its series colours from
  // `d3.scale.category10()`, which hard-codes the d3 palette into inline
  // attributes. CSS cannot recolour individual series, so category10 is wrapped
  // to emit the PatternFly chart palette (which is dark-mode aware) instead.
  // Charts that were already rendered keep their colours until the next page
  // load; see docs/LIMITATIONS.md.
  // ---------------------------------------------------------------------------
  var CHART_TOKENS = [
    '--hz-chart-1', '--hz-chart-2', '--hz-chart-3', '--hz-chart-4',
    '--hz-chart-5', '--hz-chart-6', '--hz-chart-7', '--hz-chart-8'
  ];

  function chartPalette() {
    var styles = window.getComputedStyle(document.documentElement);
    var colors = [];
    for (var i = 0; i < CHART_TOKENS.length; i++) {
      var value = (styles.getPropertyValue(CHART_TOKENS[i]) || '').trim();
      if (value) {
        colors.push(value);
      }
    }
    return colors;
  }

  function patchD3() {
    if (!window.d3 || !window.d3.scale || !window.d3.scale.category10) {
      return false;
    }
    if (window.d3.scale.category10.__hzPatched) {
      return true;
    }
    var original = window.d3.scale.category10;
    var patched = function () {
      var scale = original();
      var colors = chartPalette();
      if (colors.length) {
        scale.range(colors);
      }
      return scale;
    };
    patched.__hzPatched = true;
    window.d3.scale.category10 = patched;
    return true;
  }

  function patchD3WhenReady() {
    if (patchD3()) {
      return;
    }
    var attempts = 0;
    var timer = window.setInterval(function () {
      attempts += 1;
      if (patchD3() || attempts > 200) { // ~20s at 100ms
        window.clearInterval(timer);
      }
    }, 100);
  }

  // ------------------------------------------------------------------ startup
  function start() {
    apply(storedMode());
    bindControls();
    bindSystemChanges();
    bindCrossTab();
    patchD3WhenReady();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', start, false);
  } else {
    start();
  }

  // Public, minimal API for plugins/panels that want to follow the mode.
  window.hzThemeMode = {
    get: function () { return storedMode(); },
    resolved: function () { return resolve(storedMode()); },
    set: setMode,
    isDark: function () { return resolve(storedMode()) === 'dark'; }
  };
}(window, document));
