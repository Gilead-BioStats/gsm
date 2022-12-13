var rbmViz = (() => {
  var __defProp = Object.defineProperty;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __export = (target, all) => {
    for (var name in all)
      __defProp(target, name, { get: all[name], enumerable: true });
  };
  var __copyProps = (to2, from2, except, desc) => {
    if (from2 && typeof from2 === "object" || typeof from2 === "function") {
      for (let key of __getOwnPropNames(from2))
        if (!__hasOwnProp.call(to2, key) && key !== except)
          __defProp(to2, key, { get: () => from2[key], enumerable: !(desc = __getOwnPropDesc(from2, key)) || desc.enumerable });
    }
    return to2;
  };
  var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

  // src/main.js
  var main_exports = {};
  __export(main_exports, {
    default: () => main_default
  });

  // node_modules/chart.js/dist/chunks/helpers.segment.mjs
  function noop() {
  }
  var uid = function() {
    let id2 = 0;
    return function() {
      return id2++;
    };
  }();
  function isNullOrUndef(value) {
    return value === null || typeof value === "undefined";
  }
  function isArray(value) {
    if (Array.isArray && Array.isArray(value)) {
      return true;
    }
    const type2 = Object.prototype.toString.call(value);
    if (type2.slice(0, 7) === "[object" && type2.slice(-6) === "Array]") {
      return true;
    }
    return false;
  }
  function isObject(value) {
    return value !== null && Object.prototype.toString.call(value) === "[object Object]";
  }
  var isNumberFinite = (value) => (typeof value === "number" || value instanceof Number) && isFinite(+value);
  function finiteOrDefault(value, defaultValue) {
    return isNumberFinite(value) ? value : defaultValue;
  }
  function valueOrDefault(value, defaultValue) {
    return typeof value === "undefined" ? defaultValue : value;
  }
  var toPercentage = (value, dimension) => typeof value === "string" && value.endsWith("%") ? parseFloat(value) / 100 : value / dimension;
  var toDimension = (value, dimension) => typeof value === "string" && value.endsWith("%") ? parseFloat(value) / 100 * dimension : +value;
  function callback(fn, args, thisArg) {
    if (fn && typeof fn.call === "function") {
      return fn.apply(thisArg, args);
    }
  }
  function each(loopable, fn, thisArg, reverse) {
    let i, len, keys;
    if (isArray(loopable)) {
      len = loopable.length;
      if (reverse) {
        for (i = len - 1; i >= 0; i--) {
          fn.call(thisArg, loopable[i], i);
        }
      } else {
        for (i = 0; i < len; i++) {
          fn.call(thisArg, loopable[i], i);
        }
      }
    } else if (isObject(loopable)) {
      keys = Object.keys(loopable);
      len = keys.length;
      for (i = 0; i < len; i++) {
        fn.call(thisArg, loopable[keys[i]], keys[i]);
      }
    }
  }
  function _elementsEqual(a0, a1) {
    let i, ilen, v0, v1;
    if (!a0 || !a1 || a0.length !== a1.length) {
      return false;
    }
    for (i = 0, ilen = a0.length; i < ilen; ++i) {
      v0 = a0[i];
      v1 = a1[i];
      if (v0.datasetIndex !== v1.datasetIndex || v0.index !== v1.index) {
        return false;
      }
    }
    return true;
  }
  function clone$1(source) {
    if (isArray(source)) {
      return source.map(clone$1);
    }
    if (isObject(source)) {
      const target = /* @__PURE__ */ Object.create(null);
      const keys = Object.keys(source);
      const klen = keys.length;
      let k = 0;
      for (; k < klen; ++k) {
        target[keys[k]] = clone$1(source[keys[k]]);
      }
      return target;
    }
    return source;
  }
  function isValidKey(key) {
    return ["__proto__", "prototype", "constructor"].indexOf(key) === -1;
  }
  function _merger(key, target, source, options) {
    if (!isValidKey(key)) {
      return;
    }
    const tval = target[key];
    const sval = source[key];
    if (isObject(tval) && isObject(sval)) {
      merge(tval, sval, options);
    } else {
      target[key] = clone$1(sval);
    }
  }
  function merge(target, source, options) {
    const sources = isArray(source) ? source : [source];
    const ilen = sources.length;
    if (!isObject(target)) {
      return target;
    }
    options = options || {};
    const merger = options.merger || _merger;
    for (let i = 0; i < ilen; ++i) {
      source = sources[i];
      if (!isObject(source)) {
        continue;
      }
      const keys = Object.keys(source);
      for (let k = 0, klen = keys.length; k < klen; ++k) {
        merger(keys[k], target, source, options);
      }
    }
    return target;
  }
  function mergeIf(target, source) {
    return merge(target, source, { merger: _mergerIf });
  }
  function _mergerIf(key, target, source) {
    if (!isValidKey(key)) {
      return;
    }
    const tval = target[key];
    const sval = source[key];
    if (isObject(tval) && isObject(sval)) {
      mergeIf(tval, sval);
    } else if (!Object.prototype.hasOwnProperty.call(target, key)) {
      target[key] = clone$1(sval);
    }
  }
  var keyResolvers = {
    "": (v) => v,
    x: (o) => o.x,
    y: (o) => o.y
  };
  function resolveObjectKey(obj, key) {
    const resolver = keyResolvers[key] || (keyResolvers[key] = _getKeyResolver(key));
    return resolver(obj);
  }
  function _getKeyResolver(key) {
    const keys = _splitKey(key);
    return (obj) => {
      for (const k of keys) {
        if (k === "") {
          break;
        }
        obj = obj && obj[k];
      }
      return obj;
    };
  }
  function _splitKey(key) {
    const parts = key.split(".");
    const keys = [];
    let tmp = "";
    for (const part of parts) {
      tmp += part;
      if (tmp.endsWith("\\")) {
        tmp = tmp.slice(0, -1) + ".";
      } else {
        keys.push(tmp);
        tmp = "";
      }
    }
    return keys;
  }
  function _capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
  var defined = (value) => typeof value !== "undefined";
  var isFunction = (value) => typeof value === "function";
  var setsEqual = (a, b) => {
    if (a.size !== b.size) {
      return false;
    }
    for (const item of a) {
      if (!b.has(item)) {
        return false;
      }
    }
    return true;
  };
  function _isClickEvent(e) {
    return e.type === "mouseup" || e.type === "click" || e.type === "contextmenu";
  }
  var PI = Math.PI;
  var TAU = 2 * PI;
  var PITAU = TAU + PI;
  var INFINITY = Number.POSITIVE_INFINITY;
  var RAD_PER_DEG = PI / 180;
  var HALF_PI = PI / 2;
  var QUARTER_PI = PI / 4;
  var TWO_THIRDS_PI = PI * 2 / 3;
  var log10 = Math.log10;
  var sign = Math.sign;
  function niceNum(range) {
    const roundedRange = Math.round(range);
    range = almostEquals(range, roundedRange, range / 1e3) ? roundedRange : range;
    const niceRange = Math.pow(10, Math.floor(log10(range)));
    const fraction = range / niceRange;
    const niceFraction = fraction <= 1 ? 1 : fraction <= 2 ? 2 : fraction <= 5 ? 5 : 10;
    return niceFraction * niceRange;
  }
  function _factorize(value) {
    const result = [];
    const sqrt = Math.sqrt(value);
    let i;
    for (i = 1; i < sqrt; i++) {
      if (value % i === 0) {
        result.push(i);
        result.push(value / i);
      }
    }
    if (sqrt === (sqrt | 0)) {
      result.push(sqrt);
    }
    result.sort((a, b) => a - b).pop();
    return result;
  }
  function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
  }
  function almostEquals(x, y, epsilon) {
    return Math.abs(x - y) < epsilon;
  }
  function almostWhole(x, epsilon) {
    const rounded = Math.round(x);
    return rounded - epsilon <= x && rounded + epsilon >= x;
  }
  function _setMinAndMaxByKey(array2, target, property) {
    let i, ilen, value;
    for (i = 0, ilen = array2.length; i < ilen; i++) {
      value = array2[i][property];
      if (!isNaN(value)) {
        target.min = Math.min(target.min, value);
        target.max = Math.max(target.max, value);
      }
    }
  }
  function toRadians(degrees2) {
    return degrees2 * (PI / 180);
  }
  function toDegrees(radians) {
    return radians * (180 / PI);
  }
  function _decimalPlaces(x) {
    if (!isNumberFinite(x)) {
      return;
    }
    let e = 1;
    let p = 0;
    while (Math.round(x * e) / e !== x) {
      e *= 10;
      p++;
    }
    return p;
  }
  function getAngleFromPoint(centrePoint, anglePoint) {
    const distanceFromXCenter = anglePoint.x - centrePoint.x;
    const distanceFromYCenter = anglePoint.y - centrePoint.y;
    const radialDistanceFromCenter = Math.sqrt(distanceFromXCenter * distanceFromXCenter + distanceFromYCenter * distanceFromYCenter);
    let angle = Math.atan2(distanceFromYCenter, distanceFromXCenter);
    if (angle < -0.5 * PI) {
      angle += TAU;
    }
    return {
      angle,
      distance: radialDistanceFromCenter
    };
  }
  function distanceBetweenPoints(pt1, pt2) {
    return Math.sqrt(Math.pow(pt2.x - pt1.x, 2) + Math.pow(pt2.y - pt1.y, 2));
  }
  function _angleDiff(a, b) {
    return (a - b + PITAU) % TAU - PI;
  }
  function _normalizeAngle(a) {
    return (a % TAU + TAU) % TAU;
  }
  function _angleBetween(angle, start2, end, sameAngleIsFullCircle) {
    const a = _normalizeAngle(angle);
    const s = _normalizeAngle(start2);
    const e = _normalizeAngle(end);
    const angleToStart = _normalizeAngle(s - a);
    const angleToEnd = _normalizeAngle(e - a);
    const startToAngle = _normalizeAngle(a - s);
    const endToAngle = _normalizeAngle(a - e);
    return a === s || a === e || sameAngleIsFullCircle && s === e || angleToStart > angleToEnd && startToAngle < endToAngle;
  }
  function _limitValue(value, min3, max3) {
    return Math.max(min3, Math.min(max3, value));
  }
  function _int16Range(value) {
    return _limitValue(value, -32768, 32767);
  }
  function _isBetween(value, start2, end, epsilon = 1e-6) {
    return value >= Math.min(start2, end) - epsilon && value <= Math.max(start2, end) + epsilon;
  }
  function _lookup(table, value, cmp) {
    cmp = cmp || ((index3) => table[index3] < value);
    let hi = table.length - 1;
    let lo = 0;
    let mid;
    while (hi - lo > 1) {
      mid = lo + hi >> 1;
      if (cmp(mid)) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return { lo, hi };
  }
  var _lookupByKey = (table, key, value, last) => _lookup(table, value, last ? (index3) => table[index3][key] <= value : (index3) => table[index3][key] < value);
  var _rlookupByKey = (table, key, value) => _lookup(table, value, (index3) => table[index3][key] >= value);
  function _filterBetween(values, min3, max3) {
    let start2 = 0;
    let end = values.length;
    while (start2 < end && values[start2] < min3) {
      start2++;
    }
    while (end > start2 && values[end - 1] > max3) {
      end--;
    }
    return start2 > 0 || end < values.length ? values.slice(start2, end) : values;
  }
  var arrayEvents = ["push", "pop", "shift", "splice", "unshift"];
  function listenArrayEvents(array2, listener) {
    if (array2._chartjs) {
      array2._chartjs.listeners.push(listener);
      return;
    }
    Object.defineProperty(array2, "_chartjs", {
      configurable: true,
      enumerable: false,
      value: {
        listeners: [listener]
      }
    });
    arrayEvents.forEach((key) => {
      const method = "_onData" + _capitalize(key);
      const base = array2[key];
      Object.defineProperty(array2, key, {
        configurable: true,
        enumerable: false,
        value(...args) {
          const res = base.apply(this, args);
          array2._chartjs.listeners.forEach((object) => {
            if (typeof object[method] === "function") {
              object[method](...args);
            }
          });
          return res;
        }
      });
    });
  }
  function unlistenArrayEvents(array2, listener) {
    const stub = array2._chartjs;
    if (!stub) {
      return;
    }
    const listeners = stub.listeners;
    const index3 = listeners.indexOf(listener);
    if (index3 !== -1) {
      listeners.splice(index3, 1);
    }
    if (listeners.length > 0) {
      return;
    }
    arrayEvents.forEach((key) => {
      delete array2[key];
    });
    delete array2._chartjs;
  }
  function _arrayUnique(items) {
    const set4 = /* @__PURE__ */ new Set();
    let i, ilen;
    for (i = 0, ilen = items.length; i < ilen; ++i) {
      set4.add(items[i]);
    }
    if (set4.size === ilen) {
      return items;
    }
    return Array.from(set4);
  }
  var requestAnimFrame = function() {
    if (typeof window === "undefined") {
      return function(callback2) {
        return callback2();
      };
    }
    return window.requestAnimationFrame;
  }();
  function throttled(fn, thisArg, updateFn) {
    const updateArgs = updateFn || ((args2) => Array.prototype.slice.call(args2));
    let ticking = false;
    let args = [];
    return function(...rest) {
      args = updateArgs(rest);
      if (!ticking) {
        ticking = true;
        requestAnimFrame.call(window, () => {
          ticking = false;
          fn.apply(thisArg, args);
        });
      }
    };
  }
  function debounce(fn, delay) {
    let timeout2;
    return function(...args) {
      if (delay) {
        clearTimeout(timeout2);
        timeout2 = setTimeout(fn, delay, args);
      } else {
        fn.apply(this, args);
      }
      return delay;
    };
  }
  var _toLeftRightCenter = (align) => align === "start" ? "left" : align === "end" ? "right" : "center";
  var _alignStartEnd = (align, start2, end) => align === "start" ? start2 : align === "end" ? end : (start2 + end) / 2;
  var _textX = (align, left, right, rtl) => {
    const check = rtl ? "left" : "right";
    return align === check ? right : align === "center" ? (left + right) / 2 : left;
  };
  function _getStartAndCountOfVisiblePoints(meta, points, animationsDisabled) {
    const pointCount = points.length;
    let start2 = 0;
    let count = pointCount;
    if (meta._sorted) {
      const { iScale, _parsed } = meta;
      const axis = iScale.axis;
      const { min: min3, max: max3, minDefined, maxDefined } = iScale.getUserBounds();
      if (minDefined) {
        start2 = _limitValue(
          Math.min(
            _lookupByKey(_parsed, iScale.axis, min3).lo,
            animationsDisabled ? pointCount : _lookupByKey(points, axis, iScale.getPixelForValue(min3)).lo
          ),
          0,
          pointCount - 1
        );
      }
      if (maxDefined) {
        count = _limitValue(
          Math.max(
            _lookupByKey(_parsed, iScale.axis, max3, true).hi + 1,
            animationsDisabled ? 0 : _lookupByKey(points, axis, iScale.getPixelForValue(max3), true).hi + 1
          ),
          start2,
          pointCount
        ) - start2;
      } else {
        count = pointCount - start2;
      }
    }
    return { start: start2, count };
  }
  function _scaleRangesChanged(meta) {
    const { xScale, yScale, _scaleRanges } = meta;
    const newRanges = {
      xmin: xScale.min,
      xmax: xScale.max,
      ymin: yScale.min,
      ymax: yScale.max
    };
    if (!_scaleRanges) {
      meta._scaleRanges = newRanges;
      return true;
    }
    const changed = _scaleRanges.xmin !== xScale.min || _scaleRanges.xmax !== xScale.max || _scaleRanges.ymin !== yScale.min || _scaleRanges.ymax !== yScale.max;
    Object.assign(_scaleRanges, newRanges);
    return changed;
  }
  var atEdge = (t) => t === 0 || t === 1;
  var elasticIn = (t, s, p) => -(Math.pow(2, 10 * (t -= 1)) * Math.sin((t - s) * TAU / p));
  var elasticOut = (t, s, p) => Math.pow(2, -10 * t) * Math.sin((t - s) * TAU / p) + 1;
  var effects = {
    linear: (t) => t,
    easeInQuad: (t) => t * t,
    easeOutQuad: (t) => -t * (t - 2),
    easeInOutQuad: (t) => (t /= 0.5) < 1 ? 0.5 * t * t : -0.5 * (--t * (t - 2) - 1),
    easeInCubic: (t) => t * t * t,
    easeOutCubic: (t) => (t -= 1) * t * t + 1,
    easeInOutCubic: (t) => (t /= 0.5) < 1 ? 0.5 * t * t * t : 0.5 * ((t -= 2) * t * t + 2),
    easeInQuart: (t) => t * t * t * t,
    easeOutQuart: (t) => -((t -= 1) * t * t * t - 1),
    easeInOutQuart: (t) => (t /= 0.5) < 1 ? 0.5 * t * t * t * t : -0.5 * ((t -= 2) * t * t * t - 2),
    easeInQuint: (t) => t * t * t * t * t,
    easeOutQuint: (t) => (t -= 1) * t * t * t * t + 1,
    easeInOutQuint: (t) => (t /= 0.5) < 1 ? 0.5 * t * t * t * t * t : 0.5 * ((t -= 2) * t * t * t * t + 2),
    easeInSine: (t) => -Math.cos(t * HALF_PI) + 1,
    easeOutSine: (t) => Math.sin(t * HALF_PI),
    easeInOutSine: (t) => -0.5 * (Math.cos(PI * t) - 1),
    easeInExpo: (t) => t === 0 ? 0 : Math.pow(2, 10 * (t - 1)),
    easeOutExpo: (t) => t === 1 ? 1 : -Math.pow(2, -10 * t) + 1,
    easeInOutExpo: (t) => atEdge(t) ? t : t < 0.5 ? 0.5 * Math.pow(2, 10 * (t * 2 - 1)) : 0.5 * (-Math.pow(2, -10 * (t * 2 - 1)) + 2),
    easeInCirc: (t) => t >= 1 ? t : -(Math.sqrt(1 - t * t) - 1),
    easeOutCirc: (t) => Math.sqrt(1 - (t -= 1) * t),
    easeInOutCirc: (t) => (t /= 0.5) < 1 ? -0.5 * (Math.sqrt(1 - t * t) - 1) : 0.5 * (Math.sqrt(1 - (t -= 2) * t) + 1),
    easeInElastic: (t) => atEdge(t) ? t : elasticIn(t, 0.075, 0.3),
    easeOutElastic: (t) => atEdge(t) ? t : elasticOut(t, 0.075, 0.3),
    easeInOutElastic(t) {
      const s = 0.1125;
      const p = 0.45;
      return atEdge(t) ? t : t < 0.5 ? 0.5 * elasticIn(t * 2, s, p) : 0.5 + 0.5 * elasticOut(t * 2 - 1, s, p);
    },
    easeInBack(t) {
      const s = 1.70158;
      return t * t * ((s + 1) * t - s);
    },
    easeOutBack(t) {
      const s = 1.70158;
      return (t -= 1) * t * ((s + 1) * t + s) + 1;
    },
    easeInOutBack(t) {
      let s = 1.70158;
      if ((t /= 0.5) < 1) {
        return 0.5 * (t * t * (((s *= 1.525) + 1) * t - s));
      }
      return 0.5 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2);
    },
    easeInBounce: (t) => 1 - effects.easeOutBounce(1 - t),
    easeOutBounce(t) {
      const m = 7.5625;
      const d = 2.75;
      if (t < 1 / d) {
        return m * t * t;
      }
      if (t < 2 / d) {
        return m * (t -= 1.5 / d) * t + 0.75;
      }
      if (t < 2.5 / d) {
        return m * (t -= 2.25 / d) * t + 0.9375;
      }
      return m * (t -= 2.625 / d) * t + 0.984375;
    },
    easeInOutBounce: (t) => t < 0.5 ? effects.easeInBounce(t * 2) * 0.5 : effects.easeOutBounce(t * 2 - 1) * 0.5 + 0.5
  };
  function round(v) {
    return v + 0.5 | 0;
  }
  var lim = (v, l, h) => Math.max(Math.min(v, h), l);
  function p2b(v) {
    return lim(round(v * 2.55), 0, 255);
  }
  function n2b(v) {
    return lim(round(v * 255), 0, 255);
  }
  function b2n(v) {
    return lim(round(v / 2.55) / 100, 0, 1);
  }
  function n2p(v) {
    return lim(round(v * 100), 0, 100);
  }
  var map$1 = { 0: 0, 1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9, A: 10, B: 11, C: 12, D: 13, E: 14, F: 15, a: 10, b: 11, c: 12, d: 13, e: 14, f: 15 };
  var hex = [..."0123456789ABCDEF"];
  var h1 = (b) => hex[b & 15];
  var h2 = (b) => hex[(b & 240) >> 4] + hex[b & 15];
  var eq = (b) => (b & 240) >> 4 === (b & 15);
  var isShort = (v) => eq(v.r) && eq(v.g) && eq(v.b) && eq(v.a);
  function hexParse(str) {
    var len = str.length;
    var ret;
    if (str[0] === "#") {
      if (len === 4 || len === 5) {
        ret = {
          r: 255 & map$1[str[1]] * 17,
          g: 255 & map$1[str[2]] * 17,
          b: 255 & map$1[str[3]] * 17,
          a: len === 5 ? map$1[str[4]] * 17 : 255
        };
      } else if (len === 7 || len === 9) {
        ret = {
          r: map$1[str[1]] << 4 | map$1[str[2]],
          g: map$1[str[3]] << 4 | map$1[str[4]],
          b: map$1[str[5]] << 4 | map$1[str[6]],
          a: len === 9 ? map$1[str[7]] << 4 | map$1[str[8]] : 255
        };
      }
    }
    return ret;
  }
  var alpha = (a, f) => a < 255 ? f(a) : "";
  function hexString(v) {
    var f = isShort(v) ? h1 : h2;
    return v ? "#" + f(v.r) + f(v.g) + f(v.b) + alpha(v.a, f) : void 0;
  }
  var HUE_RE = /^(hsla?|hwb|hsv)\(\s*([-+.e\d]+)(?:deg)?[\s,]+([-+.e\d]+)%[\s,]+([-+.e\d]+)%(?:[\s,]+([-+.e\d]+)(%)?)?\s*\)$/;
  function hsl2rgbn(h, s, l) {
    const a = s * Math.min(l, 1 - l);
    const f = (n, k = (n + h / 30) % 12) => l - a * Math.max(Math.min(k - 3, 9 - k, 1), -1);
    return [f(0), f(8), f(4)];
  }
  function hsv2rgbn(h, s, v) {
    const f = (n, k = (n + h / 60) % 6) => v - v * s * Math.max(Math.min(k, 4 - k, 1), 0);
    return [f(5), f(3), f(1)];
  }
  function hwb2rgbn(h, w, b) {
    const rgb2 = hsl2rgbn(h, 1, 0.5);
    let i;
    if (w + b > 1) {
      i = 1 / (w + b);
      w *= i;
      b *= i;
    }
    for (i = 0; i < 3; i++) {
      rgb2[i] *= 1 - w - b;
      rgb2[i] += w;
    }
    return rgb2;
  }
  function hueValue(r, g, b, d, max3) {
    if (r === max3) {
      return (g - b) / d + (g < b ? 6 : 0);
    }
    if (g === max3) {
      return (b - r) / d + 2;
    }
    return (r - g) / d + 4;
  }
  function rgb2hsl(v) {
    const range = 255;
    const r = v.r / range;
    const g = v.g / range;
    const b = v.b / range;
    const max3 = Math.max(r, g, b);
    const min3 = Math.min(r, g, b);
    const l = (max3 + min3) / 2;
    let h, s, d;
    if (max3 !== min3) {
      d = max3 - min3;
      s = l > 0.5 ? d / (2 - max3 - min3) : d / (max3 + min3);
      h = hueValue(r, g, b, d, max3);
      h = h * 60 + 0.5;
    }
    return [h | 0, s || 0, l];
  }
  function calln(f, a, b, c) {
    return (Array.isArray(a) ? f(a[0], a[1], a[2]) : f(a, b, c)).map(n2b);
  }
  function hsl2rgb(h, s, l) {
    return calln(hsl2rgbn, h, s, l);
  }
  function hwb2rgb(h, w, b) {
    return calln(hwb2rgbn, h, w, b);
  }
  function hsv2rgb(h, s, v) {
    return calln(hsv2rgbn, h, s, v);
  }
  function hue(h) {
    return (h % 360 + 360) % 360;
  }
  function hueParse(str) {
    const m = HUE_RE.exec(str);
    let a = 255;
    let v;
    if (!m) {
      return;
    }
    if (m[5] !== v) {
      a = m[6] ? p2b(+m[5]) : n2b(+m[5]);
    }
    const h = hue(+m[2]);
    const p1 = +m[3] / 100;
    const p2 = +m[4] / 100;
    if (m[1] === "hwb") {
      v = hwb2rgb(h, p1, p2);
    } else if (m[1] === "hsv") {
      v = hsv2rgb(h, p1, p2);
    } else {
      v = hsl2rgb(h, p1, p2);
    }
    return {
      r: v[0],
      g: v[1],
      b: v[2],
      a
    };
  }
  function rotate(v, deg) {
    var h = rgb2hsl(v);
    h[0] = hue(h[0] + deg);
    h = hsl2rgb(h);
    v.r = h[0];
    v.g = h[1];
    v.b = h[2];
  }
  function hslString(v) {
    if (!v) {
      return;
    }
    const a = rgb2hsl(v);
    const h = a[0];
    const s = n2p(a[1]);
    const l = n2p(a[2]);
    return v.a < 255 ? `hsla(${h}, ${s}%, ${l}%, ${b2n(v.a)})` : `hsl(${h}, ${s}%, ${l}%)`;
  }
  var map = {
    x: "dark",
    Z: "light",
    Y: "re",
    X: "blu",
    W: "gr",
    V: "medium",
    U: "slate",
    A: "ee",
    T: "ol",
    S: "or",
    B: "ra",
    C: "lateg",
    D: "ights",
    R: "in",
    Q: "turquois",
    E: "hi",
    P: "ro",
    O: "al",
    N: "le",
    M: "de",
    L: "yello",
    F: "en",
    K: "ch",
    G: "arks",
    H: "ea",
    I: "ightg",
    J: "wh"
  };
  var names$1 = {
    OiceXe: "f0f8ff",
    antiquewEte: "faebd7",
    aqua: "ffff",
    aquamarRe: "7fffd4",
    azuY: "f0ffff",
    beige: "f5f5dc",
    bisque: "ffe4c4",
    black: "0",
    blanKedOmond: "ffebcd",
    Xe: "ff",
    XeviTet: "8a2be2",
    bPwn: "a52a2a",
    burlywood: "deb887",
    caMtXe: "5f9ea0",
    KartYuse: "7fff00",
    KocTate: "d2691e",
    cSO: "ff7f50",
    cSnflowerXe: "6495ed",
    cSnsilk: "fff8dc",
    crimson: "dc143c",
    cyan: "ffff",
    xXe: "8b",
    xcyan: "8b8b",
    xgTMnPd: "b8860b",
    xWay: "a9a9a9",
    xgYF: "6400",
    xgYy: "a9a9a9",
    xkhaki: "bdb76b",
    xmagFta: "8b008b",
    xTivegYF: "556b2f",
    xSange: "ff8c00",
    xScEd: "9932cc",
    xYd: "8b0000",
    xsOmon: "e9967a",
    xsHgYF: "8fbc8f",
    xUXe: "483d8b",
    xUWay: "2f4f4f",
    xUgYy: "2f4f4f",
    xQe: "ced1",
    xviTet: "9400d3",
    dAppRk: "ff1493",
    dApskyXe: "bfff",
    dimWay: "696969",
    dimgYy: "696969",
    dodgerXe: "1e90ff",
    fiYbrick: "b22222",
    flSOwEte: "fffaf0",
    foYstWAn: "228b22",
    fuKsia: "ff00ff",
    gaRsbSo: "dcdcdc",
    ghostwEte: "f8f8ff",
    gTd: "ffd700",
    gTMnPd: "daa520",
    Way: "808080",
    gYF: "8000",
    gYFLw: "adff2f",
    gYy: "808080",
    honeyMw: "f0fff0",
    hotpRk: "ff69b4",
    RdianYd: "cd5c5c",
    Rdigo: "4b0082",
    ivSy: "fffff0",
    khaki: "f0e68c",
    lavFMr: "e6e6fa",
    lavFMrXsh: "fff0f5",
    lawngYF: "7cfc00",
    NmoncEffon: "fffacd",
    ZXe: "add8e6",
    ZcSO: "f08080",
    Zcyan: "e0ffff",
    ZgTMnPdLw: "fafad2",
    ZWay: "d3d3d3",
    ZgYF: "90ee90",
    ZgYy: "d3d3d3",
    ZpRk: "ffb6c1",
    ZsOmon: "ffa07a",
    ZsHgYF: "20b2aa",
    ZskyXe: "87cefa",
    ZUWay: "778899",
    ZUgYy: "778899",
    ZstAlXe: "b0c4de",
    ZLw: "ffffe0",
    lime: "ff00",
    limegYF: "32cd32",
    lRF: "faf0e6",
    magFta: "ff00ff",
    maPon: "800000",
    VaquamarRe: "66cdaa",
    VXe: "cd",
    VScEd: "ba55d3",
    VpurpN: "9370db",
    VsHgYF: "3cb371",
    VUXe: "7b68ee",
    VsprRggYF: "fa9a",
    VQe: "48d1cc",
    VviTetYd: "c71585",
    midnightXe: "191970",
    mRtcYam: "f5fffa",
    mistyPse: "ffe4e1",
    moccasR: "ffe4b5",
    navajowEte: "ffdead",
    navy: "80",
    Tdlace: "fdf5e6",
    Tive: "808000",
    TivedBb: "6b8e23",
    Sange: "ffa500",
    SangeYd: "ff4500",
    ScEd: "da70d6",
    pOegTMnPd: "eee8aa",
    pOegYF: "98fb98",
    pOeQe: "afeeee",
    pOeviTetYd: "db7093",
    papayawEp: "ffefd5",
    pHKpuff: "ffdab9",
    peru: "cd853f",
    pRk: "ffc0cb",
    plum: "dda0dd",
    powMrXe: "b0e0e6",
    purpN: "800080",
    YbeccapurpN: "663399",
    Yd: "ff0000",
    Psybrown: "bc8f8f",
    PyOXe: "4169e1",
    saddNbPwn: "8b4513",
    sOmon: "fa8072",
    sandybPwn: "f4a460",
    sHgYF: "2e8b57",
    sHshell: "fff5ee",
    siFna: "a0522d",
    silver: "c0c0c0",
    skyXe: "87ceeb",
    UXe: "6a5acd",
    UWay: "708090",
    UgYy: "708090",
    snow: "fffafa",
    sprRggYF: "ff7f",
    stAlXe: "4682b4",
    tan: "d2b48c",
    teO: "8080",
    tEstN: "d8bfd8",
    tomato: "ff6347",
    Qe: "40e0d0",
    viTet: "ee82ee",
    JHt: "f5deb3",
    wEte: "ffffff",
    wEtesmoke: "f5f5f5",
    Lw: "ffff00",
    LwgYF: "9acd32"
  };
  function unpack() {
    const unpacked = {};
    const keys = Object.keys(names$1);
    const tkeys = Object.keys(map);
    let i, j, k, ok, nk;
    for (i = 0; i < keys.length; i++) {
      ok = nk = keys[i];
      for (j = 0; j < tkeys.length; j++) {
        k = tkeys[j];
        nk = nk.replace(k, map[k]);
      }
      k = parseInt(names$1[ok], 16);
      unpacked[nk] = [k >> 16 & 255, k >> 8 & 255, k & 255];
    }
    return unpacked;
  }
  var names;
  function nameParse(str) {
    if (!names) {
      names = unpack();
      names.transparent = [0, 0, 0, 0];
    }
    const a = names[str.toLowerCase()];
    return a && {
      r: a[0],
      g: a[1],
      b: a[2],
      a: a.length === 4 ? a[3] : 255
    };
  }
  var RGB_RE = /^rgba?\(\s*([-+.\d]+)(%)?[\s,]+([-+.e\d]+)(%)?[\s,]+([-+.e\d]+)(%)?(?:[\s,/]+([-+.e\d]+)(%)?)?\s*\)$/;
  function rgbParse(str) {
    const m = RGB_RE.exec(str);
    let a = 255;
    let r, g, b;
    if (!m) {
      return;
    }
    if (m[7] !== r) {
      const v = +m[7];
      a = m[8] ? p2b(v) : lim(v * 255, 0, 255);
    }
    r = +m[1];
    g = +m[3];
    b = +m[5];
    r = 255 & (m[2] ? p2b(r) : lim(r, 0, 255));
    g = 255 & (m[4] ? p2b(g) : lim(g, 0, 255));
    b = 255 & (m[6] ? p2b(b) : lim(b, 0, 255));
    return {
      r,
      g,
      b,
      a
    };
  }
  function rgbString(v) {
    return v && (v.a < 255 ? `rgba(${v.r}, ${v.g}, ${v.b}, ${b2n(v.a)})` : `rgb(${v.r}, ${v.g}, ${v.b})`);
  }
  var to = (v) => v <= 31308e-7 ? v * 12.92 : Math.pow(v, 1 / 2.4) * 1.055 - 0.055;
  var from = (v) => v <= 0.04045 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
  function interpolate(rgb1, rgb2, t) {
    const r = from(b2n(rgb1.r));
    const g = from(b2n(rgb1.g));
    const b = from(b2n(rgb1.b));
    return {
      r: n2b(to(r + t * (from(b2n(rgb2.r)) - r))),
      g: n2b(to(g + t * (from(b2n(rgb2.g)) - g))),
      b: n2b(to(b + t * (from(b2n(rgb2.b)) - b))),
      a: rgb1.a + t * (rgb2.a - rgb1.a)
    };
  }
  function modHSL(v, i, ratio) {
    if (v) {
      let tmp = rgb2hsl(v);
      tmp[i] = Math.max(0, Math.min(tmp[i] + tmp[i] * ratio, i === 0 ? 360 : 1));
      tmp = hsl2rgb(tmp);
      v.r = tmp[0];
      v.g = tmp[1];
      v.b = tmp[2];
    }
  }
  function clone(v, proto) {
    return v ? Object.assign(proto || {}, v) : v;
  }
  function fromObject(input) {
    var v = { r: 0, g: 0, b: 0, a: 255 };
    if (Array.isArray(input)) {
      if (input.length >= 3) {
        v = { r: input[0], g: input[1], b: input[2], a: 255 };
        if (input.length > 3) {
          v.a = n2b(input[3]);
        }
      }
    } else {
      v = clone(input, { r: 0, g: 0, b: 0, a: 1 });
      v.a = n2b(v.a);
    }
    return v;
  }
  function functionParse(str) {
    if (str.charAt(0) === "r") {
      return rgbParse(str);
    }
    return hueParse(str);
  }
  var Color = class {
    constructor(input) {
      if (input instanceof Color) {
        return input;
      }
      const type2 = typeof input;
      let v;
      if (type2 === "object") {
        v = fromObject(input);
      } else if (type2 === "string") {
        v = hexParse(input) || nameParse(input) || functionParse(input);
      }
      this._rgb = v;
      this._valid = !!v;
    }
    get valid() {
      return this._valid;
    }
    get rgb() {
      var v = clone(this._rgb);
      if (v) {
        v.a = b2n(v.a);
      }
      return v;
    }
    set rgb(obj) {
      this._rgb = fromObject(obj);
    }
    rgbString() {
      return this._valid ? rgbString(this._rgb) : void 0;
    }
    hexString() {
      return this._valid ? hexString(this._rgb) : void 0;
    }
    hslString() {
      return this._valid ? hslString(this._rgb) : void 0;
    }
    mix(color3, weight) {
      if (color3) {
        const c1 = this.rgb;
        const c2 = color3.rgb;
        let w2;
        const p = weight === w2 ? 0.5 : weight;
        const w = 2 * p - 1;
        const a = c1.a - c2.a;
        const w1 = ((w * a === -1 ? w : (w + a) / (1 + w * a)) + 1) / 2;
        w2 = 1 - w1;
        c1.r = 255 & w1 * c1.r + w2 * c2.r + 0.5;
        c1.g = 255 & w1 * c1.g + w2 * c2.g + 0.5;
        c1.b = 255 & w1 * c1.b + w2 * c2.b + 0.5;
        c1.a = p * c1.a + (1 - p) * c2.a;
        this.rgb = c1;
      }
      return this;
    }
    interpolate(color3, t) {
      if (color3) {
        this._rgb = interpolate(this._rgb, color3._rgb, t);
      }
      return this;
    }
    clone() {
      return new Color(this.rgb);
    }
    alpha(a) {
      this._rgb.a = n2b(a);
      return this;
    }
    clearer(ratio) {
      const rgb2 = this._rgb;
      rgb2.a *= 1 - ratio;
      return this;
    }
    greyscale() {
      const rgb2 = this._rgb;
      const val = round(rgb2.r * 0.3 + rgb2.g * 0.59 + rgb2.b * 0.11);
      rgb2.r = rgb2.g = rgb2.b = val;
      return this;
    }
    opaquer(ratio) {
      const rgb2 = this._rgb;
      rgb2.a *= 1 + ratio;
      return this;
    }
    negate() {
      const v = this._rgb;
      v.r = 255 - v.r;
      v.g = 255 - v.g;
      v.b = 255 - v.b;
      return this;
    }
    lighten(ratio) {
      modHSL(this._rgb, 2, ratio);
      return this;
    }
    darken(ratio) {
      modHSL(this._rgb, 2, -ratio);
      return this;
    }
    saturate(ratio) {
      modHSL(this._rgb, 1, ratio);
      return this;
    }
    desaturate(ratio) {
      modHSL(this._rgb, 1, -ratio);
      return this;
    }
    rotate(deg) {
      rotate(this._rgb, deg);
      return this;
    }
  };
  function index_esm(input) {
    return new Color(input);
  }
  function isPatternOrGradient(value) {
    if (value && typeof value === "object") {
      const type2 = value.toString();
      return type2 === "[object CanvasPattern]" || type2 === "[object CanvasGradient]";
    }
    return false;
  }
  function color(value) {
    return isPatternOrGradient(value) ? value : index_esm(value);
  }
  function getHoverColor(value) {
    return isPatternOrGradient(value) ? value : index_esm(value).saturate(0.5).darken(0.1).hexString();
  }
  var overrides = /* @__PURE__ */ Object.create(null);
  var descriptors = /* @__PURE__ */ Object.create(null);
  function getScope$1(node, key) {
    if (!key) {
      return node;
    }
    const keys = key.split(".");
    for (let i = 0, n = keys.length; i < n; ++i) {
      const k = keys[i];
      node = node[k] || (node[k] = /* @__PURE__ */ Object.create(null));
    }
    return node;
  }
  function set(root2, scope, values) {
    if (typeof scope === "string") {
      return merge(getScope$1(root2, scope), values);
    }
    return merge(getScope$1(root2, ""), scope);
  }
  var Defaults = class {
    constructor(_descriptors2) {
      this.animation = void 0;
      this.backgroundColor = "rgba(0,0,0,0.1)";
      this.borderColor = "rgba(0,0,0,0.1)";
      this.color = "#666";
      this.datasets = {};
      this.devicePixelRatio = (context) => context.chart.platform.getDevicePixelRatio();
      this.elements = {};
      this.events = [
        "mousemove",
        "mouseout",
        "click",
        "touchstart",
        "touchmove"
      ];
      this.font = {
        family: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",
        size: 12,
        style: "normal",
        lineHeight: 1.2,
        weight: null
      };
      this.hover = {};
      this.hoverBackgroundColor = (ctx, options) => getHoverColor(options.backgroundColor);
      this.hoverBorderColor = (ctx, options) => getHoverColor(options.borderColor);
      this.hoverColor = (ctx, options) => getHoverColor(options.color);
      this.indexAxis = "x";
      this.interaction = {
        mode: "nearest",
        intersect: true,
        includeInvisible: false
      };
      this.maintainAspectRatio = true;
      this.onHover = null;
      this.onClick = null;
      this.parsing = true;
      this.plugins = {};
      this.responsive = true;
      this.scale = void 0;
      this.scales = {};
      this.showLine = true;
      this.drawActiveElementsOnTop = true;
      this.describe(_descriptors2);
    }
    set(scope, values) {
      return set(this, scope, values);
    }
    get(scope) {
      return getScope$1(this, scope);
    }
    describe(scope, values) {
      return set(descriptors, scope, values);
    }
    override(scope, values) {
      return set(overrides, scope, values);
    }
    route(scope, name, targetScope, targetName) {
      const scopeObject = getScope$1(this, scope);
      const targetScopeObject = getScope$1(this, targetScope);
      const privateName = "_" + name;
      Object.defineProperties(scopeObject, {
        [privateName]: {
          value: scopeObject[name],
          writable: true
        },
        [name]: {
          enumerable: true,
          get() {
            const local = this[privateName];
            const target = targetScopeObject[targetName];
            if (isObject(local)) {
              return Object.assign({}, target, local);
            }
            return valueOrDefault(local, target);
          },
          set(value) {
            this[privateName] = value;
          }
        }
      });
    }
  };
  var defaults = new Defaults({
    _scriptable: (name) => !name.startsWith("on"),
    _indexable: (name) => name !== "events",
    hover: {
      _fallback: "interaction"
    },
    interaction: {
      _scriptable: false,
      _indexable: false
    }
  });
  function toFontString(font) {
    if (!font || isNullOrUndef(font.size) || isNullOrUndef(font.family)) {
      return null;
    }
    return (font.style ? font.style + " " : "") + (font.weight ? font.weight + " " : "") + font.size + "px " + font.family;
  }
  function _measureText(ctx, data, gc, longest, string) {
    let textWidth = data[string];
    if (!textWidth) {
      textWidth = data[string] = ctx.measureText(string).width;
      gc.push(string);
    }
    if (textWidth > longest) {
      longest = textWidth;
    }
    return longest;
  }
  function _longestText(ctx, font, arrayOfThings, cache) {
    cache = cache || {};
    let data = cache.data = cache.data || {};
    let gc = cache.garbageCollect = cache.garbageCollect || [];
    if (cache.font !== font) {
      data = cache.data = {};
      gc = cache.garbageCollect = [];
      cache.font = font;
    }
    ctx.save();
    ctx.font = font;
    let longest = 0;
    const ilen = arrayOfThings.length;
    let i, j, jlen, thing, nestedThing;
    for (i = 0; i < ilen; i++) {
      thing = arrayOfThings[i];
      if (thing !== void 0 && thing !== null && isArray(thing) !== true) {
        longest = _measureText(ctx, data, gc, longest, thing);
      } else if (isArray(thing)) {
        for (j = 0, jlen = thing.length; j < jlen; j++) {
          nestedThing = thing[j];
          if (nestedThing !== void 0 && nestedThing !== null && !isArray(nestedThing)) {
            longest = _measureText(ctx, data, gc, longest, nestedThing);
          }
        }
      }
    }
    ctx.restore();
    const gcLen = gc.length / 2;
    if (gcLen > arrayOfThings.length) {
      for (i = 0; i < gcLen; i++) {
        delete data[gc[i]];
      }
      gc.splice(0, gcLen);
    }
    return longest;
  }
  function _alignPixel(chart, pixel, width) {
    const devicePixelRatio2 = chart.currentDevicePixelRatio;
    const halfWidth = width !== 0 ? Math.max(width / 2, 0.5) : 0;
    return Math.round((pixel - halfWidth) * devicePixelRatio2) / devicePixelRatio2 + halfWidth;
  }
  function clearCanvas(canvas, ctx) {
    ctx = ctx || canvas.getContext("2d");
    ctx.save();
    ctx.resetTransform();
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.restore();
  }
  function drawPoint(ctx, options, x, y) {
    drawPointLegend(ctx, options, x, y, null);
  }
  function drawPointLegend(ctx, options, x, y, w) {
    let type2, xOffset, yOffset, size, cornerRadius, width;
    const style = options.pointStyle;
    const rotation = options.rotation;
    const radius3 = options.radius;
    let rad = (rotation || 0) * RAD_PER_DEG;
    if (style && typeof style === "object") {
      type2 = style.toString();
      if (type2 === "[object HTMLImageElement]" || type2 === "[object HTMLCanvasElement]") {
        ctx.save();
        ctx.translate(x, y);
        ctx.rotate(rad);
        ctx.drawImage(style, -style.width / 2, -style.height / 2, style.width, style.height);
        ctx.restore();
        return;
      }
    }
    if (isNaN(radius3) || radius3 <= 0) {
      return;
    }
    ctx.beginPath();
    switch (style) {
      default:
        if (w) {
          ctx.ellipse(x, y, w / 2, radius3, 0, 0, TAU);
        } else {
          ctx.arc(x, y, radius3, 0, TAU);
        }
        ctx.closePath();
        break;
      case "triangle":
        ctx.moveTo(x + Math.sin(rad) * radius3, y - Math.cos(rad) * radius3);
        rad += TWO_THIRDS_PI;
        ctx.lineTo(x + Math.sin(rad) * radius3, y - Math.cos(rad) * radius3);
        rad += TWO_THIRDS_PI;
        ctx.lineTo(x + Math.sin(rad) * radius3, y - Math.cos(rad) * radius3);
        ctx.closePath();
        break;
      case "rectRounded":
        cornerRadius = radius3 * 0.516;
        size = radius3 - cornerRadius;
        xOffset = Math.cos(rad + QUARTER_PI) * size;
        yOffset = Math.sin(rad + QUARTER_PI) * size;
        ctx.arc(x - xOffset, y - yOffset, cornerRadius, rad - PI, rad - HALF_PI);
        ctx.arc(x + yOffset, y - xOffset, cornerRadius, rad - HALF_PI, rad);
        ctx.arc(x + xOffset, y + yOffset, cornerRadius, rad, rad + HALF_PI);
        ctx.arc(x - yOffset, y + xOffset, cornerRadius, rad + HALF_PI, rad + PI);
        ctx.closePath();
        break;
      case "rect":
        if (!rotation) {
          size = Math.SQRT1_2 * radius3;
          width = w ? w / 2 : size;
          ctx.rect(x - width, y - size, 2 * width, 2 * size);
          break;
        }
        rad += QUARTER_PI;
      case "rectRot":
        xOffset = Math.cos(rad) * radius3;
        yOffset = Math.sin(rad) * radius3;
        ctx.moveTo(x - xOffset, y - yOffset);
        ctx.lineTo(x + yOffset, y - xOffset);
        ctx.lineTo(x + xOffset, y + yOffset);
        ctx.lineTo(x - yOffset, y + xOffset);
        ctx.closePath();
        break;
      case "crossRot":
        rad += QUARTER_PI;
      case "cross":
        xOffset = Math.cos(rad) * radius3;
        yOffset = Math.sin(rad) * radius3;
        ctx.moveTo(x - xOffset, y - yOffset);
        ctx.lineTo(x + xOffset, y + yOffset);
        ctx.moveTo(x + yOffset, y - xOffset);
        ctx.lineTo(x - yOffset, y + xOffset);
        break;
      case "star":
        xOffset = Math.cos(rad) * radius3;
        yOffset = Math.sin(rad) * radius3;
        ctx.moveTo(x - xOffset, y - yOffset);
        ctx.lineTo(x + xOffset, y + yOffset);
        ctx.moveTo(x + yOffset, y - xOffset);
        ctx.lineTo(x - yOffset, y + xOffset);
        rad += QUARTER_PI;
        xOffset = Math.cos(rad) * radius3;
        yOffset = Math.sin(rad) * radius3;
        ctx.moveTo(x - xOffset, y - yOffset);
        ctx.lineTo(x + xOffset, y + yOffset);
        ctx.moveTo(x + yOffset, y - xOffset);
        ctx.lineTo(x - yOffset, y + xOffset);
        break;
      case "line":
        xOffset = w ? w / 2 : Math.cos(rad) * radius3;
        yOffset = Math.sin(rad) * radius3;
        ctx.moveTo(x - xOffset, y - yOffset);
        ctx.lineTo(x + xOffset, y + yOffset);
        break;
      case "dash":
        ctx.moveTo(x, y);
        ctx.lineTo(x + Math.cos(rad) * radius3, y + Math.sin(rad) * radius3);
        break;
    }
    ctx.fill();
    if (options.borderWidth > 0) {
      ctx.stroke();
    }
  }
  function _isPointInArea(point, area, margin) {
    margin = margin || 0.5;
    return !area || point && point.x > area.left - margin && point.x < area.right + margin && point.y > area.top - margin && point.y < area.bottom + margin;
  }
  function clipArea(ctx, area) {
    ctx.save();
    ctx.beginPath();
    ctx.rect(area.left, area.top, area.right - area.left, area.bottom - area.top);
    ctx.clip();
  }
  function unclipArea(ctx) {
    ctx.restore();
  }
  function _steppedLineTo(ctx, previous, target, flip, mode) {
    if (!previous) {
      return ctx.lineTo(target.x, target.y);
    }
    if (mode === "middle") {
      const midpoint = (previous.x + target.x) / 2;
      ctx.lineTo(midpoint, previous.y);
      ctx.lineTo(midpoint, target.y);
    } else if (mode === "after" !== !!flip) {
      ctx.lineTo(previous.x, target.y);
    } else {
      ctx.lineTo(target.x, previous.y);
    }
    ctx.lineTo(target.x, target.y);
  }
  function _bezierCurveTo(ctx, previous, target, flip) {
    if (!previous) {
      return ctx.lineTo(target.x, target.y);
    }
    ctx.bezierCurveTo(
      flip ? previous.cp1x : previous.cp2x,
      flip ? previous.cp1y : previous.cp2y,
      flip ? target.cp2x : target.cp1x,
      flip ? target.cp2y : target.cp1y,
      target.x,
      target.y
    );
  }
  function renderText(ctx, text, x, y, font, opts = {}) {
    const lines = isArray(text) ? text : [text];
    const stroke = opts.strokeWidth > 0 && opts.strokeColor !== "";
    let i, line;
    ctx.save();
    ctx.font = font.string;
    setRenderOpts(ctx, opts);
    for (i = 0; i < lines.length; ++i) {
      line = lines[i];
      if (stroke) {
        if (opts.strokeColor) {
          ctx.strokeStyle = opts.strokeColor;
        }
        if (!isNullOrUndef(opts.strokeWidth)) {
          ctx.lineWidth = opts.strokeWidth;
        }
        ctx.strokeText(line, x, y, opts.maxWidth);
      }
      ctx.fillText(line, x, y, opts.maxWidth);
      decorateText(ctx, x, y, line, opts);
      y += font.lineHeight;
    }
    ctx.restore();
  }
  function setRenderOpts(ctx, opts) {
    if (opts.translation) {
      ctx.translate(opts.translation[0], opts.translation[1]);
    }
    if (!isNullOrUndef(opts.rotation)) {
      ctx.rotate(opts.rotation);
    }
    if (opts.color) {
      ctx.fillStyle = opts.color;
    }
    if (opts.textAlign) {
      ctx.textAlign = opts.textAlign;
    }
    if (opts.textBaseline) {
      ctx.textBaseline = opts.textBaseline;
    }
  }
  function decorateText(ctx, x, y, line, opts) {
    if (opts.strikethrough || opts.underline) {
      const metrics = ctx.measureText(line);
      const left = x - metrics.actualBoundingBoxLeft;
      const right = x + metrics.actualBoundingBoxRight;
      const top = y - metrics.actualBoundingBoxAscent;
      const bottom = y + metrics.actualBoundingBoxDescent;
      const yDecoration = opts.strikethrough ? (top + bottom) / 2 : bottom;
      ctx.strokeStyle = ctx.fillStyle;
      ctx.beginPath();
      ctx.lineWidth = opts.decorationWidth || 2;
      ctx.moveTo(left, yDecoration);
      ctx.lineTo(right, yDecoration);
      ctx.stroke();
    }
  }
  function addRoundedRectPath(ctx, rect) {
    const { x, y, w, h, radius: radius3 } = rect;
    ctx.arc(x + radius3.topLeft, y + radius3.topLeft, radius3.topLeft, -HALF_PI, PI, true);
    ctx.lineTo(x, y + h - radius3.bottomLeft);
    ctx.arc(x + radius3.bottomLeft, y + h - radius3.bottomLeft, radius3.bottomLeft, PI, HALF_PI, true);
    ctx.lineTo(x + w - radius3.bottomRight, y + h);
    ctx.arc(x + w - radius3.bottomRight, y + h - radius3.bottomRight, radius3.bottomRight, HALF_PI, 0, true);
    ctx.lineTo(x + w, y + radius3.topRight);
    ctx.arc(x + w - radius3.topRight, y + radius3.topRight, radius3.topRight, 0, -HALF_PI, true);
    ctx.lineTo(x + radius3.topLeft, y);
  }
  var LINE_HEIGHT = new RegExp(/^(normal|(\d+(?:\.\d+)?)(px|em|%)?)$/);
  var FONT_STYLE = new RegExp(/^(normal|italic|initial|inherit|unset|(oblique( -?[0-9]?[0-9]deg)?))$/);
  function toLineHeight(value, size) {
    const matches = ("" + value).match(LINE_HEIGHT);
    if (!matches || matches[1] === "normal") {
      return size * 1.2;
    }
    value = +matches[2];
    switch (matches[3]) {
      case "px":
        return value;
      case "%":
        value /= 100;
        break;
    }
    return size * value;
  }
  var numberOrZero = (v) => +v || 0;
  function _readValueToProps(value, props) {
    const ret = {};
    const objProps = isObject(props);
    const keys = objProps ? Object.keys(props) : props;
    const read = isObject(value) ? objProps ? (prop) => valueOrDefault(value[prop], value[props[prop]]) : (prop) => value[prop] : () => value;
    for (const prop of keys) {
      ret[prop] = numberOrZero(read(prop));
    }
    return ret;
  }
  function toTRBL(value) {
    return _readValueToProps(value, { top: "y", right: "x", bottom: "y", left: "x" });
  }
  function toTRBLCorners(value) {
    return _readValueToProps(value, ["topLeft", "topRight", "bottomLeft", "bottomRight"]);
  }
  function toPadding(value) {
    const obj = toTRBL(value);
    obj.width = obj.left + obj.right;
    obj.height = obj.top + obj.bottom;
    return obj;
  }
  function toFont(options, fallback) {
    options = options || {};
    fallback = fallback || defaults.font;
    let size = valueOrDefault(options.size, fallback.size);
    if (typeof size === "string") {
      size = parseInt(size, 10);
    }
    let style = valueOrDefault(options.style, fallback.style);
    if (style && !("" + style).match(FONT_STYLE)) {
      console.warn('Invalid font style specified: "' + style + '"');
      style = "";
    }
    const font = {
      family: valueOrDefault(options.family, fallback.family),
      lineHeight: toLineHeight(valueOrDefault(options.lineHeight, fallback.lineHeight), size),
      size,
      style,
      weight: valueOrDefault(options.weight, fallback.weight),
      string: ""
    };
    font.string = toFontString(font);
    return font;
  }
  function resolve(inputs, context, index3, info) {
    let cacheable = true;
    let i, ilen, value;
    for (i = 0, ilen = inputs.length; i < ilen; ++i) {
      value = inputs[i];
      if (value === void 0) {
        continue;
      }
      if (context !== void 0 && typeof value === "function") {
        value = value(context);
        cacheable = false;
      }
      if (index3 !== void 0 && isArray(value)) {
        value = value[index3 % value.length];
        cacheable = false;
      }
      if (value !== void 0) {
        if (info && !cacheable) {
          info.cacheable = false;
        }
        return value;
      }
    }
  }
  function _addGrace(minmax, grace, beginAtZero) {
    const { min: min3, max: max3 } = minmax;
    const change = toDimension(grace, (max3 - min3) / 2);
    const keepZero = (value, add) => beginAtZero && value === 0 ? 0 : value + add;
    return {
      min: keepZero(min3, -Math.abs(change)),
      max: keepZero(max3, change)
    };
  }
  function createContext(parentContext, context) {
    return Object.assign(Object.create(parentContext), context);
  }
  function _createResolver(scopes, prefixes2 = [""], rootScopes = scopes, fallback, getTarget = () => scopes[0]) {
    if (!defined(fallback)) {
      fallback = _resolve("_fallback", scopes);
    }
    const cache = {
      [Symbol.toStringTag]: "Object",
      _cacheable: true,
      _scopes: scopes,
      _rootScopes: rootScopes,
      _fallback: fallback,
      _getTarget: getTarget,
      override: (scope) => _createResolver([scope, ...scopes], prefixes2, rootScopes, fallback)
    };
    return new Proxy(cache, {
      deleteProperty(target, prop) {
        delete target[prop];
        delete target._keys;
        delete scopes[0][prop];
        return true;
      },
      get(target, prop) {
        return _cached(
          target,
          prop,
          () => _resolveWithPrefixes(prop, prefixes2, scopes, target)
        );
      },
      getOwnPropertyDescriptor(target, prop) {
        return Reflect.getOwnPropertyDescriptor(target._scopes[0], prop);
      },
      getPrototypeOf() {
        return Reflect.getPrototypeOf(scopes[0]);
      },
      has(target, prop) {
        return getKeysFromAllScopes(target).includes(prop);
      },
      ownKeys(target) {
        return getKeysFromAllScopes(target);
      },
      set(target, prop, value) {
        const storage = target._storage || (target._storage = getTarget());
        target[prop] = storage[prop] = value;
        delete target._keys;
        return true;
      }
    });
  }
  function _attachContext(proxy, context, subProxy, descriptorDefaults) {
    const cache = {
      _cacheable: false,
      _proxy: proxy,
      _context: context,
      _subProxy: subProxy,
      _stack: /* @__PURE__ */ new Set(),
      _descriptors: _descriptors(proxy, descriptorDefaults),
      setContext: (ctx) => _attachContext(proxy, ctx, subProxy, descriptorDefaults),
      override: (scope) => _attachContext(proxy.override(scope), context, subProxy, descriptorDefaults)
    };
    return new Proxy(cache, {
      deleteProperty(target, prop) {
        delete target[prop];
        delete proxy[prop];
        return true;
      },
      get(target, prop, receiver) {
        return _cached(
          target,
          prop,
          () => _resolveWithContext(target, prop, receiver)
        );
      },
      getOwnPropertyDescriptor(target, prop) {
        return target._descriptors.allKeys ? Reflect.has(proxy, prop) ? { enumerable: true, configurable: true } : void 0 : Reflect.getOwnPropertyDescriptor(proxy, prop);
      },
      getPrototypeOf() {
        return Reflect.getPrototypeOf(proxy);
      },
      has(target, prop) {
        return Reflect.has(proxy, prop);
      },
      ownKeys() {
        return Reflect.ownKeys(proxy);
      },
      set(target, prop, value) {
        proxy[prop] = value;
        delete target[prop];
        return true;
      }
    });
  }
  function _descriptors(proxy, defaults3 = { scriptable: true, indexable: true }) {
    const { _scriptable = defaults3.scriptable, _indexable = defaults3.indexable, _allKeys = defaults3.allKeys } = proxy;
    return {
      allKeys: _allKeys,
      scriptable: _scriptable,
      indexable: _indexable,
      isScriptable: isFunction(_scriptable) ? _scriptable : () => _scriptable,
      isIndexable: isFunction(_indexable) ? _indexable : () => _indexable
    };
  }
  var readKey = (prefix, name) => prefix ? prefix + _capitalize(name) : name;
  var needsSubResolver = (prop, value) => isObject(value) && prop !== "adapters" && (Object.getPrototypeOf(value) === null || value.constructor === Object);
  function _cached(target, prop, resolve2) {
    if (Object.prototype.hasOwnProperty.call(target, prop)) {
      return target[prop];
    }
    const value = resolve2();
    target[prop] = value;
    return value;
  }
  function _resolveWithContext(target, prop, receiver) {
    const { _proxy, _context, _subProxy, _descriptors: descriptors2 } = target;
    let value = _proxy[prop];
    if (isFunction(value) && descriptors2.isScriptable(prop)) {
      value = _resolveScriptable(prop, value, target, receiver);
    }
    if (isArray(value) && value.length) {
      value = _resolveArray(prop, value, target, descriptors2.isIndexable);
    }
    if (needsSubResolver(prop, value)) {
      value = _attachContext(value, _context, _subProxy && _subProxy[prop], descriptors2);
    }
    return value;
  }
  function _resolveScriptable(prop, value, target, receiver) {
    const { _proxy, _context, _subProxy, _stack } = target;
    if (_stack.has(prop)) {
      throw new Error("Recursion detected: " + Array.from(_stack).join("->") + "->" + prop);
    }
    _stack.add(prop);
    value = value(_context, _subProxy || receiver);
    _stack.delete(prop);
    if (needsSubResolver(prop, value)) {
      value = createSubResolver(_proxy._scopes, _proxy, prop, value);
    }
    return value;
  }
  function _resolveArray(prop, value, target, isIndexable) {
    const { _proxy, _context, _subProxy, _descriptors: descriptors2 } = target;
    if (defined(_context.index) && isIndexable(prop)) {
      value = value[_context.index % value.length];
    } else if (isObject(value[0])) {
      const arr = value;
      const scopes = _proxy._scopes.filter((s) => s !== arr);
      value = [];
      for (const item of arr) {
        const resolver = createSubResolver(scopes, _proxy, prop, item);
        value.push(_attachContext(resolver, _context, _subProxy && _subProxy[prop], descriptors2));
      }
    }
    return value;
  }
  function resolveFallback(fallback, prop, value) {
    return isFunction(fallback) ? fallback(prop, value) : fallback;
  }
  var getScope = (key, parent) => key === true ? parent : typeof key === "string" ? resolveObjectKey(parent, key) : void 0;
  function addScopes(set4, parentScopes, key, parentFallback, value) {
    for (const parent of parentScopes) {
      const scope = getScope(key, parent);
      if (scope) {
        set4.add(scope);
        const fallback = resolveFallback(scope._fallback, key, value);
        if (defined(fallback) && fallback !== key && fallback !== parentFallback) {
          return fallback;
        }
      } else if (scope === false && defined(parentFallback) && key !== parentFallback) {
        return null;
      }
    }
    return false;
  }
  function createSubResolver(parentScopes, resolver, prop, value) {
    const rootScopes = resolver._rootScopes;
    const fallback = resolveFallback(resolver._fallback, prop, value);
    const allScopes = [...parentScopes, ...rootScopes];
    const set4 = /* @__PURE__ */ new Set();
    set4.add(value);
    let key = addScopesFromKey(set4, allScopes, prop, fallback || prop, value);
    if (key === null) {
      return false;
    }
    if (defined(fallback) && fallback !== prop) {
      key = addScopesFromKey(set4, allScopes, fallback, key, value);
      if (key === null) {
        return false;
      }
    }
    return _createResolver(
      Array.from(set4),
      [""],
      rootScopes,
      fallback,
      () => subGetTarget(resolver, prop, value)
    );
  }
  function addScopesFromKey(set4, allScopes, key, fallback, item) {
    while (key) {
      key = addScopes(set4, allScopes, key, fallback, item);
    }
    return key;
  }
  function subGetTarget(resolver, prop, value) {
    const parent = resolver._getTarget();
    if (!(prop in parent)) {
      parent[prop] = {};
    }
    const target = parent[prop];
    if (isArray(target) && isObject(value)) {
      return value;
    }
    return target;
  }
  function _resolveWithPrefixes(prop, prefixes2, scopes, proxy) {
    let value;
    for (const prefix of prefixes2) {
      value = _resolve(readKey(prefix, prop), scopes);
      if (defined(value)) {
        return needsSubResolver(prop, value) ? createSubResolver(scopes, proxy, prop, value) : value;
      }
    }
  }
  function _resolve(key, scopes) {
    for (const scope of scopes) {
      if (!scope) {
        continue;
      }
      const value = scope[key];
      if (defined(value)) {
        return value;
      }
    }
  }
  function getKeysFromAllScopes(target) {
    let keys = target._keys;
    if (!keys) {
      keys = target._keys = resolveKeysFromAllScopes(target._scopes);
    }
    return keys;
  }
  function resolveKeysFromAllScopes(scopes) {
    const set4 = /* @__PURE__ */ new Set();
    for (const scope of scopes) {
      for (const key of Object.keys(scope).filter((k) => !k.startsWith("_"))) {
        set4.add(key);
      }
    }
    return Array.from(set4);
  }
  function _parseObjectDataRadialScale(meta, data, start2, count) {
    const { iScale } = meta;
    const { key = "r" } = this._parsing;
    const parsed = new Array(count);
    let i, ilen, index3, item;
    for (i = 0, ilen = count; i < ilen; ++i) {
      index3 = i + start2;
      item = data[index3];
      parsed[i] = {
        r: iScale.parse(resolveObjectKey(item, key), index3)
      };
    }
    return parsed;
  }
  var EPSILON = Number.EPSILON || 1e-14;
  var getPoint = (points, i) => i < points.length && !points[i].skip && points[i];
  var getValueAxis = (indexAxis) => indexAxis === "x" ? "y" : "x";
  function splineCurve(firstPoint, middlePoint, afterPoint, t) {
    const previous = firstPoint.skip ? middlePoint : firstPoint;
    const current = middlePoint;
    const next = afterPoint.skip ? middlePoint : afterPoint;
    const d01 = distanceBetweenPoints(current, previous);
    const d12 = distanceBetweenPoints(next, current);
    let s01 = d01 / (d01 + d12);
    let s12 = d12 / (d01 + d12);
    s01 = isNaN(s01) ? 0 : s01;
    s12 = isNaN(s12) ? 0 : s12;
    const fa = t * s01;
    const fb = t * s12;
    return {
      previous: {
        x: current.x - fa * (next.x - previous.x),
        y: current.y - fa * (next.y - previous.y)
      },
      next: {
        x: current.x + fb * (next.x - previous.x),
        y: current.y + fb * (next.y - previous.y)
      }
    };
  }
  function monotoneAdjust(points, deltaK, mK) {
    const pointsLen = points.length;
    let alphaK, betaK, tauK, squaredMagnitude, pointCurrent;
    let pointAfter = getPoint(points, 0);
    for (let i = 0; i < pointsLen - 1; ++i) {
      pointCurrent = pointAfter;
      pointAfter = getPoint(points, i + 1);
      if (!pointCurrent || !pointAfter) {
        continue;
      }
      if (almostEquals(deltaK[i], 0, EPSILON)) {
        mK[i] = mK[i + 1] = 0;
        continue;
      }
      alphaK = mK[i] / deltaK[i];
      betaK = mK[i + 1] / deltaK[i];
      squaredMagnitude = Math.pow(alphaK, 2) + Math.pow(betaK, 2);
      if (squaredMagnitude <= 9) {
        continue;
      }
      tauK = 3 / Math.sqrt(squaredMagnitude);
      mK[i] = alphaK * tauK * deltaK[i];
      mK[i + 1] = betaK * tauK * deltaK[i];
    }
  }
  function monotoneCompute(points, mK, indexAxis = "x") {
    const valueAxis = getValueAxis(indexAxis);
    const pointsLen = points.length;
    let delta, pointBefore, pointCurrent;
    let pointAfter = getPoint(points, 0);
    for (let i = 0; i < pointsLen; ++i) {
      pointBefore = pointCurrent;
      pointCurrent = pointAfter;
      pointAfter = getPoint(points, i + 1);
      if (!pointCurrent) {
        continue;
      }
      const iPixel = pointCurrent[indexAxis];
      const vPixel = pointCurrent[valueAxis];
      if (pointBefore) {
        delta = (iPixel - pointBefore[indexAxis]) / 3;
        pointCurrent[`cp1${indexAxis}`] = iPixel - delta;
        pointCurrent[`cp1${valueAxis}`] = vPixel - delta * mK[i];
      }
      if (pointAfter) {
        delta = (pointAfter[indexAxis] - iPixel) / 3;
        pointCurrent[`cp2${indexAxis}`] = iPixel + delta;
        pointCurrent[`cp2${valueAxis}`] = vPixel + delta * mK[i];
      }
    }
  }
  function splineCurveMonotone(points, indexAxis = "x") {
    const valueAxis = getValueAxis(indexAxis);
    const pointsLen = points.length;
    const deltaK = Array(pointsLen).fill(0);
    const mK = Array(pointsLen);
    let i, pointBefore, pointCurrent;
    let pointAfter = getPoint(points, 0);
    for (i = 0; i < pointsLen; ++i) {
      pointBefore = pointCurrent;
      pointCurrent = pointAfter;
      pointAfter = getPoint(points, i + 1);
      if (!pointCurrent) {
        continue;
      }
      if (pointAfter) {
        const slopeDelta = pointAfter[indexAxis] - pointCurrent[indexAxis];
        deltaK[i] = slopeDelta !== 0 ? (pointAfter[valueAxis] - pointCurrent[valueAxis]) / slopeDelta : 0;
      }
      mK[i] = !pointBefore ? deltaK[i] : !pointAfter ? deltaK[i - 1] : sign(deltaK[i - 1]) !== sign(deltaK[i]) ? 0 : (deltaK[i - 1] + deltaK[i]) / 2;
    }
    monotoneAdjust(points, deltaK, mK);
    monotoneCompute(points, mK, indexAxis);
  }
  function capControlPoint(pt, min3, max3) {
    return Math.max(Math.min(pt, max3), min3);
  }
  function capBezierPoints(points, area) {
    let i, ilen, point, inArea, inAreaPrev;
    let inAreaNext = _isPointInArea(points[0], area);
    for (i = 0, ilen = points.length; i < ilen; ++i) {
      inAreaPrev = inArea;
      inArea = inAreaNext;
      inAreaNext = i < ilen - 1 && _isPointInArea(points[i + 1], area);
      if (!inArea) {
        continue;
      }
      point = points[i];
      if (inAreaPrev) {
        point.cp1x = capControlPoint(point.cp1x, area.left, area.right);
        point.cp1y = capControlPoint(point.cp1y, area.top, area.bottom);
      }
      if (inAreaNext) {
        point.cp2x = capControlPoint(point.cp2x, area.left, area.right);
        point.cp2y = capControlPoint(point.cp2y, area.top, area.bottom);
      }
    }
  }
  function _updateBezierControlPoints(points, options, area, loop, indexAxis) {
    let i, ilen, point, controlPoints;
    if (options.spanGaps) {
      points = points.filter((pt) => !pt.skip);
    }
    if (options.cubicInterpolationMode === "monotone") {
      splineCurveMonotone(points, indexAxis);
    } else {
      let prev = loop ? points[points.length - 1] : points[0];
      for (i = 0, ilen = points.length; i < ilen; ++i) {
        point = points[i];
        controlPoints = splineCurve(
          prev,
          point,
          points[Math.min(i + 1, ilen - (loop ? 0 : 1)) % ilen],
          options.tension
        );
        point.cp1x = controlPoints.previous.x;
        point.cp1y = controlPoints.previous.y;
        point.cp2x = controlPoints.next.x;
        point.cp2y = controlPoints.next.y;
        prev = point;
      }
    }
    if (options.capBezierPoints) {
      capBezierPoints(points, area);
    }
  }
  function _isDomSupported() {
    return typeof window !== "undefined" && typeof document !== "undefined";
  }
  function _getParentNode(domNode) {
    let parent = domNode.parentNode;
    if (parent && parent.toString() === "[object ShadowRoot]") {
      parent = parent.host;
    }
    return parent;
  }
  function parseMaxStyle(styleValue2, node, parentProperty) {
    let valueInPixels;
    if (typeof styleValue2 === "string") {
      valueInPixels = parseInt(styleValue2, 10);
      if (styleValue2.indexOf("%") !== -1) {
        valueInPixels = valueInPixels / 100 * node.parentNode[parentProperty];
      }
    } else {
      valueInPixels = styleValue2;
    }
    return valueInPixels;
  }
  var getComputedStyle = (element) => window.getComputedStyle(element, null);
  function getStyle(el, property) {
    return getComputedStyle(el).getPropertyValue(property);
  }
  var positions = ["top", "right", "bottom", "left"];
  function getPositionedStyle(styles, style, suffix) {
    const result = {};
    suffix = suffix ? "-" + suffix : "";
    for (let i = 0; i < 4; i++) {
      const pos = positions[i];
      result[pos] = parseFloat(styles[style + "-" + pos + suffix]) || 0;
    }
    result.width = result.left + result.right;
    result.height = result.top + result.bottom;
    return result;
  }
  var useOffsetPos = (x, y, target) => (x > 0 || y > 0) && (!target || !target.shadowRoot);
  function getCanvasPosition(e, canvas) {
    const touches = e.touches;
    const source = touches && touches.length ? touches[0] : e;
    const { offsetX, offsetY } = source;
    let box = false;
    let x, y;
    if (useOffsetPos(offsetX, offsetY, e.target)) {
      x = offsetX;
      y = offsetY;
    } else {
      const rect = canvas.getBoundingClientRect();
      x = source.clientX - rect.left;
      y = source.clientY - rect.top;
      box = true;
    }
    return { x, y, box };
  }
  function getRelativePosition(evt, chart) {
    if ("native" in evt) {
      return evt;
    }
    const { canvas, currentDevicePixelRatio } = chart;
    const style = getComputedStyle(canvas);
    const borderBox = style.boxSizing === "border-box";
    const paddings = getPositionedStyle(style, "padding");
    const borders = getPositionedStyle(style, "border", "width");
    const { x, y, box } = getCanvasPosition(evt, canvas);
    const xOffset = paddings.left + (box && borders.left);
    const yOffset = paddings.top + (box && borders.top);
    let { width, height } = chart;
    if (borderBox) {
      width -= paddings.width + borders.width;
      height -= paddings.height + borders.height;
    }
    return {
      x: Math.round((x - xOffset) / width * canvas.width / currentDevicePixelRatio),
      y: Math.round((y - yOffset) / height * canvas.height / currentDevicePixelRatio)
    };
  }
  function getContainerSize(canvas, width, height) {
    let maxWidth, maxHeight;
    if (width === void 0 || height === void 0) {
      const container = _getParentNode(canvas);
      if (!container) {
        width = canvas.clientWidth;
        height = canvas.clientHeight;
      } else {
        const rect = container.getBoundingClientRect();
        const containerStyle = getComputedStyle(container);
        const containerBorder = getPositionedStyle(containerStyle, "border", "width");
        const containerPadding = getPositionedStyle(containerStyle, "padding");
        width = rect.width - containerPadding.width - containerBorder.width;
        height = rect.height - containerPadding.height - containerBorder.height;
        maxWidth = parseMaxStyle(containerStyle.maxWidth, container, "clientWidth");
        maxHeight = parseMaxStyle(containerStyle.maxHeight, container, "clientHeight");
      }
    }
    return {
      width,
      height,
      maxWidth: maxWidth || INFINITY,
      maxHeight: maxHeight || INFINITY
    };
  }
  var round1 = (v) => Math.round(v * 10) / 10;
  function getMaximumSize(canvas, bbWidth, bbHeight, aspectRatio) {
    const style = getComputedStyle(canvas);
    const margins = getPositionedStyle(style, "margin");
    const maxWidth = parseMaxStyle(style.maxWidth, canvas, "clientWidth") || INFINITY;
    const maxHeight = parseMaxStyle(style.maxHeight, canvas, "clientHeight") || INFINITY;
    const containerSize = getContainerSize(canvas, bbWidth, bbHeight);
    let { width, height } = containerSize;
    if (style.boxSizing === "content-box") {
      const borders = getPositionedStyle(style, "border", "width");
      const paddings = getPositionedStyle(style, "padding");
      width -= paddings.width + borders.width;
      height -= paddings.height + borders.height;
    }
    width = Math.max(0, width - margins.width);
    height = Math.max(0, aspectRatio ? Math.floor(width / aspectRatio) : height - margins.height);
    width = round1(Math.min(width, maxWidth, containerSize.maxWidth));
    height = round1(Math.min(height, maxHeight, containerSize.maxHeight));
    if (width && !height) {
      height = round1(width / 2);
    }
    return {
      width,
      height
    };
  }
  function retinaScale(chart, forceRatio, forceStyle) {
    const pixelRatio = forceRatio || 1;
    const deviceHeight = Math.floor(chart.height * pixelRatio);
    const deviceWidth = Math.floor(chart.width * pixelRatio);
    chart.height = deviceHeight / pixelRatio;
    chart.width = deviceWidth / pixelRatio;
    const canvas = chart.canvas;
    if (canvas.style && (forceStyle || !canvas.style.height && !canvas.style.width)) {
      canvas.style.height = `${chart.height}px`;
      canvas.style.width = `${chart.width}px`;
    }
    if (chart.currentDevicePixelRatio !== pixelRatio || canvas.height !== deviceHeight || canvas.width !== deviceWidth) {
      chart.currentDevicePixelRatio = pixelRatio;
      canvas.height = deviceHeight;
      canvas.width = deviceWidth;
      chart.ctx.setTransform(pixelRatio, 0, 0, pixelRatio, 0, 0);
      return true;
    }
    return false;
  }
  var supportsEventListenerOptions = function() {
    let passiveSupported = false;
    try {
      const options = {
        get passive() {
          passiveSupported = true;
          return false;
        }
      };
      window.addEventListener("test", null, options);
      window.removeEventListener("test", null, options);
    } catch (e) {
    }
    return passiveSupported;
  }();
  function readUsedSize(element, property) {
    const value = getStyle(element, property);
    const matches = value && value.match(/^(\d+)(\.\d+)?px$/);
    return matches ? +matches[1] : void 0;
  }
  function _pointInLine(p1, p2, t, mode) {
    return {
      x: p1.x + t * (p2.x - p1.x),
      y: p1.y + t * (p2.y - p1.y)
    };
  }
  function _steppedInterpolation(p1, p2, t, mode) {
    return {
      x: p1.x + t * (p2.x - p1.x),
      y: mode === "middle" ? t < 0.5 ? p1.y : p2.y : mode === "after" ? t < 1 ? p1.y : p2.y : t > 0 ? p2.y : p1.y
    };
  }
  function _bezierInterpolation(p1, p2, t, mode) {
    const cp1 = { x: p1.cp2x, y: p1.cp2y };
    const cp2 = { x: p2.cp1x, y: p2.cp1y };
    const a = _pointInLine(p1, cp1, t);
    const b = _pointInLine(cp1, cp2, t);
    const c = _pointInLine(cp2, p2, t);
    const d = _pointInLine(a, b, t);
    const e = _pointInLine(b, c, t);
    return _pointInLine(d, e, t);
  }
  var intlCache = /* @__PURE__ */ new Map();
  function getNumberFormat(locale3, options) {
    options = options || {};
    const cacheKey = locale3 + JSON.stringify(options);
    let formatter2 = intlCache.get(cacheKey);
    if (!formatter2) {
      formatter2 = new Intl.NumberFormat(locale3, options);
      intlCache.set(cacheKey, formatter2);
    }
    return formatter2;
  }
  function formatNumber(num, locale3, options) {
    return getNumberFormat(locale3, options).format(num);
  }
  var getRightToLeftAdapter = function(rectX, width) {
    return {
      x(x) {
        return rectX + rectX + width - x;
      },
      setWidth(w) {
        width = w;
      },
      textAlign(align) {
        if (align === "center") {
          return align;
        }
        return align === "right" ? "left" : "right";
      },
      xPlus(x, value) {
        return x - value;
      },
      leftForLtr(x, itemWidth) {
        return x - itemWidth;
      }
    };
  };
  var getLeftToRightAdapter = function() {
    return {
      x(x) {
        return x;
      },
      setWidth(w) {
      },
      textAlign(align) {
        return align;
      },
      xPlus(x, value) {
        return x + value;
      },
      leftForLtr(x, _itemWidth) {
        return x;
      }
    };
  };
  function getRtlAdapter(rtl, rectX, width) {
    return rtl ? getRightToLeftAdapter(rectX, width) : getLeftToRightAdapter();
  }
  function overrideTextDirection(ctx, direction) {
    let style, original;
    if (direction === "ltr" || direction === "rtl") {
      style = ctx.canvas.style;
      original = [
        style.getPropertyValue("direction"),
        style.getPropertyPriority("direction")
      ];
      style.setProperty("direction", direction, "important");
      ctx.prevTextDirection = original;
    }
  }
  function restoreTextDirection(ctx, original) {
    if (original !== void 0) {
      delete ctx.prevTextDirection;
      ctx.canvas.style.setProperty("direction", original[0], original[1]);
    }
  }
  function propertyFn(property) {
    if (property === "angle") {
      return {
        between: _angleBetween,
        compare: _angleDiff,
        normalize: _normalizeAngle
      };
    }
    return {
      between: _isBetween,
      compare: (a, b) => a - b,
      normalize: (x) => x
    };
  }
  function normalizeSegment({ start: start2, end, count, loop, style }) {
    return {
      start: start2 % count,
      end: end % count,
      loop: loop && (end - start2 + 1) % count === 0,
      style
    };
  }
  function getSegment(segment, points, bounds) {
    const { property, start: startBound, end: endBound } = bounds;
    const { between, normalize } = propertyFn(property);
    const count = points.length;
    let { start: start2, end, loop } = segment;
    let i, ilen;
    if (loop) {
      start2 += count;
      end += count;
      for (i = 0, ilen = count; i < ilen; ++i) {
        if (!between(normalize(points[start2 % count][property]), startBound, endBound)) {
          break;
        }
        start2--;
        end--;
      }
      start2 %= count;
      end %= count;
    }
    if (end < start2) {
      end += count;
    }
    return { start: start2, end, loop, style: segment.style };
  }
  function _boundSegment(segment, points, bounds) {
    if (!bounds) {
      return [segment];
    }
    const { property, start: startBound, end: endBound } = bounds;
    const count = points.length;
    const { compare, between, normalize } = propertyFn(property);
    const { start: start2, end, loop, style } = getSegment(segment, points, bounds);
    const result = [];
    let inside = false;
    let subStart = null;
    let value, point, prevValue;
    const startIsBefore = () => between(startBound, prevValue, value) && compare(startBound, prevValue) !== 0;
    const endIsBefore = () => compare(endBound, value) === 0 || between(endBound, prevValue, value);
    const shouldStart = () => inside || startIsBefore();
    const shouldStop = () => !inside || endIsBefore();
    for (let i = start2, prev = start2; i <= end; ++i) {
      point = points[i % count];
      if (point.skip) {
        continue;
      }
      value = normalize(point[property]);
      if (value === prevValue) {
        continue;
      }
      inside = between(value, startBound, endBound);
      if (subStart === null && shouldStart()) {
        subStart = compare(value, startBound) === 0 ? i : prev;
      }
      if (subStart !== null && shouldStop()) {
        result.push(normalizeSegment({ start: subStart, end: i, loop, count, style }));
        subStart = null;
      }
      prev = i;
      prevValue = value;
    }
    if (subStart !== null) {
      result.push(normalizeSegment({ start: subStart, end, loop, count, style }));
    }
    return result;
  }
  function _boundSegments(line, bounds) {
    const result = [];
    const segments = line.segments;
    for (let i = 0; i < segments.length; i++) {
      const sub = _boundSegment(segments[i], line.points, bounds);
      if (sub.length) {
        result.push(...sub);
      }
    }
    return result;
  }
  function findStartAndEnd(points, count, loop, spanGaps) {
    let start2 = 0;
    let end = count - 1;
    if (loop && !spanGaps) {
      while (start2 < count && !points[start2].skip) {
        start2++;
      }
    }
    while (start2 < count && points[start2].skip) {
      start2++;
    }
    start2 %= count;
    if (loop) {
      end += start2;
    }
    while (end > start2 && points[end % count].skip) {
      end--;
    }
    end %= count;
    return { start: start2, end };
  }
  function solidSegments(points, start2, max3, loop) {
    const count = points.length;
    const result = [];
    let last = start2;
    let prev = points[start2];
    let end;
    for (end = start2 + 1; end <= max3; ++end) {
      const cur = points[end % count];
      if (cur.skip || cur.stop) {
        if (!prev.skip) {
          loop = false;
          result.push({ start: start2 % count, end: (end - 1) % count, loop });
          start2 = last = cur.stop ? end : null;
        }
      } else {
        last = end;
        if (prev.skip) {
          start2 = end;
        }
      }
      prev = cur;
    }
    if (last !== null) {
      result.push({ start: start2 % count, end: last % count, loop });
    }
    return result;
  }
  function _computeSegments(line, segmentOptions) {
    const points = line.points;
    const spanGaps = line.options.spanGaps;
    const count = points.length;
    if (!count) {
      return [];
    }
    const loop = !!line._loop;
    const { start: start2, end } = findStartAndEnd(points, count, loop, spanGaps);
    if (spanGaps === true) {
      return splitByStyles(line, [{ start: start2, end, loop }], points, segmentOptions);
    }
    const max3 = end < start2 ? end + count : end;
    const completeLoop = !!line._fullLoop && start2 === 0 && end === count - 1;
    return splitByStyles(line, solidSegments(points, start2, max3, completeLoop), points, segmentOptions);
  }
  function splitByStyles(line, segments, points, segmentOptions) {
    if (!segmentOptions || !segmentOptions.setContext || !points) {
      return segments;
    }
    return doSplitByStyles(line, segments, points, segmentOptions);
  }
  function doSplitByStyles(line, segments, points, segmentOptions) {
    const chartContext = line._chart.getContext();
    const baseStyle = readStyle(line.options);
    const { _datasetIndex: datasetIndex, options: { spanGaps } } = line;
    const count = points.length;
    const result = [];
    let prevStyle = baseStyle;
    let start2 = segments[0].start;
    let i = start2;
    function addStyle(s, e, l, st) {
      const dir = spanGaps ? -1 : 1;
      if (s === e) {
        return;
      }
      s += count;
      while (points[s % count].skip) {
        s -= dir;
      }
      while (points[e % count].skip) {
        e += dir;
      }
      if (s % count !== e % count) {
        result.push({ start: s % count, end: e % count, loop: l, style: st });
        prevStyle = st;
        start2 = e % count;
      }
    }
    for (const segment of segments) {
      start2 = spanGaps ? start2 : segment.start;
      let prev = points[start2 % count];
      let style;
      for (i = start2 + 1; i <= segment.end; i++) {
        const pt = points[i % count];
        style = readStyle(segmentOptions.setContext(createContext(chartContext, {
          type: "segment",
          p0: prev,
          p1: pt,
          p0DataIndex: (i - 1) % count,
          p1DataIndex: i % count,
          datasetIndex
        })));
        if (styleChanged(style, prevStyle)) {
          addStyle(start2, i - 1, segment.loop, prevStyle);
        }
        prev = pt;
        prevStyle = style;
      }
      if (start2 < i - 1) {
        addStyle(start2, i - 1, segment.loop, prevStyle);
      }
    }
    return result;
  }
  function readStyle(options) {
    return {
      backgroundColor: options.backgroundColor,
      borderCapStyle: options.borderCapStyle,
      borderDash: options.borderDash,
      borderDashOffset: options.borderDashOffset,
      borderJoinStyle: options.borderJoinStyle,
      borderWidth: options.borderWidth,
      borderColor: options.borderColor
    };
  }
  function styleChanged(style, prevStyle) {
    return prevStyle && JSON.stringify(style) !== JSON.stringify(prevStyle);
  }

  // node_modules/chart.js/dist/chart.mjs
  var Animator = class {
    constructor() {
      this._request = null;
      this._charts = /* @__PURE__ */ new Map();
      this._running = false;
      this._lastDate = void 0;
    }
    _notify(chart, anims, date, type2) {
      const callbacks = anims.listeners[type2];
      const numSteps = anims.duration;
      callbacks.forEach((fn) => fn({
        chart,
        initial: anims.initial,
        numSteps,
        currentStep: Math.min(date - anims.start, numSteps)
      }));
    }
    _refresh() {
      if (this._request) {
        return;
      }
      this._running = true;
      this._request = requestAnimFrame.call(window, () => {
        this._update();
        this._request = null;
        if (this._running) {
          this._refresh();
        }
      });
    }
    _update(date = Date.now()) {
      let remaining = 0;
      this._charts.forEach((anims, chart) => {
        if (!anims.running || !anims.items.length) {
          return;
        }
        const items = anims.items;
        let i = items.length - 1;
        let draw3 = false;
        let item;
        for (; i >= 0; --i) {
          item = items[i];
          if (item._active) {
            if (item._total > anims.duration) {
              anims.duration = item._total;
            }
            item.tick(date);
            draw3 = true;
          } else {
            items[i] = items[items.length - 1];
            items.pop();
          }
        }
        if (draw3) {
          chart.draw();
          this._notify(chart, anims, date, "progress");
        }
        if (!items.length) {
          anims.running = false;
          this._notify(chart, anims, date, "complete");
          anims.initial = false;
        }
        remaining += items.length;
      });
      this._lastDate = date;
      if (remaining === 0) {
        this._running = false;
      }
    }
    _getAnims(chart) {
      const charts = this._charts;
      let anims = charts.get(chart);
      if (!anims) {
        anims = {
          running: false,
          initial: true,
          items: [],
          listeners: {
            complete: [],
            progress: []
          }
        };
        charts.set(chart, anims);
      }
      return anims;
    }
    listen(chart, event, cb) {
      this._getAnims(chart).listeners[event].push(cb);
    }
    add(chart, items) {
      if (!items || !items.length) {
        return;
      }
      this._getAnims(chart).items.push(...items);
    }
    has(chart) {
      return this._getAnims(chart).items.length > 0;
    }
    start(chart) {
      const anims = this._charts.get(chart);
      if (!anims) {
        return;
      }
      anims.running = true;
      anims.start = Date.now();
      anims.duration = anims.items.reduce((acc, cur) => Math.max(acc, cur._duration), 0);
      this._refresh();
    }
    running(chart) {
      if (!this._running) {
        return false;
      }
      const anims = this._charts.get(chart);
      if (!anims || !anims.running || !anims.items.length) {
        return false;
      }
      return true;
    }
    stop(chart) {
      const anims = this._charts.get(chart);
      if (!anims || !anims.items.length) {
        return;
      }
      const items = anims.items;
      let i = items.length - 1;
      for (; i >= 0; --i) {
        items[i].cancel();
      }
      anims.items = [];
      this._notify(chart, anims, Date.now(), "complete");
    }
    remove(chart) {
      return this._charts.delete(chart);
    }
  };
  var animator = new Animator();
  var transparent = "transparent";
  var interpolators = {
    boolean(from2, to2, factor) {
      return factor > 0.5 ? to2 : from2;
    },
    color(from2, to2, factor) {
      const c0 = color(from2 || transparent);
      const c1 = c0.valid && color(to2 || transparent);
      return c1 && c1.valid ? c1.mix(c0, factor).hexString() : to2;
    },
    number(from2, to2, factor) {
      return from2 + (to2 - from2) * factor;
    }
  };
  var Animation = class {
    constructor(cfg, target, prop, to2) {
      const currentValue = target[prop];
      to2 = resolve([cfg.to, to2, currentValue, cfg.from]);
      const from2 = resolve([cfg.from, currentValue, to2]);
      this._active = true;
      this._fn = cfg.fn || interpolators[cfg.type || typeof from2];
      this._easing = effects[cfg.easing] || effects.linear;
      this._start = Math.floor(Date.now() + (cfg.delay || 0));
      this._duration = this._total = Math.floor(cfg.duration);
      this._loop = !!cfg.loop;
      this._target = target;
      this._prop = prop;
      this._from = from2;
      this._to = to2;
      this._promises = void 0;
    }
    active() {
      return this._active;
    }
    update(cfg, to2, date) {
      if (this._active) {
        this._notify(false);
        const currentValue = this._target[this._prop];
        const elapsed = date - this._start;
        const remain = this._duration - elapsed;
        this._start = date;
        this._duration = Math.floor(Math.max(remain, cfg.duration));
        this._total += elapsed;
        this._loop = !!cfg.loop;
        this._to = resolve([cfg.to, to2, currentValue, cfg.from]);
        this._from = resolve([cfg.from, currentValue, to2]);
      }
    }
    cancel() {
      if (this._active) {
        this.tick(Date.now());
        this._active = false;
        this._notify(false);
      }
    }
    tick(date) {
      const elapsed = date - this._start;
      const duration = this._duration;
      const prop = this._prop;
      const from2 = this._from;
      const loop = this._loop;
      const to2 = this._to;
      let factor;
      this._active = from2 !== to2 && (loop || elapsed < duration);
      if (!this._active) {
        this._target[prop] = to2;
        this._notify(true);
        return;
      }
      if (elapsed < 0) {
        this._target[prop] = from2;
        return;
      }
      factor = elapsed / duration % 2;
      factor = loop && factor > 1 ? 2 - factor : factor;
      factor = this._easing(Math.min(1, Math.max(0, factor)));
      this._target[prop] = this._fn(from2, to2, factor);
    }
    wait() {
      const promises = this._promises || (this._promises = []);
      return new Promise((res, rej) => {
        promises.push({ res, rej });
      });
    }
    _notify(resolved) {
      const method = resolved ? "res" : "rej";
      const promises = this._promises || [];
      for (let i = 0; i < promises.length; i++) {
        promises[i][method]();
      }
    }
  };
  var numbers = ["x", "y", "borderWidth", "radius", "tension"];
  var colors = ["color", "borderColor", "backgroundColor"];
  defaults.set("animation", {
    delay: void 0,
    duration: 1e3,
    easing: "easeOutQuart",
    fn: void 0,
    from: void 0,
    loop: void 0,
    to: void 0,
    type: void 0
  });
  var animationOptions = Object.keys(defaults.animation);
  defaults.describe("animation", {
    _fallback: false,
    _indexable: false,
    _scriptable: (name) => name !== "onProgress" && name !== "onComplete" && name !== "fn"
  });
  defaults.set("animations", {
    colors: {
      type: "color",
      properties: colors
    },
    numbers: {
      type: "number",
      properties: numbers
    }
  });
  defaults.describe("animations", {
    _fallback: "animation"
  });
  defaults.set("transitions", {
    active: {
      animation: {
        duration: 400
      }
    },
    resize: {
      animation: {
        duration: 0
      }
    },
    show: {
      animations: {
        colors: {
          from: "transparent"
        },
        visible: {
          type: "boolean",
          duration: 0
        }
      }
    },
    hide: {
      animations: {
        colors: {
          to: "transparent"
        },
        visible: {
          type: "boolean",
          easing: "linear",
          fn: (v) => v | 0
        }
      }
    }
  });
  var Animations = class {
    constructor(chart, config) {
      this._chart = chart;
      this._properties = /* @__PURE__ */ new Map();
      this.configure(config);
    }
    configure(config) {
      if (!isObject(config)) {
        return;
      }
      const animatedProps = this._properties;
      Object.getOwnPropertyNames(config).forEach((key) => {
        const cfg = config[key];
        if (!isObject(cfg)) {
          return;
        }
        const resolved = {};
        for (const option of animationOptions) {
          resolved[option] = cfg[option];
        }
        (isArray(cfg.properties) && cfg.properties || [key]).forEach((prop) => {
          if (prop === key || !animatedProps.has(prop)) {
            animatedProps.set(prop, resolved);
          }
        });
      });
    }
    _animateOptions(target, values) {
      const newOptions = values.options;
      const options = resolveTargetOptions(target, newOptions);
      if (!options) {
        return [];
      }
      const animations = this._createAnimations(options, newOptions);
      if (newOptions.$shared) {
        awaitAll(target.options.$animations, newOptions).then(() => {
          target.options = newOptions;
        }, () => {
        });
      }
      return animations;
    }
    _createAnimations(target, values) {
      const animatedProps = this._properties;
      const animations = [];
      const running = target.$animations || (target.$animations = {});
      const props = Object.keys(values);
      const date = Date.now();
      let i;
      for (i = props.length - 1; i >= 0; --i) {
        const prop = props[i];
        if (prop.charAt(0) === "$") {
          continue;
        }
        if (prop === "options") {
          animations.push(...this._animateOptions(target, values));
          continue;
        }
        const value = values[prop];
        let animation = running[prop];
        const cfg = animatedProps.get(prop);
        if (animation) {
          if (cfg && animation.active()) {
            animation.update(cfg, value, date);
            continue;
          } else {
            animation.cancel();
          }
        }
        if (!cfg || !cfg.duration) {
          target[prop] = value;
          continue;
        }
        running[prop] = animation = new Animation(cfg, target, prop, value);
        animations.push(animation);
      }
      return animations;
    }
    update(target, values) {
      if (this._properties.size === 0) {
        Object.assign(target, values);
        return;
      }
      const animations = this._createAnimations(target, values);
      if (animations.length) {
        animator.add(this._chart, animations);
        return true;
      }
    }
  };
  function awaitAll(animations, properties) {
    const running = [];
    const keys = Object.keys(properties);
    for (let i = 0; i < keys.length; i++) {
      const anim = animations[keys[i]];
      if (anim && anim.active()) {
        running.push(anim.wait());
      }
    }
    return Promise.all(running);
  }
  function resolveTargetOptions(target, newOptions) {
    if (!newOptions) {
      return;
    }
    let options = target.options;
    if (!options) {
      target.options = newOptions;
      return;
    }
    if (options.$shared) {
      target.options = options = Object.assign({}, options, { $shared: false, $animations: {} });
    }
    return options;
  }
  function scaleClip(scale, allowedOverflow) {
    const opts = scale && scale.options || {};
    const reverse = opts.reverse;
    const min3 = opts.min === void 0 ? allowedOverflow : 0;
    const max3 = opts.max === void 0 ? allowedOverflow : 0;
    return {
      start: reverse ? max3 : min3,
      end: reverse ? min3 : max3
    };
  }
  function defaultClip(xScale, yScale, allowedOverflow) {
    if (allowedOverflow === false) {
      return false;
    }
    const x = scaleClip(xScale, allowedOverflow);
    const y = scaleClip(yScale, allowedOverflow);
    return {
      top: y.end,
      right: x.end,
      bottom: y.start,
      left: x.start
    };
  }
  function toClip(value) {
    let t, r, b, l;
    if (isObject(value)) {
      t = value.top;
      r = value.right;
      b = value.bottom;
      l = value.left;
    } else {
      t = r = b = l = value;
    }
    return {
      top: t,
      right: r,
      bottom: b,
      left: l,
      disabled: value === false
    };
  }
  function getSortedDatasetIndices(chart, filterVisible) {
    const keys = [];
    const metasets = chart._getSortedDatasetMetas(filterVisible);
    let i, ilen;
    for (i = 0, ilen = metasets.length; i < ilen; ++i) {
      keys.push(metasets[i].index);
    }
    return keys;
  }
  function applyStack(stack, value, dsIndex, options = {}) {
    const keys = stack.keys;
    const singleMode = options.mode === "single";
    let i, ilen, datasetIndex, otherValue;
    if (value === null) {
      return;
    }
    for (i = 0, ilen = keys.length; i < ilen; ++i) {
      datasetIndex = +keys[i];
      if (datasetIndex === dsIndex) {
        if (options.all) {
          continue;
        }
        break;
      }
      otherValue = stack.values[datasetIndex];
      if (isNumberFinite(otherValue) && (singleMode || (value === 0 || sign(value) === sign(otherValue)))) {
        value += otherValue;
      }
    }
    return value;
  }
  function convertObjectDataToArray(data) {
    const keys = Object.keys(data);
    const adata = new Array(keys.length);
    let i, ilen, key;
    for (i = 0, ilen = keys.length; i < ilen; ++i) {
      key = keys[i];
      adata[i] = {
        x: key,
        y: data[key]
      };
    }
    return adata;
  }
  function isStacked(scale, meta) {
    const stacked = scale && scale.options.stacked;
    return stacked || stacked === void 0 && meta.stack !== void 0;
  }
  function getStackKey(indexScale, valueScale, meta) {
    return `${indexScale.id}.${valueScale.id}.${meta.stack || meta.type}`;
  }
  function getUserBounds(scale) {
    const { min: min3, max: max3, minDefined, maxDefined } = scale.getUserBounds();
    return {
      min: minDefined ? min3 : Number.NEGATIVE_INFINITY,
      max: maxDefined ? max3 : Number.POSITIVE_INFINITY
    };
  }
  function getOrCreateStack(stacks, stackKey, indexValue) {
    const subStack = stacks[stackKey] || (stacks[stackKey] = {});
    return subStack[indexValue] || (subStack[indexValue] = {});
  }
  function getLastIndexInStack(stack, vScale, positive, type2) {
    for (const meta of vScale.getMatchingVisibleMetas(type2).reverse()) {
      const value = stack[meta.index];
      if (positive && value > 0 || !positive && value < 0) {
        return meta.index;
      }
    }
    return null;
  }
  function updateStacks(controller, parsed) {
    const { chart, _cachedMeta: meta } = controller;
    const stacks = chart._stacks || (chart._stacks = {});
    const { iScale, vScale, index: datasetIndex } = meta;
    const iAxis = iScale.axis;
    const vAxis = vScale.axis;
    const key = getStackKey(iScale, vScale, meta);
    const ilen = parsed.length;
    let stack;
    for (let i = 0; i < ilen; ++i) {
      const item = parsed[i];
      const { [iAxis]: index3, [vAxis]: value } = item;
      const itemStacks = item._stacks || (item._stacks = {});
      stack = itemStacks[vAxis] = getOrCreateStack(stacks, key, index3);
      stack[datasetIndex] = value;
      stack._top = getLastIndexInStack(stack, vScale, true, meta.type);
      stack._bottom = getLastIndexInStack(stack, vScale, false, meta.type);
    }
  }
  function getFirstScaleId(chart, axis) {
    const scales2 = chart.scales;
    return Object.keys(scales2).filter((key) => scales2[key].axis === axis).shift();
  }
  function createDatasetContext(parent, index3) {
    return createContext(
      parent,
      {
        active: false,
        dataset: void 0,
        datasetIndex: index3,
        index: index3,
        mode: "default",
        type: "dataset"
      }
    );
  }
  function createDataContext(parent, index3, element) {
    return createContext(parent, {
      active: false,
      dataIndex: index3,
      parsed: void 0,
      raw: void 0,
      element,
      index: index3,
      mode: "default",
      type: "data"
    });
  }
  function clearStacks(meta, items) {
    const datasetIndex = meta.controller.index;
    const axis = meta.vScale && meta.vScale.axis;
    if (!axis) {
      return;
    }
    items = items || meta._parsed;
    for (const parsed of items) {
      const stacks = parsed._stacks;
      if (!stacks || stacks[axis] === void 0 || stacks[axis][datasetIndex] === void 0) {
        return;
      }
      delete stacks[axis][datasetIndex];
    }
  }
  var isDirectUpdateMode = (mode) => mode === "reset" || mode === "none";
  var cloneIfNotShared = (cached, shared) => shared ? cached : Object.assign({}, cached);
  var createStack = (canStack, meta, chart) => canStack && !meta.hidden && meta._stacked && { keys: getSortedDatasetIndices(chart, true), values: null };
  var DatasetController = class {
    constructor(chart, datasetIndex) {
      this.chart = chart;
      this._ctx = chart.ctx;
      this.index = datasetIndex;
      this._cachedDataOpts = {};
      this._cachedMeta = this.getMeta();
      this._type = this._cachedMeta.type;
      this.options = void 0;
      this._parsing = false;
      this._data = void 0;
      this._objectData = void 0;
      this._sharedOptions = void 0;
      this._drawStart = void 0;
      this._drawCount = void 0;
      this.enableOptionSharing = false;
      this.supportsDecimation = false;
      this.$context = void 0;
      this._syncList = [];
      this.initialize();
    }
    initialize() {
      const meta = this._cachedMeta;
      this.configure();
      this.linkScales();
      meta._stacked = isStacked(meta.vScale, meta);
      this.addElements();
    }
    updateIndex(datasetIndex) {
      if (this.index !== datasetIndex) {
        clearStacks(this._cachedMeta);
      }
      this.index = datasetIndex;
    }
    linkScales() {
      const chart = this.chart;
      const meta = this._cachedMeta;
      const dataset = this.getDataset();
      const chooseId = (axis, x, y, r) => axis === "x" ? x : axis === "r" ? r : y;
      const xid = meta.xAxisID = valueOrDefault(dataset.xAxisID, getFirstScaleId(chart, "x"));
      const yid = meta.yAxisID = valueOrDefault(dataset.yAxisID, getFirstScaleId(chart, "y"));
      const rid = meta.rAxisID = valueOrDefault(dataset.rAxisID, getFirstScaleId(chart, "r"));
      const indexAxis = meta.indexAxis;
      const iid = meta.iAxisID = chooseId(indexAxis, xid, yid, rid);
      const vid = meta.vAxisID = chooseId(indexAxis, yid, xid, rid);
      meta.xScale = this.getScaleForId(xid);
      meta.yScale = this.getScaleForId(yid);
      meta.rScale = this.getScaleForId(rid);
      meta.iScale = this.getScaleForId(iid);
      meta.vScale = this.getScaleForId(vid);
    }
    getDataset() {
      return this.chart.data.datasets[this.index];
    }
    getMeta() {
      return this.chart.getDatasetMeta(this.index);
    }
    getScaleForId(scaleID) {
      return this.chart.scales[scaleID];
    }
    _getOtherScale(scale) {
      const meta = this._cachedMeta;
      return scale === meta.iScale ? meta.vScale : meta.iScale;
    }
    reset() {
      this._update("reset");
    }
    _destroy() {
      const meta = this._cachedMeta;
      if (this._data) {
        unlistenArrayEvents(this._data, this);
      }
      if (meta._stacked) {
        clearStacks(meta);
      }
    }
    _dataCheck() {
      const dataset = this.getDataset();
      const data = dataset.data || (dataset.data = []);
      const _data = this._data;
      if (isObject(data)) {
        this._data = convertObjectDataToArray(data);
      } else if (_data !== data) {
        if (_data) {
          unlistenArrayEvents(_data, this);
          const meta = this._cachedMeta;
          clearStacks(meta);
          meta._parsed = [];
        }
        if (data && Object.isExtensible(data)) {
          listenArrayEvents(data, this);
        }
        this._syncList = [];
        this._data = data;
      }
    }
    addElements() {
      const meta = this._cachedMeta;
      this._dataCheck();
      if (this.datasetElementType) {
        meta.dataset = new this.datasetElementType();
      }
    }
    buildOrUpdateElements(resetNewElements) {
      const meta = this._cachedMeta;
      const dataset = this.getDataset();
      let stackChanged = false;
      this._dataCheck();
      const oldStacked = meta._stacked;
      meta._stacked = isStacked(meta.vScale, meta);
      if (meta.stack !== dataset.stack) {
        stackChanged = true;
        clearStacks(meta);
        meta.stack = dataset.stack;
      }
      this._resyncElements(resetNewElements);
      if (stackChanged || oldStacked !== meta._stacked) {
        updateStacks(this, meta._parsed);
      }
    }
    configure() {
      const config = this.chart.config;
      const scopeKeys = config.datasetScopeKeys(this._type);
      const scopes = config.getOptionScopes(this.getDataset(), scopeKeys, true);
      this.options = config.createResolver(scopes, this.getContext());
      this._parsing = this.options.parsing;
      this._cachedDataOpts = {};
    }
    parse(start2, count) {
      const { _cachedMeta: meta, _data: data } = this;
      const { iScale, _stacked } = meta;
      const iAxis = iScale.axis;
      let sorted = start2 === 0 && count === data.length ? true : meta._sorted;
      let prev = start2 > 0 && meta._parsed[start2 - 1];
      let i, cur, parsed;
      if (this._parsing === false) {
        meta._parsed = data;
        meta._sorted = true;
        parsed = data;
      } else {
        if (isArray(data[start2])) {
          parsed = this.parseArrayData(meta, data, start2, count);
        } else if (isObject(data[start2])) {
          parsed = this.parseObjectData(meta, data, start2, count);
        } else {
          parsed = this.parsePrimitiveData(meta, data, start2, count);
        }
        const isNotInOrderComparedToPrev = () => cur[iAxis] === null || prev && cur[iAxis] < prev[iAxis];
        for (i = 0; i < count; ++i) {
          meta._parsed[i + start2] = cur = parsed[i];
          if (sorted) {
            if (isNotInOrderComparedToPrev()) {
              sorted = false;
            }
            prev = cur;
          }
        }
        meta._sorted = sorted;
      }
      if (_stacked) {
        updateStacks(this, parsed);
      }
    }
    parsePrimitiveData(meta, data, start2, count) {
      const { iScale, vScale } = meta;
      const iAxis = iScale.axis;
      const vAxis = vScale.axis;
      const labels = iScale.getLabels();
      const singleScale = iScale === vScale;
      const parsed = new Array(count);
      let i, ilen, index3;
      for (i = 0, ilen = count; i < ilen; ++i) {
        index3 = i + start2;
        parsed[i] = {
          [iAxis]: singleScale || iScale.parse(labels[index3], index3),
          [vAxis]: vScale.parse(data[index3], index3)
        };
      }
      return parsed;
    }
    parseArrayData(meta, data, start2, count) {
      const { xScale, yScale } = meta;
      const parsed = new Array(count);
      let i, ilen, index3, item;
      for (i = 0, ilen = count; i < ilen; ++i) {
        index3 = i + start2;
        item = data[index3];
        parsed[i] = {
          x: xScale.parse(item[0], index3),
          y: yScale.parse(item[1], index3)
        };
      }
      return parsed;
    }
    parseObjectData(meta, data, start2, count) {
      const { xScale, yScale } = meta;
      const { xAxisKey = "x", yAxisKey = "y" } = this._parsing;
      const parsed = new Array(count);
      let i, ilen, index3, item;
      for (i = 0, ilen = count; i < ilen; ++i) {
        index3 = i + start2;
        item = data[index3];
        parsed[i] = {
          x: xScale.parse(resolveObjectKey(item, xAxisKey), index3),
          y: yScale.parse(resolveObjectKey(item, yAxisKey), index3)
        };
      }
      return parsed;
    }
    getParsed(index3) {
      return this._cachedMeta._parsed[index3];
    }
    getDataElement(index3) {
      return this._cachedMeta.data[index3];
    }
    applyStack(scale, parsed, mode) {
      const chart = this.chart;
      const meta = this._cachedMeta;
      const value = parsed[scale.axis];
      const stack = {
        keys: getSortedDatasetIndices(chart, true),
        values: parsed._stacks[scale.axis]
      };
      return applyStack(stack, value, meta.index, { mode });
    }
    updateRangeFromParsed(range, scale, parsed, stack) {
      const parsedValue = parsed[scale.axis];
      let value = parsedValue === null ? NaN : parsedValue;
      const values = stack && parsed._stacks[scale.axis];
      if (stack && values) {
        stack.values = values;
        value = applyStack(stack, parsedValue, this._cachedMeta.index);
      }
      range.min = Math.min(range.min, value);
      range.max = Math.max(range.max, value);
    }
    getMinMax(scale, canStack) {
      const meta = this._cachedMeta;
      const _parsed = meta._parsed;
      const sorted = meta._sorted && scale === meta.iScale;
      const ilen = _parsed.length;
      const otherScale = this._getOtherScale(scale);
      const stack = createStack(canStack, meta, this.chart);
      const range = { min: Number.POSITIVE_INFINITY, max: Number.NEGATIVE_INFINITY };
      const { min: otherMin, max: otherMax } = getUserBounds(otherScale);
      let i, parsed;
      function _skip() {
        parsed = _parsed[i];
        const otherValue = parsed[otherScale.axis];
        return !isNumberFinite(parsed[scale.axis]) || otherMin > otherValue || otherMax < otherValue;
      }
      for (i = 0; i < ilen; ++i) {
        if (_skip()) {
          continue;
        }
        this.updateRangeFromParsed(range, scale, parsed, stack);
        if (sorted) {
          break;
        }
      }
      if (sorted) {
        for (i = ilen - 1; i >= 0; --i) {
          if (_skip()) {
            continue;
          }
          this.updateRangeFromParsed(range, scale, parsed, stack);
          break;
        }
      }
      return range;
    }
    getAllParsedValues(scale) {
      const parsed = this._cachedMeta._parsed;
      const values = [];
      let i, ilen, value;
      for (i = 0, ilen = parsed.length; i < ilen; ++i) {
        value = parsed[i][scale.axis];
        if (isNumberFinite(value)) {
          values.push(value);
        }
      }
      return values;
    }
    getMaxOverflow() {
      return false;
    }
    getLabelAndValue(index3) {
      const meta = this._cachedMeta;
      const iScale = meta.iScale;
      const vScale = meta.vScale;
      const parsed = this.getParsed(index3);
      return {
        label: iScale ? "" + iScale.getLabelForValue(parsed[iScale.axis]) : "",
        value: vScale ? "" + vScale.getLabelForValue(parsed[vScale.axis]) : ""
      };
    }
    _update(mode) {
      const meta = this._cachedMeta;
      this.update(mode || "default");
      meta._clip = toClip(valueOrDefault(this.options.clip, defaultClip(meta.xScale, meta.yScale, this.getMaxOverflow())));
    }
    update(mode) {
    }
    draw() {
      const ctx = this._ctx;
      const chart = this.chart;
      const meta = this._cachedMeta;
      const elements2 = meta.data || [];
      const area = chart.chartArea;
      const active = [];
      const start2 = this._drawStart || 0;
      const count = this._drawCount || elements2.length - start2;
      const drawActiveElementsOnTop = this.options.drawActiveElementsOnTop;
      let i;
      if (meta.dataset) {
        meta.dataset.draw(ctx, area, start2, count);
      }
      for (i = start2; i < start2 + count; ++i) {
        const element = elements2[i];
        if (element.hidden) {
          continue;
        }
        if (element.active && drawActiveElementsOnTop) {
          active.push(element);
        } else {
          element.draw(ctx, area);
        }
      }
      for (i = 0; i < active.length; ++i) {
        active[i].draw(ctx, area);
      }
    }
    getStyle(index3, active) {
      const mode = active ? "active" : "default";
      return index3 === void 0 && this._cachedMeta.dataset ? this.resolveDatasetElementOptions(mode) : this.resolveDataElementOptions(index3 || 0, mode);
    }
    getContext(index3, active, mode) {
      const dataset = this.getDataset();
      let context;
      if (index3 >= 0 && index3 < this._cachedMeta.data.length) {
        const element = this._cachedMeta.data[index3];
        context = element.$context || (element.$context = createDataContext(this.getContext(), index3, element));
        context.parsed = this.getParsed(index3);
        context.raw = dataset.data[index3];
        context.index = context.dataIndex = index3;
      } else {
        context = this.$context || (this.$context = createDatasetContext(this.chart.getContext(), this.index));
        context.dataset = dataset;
        context.index = context.datasetIndex = this.index;
      }
      context.active = !!active;
      context.mode = mode;
      return context;
    }
    resolveDatasetElementOptions(mode) {
      return this._resolveElementOptions(this.datasetElementType.id, mode);
    }
    resolveDataElementOptions(index3, mode) {
      return this._resolveElementOptions(this.dataElementType.id, mode, index3);
    }
    _resolveElementOptions(elementType, mode = "default", index3) {
      const active = mode === "active";
      const cache = this._cachedDataOpts;
      const cacheKey = elementType + "-" + mode;
      const cached = cache[cacheKey];
      const sharing = this.enableOptionSharing && defined(index3);
      if (cached) {
        return cloneIfNotShared(cached, sharing);
      }
      const config = this.chart.config;
      const scopeKeys = config.datasetElementScopeKeys(this._type, elementType);
      const prefixes2 = active ? [`${elementType}Hover`, "hover", elementType, ""] : [elementType, ""];
      const scopes = config.getOptionScopes(this.getDataset(), scopeKeys);
      const names2 = Object.keys(defaults.elements[elementType]);
      const context = () => this.getContext(index3, active);
      const values = config.resolveNamedOptions(scopes, names2, context, prefixes2);
      if (values.$shared) {
        values.$shared = sharing;
        cache[cacheKey] = Object.freeze(cloneIfNotShared(values, sharing));
      }
      return values;
    }
    _resolveAnimations(index3, transition2, active) {
      const chart = this.chart;
      const cache = this._cachedDataOpts;
      const cacheKey = `animation-${transition2}`;
      const cached = cache[cacheKey];
      if (cached) {
        return cached;
      }
      let options;
      if (chart.options.animation !== false) {
        const config = this.chart.config;
        const scopeKeys = config.datasetAnimationScopeKeys(this._type, transition2);
        const scopes = config.getOptionScopes(this.getDataset(), scopeKeys);
        options = config.createResolver(scopes, this.getContext(index3, active, transition2));
      }
      const animations = new Animations(chart, options && options.animations);
      if (options && options._cacheable) {
        cache[cacheKey] = Object.freeze(animations);
      }
      return animations;
    }
    getSharedOptions(options) {
      if (!options.$shared) {
        return;
      }
      return this._sharedOptions || (this._sharedOptions = Object.assign({}, options));
    }
    includeOptions(mode, sharedOptions) {
      return !sharedOptions || isDirectUpdateMode(mode) || this.chart._animationsDisabled;
    }
    _getSharedOptions(start2, mode) {
      const firstOpts = this.resolveDataElementOptions(start2, mode);
      const previouslySharedOptions = this._sharedOptions;
      const sharedOptions = this.getSharedOptions(firstOpts);
      const includeOptions = this.includeOptions(mode, sharedOptions) || sharedOptions !== previouslySharedOptions;
      this.updateSharedOptions(sharedOptions, mode, firstOpts);
      return { sharedOptions, includeOptions };
    }
    updateElement(element, index3, properties, mode) {
      if (isDirectUpdateMode(mode)) {
        Object.assign(element, properties);
      } else {
        this._resolveAnimations(index3, mode).update(element, properties);
      }
    }
    updateSharedOptions(sharedOptions, mode, newOptions) {
      if (sharedOptions && !isDirectUpdateMode(mode)) {
        this._resolveAnimations(void 0, mode).update(sharedOptions, newOptions);
      }
    }
    _setStyle(element, index3, mode, active) {
      element.active = active;
      const options = this.getStyle(index3, active);
      this._resolveAnimations(index3, mode, active).update(element, {
        options: !active && this.getSharedOptions(options) || options
      });
    }
    removeHoverStyle(element, datasetIndex, index3) {
      this._setStyle(element, index3, "active", false);
    }
    setHoverStyle(element, datasetIndex, index3) {
      this._setStyle(element, index3, "active", true);
    }
    _removeDatasetHoverStyle() {
      const element = this._cachedMeta.dataset;
      if (element) {
        this._setStyle(element, void 0, "active", false);
      }
    }
    _setDatasetHoverStyle() {
      const element = this._cachedMeta.dataset;
      if (element) {
        this._setStyle(element, void 0, "active", true);
      }
    }
    _resyncElements(resetNewElements) {
      const data = this._data;
      const elements2 = this._cachedMeta.data;
      for (const [method, arg1, arg2] of this._syncList) {
        this[method](arg1, arg2);
      }
      this._syncList = [];
      const numMeta = elements2.length;
      const numData = data.length;
      const count = Math.min(numData, numMeta);
      if (count) {
        this.parse(0, count);
      }
      if (numData > numMeta) {
        this._insertElements(numMeta, numData - numMeta, resetNewElements);
      } else if (numData < numMeta) {
        this._removeElements(numData, numMeta - numData);
      }
    }
    _insertElements(start2, count, resetNewElements = true) {
      const meta = this._cachedMeta;
      const data = meta.data;
      const end = start2 + count;
      let i;
      const move = (arr) => {
        arr.length += count;
        for (i = arr.length - 1; i >= end; i--) {
          arr[i] = arr[i - count];
        }
      };
      move(data);
      for (i = start2; i < end; ++i) {
        data[i] = new this.dataElementType();
      }
      if (this._parsing) {
        move(meta._parsed);
      }
      this.parse(start2, count);
      if (resetNewElements) {
        this.updateElements(data, start2, count, "reset");
      }
    }
    updateElements(element, start2, count, mode) {
    }
    _removeElements(start2, count) {
      const meta = this._cachedMeta;
      if (this._parsing) {
        const removed = meta._parsed.splice(start2, count);
        if (meta._stacked) {
          clearStacks(meta, removed);
        }
      }
      meta.data.splice(start2, count);
    }
    _sync(args) {
      if (this._parsing) {
        this._syncList.push(args);
      } else {
        const [method, arg1, arg2] = args;
        this[method](arg1, arg2);
      }
      this.chart._dataChanges.push([this.index, ...args]);
    }
    _onDataPush() {
      const count = arguments.length;
      this._sync(["_insertElements", this.getDataset().data.length - count, count]);
    }
    _onDataPop() {
      this._sync(["_removeElements", this._cachedMeta.data.length - 1, 1]);
    }
    _onDataShift() {
      this._sync(["_removeElements", 0, 1]);
    }
    _onDataSplice(start2, count) {
      if (count) {
        this._sync(["_removeElements", start2, count]);
      }
      const newCount = arguments.length - 2;
      if (newCount) {
        this._sync(["_insertElements", start2, newCount]);
      }
    }
    _onDataUnshift() {
      this._sync(["_insertElements", 0, arguments.length]);
    }
  };
  DatasetController.defaults = {};
  DatasetController.prototype.datasetElementType = null;
  DatasetController.prototype.dataElementType = null;
  function getAllScaleValues(scale, type2) {
    if (!scale._cache.$bar) {
      const visibleMetas = scale.getMatchingVisibleMetas(type2);
      let values = [];
      for (let i = 0, ilen = visibleMetas.length; i < ilen; i++) {
        values = values.concat(visibleMetas[i].controller.getAllParsedValues(scale));
      }
      scale._cache.$bar = _arrayUnique(values.sort((a, b) => a - b));
    }
    return scale._cache.$bar;
  }
  function computeMinSampleSize(meta) {
    const scale = meta.iScale;
    const values = getAllScaleValues(scale, meta.type);
    let min3 = scale._length;
    let i, ilen, curr, prev;
    const updateMinAndPrev = () => {
      if (curr === 32767 || curr === -32768) {
        return;
      }
      if (defined(prev)) {
        min3 = Math.min(min3, Math.abs(curr - prev) || min3);
      }
      prev = curr;
    };
    for (i = 0, ilen = values.length; i < ilen; ++i) {
      curr = scale.getPixelForValue(values[i]);
      updateMinAndPrev();
    }
    prev = void 0;
    for (i = 0, ilen = scale.ticks.length; i < ilen; ++i) {
      curr = scale.getPixelForTick(i);
      updateMinAndPrev();
    }
    return min3;
  }
  function computeFitCategoryTraits(index3, ruler, options, stackCount) {
    const thickness = options.barThickness;
    let size, ratio;
    if (isNullOrUndef(thickness)) {
      size = ruler.min * options.categoryPercentage;
      ratio = options.barPercentage;
    } else {
      size = thickness * stackCount;
      ratio = 1;
    }
    return {
      chunk: size / stackCount,
      ratio,
      start: ruler.pixels[index3] - size / 2
    };
  }
  function computeFlexCategoryTraits(index3, ruler, options, stackCount) {
    const pixels = ruler.pixels;
    const curr = pixels[index3];
    let prev = index3 > 0 ? pixels[index3 - 1] : null;
    let next = index3 < pixels.length - 1 ? pixels[index3 + 1] : null;
    const percent = options.categoryPercentage;
    if (prev === null) {
      prev = curr - (next === null ? ruler.end - ruler.start : next - curr);
    }
    if (next === null) {
      next = curr + curr - prev;
    }
    const start2 = curr - (curr - Math.min(prev, next)) / 2 * percent;
    const size = Math.abs(next - prev) / 2 * percent;
    return {
      chunk: size / stackCount,
      ratio: options.barPercentage,
      start: start2
    };
  }
  function parseFloatBar(entry, item, vScale, i) {
    const startValue = vScale.parse(entry[0], i);
    const endValue = vScale.parse(entry[1], i);
    const min3 = Math.min(startValue, endValue);
    const max3 = Math.max(startValue, endValue);
    let barStart = min3;
    let barEnd = max3;
    if (Math.abs(min3) > Math.abs(max3)) {
      barStart = max3;
      barEnd = min3;
    }
    item[vScale.axis] = barEnd;
    item._custom = {
      barStart,
      barEnd,
      start: startValue,
      end: endValue,
      min: min3,
      max: max3
    };
  }
  function parseValue(entry, item, vScale, i) {
    if (isArray(entry)) {
      parseFloatBar(entry, item, vScale, i);
    } else {
      item[vScale.axis] = vScale.parse(entry, i);
    }
    return item;
  }
  function parseArrayOrPrimitive(meta, data, start2, count) {
    const iScale = meta.iScale;
    const vScale = meta.vScale;
    const labels = iScale.getLabels();
    const singleScale = iScale === vScale;
    const parsed = [];
    let i, ilen, item, entry;
    for (i = start2, ilen = start2 + count; i < ilen; ++i) {
      entry = data[i];
      item = {};
      item[iScale.axis] = singleScale || iScale.parse(labels[i], i);
      parsed.push(parseValue(entry, item, vScale, i));
    }
    return parsed;
  }
  function isFloatBar(custom) {
    return custom && custom.barStart !== void 0 && custom.barEnd !== void 0;
  }
  function barSign(size, vScale, actualBase) {
    if (size !== 0) {
      return sign(size);
    }
    return (vScale.isHorizontal() ? 1 : -1) * (vScale.min >= actualBase ? 1 : -1);
  }
  function borderProps(properties) {
    let reverse, start2, end, top, bottom;
    if (properties.horizontal) {
      reverse = properties.base > properties.x;
      start2 = "left";
      end = "right";
    } else {
      reverse = properties.base < properties.y;
      start2 = "bottom";
      end = "top";
    }
    if (reverse) {
      top = "end";
      bottom = "start";
    } else {
      top = "start";
      bottom = "end";
    }
    return { start: start2, end, reverse, top, bottom };
  }
  function setBorderSkipped(properties, options, stack, index3) {
    let edge = options.borderSkipped;
    const res = {};
    if (!edge) {
      properties.borderSkipped = res;
      return;
    }
    if (edge === true) {
      properties.borderSkipped = { top: true, right: true, bottom: true, left: true };
      return;
    }
    const { start: start2, end, reverse, top, bottom } = borderProps(properties);
    if (edge === "middle" && stack) {
      properties.enableBorderRadius = true;
      if ((stack._top || 0) === index3) {
        edge = top;
      } else if ((stack._bottom || 0) === index3) {
        edge = bottom;
      } else {
        res[parseEdge(bottom, start2, end, reverse)] = true;
        edge = top;
      }
    }
    res[parseEdge(edge, start2, end, reverse)] = true;
    properties.borderSkipped = res;
  }
  function parseEdge(edge, a, b, reverse) {
    if (reverse) {
      edge = swap(edge, a, b);
      edge = startEnd(edge, b, a);
    } else {
      edge = startEnd(edge, a, b);
    }
    return edge;
  }
  function swap(orig, v1, v2) {
    return orig === v1 ? v2 : orig === v2 ? v1 : orig;
  }
  function startEnd(v, start2, end) {
    return v === "start" ? start2 : v === "end" ? end : v;
  }
  function setInflateAmount(properties, { inflateAmount }, ratio) {
    properties.inflateAmount = inflateAmount === "auto" ? ratio === 1 ? 0.33 : 0 : inflateAmount;
  }
  var BarController = class extends DatasetController {
    parsePrimitiveData(meta, data, start2, count) {
      return parseArrayOrPrimitive(meta, data, start2, count);
    }
    parseArrayData(meta, data, start2, count) {
      return parseArrayOrPrimitive(meta, data, start2, count);
    }
    parseObjectData(meta, data, start2, count) {
      const { iScale, vScale } = meta;
      const { xAxisKey = "x", yAxisKey = "y" } = this._parsing;
      const iAxisKey = iScale.axis === "x" ? xAxisKey : yAxisKey;
      const vAxisKey = vScale.axis === "x" ? xAxisKey : yAxisKey;
      const parsed = [];
      let i, ilen, item, obj;
      for (i = start2, ilen = start2 + count; i < ilen; ++i) {
        obj = data[i];
        item = {};
        item[iScale.axis] = iScale.parse(resolveObjectKey(obj, iAxisKey), i);
        parsed.push(parseValue(resolveObjectKey(obj, vAxisKey), item, vScale, i));
      }
      return parsed;
    }
    updateRangeFromParsed(range, scale, parsed, stack) {
      super.updateRangeFromParsed(range, scale, parsed, stack);
      const custom = parsed._custom;
      if (custom && scale === this._cachedMeta.vScale) {
        range.min = Math.min(range.min, custom.min);
        range.max = Math.max(range.max, custom.max);
      }
    }
    getMaxOverflow() {
      return 0;
    }
    getLabelAndValue(index3) {
      const meta = this._cachedMeta;
      const { iScale, vScale } = meta;
      const parsed = this.getParsed(index3);
      const custom = parsed._custom;
      const value = isFloatBar(custom) ? "[" + custom.start + ", " + custom.end + "]" : "" + vScale.getLabelForValue(parsed[vScale.axis]);
      return {
        label: "" + iScale.getLabelForValue(parsed[iScale.axis]),
        value
      };
    }
    initialize() {
      this.enableOptionSharing = true;
      super.initialize();
      const meta = this._cachedMeta;
      meta.stack = this.getDataset().stack;
    }
    update(mode) {
      const meta = this._cachedMeta;
      this.updateElements(meta.data, 0, meta.data.length, mode);
    }
    updateElements(bars, start2, count, mode) {
      const reset = mode === "reset";
      const { index: index3, _cachedMeta: { vScale } } = this;
      const base = vScale.getBasePixel();
      const horizontal = vScale.isHorizontal();
      const ruler = this._getRuler();
      const { sharedOptions, includeOptions } = this._getSharedOptions(start2, mode);
      for (let i = start2; i < start2 + count; i++) {
        const parsed = this.getParsed(i);
        const vpixels = reset || isNullOrUndef(parsed[vScale.axis]) ? { base, head: base } : this._calculateBarValuePixels(i);
        const ipixels = this._calculateBarIndexPixels(i, ruler);
        const stack = (parsed._stacks || {})[vScale.axis];
        const properties = {
          horizontal,
          base: vpixels.base,
          enableBorderRadius: !stack || isFloatBar(parsed._custom) || (index3 === stack._top || index3 === stack._bottom),
          x: horizontal ? vpixels.head : ipixels.center,
          y: horizontal ? ipixels.center : vpixels.head,
          height: horizontal ? ipixels.size : Math.abs(vpixels.size),
          width: horizontal ? Math.abs(vpixels.size) : ipixels.size
        };
        if (includeOptions) {
          properties.options = sharedOptions || this.resolveDataElementOptions(i, bars[i].active ? "active" : mode);
        }
        const options = properties.options || bars[i].options;
        setBorderSkipped(properties, options, stack, index3);
        setInflateAmount(properties, options, ruler.ratio);
        this.updateElement(bars[i], i, properties, mode);
      }
    }
    _getStacks(last, dataIndex) {
      const { iScale } = this._cachedMeta;
      const metasets = iScale.getMatchingVisibleMetas(this._type).filter((meta) => meta.controller.options.grouped);
      const stacked = iScale.options.stacked;
      const stacks = [];
      const skipNull = (meta) => {
        const parsed = meta.controller.getParsed(dataIndex);
        const val = parsed && parsed[meta.vScale.axis];
        if (isNullOrUndef(val) || isNaN(val)) {
          return true;
        }
      };
      for (const meta of metasets) {
        if (dataIndex !== void 0 && skipNull(meta)) {
          continue;
        }
        if (stacked === false || stacks.indexOf(meta.stack) === -1 || stacked === void 0 && meta.stack === void 0) {
          stacks.push(meta.stack);
        }
        if (meta.index === last) {
          break;
        }
      }
      if (!stacks.length) {
        stacks.push(void 0);
      }
      return stacks;
    }
    _getStackCount(index3) {
      return this._getStacks(void 0, index3).length;
    }
    _getStackIndex(datasetIndex, name, dataIndex) {
      const stacks = this._getStacks(datasetIndex, dataIndex);
      const index3 = name !== void 0 ? stacks.indexOf(name) : -1;
      return index3 === -1 ? stacks.length - 1 : index3;
    }
    _getRuler() {
      const opts = this.options;
      const meta = this._cachedMeta;
      const iScale = meta.iScale;
      const pixels = [];
      let i, ilen;
      for (i = 0, ilen = meta.data.length; i < ilen; ++i) {
        pixels.push(iScale.getPixelForValue(this.getParsed(i)[iScale.axis], i));
      }
      const barThickness = opts.barThickness;
      const min3 = barThickness || computeMinSampleSize(meta);
      return {
        min: min3,
        pixels,
        start: iScale._startPixel,
        end: iScale._endPixel,
        stackCount: this._getStackCount(),
        scale: iScale,
        grouped: opts.grouped,
        ratio: barThickness ? 1 : opts.categoryPercentage * opts.barPercentage
      };
    }
    _calculateBarValuePixels(index3) {
      const { _cachedMeta: { vScale, _stacked }, options: { base: baseValue, minBarLength } } = this;
      const actualBase = baseValue || 0;
      const parsed = this.getParsed(index3);
      const custom = parsed._custom;
      const floating = isFloatBar(custom);
      let value = parsed[vScale.axis];
      let start2 = 0;
      let length = _stacked ? this.applyStack(vScale, parsed, _stacked) : value;
      let head, size;
      if (length !== value) {
        start2 = length - value;
        length = value;
      }
      if (floating) {
        value = custom.barStart;
        length = custom.barEnd - custom.barStart;
        if (value !== 0 && sign(value) !== sign(custom.barEnd)) {
          start2 = 0;
        }
        start2 += value;
      }
      const startValue = !isNullOrUndef(baseValue) && !floating ? baseValue : start2;
      let base = vScale.getPixelForValue(startValue);
      if (this.chart.getDataVisibility(index3)) {
        head = vScale.getPixelForValue(start2 + length);
      } else {
        head = base;
      }
      size = head - base;
      if (Math.abs(size) < minBarLength) {
        size = barSign(size, vScale, actualBase) * minBarLength;
        if (value === actualBase) {
          base -= size / 2;
        }
        const startPixel = vScale.getPixelForDecimal(0);
        const endPixel = vScale.getPixelForDecimal(1);
        const min3 = Math.min(startPixel, endPixel);
        const max3 = Math.max(startPixel, endPixel);
        base = Math.max(Math.min(base, max3), min3);
        head = base + size;
      }
      if (base === vScale.getPixelForValue(actualBase)) {
        const halfGrid = sign(size) * vScale.getLineWidthForValue(actualBase) / 2;
        base += halfGrid;
        size -= halfGrid;
      }
      return {
        size,
        base,
        head,
        center: head + size / 2
      };
    }
    _calculateBarIndexPixels(index3, ruler) {
      const scale = ruler.scale;
      const options = this.options;
      const skipNull = options.skipNull;
      const maxBarThickness = valueOrDefault(options.maxBarThickness, Infinity);
      let center, size;
      if (ruler.grouped) {
        const stackCount = skipNull ? this._getStackCount(index3) : ruler.stackCount;
        const range = options.barThickness === "flex" ? computeFlexCategoryTraits(index3, ruler, options, stackCount) : computeFitCategoryTraits(index3, ruler, options, stackCount);
        const stackIndex = this._getStackIndex(this.index, this._cachedMeta.stack, skipNull ? index3 : void 0);
        center = range.start + range.chunk * stackIndex + range.chunk / 2;
        size = Math.min(maxBarThickness, range.chunk * range.ratio);
      } else {
        center = scale.getPixelForValue(this.getParsed(index3)[scale.axis], index3);
        size = Math.min(maxBarThickness, ruler.min * ruler.ratio);
      }
      return {
        base: center - size / 2,
        head: center + size / 2,
        center,
        size
      };
    }
    draw() {
      const meta = this._cachedMeta;
      const vScale = meta.vScale;
      const rects = meta.data;
      const ilen = rects.length;
      let i = 0;
      for (; i < ilen; ++i) {
        if (this.getParsed(i)[vScale.axis] !== null) {
          rects[i].draw(this._ctx);
        }
      }
    }
  };
  BarController.id = "bar";
  BarController.defaults = {
    datasetElementType: false,
    dataElementType: "bar",
    categoryPercentage: 0.8,
    barPercentage: 0.9,
    grouped: true,
    animations: {
      numbers: {
        type: "number",
        properties: ["x", "y", "base", "width", "height"]
      }
    }
  };
  BarController.overrides = {
    scales: {
      _index_: {
        type: "category",
        offset: true,
        grid: {
          offset: true
        }
      },
      _value_: {
        type: "linear",
        beginAtZero: true
      }
    }
  };
  var BubbleController = class extends DatasetController {
    initialize() {
      this.enableOptionSharing = true;
      super.initialize();
    }
    parsePrimitiveData(meta, data, start2, count) {
      const parsed = super.parsePrimitiveData(meta, data, start2, count);
      for (let i = 0; i < parsed.length; i++) {
        parsed[i]._custom = this.resolveDataElementOptions(i + start2).radius;
      }
      return parsed;
    }
    parseArrayData(meta, data, start2, count) {
      const parsed = super.parseArrayData(meta, data, start2, count);
      for (let i = 0; i < parsed.length; i++) {
        const item = data[start2 + i];
        parsed[i]._custom = valueOrDefault(item[2], this.resolveDataElementOptions(i + start2).radius);
      }
      return parsed;
    }
    parseObjectData(meta, data, start2, count) {
      const parsed = super.parseObjectData(meta, data, start2, count);
      for (let i = 0; i < parsed.length; i++) {
        const item = data[start2 + i];
        parsed[i]._custom = valueOrDefault(item && item.r && +item.r, this.resolveDataElementOptions(i + start2).radius);
      }
      return parsed;
    }
    getMaxOverflow() {
      const data = this._cachedMeta.data;
      let max3 = 0;
      for (let i = data.length - 1; i >= 0; --i) {
        max3 = Math.max(max3, data[i].size(this.resolveDataElementOptions(i)) / 2);
      }
      return max3 > 0 && max3;
    }
    getLabelAndValue(index3) {
      const meta = this._cachedMeta;
      const { xScale, yScale } = meta;
      const parsed = this.getParsed(index3);
      const x = xScale.getLabelForValue(parsed.x);
      const y = yScale.getLabelForValue(parsed.y);
      const r = parsed._custom;
      return {
        label: meta.label,
        value: "(" + x + ", " + y + (r ? ", " + r : "") + ")"
      };
    }
    update(mode) {
      const points = this._cachedMeta.data;
      this.updateElements(points, 0, points.length, mode);
    }
    updateElements(points, start2, count, mode) {
      const reset = mode === "reset";
      const { iScale, vScale } = this._cachedMeta;
      const { sharedOptions, includeOptions } = this._getSharedOptions(start2, mode);
      const iAxis = iScale.axis;
      const vAxis = vScale.axis;
      for (let i = start2; i < start2 + count; i++) {
        const point = points[i];
        const parsed = !reset && this.getParsed(i);
        const properties = {};
        const iPixel = properties[iAxis] = reset ? iScale.getPixelForDecimal(0.5) : iScale.getPixelForValue(parsed[iAxis]);
        const vPixel = properties[vAxis] = reset ? vScale.getBasePixel() : vScale.getPixelForValue(parsed[vAxis]);
        properties.skip = isNaN(iPixel) || isNaN(vPixel);
        if (includeOptions) {
          properties.options = sharedOptions || this.resolveDataElementOptions(i, point.active ? "active" : mode);
          if (reset) {
            properties.options.radius = 0;
          }
        }
        this.updateElement(point, i, properties, mode);
      }
    }
    resolveDataElementOptions(index3, mode) {
      const parsed = this.getParsed(index3);
      let values = super.resolveDataElementOptions(index3, mode);
      if (values.$shared) {
        values = Object.assign({}, values, { $shared: false });
      }
      const radius3 = values.radius;
      if (mode !== "active") {
        values.radius = 0;
      }
      values.radius += valueOrDefault(parsed && parsed._custom, radius3);
      return values;
    }
  };
  BubbleController.id = "bubble";
  BubbleController.defaults = {
    datasetElementType: false,
    dataElementType: "point",
    animations: {
      numbers: {
        type: "number",
        properties: ["x", "y", "borderWidth", "radius"]
      }
    }
  };
  BubbleController.overrides = {
    scales: {
      x: {
        type: "linear"
      },
      y: {
        type: "linear"
      }
    },
    plugins: {
      tooltip: {
        callbacks: {
          title() {
            return "";
          }
        }
      }
    }
  };
  function getRatioAndOffset(rotation, circumference, cutout) {
    let ratioX = 1;
    let ratioY = 1;
    let offsetX = 0;
    let offsetY = 0;
    if (circumference < TAU) {
      const startAngle = rotation;
      const endAngle = startAngle + circumference;
      const startX = Math.cos(startAngle);
      const startY = Math.sin(startAngle);
      const endX = Math.cos(endAngle);
      const endY = Math.sin(endAngle);
      const calcMax = (angle, a, b) => _angleBetween(angle, startAngle, endAngle, true) ? 1 : Math.max(a, a * cutout, b, b * cutout);
      const calcMin = (angle, a, b) => _angleBetween(angle, startAngle, endAngle, true) ? -1 : Math.min(a, a * cutout, b, b * cutout);
      const maxX = calcMax(0, startX, endX);
      const maxY = calcMax(HALF_PI, startY, endY);
      const minX = calcMin(PI, startX, endX);
      const minY = calcMin(PI + HALF_PI, startY, endY);
      ratioX = (maxX - minX) / 2;
      ratioY = (maxY - minY) / 2;
      offsetX = -(maxX + minX) / 2;
      offsetY = -(maxY + minY) / 2;
    }
    return { ratioX, ratioY, offsetX, offsetY };
  }
  var DoughnutController = class extends DatasetController {
    constructor(chart, datasetIndex) {
      super(chart, datasetIndex);
      this.enableOptionSharing = true;
      this.innerRadius = void 0;
      this.outerRadius = void 0;
      this.offsetX = void 0;
      this.offsetY = void 0;
    }
    linkScales() {
    }
    parse(start2, count) {
      const data = this.getDataset().data;
      const meta = this._cachedMeta;
      if (this._parsing === false) {
        meta._parsed = data;
      } else {
        let getter = (i2) => +data[i2];
        if (isObject(data[start2])) {
          const { key = "value" } = this._parsing;
          getter = (i2) => +resolveObjectKey(data[i2], key);
        }
        let i, ilen;
        for (i = start2, ilen = start2 + count; i < ilen; ++i) {
          meta._parsed[i] = getter(i);
        }
      }
    }
    _getRotation() {
      return toRadians(this.options.rotation - 90);
    }
    _getCircumference() {
      return toRadians(this.options.circumference);
    }
    _getRotationExtents() {
      let min3 = TAU;
      let max3 = -TAU;
      for (let i = 0; i < this.chart.data.datasets.length; ++i) {
        if (this.chart.isDatasetVisible(i)) {
          const controller = this.chart.getDatasetMeta(i).controller;
          const rotation = controller._getRotation();
          const circumference = controller._getCircumference();
          min3 = Math.min(min3, rotation);
          max3 = Math.max(max3, rotation + circumference);
        }
      }
      return {
        rotation: min3,
        circumference: max3 - min3
      };
    }
    update(mode) {
      const chart = this.chart;
      const { chartArea } = chart;
      const meta = this._cachedMeta;
      const arcs = meta.data;
      const spacing = this.getMaxBorderWidth() + this.getMaxOffset(arcs) + this.options.spacing;
      const maxSize = Math.max((Math.min(chartArea.width, chartArea.height) - spacing) / 2, 0);
      const cutout = Math.min(toPercentage(this.options.cutout, maxSize), 1);
      const chartWeight = this._getRingWeight(this.index);
      const { circumference, rotation } = this._getRotationExtents();
      const { ratioX, ratioY, offsetX, offsetY } = getRatioAndOffset(rotation, circumference, cutout);
      const maxWidth = (chartArea.width - spacing) / ratioX;
      const maxHeight = (chartArea.height - spacing) / ratioY;
      const maxRadius = Math.max(Math.min(maxWidth, maxHeight) / 2, 0);
      const outerRadius = toDimension(this.options.radius, maxRadius);
      const innerRadius = Math.max(outerRadius * cutout, 0);
      const radiusLength = (outerRadius - innerRadius) / this._getVisibleDatasetWeightTotal();
      this.offsetX = offsetX * outerRadius;
      this.offsetY = offsetY * outerRadius;
      meta.total = this.calculateTotal();
      this.outerRadius = outerRadius - radiusLength * this._getRingWeightOffset(this.index);
      this.innerRadius = Math.max(this.outerRadius - radiusLength * chartWeight, 0);
      this.updateElements(arcs, 0, arcs.length, mode);
    }
    _circumference(i, reset) {
      const opts = this.options;
      const meta = this._cachedMeta;
      const circumference = this._getCircumference();
      if (reset && opts.animation.animateRotate || !this.chart.getDataVisibility(i) || meta._parsed[i] === null || meta.data[i].hidden) {
        return 0;
      }
      return this.calculateCircumference(meta._parsed[i] * circumference / TAU);
    }
    updateElements(arcs, start2, count, mode) {
      const reset = mode === "reset";
      const chart = this.chart;
      const chartArea = chart.chartArea;
      const opts = chart.options;
      const animationOpts = opts.animation;
      const centerX = (chartArea.left + chartArea.right) / 2;
      const centerY = (chartArea.top + chartArea.bottom) / 2;
      const animateScale = reset && animationOpts.animateScale;
      const innerRadius = animateScale ? 0 : this.innerRadius;
      const outerRadius = animateScale ? 0 : this.outerRadius;
      const { sharedOptions, includeOptions } = this._getSharedOptions(start2, mode);
      let startAngle = this._getRotation();
      let i;
      for (i = 0; i < start2; ++i) {
        startAngle += this._circumference(i, reset);
      }
      for (i = start2; i < start2 + count; ++i) {
        const circumference = this._circumference(i, reset);
        const arc = arcs[i];
        const properties = {
          x: centerX + this.offsetX,
          y: centerY + this.offsetY,
          startAngle,
          endAngle: startAngle + circumference,
          circumference,
          outerRadius,
          innerRadius
        };
        if (includeOptions) {
          properties.options = sharedOptions || this.resolveDataElementOptions(i, arc.active ? "active" : mode);
        }
        startAngle += circumference;
        this.updateElement(arc, i, properties, mode);
      }
    }
    calculateTotal() {
      const meta = this._cachedMeta;
      const metaData = meta.data;
      let total = 0;
      let i;
      for (i = 0; i < metaData.length; i++) {
        const value = meta._parsed[i];
        if (value !== null && !isNaN(value) && this.chart.getDataVisibility(i) && !metaData[i].hidden) {
          total += Math.abs(value);
        }
      }
      return total;
    }
    calculateCircumference(value) {
      const total = this._cachedMeta.total;
      if (total > 0 && !isNaN(value)) {
        return TAU * (Math.abs(value) / total);
      }
      return 0;
    }
    getLabelAndValue(index3) {
      const meta = this._cachedMeta;
      const chart = this.chart;
      const labels = chart.data.labels || [];
      const value = formatNumber(meta._parsed[index3], chart.options.locale);
      return {
        label: labels[index3] || "",
        value
      };
    }
    getMaxBorderWidth(arcs) {
      let max3 = 0;
      const chart = this.chart;
      let i, ilen, meta, controller, options;
      if (!arcs) {
        for (i = 0, ilen = chart.data.datasets.length; i < ilen; ++i) {
          if (chart.isDatasetVisible(i)) {
            meta = chart.getDatasetMeta(i);
            arcs = meta.data;
            controller = meta.controller;
            break;
          }
        }
      }
      if (!arcs) {
        return 0;
      }
      for (i = 0, ilen = arcs.length; i < ilen; ++i) {
        options = controller.resolveDataElementOptions(i);
        if (options.borderAlign !== "inner") {
          max3 = Math.max(max3, options.borderWidth || 0, options.hoverBorderWidth || 0);
        }
      }
      return max3;
    }
    getMaxOffset(arcs) {
      let max3 = 0;
      for (let i = 0, ilen = arcs.length; i < ilen; ++i) {
        const options = this.resolveDataElementOptions(i);
        max3 = Math.max(max3, options.offset || 0, options.hoverOffset || 0);
      }
      return max3;
    }
    _getRingWeightOffset(datasetIndex) {
      let ringWeightOffset = 0;
      for (let i = 0; i < datasetIndex; ++i) {
        if (this.chart.isDatasetVisible(i)) {
          ringWeightOffset += this._getRingWeight(i);
        }
      }
      return ringWeightOffset;
    }
    _getRingWeight(datasetIndex) {
      return Math.max(valueOrDefault(this.chart.data.datasets[datasetIndex].weight, 1), 0);
    }
    _getVisibleDatasetWeightTotal() {
      return this._getRingWeightOffset(this.chart.data.datasets.length) || 1;
    }
  };
  DoughnutController.id = "doughnut";
  DoughnutController.defaults = {
    datasetElementType: false,
    dataElementType: "arc",
    animation: {
      animateRotate: true,
      animateScale: false
    },
    animations: {
      numbers: {
        type: "number",
        properties: ["circumference", "endAngle", "innerRadius", "outerRadius", "startAngle", "x", "y", "offset", "borderWidth", "spacing"]
      }
    },
    cutout: "50%",
    rotation: 0,
    circumference: 360,
    radius: "100%",
    spacing: 0,
    indexAxis: "r"
  };
  DoughnutController.descriptors = {
    _scriptable: (name) => name !== "spacing",
    _indexable: (name) => name !== "spacing"
  };
  DoughnutController.overrides = {
    aspectRatio: 1,
    plugins: {
      legend: {
        labels: {
          generateLabels(chart) {
            const data = chart.data;
            if (data.labels.length && data.datasets.length) {
              const { labels: { pointStyle } } = chart.legend.options;
              return data.labels.map((label, i) => {
                const meta = chart.getDatasetMeta(0);
                const style = meta.controller.getStyle(i);
                return {
                  text: label,
                  fillStyle: style.backgroundColor,
                  strokeStyle: style.borderColor,
                  lineWidth: style.borderWidth,
                  pointStyle,
                  hidden: !chart.getDataVisibility(i),
                  index: i
                };
              });
            }
            return [];
          }
        },
        onClick(e, legendItem, legend5) {
          legend5.chart.toggleDataVisibility(legendItem.index);
          legend5.chart.update();
        }
      },
      tooltip: {
        callbacks: {
          title() {
            return "";
          },
          label(tooltipItem) {
            let dataLabel = tooltipItem.label;
            const value = ": " + tooltipItem.formattedValue;
            if (isArray(dataLabel)) {
              dataLabel = dataLabel.slice();
              dataLabel[0] += value;
            } else {
              dataLabel += value;
            }
            return dataLabel;
          }
        }
      }
    }
  };
  var LineController = class extends DatasetController {
    initialize() {
      this.enableOptionSharing = true;
      this.supportsDecimation = true;
      super.initialize();
    }
    update(mode) {
      const meta = this._cachedMeta;
      const { dataset: line, data: points = [], _dataset } = meta;
      const animationsDisabled = this.chart._animationsDisabled;
      let { start: start2, count } = _getStartAndCountOfVisiblePoints(meta, points, animationsDisabled);
      this._drawStart = start2;
      this._drawCount = count;
      if (_scaleRangesChanged(meta)) {
        start2 = 0;
        count = points.length;
      }
      line._chart = this.chart;
      line._datasetIndex = this.index;
      line._decimated = !!_dataset._decimated;
      line.points = points;
      const options = this.resolveDatasetElementOptions(mode);
      if (!this.options.showLine) {
        options.borderWidth = 0;
      }
      options.segment = this.options.segment;
      this.updateElement(line, void 0, {
        animated: !animationsDisabled,
        options
      }, mode);
      this.updateElements(points, start2, count, mode);
    }
    updateElements(points, start2, count, mode) {
      const reset = mode === "reset";
      const { iScale, vScale, _stacked, _dataset } = this._cachedMeta;
      const { sharedOptions, includeOptions } = this._getSharedOptions(start2, mode);
      const iAxis = iScale.axis;
      const vAxis = vScale.axis;
      const { spanGaps, segment } = this.options;
      const maxGapLength = isNumber(spanGaps) ? spanGaps : Number.POSITIVE_INFINITY;
      const directUpdate = this.chart._animationsDisabled || reset || mode === "none";
      let prevParsed = start2 > 0 && this.getParsed(start2 - 1);
      for (let i = start2; i < start2 + count; ++i) {
        const point = points[i];
        const parsed = this.getParsed(i);
        const properties = directUpdate ? point : {};
        const nullData = isNullOrUndef(parsed[vAxis]);
        const iPixel = properties[iAxis] = iScale.getPixelForValue(parsed[iAxis], i);
        const vPixel = properties[vAxis] = reset || nullData ? vScale.getBasePixel() : vScale.getPixelForValue(_stacked ? this.applyStack(vScale, parsed, _stacked) : parsed[vAxis], i);
        properties.skip = isNaN(iPixel) || isNaN(vPixel) || nullData;
        properties.stop = i > 0 && Math.abs(parsed[iAxis] - prevParsed[iAxis]) > maxGapLength;
        if (segment) {
          properties.parsed = parsed;
          properties.raw = _dataset.data[i];
        }
        if (includeOptions) {
          properties.options = sharedOptions || this.resolveDataElementOptions(i, point.active ? "active" : mode);
        }
        if (!directUpdate) {
          this.updateElement(point, i, properties, mode);
        }
        prevParsed = parsed;
      }
    }
    getMaxOverflow() {
      const meta = this._cachedMeta;
      const dataset = meta.dataset;
      const border = dataset.options && dataset.options.borderWidth || 0;
      const data = meta.data || [];
      if (!data.length) {
        return border;
      }
      const firstPoint = data[0].size(this.resolveDataElementOptions(0));
      const lastPoint = data[data.length - 1].size(this.resolveDataElementOptions(data.length - 1));
      return Math.max(border, firstPoint, lastPoint) / 2;
    }
    draw() {
      const meta = this._cachedMeta;
      meta.dataset.updateControlPoints(this.chart.chartArea, meta.iScale.axis);
      super.draw();
    }
  };
  LineController.id = "line";
  LineController.defaults = {
    datasetElementType: "line",
    dataElementType: "point",
    showLine: true,
    spanGaps: false
  };
  LineController.overrides = {
    scales: {
      _index_: {
        type: "category"
      },
      _value_: {
        type: "linear"
      }
    }
  };
  var PolarAreaController = class extends DatasetController {
    constructor(chart, datasetIndex) {
      super(chart, datasetIndex);
      this.innerRadius = void 0;
      this.outerRadius = void 0;
    }
    getLabelAndValue(index3) {
      const meta = this._cachedMeta;
      const chart = this.chart;
      const labels = chart.data.labels || [];
      const value = formatNumber(meta._parsed[index3].r, chart.options.locale);
      return {
        label: labels[index3] || "",
        value
      };
    }
    parseObjectData(meta, data, start2, count) {
      return _parseObjectDataRadialScale.bind(this)(meta, data, start2, count);
    }
    update(mode) {
      const arcs = this._cachedMeta.data;
      this._updateRadius();
      this.updateElements(arcs, 0, arcs.length, mode);
    }
    getMinMax() {
      const meta = this._cachedMeta;
      const range = { min: Number.POSITIVE_INFINITY, max: Number.NEGATIVE_INFINITY };
      meta.data.forEach((element, index3) => {
        const parsed = this.getParsed(index3).r;
        if (!isNaN(parsed) && this.chart.getDataVisibility(index3)) {
          if (parsed < range.min) {
            range.min = parsed;
          }
          if (parsed > range.max) {
            range.max = parsed;
          }
        }
      });
      return range;
    }
    _updateRadius() {
      const chart = this.chart;
      const chartArea = chart.chartArea;
      const opts = chart.options;
      const minSize = Math.min(chartArea.right - chartArea.left, chartArea.bottom - chartArea.top);
      const outerRadius = Math.max(minSize / 2, 0);
      const innerRadius = Math.max(opts.cutoutPercentage ? outerRadius / 100 * opts.cutoutPercentage : 1, 0);
      const radiusLength = (outerRadius - innerRadius) / chart.getVisibleDatasetCount();
      this.outerRadius = outerRadius - radiusLength * this.index;
      this.innerRadius = this.outerRadius - radiusLength;
    }
    updateElements(arcs, start2, count, mode) {
      const reset = mode === "reset";
      const chart = this.chart;
      const opts = chart.options;
      const animationOpts = opts.animation;
      const scale = this._cachedMeta.rScale;
      const centerX = scale.xCenter;
      const centerY = scale.yCenter;
      const datasetStartAngle = scale.getIndexAngle(0) - 0.5 * PI;
      let angle = datasetStartAngle;
      let i;
      const defaultAngle = 360 / this.countVisibleElements();
      for (i = 0; i < start2; ++i) {
        angle += this._computeAngle(i, mode, defaultAngle);
      }
      for (i = start2; i < start2 + count; i++) {
        const arc = arcs[i];
        let startAngle = angle;
        let endAngle = angle + this._computeAngle(i, mode, defaultAngle);
        let outerRadius = chart.getDataVisibility(i) ? scale.getDistanceFromCenterForValue(this.getParsed(i).r) : 0;
        angle = endAngle;
        if (reset) {
          if (animationOpts.animateScale) {
            outerRadius = 0;
          }
          if (animationOpts.animateRotate) {
            startAngle = endAngle = datasetStartAngle;
          }
        }
        const properties = {
          x: centerX,
          y: centerY,
          innerRadius: 0,
          outerRadius,
          startAngle,
          endAngle,
          options: this.resolveDataElementOptions(i, arc.active ? "active" : mode)
        };
        this.updateElement(arc, i, properties, mode);
      }
    }
    countVisibleElements() {
      const meta = this._cachedMeta;
      let count = 0;
      meta.data.forEach((element, index3) => {
        if (!isNaN(this.getParsed(index3).r) && this.chart.getDataVisibility(index3)) {
          count++;
        }
      });
      return count;
    }
    _computeAngle(index3, mode, defaultAngle) {
      return this.chart.getDataVisibility(index3) ? toRadians(this.resolveDataElementOptions(index3, mode).angle || defaultAngle) : 0;
    }
  };
  PolarAreaController.id = "polarArea";
  PolarAreaController.defaults = {
    dataElementType: "arc",
    animation: {
      animateRotate: true,
      animateScale: true
    },
    animations: {
      numbers: {
        type: "number",
        properties: ["x", "y", "startAngle", "endAngle", "innerRadius", "outerRadius"]
      }
    },
    indexAxis: "r",
    startAngle: 0
  };
  PolarAreaController.overrides = {
    aspectRatio: 1,
    plugins: {
      legend: {
        labels: {
          generateLabels(chart) {
            const data = chart.data;
            if (data.labels.length && data.datasets.length) {
              const { labels: { pointStyle } } = chart.legend.options;
              return data.labels.map((label, i) => {
                const meta = chart.getDatasetMeta(0);
                const style = meta.controller.getStyle(i);
                return {
                  text: label,
                  fillStyle: style.backgroundColor,
                  strokeStyle: style.borderColor,
                  lineWidth: style.borderWidth,
                  pointStyle,
                  hidden: !chart.getDataVisibility(i),
                  index: i
                };
              });
            }
            return [];
          }
        },
        onClick(e, legendItem, legend5) {
          legend5.chart.toggleDataVisibility(legendItem.index);
          legend5.chart.update();
        }
      },
      tooltip: {
        callbacks: {
          title() {
            return "";
          },
          label(context) {
            return context.chart.data.labels[context.dataIndex] + ": " + context.formattedValue;
          }
        }
      }
    },
    scales: {
      r: {
        type: "radialLinear",
        angleLines: {
          display: false
        },
        beginAtZero: true,
        grid: {
          circular: true
        },
        pointLabels: {
          display: false
        },
        startAngle: 0
      }
    }
  };
  var PieController = class extends DoughnutController {
  };
  PieController.id = "pie";
  PieController.defaults = {
    cutout: 0,
    rotation: 0,
    circumference: 360,
    radius: "100%"
  };
  var RadarController = class extends DatasetController {
    getLabelAndValue(index3) {
      const vScale = this._cachedMeta.vScale;
      const parsed = this.getParsed(index3);
      return {
        label: vScale.getLabels()[index3],
        value: "" + vScale.getLabelForValue(parsed[vScale.axis])
      };
    }
    parseObjectData(meta, data, start2, count) {
      return _parseObjectDataRadialScale.bind(this)(meta, data, start2, count);
    }
    update(mode) {
      const meta = this._cachedMeta;
      const line = meta.dataset;
      const points = meta.data || [];
      const labels = meta.iScale.getLabels();
      line.points = points;
      if (mode !== "resize") {
        const options = this.resolveDatasetElementOptions(mode);
        if (!this.options.showLine) {
          options.borderWidth = 0;
        }
        const properties = {
          _loop: true,
          _fullLoop: labels.length === points.length,
          options
        };
        this.updateElement(line, void 0, properties, mode);
      }
      this.updateElements(points, 0, points.length, mode);
    }
    updateElements(points, start2, count, mode) {
      const scale = this._cachedMeta.rScale;
      const reset = mode === "reset";
      for (let i = start2; i < start2 + count; i++) {
        const point = points[i];
        const options = this.resolveDataElementOptions(i, point.active ? "active" : mode);
        const pointPosition = scale.getPointPositionForValue(i, this.getParsed(i).r);
        const x = reset ? scale.xCenter : pointPosition.x;
        const y = reset ? scale.yCenter : pointPosition.y;
        const properties = {
          x,
          y,
          angle: pointPosition.angle,
          skip: isNaN(x) || isNaN(y),
          options
        };
        this.updateElement(point, i, properties, mode);
      }
    }
  };
  RadarController.id = "radar";
  RadarController.defaults = {
    datasetElementType: "line",
    dataElementType: "point",
    indexAxis: "r",
    showLine: true,
    elements: {
      line: {
        fill: "start"
      }
    }
  };
  RadarController.overrides = {
    aspectRatio: 1,
    scales: {
      r: {
        type: "radialLinear"
      }
    }
  };
  var Element = class {
    constructor() {
      this.x = void 0;
      this.y = void 0;
      this.active = false;
      this.options = void 0;
      this.$animations = void 0;
    }
    tooltipPosition(useFinalPosition) {
      const { x, y } = this.getProps(["x", "y"], useFinalPosition);
      return { x, y };
    }
    hasValue() {
      return isNumber(this.x) && isNumber(this.y);
    }
    getProps(props, final) {
      const anims = this.$animations;
      if (!final || !anims) {
        return this;
      }
      const ret = {};
      props.forEach((prop) => {
        ret[prop] = anims[prop] && anims[prop].active() ? anims[prop]._to : this[prop];
      });
      return ret;
    }
  };
  Element.defaults = {};
  Element.defaultRoutes = void 0;
  var formatters = {
    values(value) {
      return isArray(value) ? value : "" + value;
    },
    numeric(tickValue, index3, ticks) {
      if (tickValue === 0) {
        return "0";
      }
      const locale3 = this.chart.options.locale;
      let notation;
      let delta = tickValue;
      if (ticks.length > 1) {
        const maxTick = Math.max(Math.abs(ticks[0].value), Math.abs(ticks[ticks.length - 1].value));
        if (maxTick < 1e-4 || maxTick > 1e15) {
          notation = "scientific";
        }
        delta = calculateDelta(tickValue, ticks);
      }
      const logDelta = log10(Math.abs(delta));
      const numDecimal = Math.max(Math.min(-1 * Math.floor(logDelta), 20), 0);
      const options = { notation, minimumFractionDigits: numDecimal, maximumFractionDigits: numDecimal };
      Object.assign(options, this.options.ticks.format);
      return formatNumber(tickValue, locale3, options);
    },
    logarithmic(tickValue, index3, ticks) {
      if (tickValue === 0) {
        return "0";
      }
      const remain = tickValue / Math.pow(10, Math.floor(log10(tickValue)));
      if (remain === 1 || remain === 2 || remain === 5) {
        return formatters.numeric.call(this, tickValue, index3, ticks);
      }
      return "";
    }
  };
  function calculateDelta(tickValue, ticks) {
    let delta = ticks.length > 3 ? ticks[2].value - ticks[1].value : ticks[1].value - ticks[0].value;
    if (Math.abs(delta) >= 1 && tickValue !== Math.floor(tickValue)) {
      delta = tickValue - Math.floor(tickValue);
    }
    return delta;
  }
  var Ticks = { formatters };
  defaults.set("scale", {
    display: true,
    offset: false,
    reverse: false,
    beginAtZero: false,
    bounds: "ticks",
    grace: 0,
    grid: {
      display: true,
      lineWidth: 1,
      drawBorder: true,
      drawOnChartArea: true,
      drawTicks: true,
      tickLength: 8,
      tickWidth: (_ctx, options) => options.lineWidth,
      tickColor: (_ctx, options) => options.color,
      offset: false,
      borderDash: [],
      borderDashOffset: 0,
      borderWidth: 1
    },
    title: {
      display: false,
      text: "",
      padding: {
        top: 4,
        bottom: 4
      }
    },
    ticks: {
      minRotation: 0,
      maxRotation: 50,
      mirror: false,
      textStrokeWidth: 0,
      textStrokeColor: "",
      padding: 3,
      display: true,
      autoSkip: true,
      autoSkipPadding: 3,
      labelOffset: 0,
      callback: Ticks.formatters.values,
      minor: {},
      major: {},
      align: "center",
      crossAlign: "near",
      showLabelBackdrop: false,
      backdropColor: "rgba(255, 255, 255, 0.75)",
      backdropPadding: 2
    }
  });
  defaults.route("scale.ticks", "color", "", "color");
  defaults.route("scale.grid", "color", "", "borderColor");
  defaults.route("scale.grid", "borderColor", "", "borderColor");
  defaults.route("scale.title", "color", "", "color");
  defaults.describe("scale", {
    _fallback: false,
    _scriptable: (name) => !name.startsWith("before") && !name.startsWith("after") && name !== "callback" && name !== "parser",
    _indexable: (name) => name !== "borderDash" && name !== "tickBorderDash"
  });
  defaults.describe("scales", {
    _fallback: "scale"
  });
  defaults.describe("scale.ticks", {
    _scriptable: (name) => name !== "backdropPadding" && name !== "callback",
    _indexable: (name) => name !== "backdropPadding"
  });
  function autoSkip(scale, ticks) {
    const tickOpts = scale.options.ticks;
    const ticksLimit = tickOpts.maxTicksLimit || determineMaxTicks(scale);
    const majorIndices = tickOpts.major.enabled ? getMajorIndices(ticks) : [];
    const numMajorIndices = majorIndices.length;
    const first = majorIndices[0];
    const last = majorIndices[numMajorIndices - 1];
    const newTicks = [];
    if (numMajorIndices > ticksLimit) {
      skipMajors(ticks, newTicks, majorIndices, numMajorIndices / ticksLimit);
      return newTicks;
    }
    const spacing = calculateSpacing(majorIndices, ticks, ticksLimit);
    if (numMajorIndices > 0) {
      let i, ilen;
      const avgMajorSpacing = numMajorIndices > 1 ? Math.round((last - first) / (numMajorIndices - 1)) : null;
      skip(ticks, newTicks, spacing, isNullOrUndef(avgMajorSpacing) ? 0 : first - avgMajorSpacing, first);
      for (i = 0, ilen = numMajorIndices - 1; i < ilen; i++) {
        skip(ticks, newTicks, spacing, majorIndices[i], majorIndices[i + 1]);
      }
      skip(ticks, newTicks, spacing, last, isNullOrUndef(avgMajorSpacing) ? ticks.length : last + avgMajorSpacing);
      return newTicks;
    }
    skip(ticks, newTicks, spacing);
    return newTicks;
  }
  function determineMaxTicks(scale) {
    const offset = scale.options.offset;
    const tickLength = scale._tickSize();
    const maxScale = scale._length / tickLength + (offset ? 0 : 1);
    const maxChart = scale._maxLength / tickLength;
    return Math.floor(Math.min(maxScale, maxChart));
  }
  function calculateSpacing(majorIndices, ticks, ticksLimit) {
    const evenMajorSpacing = getEvenSpacing(majorIndices);
    const spacing = ticks.length / ticksLimit;
    if (!evenMajorSpacing) {
      return Math.max(spacing, 1);
    }
    const factors = _factorize(evenMajorSpacing);
    for (let i = 0, ilen = factors.length - 1; i < ilen; i++) {
      const factor = factors[i];
      if (factor > spacing) {
        return factor;
      }
    }
    return Math.max(spacing, 1);
  }
  function getMajorIndices(ticks) {
    const result = [];
    let i, ilen;
    for (i = 0, ilen = ticks.length; i < ilen; i++) {
      if (ticks[i].major) {
        result.push(i);
      }
    }
    return result;
  }
  function skipMajors(ticks, newTicks, majorIndices, spacing) {
    let count = 0;
    let next = majorIndices[0];
    let i;
    spacing = Math.ceil(spacing);
    for (i = 0; i < ticks.length; i++) {
      if (i === next) {
        newTicks.push(ticks[i]);
        count++;
        next = majorIndices[count * spacing];
      }
    }
  }
  function skip(ticks, newTicks, spacing, majorStart, majorEnd) {
    const start2 = valueOrDefault(majorStart, 0);
    const end = Math.min(valueOrDefault(majorEnd, ticks.length), ticks.length);
    let count = 0;
    let length, i, next;
    spacing = Math.ceil(spacing);
    if (majorEnd) {
      length = majorEnd - majorStart;
      spacing = length / Math.floor(length / spacing);
    }
    next = start2;
    while (next < 0) {
      count++;
      next = Math.round(start2 + count * spacing);
    }
    for (i = Math.max(start2, 0); i < end; i++) {
      if (i === next) {
        newTicks.push(ticks[i]);
        count++;
        next = Math.round(start2 + count * spacing);
      }
    }
  }
  function getEvenSpacing(arr) {
    const len = arr.length;
    let i, diff;
    if (len < 2) {
      return false;
    }
    for (diff = arr[0], i = 1; i < len; ++i) {
      if (arr[i] - arr[i - 1] !== diff) {
        return false;
      }
    }
    return diff;
  }
  var reverseAlign = (align) => align === "left" ? "right" : align === "right" ? "left" : align;
  var offsetFromEdge = (scale, edge, offset) => edge === "top" || edge === "left" ? scale[edge] + offset : scale[edge] - offset;
  function sample(arr, numItems) {
    const result = [];
    const increment = arr.length / numItems;
    const len = arr.length;
    let i = 0;
    for (; i < len; i += increment) {
      result.push(arr[Math.floor(i)]);
    }
    return result;
  }
  function getPixelForGridLine(scale, index3, offsetGridLines) {
    const length = scale.ticks.length;
    const validIndex2 = Math.min(index3, length - 1);
    const start2 = scale._startPixel;
    const end = scale._endPixel;
    const epsilon = 1e-6;
    let lineValue = scale.getPixelForTick(validIndex2);
    let offset;
    if (offsetGridLines) {
      if (length === 1) {
        offset = Math.max(lineValue - start2, end - lineValue);
      } else if (index3 === 0) {
        offset = (scale.getPixelForTick(1) - lineValue) / 2;
      } else {
        offset = (lineValue - scale.getPixelForTick(validIndex2 - 1)) / 2;
      }
      lineValue += validIndex2 < index3 ? offset : -offset;
      if (lineValue < start2 - epsilon || lineValue > end + epsilon) {
        return;
      }
    }
    return lineValue;
  }
  function garbageCollect(caches, length) {
    each(caches, (cache) => {
      const gc = cache.gc;
      const gcLen = gc.length / 2;
      let i;
      if (gcLen > length) {
        for (i = 0; i < gcLen; ++i) {
          delete cache.data[gc[i]];
        }
        gc.splice(0, gcLen);
      }
    });
  }
  function getTickMarkLength(options) {
    return options.drawTicks ? options.tickLength : 0;
  }
  function getTitleHeight(options, fallback) {
    if (!options.display) {
      return 0;
    }
    const font = toFont(options.font, fallback);
    const padding = toPadding(options.padding);
    const lines = isArray(options.text) ? options.text.length : 1;
    return lines * font.lineHeight + padding.height;
  }
  function createScaleContext(parent, scale) {
    return createContext(parent, {
      scale,
      type: "scale"
    });
  }
  function createTickContext(parent, index3, tick) {
    return createContext(parent, {
      tick,
      index: index3,
      type: "tick"
    });
  }
  function titleAlign(align, position, reverse) {
    let ret = _toLeftRightCenter(align);
    if (reverse && position !== "right" || !reverse && position === "right") {
      ret = reverseAlign(ret);
    }
    return ret;
  }
  function titleArgs(scale, offset, position, align) {
    const { top, left, bottom, right, chart } = scale;
    const { chartArea, scales: scales2 } = chart;
    let rotation = 0;
    let maxWidth, titleX, titleY;
    const height = bottom - top;
    const width = right - left;
    if (scale.isHorizontal()) {
      titleX = _alignStartEnd(align, left, right);
      if (isObject(position)) {
        const positionAxisID = Object.keys(position)[0];
        const value = position[positionAxisID];
        titleY = scales2[positionAxisID].getPixelForValue(value) + height - offset;
      } else if (position === "center") {
        titleY = (chartArea.bottom + chartArea.top) / 2 + height - offset;
      } else {
        titleY = offsetFromEdge(scale, position, offset);
      }
      maxWidth = right - left;
    } else {
      if (isObject(position)) {
        const positionAxisID = Object.keys(position)[0];
        const value = position[positionAxisID];
        titleX = scales2[positionAxisID].getPixelForValue(value) - width + offset;
      } else if (position === "center") {
        titleX = (chartArea.left + chartArea.right) / 2 - width + offset;
      } else {
        titleX = offsetFromEdge(scale, position, offset);
      }
      titleY = _alignStartEnd(align, bottom, top);
      rotation = position === "left" ? -HALF_PI : HALF_PI;
    }
    return { titleX, titleY, maxWidth, rotation };
  }
  var Scale = class extends Element {
    constructor(cfg) {
      super();
      this.id = cfg.id;
      this.type = cfg.type;
      this.options = void 0;
      this.ctx = cfg.ctx;
      this.chart = cfg.chart;
      this.top = void 0;
      this.bottom = void 0;
      this.left = void 0;
      this.right = void 0;
      this.width = void 0;
      this.height = void 0;
      this._margins = {
        left: 0,
        right: 0,
        top: 0,
        bottom: 0
      };
      this.maxWidth = void 0;
      this.maxHeight = void 0;
      this.paddingTop = void 0;
      this.paddingBottom = void 0;
      this.paddingLeft = void 0;
      this.paddingRight = void 0;
      this.axis = void 0;
      this.labelRotation = void 0;
      this.min = void 0;
      this.max = void 0;
      this._range = void 0;
      this.ticks = [];
      this._gridLineItems = null;
      this._labelItems = null;
      this._labelSizes = null;
      this._length = 0;
      this._maxLength = 0;
      this._longestTextCache = {};
      this._startPixel = void 0;
      this._endPixel = void 0;
      this._reversePixels = false;
      this._userMax = void 0;
      this._userMin = void 0;
      this._suggestedMax = void 0;
      this._suggestedMin = void 0;
      this._ticksLength = 0;
      this._borderValue = 0;
      this._cache = {};
      this._dataLimitsCached = false;
      this.$context = void 0;
    }
    init(options) {
      this.options = options.setContext(this.getContext());
      this.axis = options.axis;
      this._userMin = this.parse(options.min);
      this._userMax = this.parse(options.max);
      this._suggestedMin = this.parse(options.suggestedMin);
      this._suggestedMax = this.parse(options.suggestedMax);
    }
    parse(raw, index3) {
      return raw;
    }
    getUserBounds() {
      let { _userMin, _userMax, _suggestedMin, _suggestedMax } = this;
      _userMin = finiteOrDefault(_userMin, Number.POSITIVE_INFINITY);
      _userMax = finiteOrDefault(_userMax, Number.NEGATIVE_INFINITY);
      _suggestedMin = finiteOrDefault(_suggestedMin, Number.POSITIVE_INFINITY);
      _suggestedMax = finiteOrDefault(_suggestedMax, Number.NEGATIVE_INFINITY);
      return {
        min: finiteOrDefault(_userMin, _suggestedMin),
        max: finiteOrDefault(_userMax, _suggestedMax),
        minDefined: isNumberFinite(_userMin),
        maxDefined: isNumberFinite(_userMax)
      };
    }
    getMinMax(canStack) {
      let { min: min3, max: max3, minDefined, maxDefined } = this.getUserBounds();
      let range;
      if (minDefined && maxDefined) {
        return { min: min3, max: max3 };
      }
      const metas = this.getMatchingVisibleMetas();
      for (let i = 0, ilen = metas.length; i < ilen; ++i) {
        range = metas[i].controller.getMinMax(this, canStack);
        if (!minDefined) {
          min3 = Math.min(min3, range.min);
        }
        if (!maxDefined) {
          max3 = Math.max(max3, range.max);
        }
      }
      min3 = maxDefined && min3 > max3 ? max3 : min3;
      max3 = minDefined && min3 > max3 ? min3 : max3;
      return {
        min: finiteOrDefault(min3, finiteOrDefault(max3, min3)),
        max: finiteOrDefault(max3, finiteOrDefault(min3, max3))
      };
    }
    getPadding() {
      return {
        left: this.paddingLeft || 0,
        top: this.paddingTop || 0,
        right: this.paddingRight || 0,
        bottom: this.paddingBottom || 0
      };
    }
    getTicks() {
      return this.ticks;
    }
    getLabels() {
      const data = this.chart.data;
      return this.options.labels || (this.isHorizontal() ? data.xLabels : data.yLabels) || data.labels || [];
    }
    beforeLayout() {
      this._cache = {};
      this._dataLimitsCached = false;
    }
    beforeUpdate() {
      callback(this.options.beforeUpdate, [this]);
    }
    update(maxWidth, maxHeight, margins) {
      const { beginAtZero, grace, ticks: tickOpts } = this.options;
      const sampleSize = tickOpts.sampleSize;
      this.beforeUpdate();
      this.maxWidth = maxWidth;
      this.maxHeight = maxHeight;
      this._margins = margins = Object.assign({
        left: 0,
        right: 0,
        top: 0,
        bottom: 0
      }, margins);
      this.ticks = null;
      this._labelSizes = null;
      this._gridLineItems = null;
      this._labelItems = null;
      this.beforeSetDimensions();
      this.setDimensions();
      this.afterSetDimensions();
      this._maxLength = this.isHorizontal() ? this.width + margins.left + margins.right : this.height + margins.top + margins.bottom;
      if (!this._dataLimitsCached) {
        this.beforeDataLimits();
        this.determineDataLimits();
        this.afterDataLimits();
        this._range = _addGrace(this, grace, beginAtZero);
        this._dataLimitsCached = true;
      }
      this.beforeBuildTicks();
      this.ticks = this.buildTicks() || [];
      this.afterBuildTicks();
      const samplingEnabled = sampleSize < this.ticks.length;
      this._convertTicksToLabels(samplingEnabled ? sample(this.ticks, sampleSize) : this.ticks);
      this.configure();
      this.beforeCalculateLabelRotation();
      this.calculateLabelRotation();
      this.afterCalculateLabelRotation();
      if (tickOpts.display && (tickOpts.autoSkip || tickOpts.source === "auto")) {
        this.ticks = autoSkip(this, this.ticks);
        this._labelSizes = null;
        this.afterAutoSkip();
      }
      if (samplingEnabled) {
        this._convertTicksToLabels(this.ticks);
      }
      this.beforeFit();
      this.fit();
      this.afterFit();
      this.afterUpdate();
    }
    configure() {
      let reversePixels = this.options.reverse;
      let startPixel, endPixel;
      if (this.isHorizontal()) {
        startPixel = this.left;
        endPixel = this.right;
      } else {
        startPixel = this.top;
        endPixel = this.bottom;
        reversePixels = !reversePixels;
      }
      this._startPixel = startPixel;
      this._endPixel = endPixel;
      this._reversePixels = reversePixels;
      this._length = endPixel - startPixel;
      this._alignToPixels = this.options.alignToPixels;
    }
    afterUpdate() {
      callback(this.options.afterUpdate, [this]);
    }
    beforeSetDimensions() {
      callback(this.options.beforeSetDimensions, [this]);
    }
    setDimensions() {
      if (this.isHorizontal()) {
        this.width = this.maxWidth;
        this.left = 0;
        this.right = this.width;
      } else {
        this.height = this.maxHeight;
        this.top = 0;
        this.bottom = this.height;
      }
      this.paddingLeft = 0;
      this.paddingTop = 0;
      this.paddingRight = 0;
      this.paddingBottom = 0;
    }
    afterSetDimensions() {
      callback(this.options.afterSetDimensions, [this]);
    }
    _callHooks(name) {
      this.chart.notifyPlugins(name, this.getContext());
      callback(this.options[name], [this]);
    }
    beforeDataLimits() {
      this._callHooks("beforeDataLimits");
    }
    determineDataLimits() {
    }
    afterDataLimits() {
      this._callHooks("afterDataLimits");
    }
    beforeBuildTicks() {
      this._callHooks("beforeBuildTicks");
    }
    buildTicks() {
      return [];
    }
    afterBuildTicks() {
      this._callHooks("afterBuildTicks");
    }
    beforeTickToLabelConversion() {
      callback(this.options.beforeTickToLabelConversion, [this]);
    }
    generateTickLabels(ticks) {
      const tickOpts = this.options.ticks;
      let i, ilen, tick;
      for (i = 0, ilen = ticks.length; i < ilen; i++) {
        tick = ticks[i];
        tick.label = callback(tickOpts.callback, [tick.value, i, ticks], this);
      }
    }
    afterTickToLabelConversion() {
      callback(this.options.afterTickToLabelConversion, [this]);
    }
    beforeCalculateLabelRotation() {
      callback(this.options.beforeCalculateLabelRotation, [this]);
    }
    calculateLabelRotation() {
      const options = this.options;
      const tickOpts = options.ticks;
      const numTicks = this.ticks.length;
      const minRotation = tickOpts.minRotation || 0;
      const maxRotation = tickOpts.maxRotation;
      let labelRotation = minRotation;
      let tickWidth, maxHeight, maxLabelDiagonal;
      if (!this._isVisible() || !tickOpts.display || minRotation >= maxRotation || numTicks <= 1 || !this.isHorizontal()) {
        this.labelRotation = minRotation;
        return;
      }
      const labelSizes = this._getLabelSizes();
      const maxLabelWidth = labelSizes.widest.width;
      const maxLabelHeight = labelSizes.highest.height;
      const maxWidth = _limitValue(this.chart.width - maxLabelWidth, 0, this.maxWidth);
      tickWidth = options.offset ? this.maxWidth / numTicks : maxWidth / (numTicks - 1);
      if (maxLabelWidth + 6 > tickWidth) {
        tickWidth = maxWidth / (numTicks - (options.offset ? 0.5 : 1));
        maxHeight = this.maxHeight - getTickMarkLength(options.grid) - tickOpts.padding - getTitleHeight(options.title, this.chart.options.font);
        maxLabelDiagonal = Math.sqrt(maxLabelWidth * maxLabelWidth + maxLabelHeight * maxLabelHeight);
        labelRotation = toDegrees(Math.min(
          Math.asin(_limitValue((labelSizes.highest.height + 6) / tickWidth, -1, 1)),
          Math.asin(_limitValue(maxHeight / maxLabelDiagonal, -1, 1)) - Math.asin(_limitValue(maxLabelHeight / maxLabelDiagonal, -1, 1))
        ));
        labelRotation = Math.max(minRotation, Math.min(maxRotation, labelRotation));
      }
      this.labelRotation = labelRotation;
    }
    afterCalculateLabelRotation() {
      callback(this.options.afterCalculateLabelRotation, [this]);
    }
    afterAutoSkip() {
    }
    beforeFit() {
      callback(this.options.beforeFit, [this]);
    }
    fit() {
      const minSize = {
        width: 0,
        height: 0
      };
      const { chart, options: { ticks: tickOpts, title: titleOpts, grid: gridOpts } } = this;
      const display = this._isVisible();
      const isHorizontal = this.isHorizontal();
      if (display) {
        const titleHeight = getTitleHeight(titleOpts, chart.options.font);
        if (isHorizontal) {
          minSize.width = this.maxWidth;
          minSize.height = getTickMarkLength(gridOpts) + titleHeight;
        } else {
          minSize.height = this.maxHeight;
          minSize.width = getTickMarkLength(gridOpts) + titleHeight;
        }
        if (tickOpts.display && this.ticks.length) {
          const { first, last, widest, highest } = this._getLabelSizes();
          const tickPadding = tickOpts.padding * 2;
          const angleRadians = toRadians(this.labelRotation);
          const cos = Math.cos(angleRadians);
          const sin = Math.sin(angleRadians);
          if (isHorizontal) {
            const labelHeight = tickOpts.mirror ? 0 : sin * widest.width + cos * highest.height;
            minSize.height = Math.min(this.maxHeight, minSize.height + labelHeight + tickPadding);
          } else {
            const labelWidth = tickOpts.mirror ? 0 : cos * widest.width + sin * highest.height;
            minSize.width = Math.min(this.maxWidth, minSize.width + labelWidth + tickPadding);
          }
          this._calculatePadding(first, last, sin, cos);
        }
      }
      this._handleMargins();
      if (isHorizontal) {
        this.width = this._length = chart.width - this._margins.left - this._margins.right;
        this.height = minSize.height;
      } else {
        this.width = minSize.width;
        this.height = this._length = chart.height - this._margins.top - this._margins.bottom;
      }
    }
    _calculatePadding(first, last, sin, cos) {
      const { ticks: { align, padding }, position } = this.options;
      const isRotated = this.labelRotation !== 0;
      const labelsBelowTicks = position !== "top" && this.axis === "x";
      if (this.isHorizontal()) {
        const offsetLeft = this.getPixelForTick(0) - this.left;
        const offsetRight = this.right - this.getPixelForTick(this.ticks.length - 1);
        let paddingLeft = 0;
        let paddingRight = 0;
        if (isRotated) {
          if (labelsBelowTicks) {
            paddingLeft = cos * first.width;
            paddingRight = sin * last.height;
          } else {
            paddingLeft = sin * first.height;
            paddingRight = cos * last.width;
          }
        } else if (align === "start") {
          paddingRight = last.width;
        } else if (align === "end") {
          paddingLeft = first.width;
        } else if (align !== "inner") {
          paddingLeft = first.width / 2;
          paddingRight = last.width / 2;
        }
        this.paddingLeft = Math.max((paddingLeft - offsetLeft + padding) * this.width / (this.width - offsetLeft), 0);
        this.paddingRight = Math.max((paddingRight - offsetRight + padding) * this.width / (this.width - offsetRight), 0);
      } else {
        let paddingTop = last.height / 2;
        let paddingBottom = first.height / 2;
        if (align === "start") {
          paddingTop = 0;
          paddingBottom = first.height;
        } else if (align === "end") {
          paddingTop = last.height;
          paddingBottom = 0;
        }
        this.paddingTop = paddingTop + padding;
        this.paddingBottom = paddingBottom + padding;
      }
    }
    _handleMargins() {
      if (this._margins) {
        this._margins.left = Math.max(this.paddingLeft, this._margins.left);
        this._margins.top = Math.max(this.paddingTop, this._margins.top);
        this._margins.right = Math.max(this.paddingRight, this._margins.right);
        this._margins.bottom = Math.max(this.paddingBottom, this._margins.bottom);
      }
    }
    afterFit() {
      callback(this.options.afterFit, [this]);
    }
    isHorizontal() {
      const { axis, position } = this.options;
      return position === "top" || position === "bottom" || axis === "x";
    }
    isFullSize() {
      return this.options.fullSize;
    }
    _convertTicksToLabels(ticks) {
      this.beforeTickToLabelConversion();
      this.generateTickLabels(ticks);
      let i, ilen;
      for (i = 0, ilen = ticks.length; i < ilen; i++) {
        if (isNullOrUndef(ticks[i].label)) {
          ticks.splice(i, 1);
          ilen--;
          i--;
        }
      }
      this.afterTickToLabelConversion();
    }
    _getLabelSizes() {
      let labelSizes = this._labelSizes;
      if (!labelSizes) {
        const sampleSize = this.options.ticks.sampleSize;
        let ticks = this.ticks;
        if (sampleSize < ticks.length) {
          ticks = sample(ticks, sampleSize);
        }
        this._labelSizes = labelSizes = this._computeLabelSizes(ticks, ticks.length);
      }
      return labelSizes;
    }
    _computeLabelSizes(ticks, length) {
      const { ctx, _longestTextCache: caches } = this;
      const widths = [];
      const heights = [];
      let widestLabelSize = 0;
      let highestLabelSize = 0;
      let i, j, jlen, label, tickFont, fontString2, cache, lineHeight, width, height, nestedLabel;
      for (i = 0; i < length; ++i) {
        label = ticks[i].label;
        tickFont = this._resolveTickFontOptions(i);
        ctx.font = fontString2 = tickFont.string;
        cache = caches[fontString2] = caches[fontString2] || { data: {}, gc: [] };
        lineHeight = tickFont.lineHeight;
        width = height = 0;
        if (!isNullOrUndef(label) && !isArray(label)) {
          width = _measureText(ctx, cache.data, cache.gc, width, label);
          height = lineHeight;
        } else if (isArray(label)) {
          for (j = 0, jlen = label.length; j < jlen; ++j) {
            nestedLabel = label[j];
            if (!isNullOrUndef(nestedLabel) && !isArray(nestedLabel)) {
              width = _measureText(ctx, cache.data, cache.gc, width, nestedLabel);
              height += lineHeight;
            }
          }
        }
        widths.push(width);
        heights.push(height);
        widestLabelSize = Math.max(width, widestLabelSize);
        highestLabelSize = Math.max(height, highestLabelSize);
      }
      garbageCollect(caches, length);
      const widest = widths.indexOf(widestLabelSize);
      const highest = heights.indexOf(highestLabelSize);
      const valueAt = (idx) => ({ width: widths[idx] || 0, height: heights[idx] || 0 });
      return {
        first: valueAt(0),
        last: valueAt(length - 1),
        widest: valueAt(widest),
        highest: valueAt(highest),
        widths,
        heights
      };
    }
    getLabelForValue(value) {
      return value;
    }
    getPixelForValue(value, index3) {
      return NaN;
    }
    getValueForPixel(pixel) {
    }
    getPixelForTick(index3) {
      const ticks = this.ticks;
      if (index3 < 0 || index3 > ticks.length - 1) {
        return null;
      }
      return this.getPixelForValue(ticks[index3].value);
    }
    getPixelForDecimal(decimal) {
      if (this._reversePixels) {
        decimal = 1 - decimal;
      }
      const pixel = this._startPixel + decimal * this._length;
      return _int16Range(this._alignToPixels ? _alignPixel(this.chart, pixel, 0) : pixel);
    }
    getDecimalForPixel(pixel) {
      const decimal = (pixel - this._startPixel) / this._length;
      return this._reversePixels ? 1 - decimal : decimal;
    }
    getBasePixel() {
      return this.getPixelForValue(this.getBaseValue());
    }
    getBaseValue() {
      const { min: min3, max: max3 } = this;
      return min3 < 0 && max3 < 0 ? max3 : min3 > 0 && max3 > 0 ? min3 : 0;
    }
    getContext(index3) {
      const ticks = this.ticks || [];
      if (index3 >= 0 && index3 < ticks.length) {
        const tick = ticks[index3];
        return tick.$context || (tick.$context = createTickContext(this.getContext(), index3, tick));
      }
      return this.$context || (this.$context = createScaleContext(this.chart.getContext(), this));
    }
    _tickSize() {
      const optionTicks = this.options.ticks;
      const rot = toRadians(this.labelRotation);
      const cos = Math.abs(Math.cos(rot));
      const sin = Math.abs(Math.sin(rot));
      const labelSizes = this._getLabelSizes();
      const padding = optionTicks.autoSkipPadding || 0;
      const w = labelSizes ? labelSizes.widest.width + padding : 0;
      const h = labelSizes ? labelSizes.highest.height + padding : 0;
      return this.isHorizontal() ? h * cos > w * sin ? w / cos : h / sin : h * sin < w * cos ? h / cos : w / sin;
    }
    _isVisible() {
      const display = this.options.display;
      if (display !== "auto") {
        return !!display;
      }
      return this.getMatchingVisibleMetas().length > 0;
    }
    _computeGridLineItems(chartArea) {
      const axis = this.axis;
      const chart = this.chart;
      const options = this.options;
      const { grid, position } = options;
      const offset = grid.offset;
      const isHorizontal = this.isHorizontal();
      const ticks = this.ticks;
      const ticksLength = ticks.length + (offset ? 1 : 0);
      const tl = getTickMarkLength(grid);
      const items = [];
      const borderOpts = grid.setContext(this.getContext());
      const axisWidth = borderOpts.drawBorder ? borderOpts.borderWidth : 0;
      const axisHalfWidth = axisWidth / 2;
      const alignBorderValue = function(pixel) {
        return _alignPixel(chart, pixel, axisWidth);
      };
      let borderValue, i, lineValue, alignedLineValue;
      let tx1, ty1, tx2, ty2, x1, y1, x2, y2;
      if (position === "top") {
        borderValue = alignBorderValue(this.bottom);
        ty1 = this.bottom - tl;
        ty2 = borderValue - axisHalfWidth;
        y1 = alignBorderValue(chartArea.top) + axisHalfWidth;
        y2 = chartArea.bottom;
      } else if (position === "bottom") {
        borderValue = alignBorderValue(this.top);
        y1 = chartArea.top;
        y2 = alignBorderValue(chartArea.bottom) - axisHalfWidth;
        ty1 = borderValue + axisHalfWidth;
        ty2 = this.top + tl;
      } else if (position === "left") {
        borderValue = alignBorderValue(this.right);
        tx1 = this.right - tl;
        tx2 = borderValue - axisHalfWidth;
        x1 = alignBorderValue(chartArea.left) + axisHalfWidth;
        x2 = chartArea.right;
      } else if (position === "right") {
        borderValue = alignBorderValue(this.left);
        x1 = chartArea.left;
        x2 = alignBorderValue(chartArea.right) - axisHalfWidth;
        tx1 = borderValue + axisHalfWidth;
        tx2 = this.left + tl;
      } else if (axis === "x") {
        if (position === "center") {
          borderValue = alignBorderValue((chartArea.top + chartArea.bottom) / 2 + 0.5);
        } else if (isObject(position)) {
          const positionAxisID = Object.keys(position)[0];
          const value = position[positionAxisID];
          borderValue = alignBorderValue(this.chart.scales[positionAxisID].getPixelForValue(value));
        }
        y1 = chartArea.top;
        y2 = chartArea.bottom;
        ty1 = borderValue + axisHalfWidth;
        ty2 = ty1 + tl;
      } else if (axis === "y") {
        if (position === "center") {
          borderValue = alignBorderValue((chartArea.left + chartArea.right) / 2);
        } else if (isObject(position)) {
          const positionAxisID = Object.keys(position)[0];
          const value = position[positionAxisID];
          borderValue = alignBorderValue(this.chart.scales[positionAxisID].getPixelForValue(value));
        }
        tx1 = borderValue - axisHalfWidth;
        tx2 = tx1 - tl;
        x1 = chartArea.left;
        x2 = chartArea.right;
      }
      const limit = valueOrDefault(options.ticks.maxTicksLimit, ticksLength);
      const step = Math.max(1, Math.ceil(ticksLength / limit));
      for (i = 0; i < ticksLength; i += step) {
        const optsAtIndex = grid.setContext(this.getContext(i));
        const lineWidth = optsAtIndex.lineWidth;
        const lineColor = optsAtIndex.color;
        const borderDash = optsAtIndex.borderDash || [];
        const borderDashOffset = optsAtIndex.borderDashOffset;
        const tickWidth = optsAtIndex.tickWidth;
        const tickColor = optsAtIndex.tickColor;
        const tickBorderDash = optsAtIndex.tickBorderDash || [];
        const tickBorderDashOffset = optsAtIndex.tickBorderDashOffset;
        lineValue = getPixelForGridLine(this, i, offset);
        if (lineValue === void 0) {
          continue;
        }
        alignedLineValue = _alignPixel(chart, lineValue, lineWidth);
        if (isHorizontal) {
          tx1 = tx2 = x1 = x2 = alignedLineValue;
        } else {
          ty1 = ty2 = y1 = y2 = alignedLineValue;
        }
        items.push({
          tx1,
          ty1,
          tx2,
          ty2,
          x1,
          y1,
          x2,
          y2,
          width: lineWidth,
          color: lineColor,
          borderDash,
          borderDashOffset,
          tickWidth,
          tickColor,
          tickBorderDash,
          tickBorderDashOffset
        });
      }
      this._ticksLength = ticksLength;
      this._borderValue = borderValue;
      return items;
    }
    _computeLabelItems(chartArea) {
      const axis = this.axis;
      const options = this.options;
      const { position, ticks: optionTicks } = options;
      const isHorizontal = this.isHorizontal();
      const ticks = this.ticks;
      const { align, crossAlign, padding, mirror } = optionTicks;
      const tl = getTickMarkLength(options.grid);
      const tickAndPadding = tl + padding;
      const hTickAndPadding = mirror ? -padding : tickAndPadding;
      const rotation = -toRadians(this.labelRotation);
      const items = [];
      let i, ilen, tick, label, x, y, textAlign, pixel, font, lineHeight, lineCount, textOffset;
      let textBaseline = "middle";
      if (position === "top") {
        y = this.bottom - hTickAndPadding;
        textAlign = this._getXAxisLabelAlignment();
      } else if (position === "bottom") {
        y = this.top + hTickAndPadding;
        textAlign = this._getXAxisLabelAlignment();
      } else if (position === "left") {
        const ret = this._getYAxisLabelAlignment(tl);
        textAlign = ret.textAlign;
        x = ret.x;
      } else if (position === "right") {
        const ret = this._getYAxisLabelAlignment(tl);
        textAlign = ret.textAlign;
        x = ret.x;
      } else if (axis === "x") {
        if (position === "center") {
          y = (chartArea.top + chartArea.bottom) / 2 + tickAndPadding;
        } else if (isObject(position)) {
          const positionAxisID = Object.keys(position)[0];
          const value = position[positionAxisID];
          y = this.chart.scales[positionAxisID].getPixelForValue(value) + tickAndPadding;
        }
        textAlign = this._getXAxisLabelAlignment();
      } else if (axis === "y") {
        if (position === "center") {
          x = (chartArea.left + chartArea.right) / 2 - tickAndPadding;
        } else if (isObject(position)) {
          const positionAxisID = Object.keys(position)[0];
          const value = position[positionAxisID];
          x = this.chart.scales[positionAxisID].getPixelForValue(value);
        }
        textAlign = this._getYAxisLabelAlignment(tl).textAlign;
      }
      if (axis === "y") {
        if (align === "start") {
          textBaseline = "top";
        } else if (align === "end") {
          textBaseline = "bottom";
        }
      }
      const labelSizes = this._getLabelSizes();
      for (i = 0, ilen = ticks.length; i < ilen; ++i) {
        tick = ticks[i];
        label = tick.label;
        const optsAtIndex = optionTicks.setContext(this.getContext(i));
        pixel = this.getPixelForTick(i) + optionTicks.labelOffset;
        font = this._resolveTickFontOptions(i);
        lineHeight = font.lineHeight;
        lineCount = isArray(label) ? label.length : 1;
        const halfCount = lineCount / 2;
        const color3 = optsAtIndex.color;
        const strokeColor = optsAtIndex.textStrokeColor;
        const strokeWidth = optsAtIndex.textStrokeWidth;
        let tickTextAlign = textAlign;
        if (isHorizontal) {
          x = pixel;
          if (textAlign === "inner") {
            if (i === ilen - 1) {
              tickTextAlign = !this.options.reverse ? "right" : "left";
            } else if (i === 0) {
              tickTextAlign = !this.options.reverse ? "left" : "right";
            } else {
              tickTextAlign = "center";
            }
          }
          if (position === "top") {
            if (crossAlign === "near" || rotation !== 0) {
              textOffset = -lineCount * lineHeight + lineHeight / 2;
            } else if (crossAlign === "center") {
              textOffset = -labelSizes.highest.height / 2 - halfCount * lineHeight + lineHeight;
            } else {
              textOffset = -labelSizes.highest.height + lineHeight / 2;
            }
          } else {
            if (crossAlign === "near" || rotation !== 0) {
              textOffset = lineHeight / 2;
            } else if (crossAlign === "center") {
              textOffset = labelSizes.highest.height / 2 - halfCount * lineHeight;
            } else {
              textOffset = labelSizes.highest.height - lineCount * lineHeight;
            }
          }
          if (mirror) {
            textOffset *= -1;
          }
        } else {
          y = pixel;
          textOffset = (1 - lineCount) * lineHeight / 2;
        }
        let backdrop;
        if (optsAtIndex.showLabelBackdrop) {
          const labelPadding = toPadding(optsAtIndex.backdropPadding);
          const height = labelSizes.heights[i];
          const width = labelSizes.widths[i];
          let top = y + textOffset - labelPadding.top;
          let left = x - labelPadding.left;
          switch (textBaseline) {
            case "middle":
              top -= height / 2;
              break;
            case "bottom":
              top -= height;
              break;
          }
          switch (textAlign) {
            case "center":
              left -= width / 2;
              break;
            case "right":
              left -= width;
              break;
          }
          backdrop = {
            left,
            top,
            width: width + labelPadding.width,
            height: height + labelPadding.height,
            color: optsAtIndex.backdropColor
          };
        }
        items.push({
          rotation,
          label,
          font,
          color: color3,
          strokeColor,
          strokeWidth,
          textOffset,
          textAlign: tickTextAlign,
          textBaseline,
          translation: [x, y],
          backdrop
        });
      }
      return items;
    }
    _getXAxisLabelAlignment() {
      const { position, ticks } = this.options;
      const rotation = -toRadians(this.labelRotation);
      if (rotation) {
        return position === "top" ? "left" : "right";
      }
      let align = "center";
      if (ticks.align === "start") {
        align = "left";
      } else if (ticks.align === "end") {
        align = "right";
      } else if (ticks.align === "inner") {
        align = "inner";
      }
      return align;
    }
    _getYAxisLabelAlignment(tl) {
      const { position, ticks: { crossAlign, mirror, padding } } = this.options;
      const labelSizes = this._getLabelSizes();
      const tickAndPadding = tl + padding;
      const widest = labelSizes.widest.width;
      let textAlign;
      let x;
      if (position === "left") {
        if (mirror) {
          x = this.right + padding;
          if (crossAlign === "near") {
            textAlign = "left";
          } else if (crossAlign === "center") {
            textAlign = "center";
            x += widest / 2;
          } else {
            textAlign = "right";
            x += widest;
          }
        } else {
          x = this.right - tickAndPadding;
          if (crossAlign === "near") {
            textAlign = "right";
          } else if (crossAlign === "center") {
            textAlign = "center";
            x -= widest / 2;
          } else {
            textAlign = "left";
            x = this.left;
          }
        }
      } else if (position === "right") {
        if (mirror) {
          x = this.left + padding;
          if (crossAlign === "near") {
            textAlign = "right";
          } else if (crossAlign === "center") {
            textAlign = "center";
            x -= widest / 2;
          } else {
            textAlign = "left";
            x -= widest;
          }
        } else {
          x = this.left + tickAndPadding;
          if (crossAlign === "near") {
            textAlign = "left";
          } else if (crossAlign === "center") {
            textAlign = "center";
            x += widest / 2;
          } else {
            textAlign = "right";
            x = this.right;
          }
        }
      } else {
        textAlign = "right";
      }
      return { textAlign, x };
    }
    _computeLabelArea() {
      if (this.options.ticks.mirror) {
        return;
      }
      const chart = this.chart;
      const position = this.options.position;
      if (position === "left" || position === "right") {
        return { top: 0, left: this.left, bottom: chart.height, right: this.right };
      }
      if (position === "top" || position === "bottom") {
        return { top: this.top, left: 0, bottom: this.bottom, right: chart.width };
      }
    }
    drawBackground() {
      const { ctx, options: { backgroundColor: backgroundColor4 }, left, top, width, height } = this;
      if (backgroundColor4) {
        ctx.save();
        ctx.fillStyle = backgroundColor4;
        ctx.fillRect(left, top, width, height);
        ctx.restore();
      }
    }
    getLineWidthForValue(value) {
      const grid = this.options.grid;
      if (!this._isVisible() || !grid.display) {
        return 0;
      }
      const ticks = this.ticks;
      const index3 = ticks.findIndex((t) => t.value === value);
      if (index3 >= 0) {
        const opts = grid.setContext(this.getContext(index3));
        return opts.lineWidth;
      }
      return 0;
    }
    drawGrid(chartArea) {
      const grid = this.options.grid;
      const ctx = this.ctx;
      const items = this._gridLineItems || (this._gridLineItems = this._computeGridLineItems(chartArea));
      let i, ilen;
      const drawLine = (p1, p2, style) => {
        if (!style.width || !style.color) {
          return;
        }
        ctx.save();
        ctx.lineWidth = style.width;
        ctx.strokeStyle = style.color;
        ctx.setLineDash(style.borderDash || []);
        ctx.lineDashOffset = style.borderDashOffset;
        ctx.beginPath();
        ctx.moveTo(p1.x, p1.y);
        ctx.lineTo(p2.x, p2.y);
        ctx.stroke();
        ctx.restore();
      };
      if (grid.display) {
        for (i = 0, ilen = items.length; i < ilen; ++i) {
          const item = items[i];
          if (grid.drawOnChartArea) {
            drawLine(
              { x: item.x1, y: item.y1 },
              { x: item.x2, y: item.y2 },
              item
            );
          }
          if (grid.drawTicks) {
            drawLine(
              { x: item.tx1, y: item.ty1 },
              { x: item.tx2, y: item.ty2 },
              {
                color: item.tickColor,
                width: item.tickWidth,
                borderDash: item.tickBorderDash,
                borderDashOffset: item.tickBorderDashOffset
              }
            );
          }
        }
      }
    }
    drawBorder() {
      const { chart, ctx, options: { grid } } = this;
      const borderOpts = grid.setContext(this.getContext());
      const axisWidth = grid.drawBorder ? borderOpts.borderWidth : 0;
      if (!axisWidth) {
        return;
      }
      const lastLineWidth = grid.setContext(this.getContext(0)).lineWidth;
      const borderValue = this._borderValue;
      let x1, x2, y1, y2;
      if (this.isHorizontal()) {
        x1 = _alignPixel(chart, this.left, axisWidth) - axisWidth / 2;
        x2 = _alignPixel(chart, this.right, lastLineWidth) + lastLineWidth / 2;
        y1 = y2 = borderValue;
      } else {
        y1 = _alignPixel(chart, this.top, axisWidth) - axisWidth / 2;
        y2 = _alignPixel(chart, this.bottom, lastLineWidth) + lastLineWidth / 2;
        x1 = x2 = borderValue;
      }
      ctx.save();
      ctx.lineWidth = borderOpts.borderWidth;
      ctx.strokeStyle = borderOpts.borderColor;
      ctx.beginPath();
      ctx.moveTo(x1, y1);
      ctx.lineTo(x2, y2);
      ctx.stroke();
      ctx.restore();
    }
    drawLabels(chartArea) {
      const optionTicks = this.options.ticks;
      if (!optionTicks.display) {
        return;
      }
      const ctx = this.ctx;
      const area = this._computeLabelArea();
      if (area) {
        clipArea(ctx, area);
      }
      const items = this._labelItems || (this._labelItems = this._computeLabelItems(chartArea));
      let i, ilen;
      for (i = 0, ilen = items.length; i < ilen; ++i) {
        const item = items[i];
        const tickFont = item.font;
        const label = item.label;
        if (item.backdrop) {
          ctx.fillStyle = item.backdrop.color;
          ctx.fillRect(item.backdrop.left, item.backdrop.top, item.backdrop.width, item.backdrop.height);
        }
        let y = item.textOffset;
        renderText(ctx, label, 0, y, tickFont, item);
      }
      if (area) {
        unclipArea(ctx);
      }
    }
    drawTitle() {
      const { ctx, options: { position, title: title2, reverse } } = this;
      if (!title2.display) {
        return;
      }
      const font = toFont(title2.font);
      const padding = toPadding(title2.padding);
      const align = title2.align;
      let offset = font.lineHeight / 2;
      if (position === "bottom" || position === "center" || isObject(position)) {
        offset += padding.bottom;
        if (isArray(title2.text)) {
          offset += font.lineHeight * (title2.text.length - 1);
        }
      } else {
        offset += padding.top;
      }
      const { titleX, titleY, maxWidth, rotation } = titleArgs(this, offset, position, align);
      renderText(ctx, title2.text, 0, 0, font, {
        color: title2.color,
        maxWidth,
        rotation,
        textAlign: titleAlign(align, position, reverse),
        textBaseline: "middle",
        translation: [titleX, titleY]
      });
    }
    draw(chartArea) {
      if (!this._isVisible()) {
        return;
      }
      this.drawBackground();
      this.drawGrid(chartArea);
      this.drawBorder();
      this.drawTitle();
      this.drawLabels(chartArea);
    }
    _layers() {
      const opts = this.options;
      const tz = opts.ticks && opts.ticks.z || 0;
      const gz = valueOrDefault(opts.grid && opts.grid.z, -1);
      if (!this._isVisible() || this.draw !== Scale.prototype.draw) {
        return [{
          z: tz,
          draw: (chartArea) => {
            this.draw(chartArea);
          }
        }];
      }
      return [{
        z: gz,
        draw: (chartArea) => {
          this.drawBackground();
          this.drawGrid(chartArea);
          this.drawTitle();
        }
      }, {
        z: gz + 1,
        draw: () => {
          this.drawBorder();
        }
      }, {
        z: tz,
        draw: (chartArea) => {
          this.drawLabels(chartArea);
        }
      }];
    }
    getMatchingVisibleMetas(type2) {
      const metas = this.chart.getSortedVisibleDatasetMetas();
      const axisID = this.axis + "AxisID";
      const result = [];
      let i, ilen;
      for (i = 0, ilen = metas.length; i < ilen; ++i) {
        const meta = metas[i];
        if (meta[axisID] === this.id && (!type2 || meta.type === type2)) {
          result.push(meta);
        }
      }
      return result;
    }
    _resolveTickFontOptions(index3) {
      const opts = this.options.ticks.setContext(this.getContext(index3));
      return toFont(opts.font);
    }
    _maxDigits() {
      const fontSize = this._resolveTickFontOptions(0).lineHeight;
      return (this.isHorizontal() ? this.width : this.height) / fontSize;
    }
  };
  var TypedRegistry = class {
    constructor(type2, scope, override) {
      this.type = type2;
      this.scope = scope;
      this.override = override;
      this.items = /* @__PURE__ */ Object.create(null);
    }
    isForType(type2) {
      return Object.prototype.isPrototypeOf.call(this.type.prototype, type2.prototype);
    }
    register(item) {
      const proto = Object.getPrototypeOf(item);
      let parentScope;
      if (isIChartComponent(proto)) {
        parentScope = this.register(proto);
      }
      const items = this.items;
      const id2 = item.id;
      const scope = this.scope + "." + id2;
      if (!id2) {
        throw new Error("class does not have id: " + item);
      }
      if (id2 in items) {
        return scope;
      }
      items[id2] = item;
      registerDefaults(item, scope, parentScope);
      if (this.override) {
        defaults.override(item.id, item.overrides);
      }
      return scope;
    }
    get(id2) {
      return this.items[id2];
    }
    unregister(item) {
      const items = this.items;
      const id2 = item.id;
      const scope = this.scope;
      if (id2 in items) {
        delete items[id2];
      }
      if (scope && id2 in defaults[scope]) {
        delete defaults[scope][id2];
        if (this.override) {
          delete overrides[id2];
        }
      }
    }
  };
  function registerDefaults(item, scope, parentScope) {
    const itemDefaults = merge(/* @__PURE__ */ Object.create(null), [
      parentScope ? defaults.get(parentScope) : {},
      defaults.get(scope),
      item.defaults
    ]);
    defaults.set(scope, itemDefaults);
    if (item.defaultRoutes) {
      routeDefaults(scope, item.defaultRoutes);
    }
    if (item.descriptors) {
      defaults.describe(scope, item.descriptors);
    }
  }
  function routeDefaults(scope, routes) {
    Object.keys(routes).forEach((property) => {
      const propertyParts = property.split(".");
      const sourceName = propertyParts.pop();
      const sourceScope = [scope].concat(propertyParts).join(".");
      const parts = routes[property].split(".");
      const targetName = parts.pop();
      const targetScope = parts.join(".");
      defaults.route(sourceScope, sourceName, targetScope, targetName);
    });
  }
  function isIChartComponent(proto) {
    return "id" in proto && "defaults" in proto;
  }
  var Registry = class {
    constructor() {
      this.controllers = new TypedRegistry(DatasetController, "datasets", true);
      this.elements = new TypedRegistry(Element, "elements");
      this.plugins = new TypedRegistry(Object, "plugins");
      this.scales = new TypedRegistry(Scale, "scales");
      this._typedRegistries = [this.controllers, this.scales, this.elements];
    }
    add(...args) {
      this._each("register", args);
    }
    remove(...args) {
      this._each("unregister", args);
    }
    addControllers(...args) {
      this._each("register", args, this.controllers);
    }
    addElements(...args) {
      this._each("register", args, this.elements);
    }
    addPlugins(...args) {
      this._each("register", args, this.plugins);
    }
    addScales(...args) {
      this._each("register", args, this.scales);
    }
    getController(id2) {
      return this._get(id2, this.controllers, "controller");
    }
    getElement(id2) {
      return this._get(id2, this.elements, "element");
    }
    getPlugin(id2) {
      return this._get(id2, this.plugins, "plugin");
    }
    getScale(id2) {
      return this._get(id2, this.scales, "scale");
    }
    removeControllers(...args) {
      this._each("unregister", args, this.controllers);
    }
    removeElements(...args) {
      this._each("unregister", args, this.elements);
    }
    removePlugins(...args) {
      this._each("unregister", args, this.plugins);
    }
    removeScales(...args) {
      this._each("unregister", args, this.scales);
    }
    _each(method, args, typedRegistry) {
      [...args].forEach((arg) => {
        const reg = typedRegistry || this._getRegistryForType(arg);
        if (typedRegistry || reg.isForType(arg) || reg === this.plugins && arg.id) {
          this._exec(method, reg, arg);
        } else {
          each(arg, (item) => {
            const itemReg = typedRegistry || this._getRegistryForType(item);
            this._exec(method, itemReg, item);
          });
        }
      });
    }
    _exec(method, registry2, component) {
      const camelMethod = _capitalize(method);
      callback(component["before" + camelMethod], [], component);
      registry2[method](component);
      callback(component["after" + camelMethod], [], component);
    }
    _getRegistryForType(type2) {
      for (let i = 0; i < this._typedRegistries.length; i++) {
        const reg = this._typedRegistries[i];
        if (reg.isForType(type2)) {
          return reg;
        }
      }
      return this.plugins;
    }
    _get(id2, typedRegistry, type2) {
      const item = typedRegistry.get(id2);
      if (item === void 0) {
        throw new Error('"' + id2 + '" is not a registered ' + type2 + ".");
      }
      return item;
    }
  };
  var registry = new Registry();
  var ScatterController = class extends DatasetController {
    update(mode) {
      const meta = this._cachedMeta;
      const { data: points = [] } = meta;
      const animationsDisabled = this.chart._animationsDisabled;
      let { start: start2, count } = _getStartAndCountOfVisiblePoints(meta, points, animationsDisabled);
      this._drawStart = start2;
      this._drawCount = count;
      if (_scaleRangesChanged(meta)) {
        start2 = 0;
        count = points.length;
      }
      if (this.options.showLine) {
        const { dataset: line, _dataset } = meta;
        line._chart = this.chart;
        line._datasetIndex = this.index;
        line._decimated = !!_dataset._decimated;
        line.points = points;
        const options = this.resolveDatasetElementOptions(mode);
        options.segment = this.options.segment;
        this.updateElement(line, void 0, {
          animated: !animationsDisabled,
          options
        }, mode);
      }
      this.updateElements(points, start2, count, mode);
    }
    addElements() {
      const { showLine } = this.options;
      if (!this.datasetElementType && showLine) {
        this.datasetElementType = registry.getElement("line");
      }
      super.addElements();
    }
    updateElements(points, start2, count, mode) {
      const reset = mode === "reset";
      const { iScale, vScale, _stacked, _dataset } = this._cachedMeta;
      const firstOpts = this.resolveDataElementOptions(start2, mode);
      const sharedOptions = this.getSharedOptions(firstOpts);
      const includeOptions = this.includeOptions(mode, sharedOptions);
      const iAxis = iScale.axis;
      const vAxis = vScale.axis;
      const { spanGaps, segment } = this.options;
      const maxGapLength = isNumber(spanGaps) ? spanGaps : Number.POSITIVE_INFINITY;
      const directUpdate = this.chart._animationsDisabled || reset || mode === "none";
      let prevParsed = start2 > 0 && this.getParsed(start2 - 1);
      for (let i = start2; i < start2 + count; ++i) {
        const point = points[i];
        const parsed = this.getParsed(i);
        const properties = directUpdate ? point : {};
        const nullData = isNullOrUndef(parsed[vAxis]);
        const iPixel = properties[iAxis] = iScale.getPixelForValue(parsed[iAxis], i);
        const vPixel = properties[vAxis] = reset || nullData ? vScale.getBasePixel() : vScale.getPixelForValue(_stacked ? this.applyStack(vScale, parsed, _stacked) : parsed[vAxis], i);
        properties.skip = isNaN(iPixel) || isNaN(vPixel) || nullData;
        properties.stop = i > 0 && Math.abs(parsed[iAxis] - prevParsed[iAxis]) > maxGapLength;
        if (segment) {
          properties.parsed = parsed;
          properties.raw = _dataset.data[i];
        }
        if (includeOptions) {
          properties.options = sharedOptions || this.resolveDataElementOptions(i, point.active ? "active" : mode);
        }
        if (!directUpdate) {
          this.updateElement(point, i, properties, mode);
        }
        prevParsed = parsed;
      }
      this.updateSharedOptions(sharedOptions, mode, firstOpts);
    }
    getMaxOverflow() {
      const meta = this._cachedMeta;
      const data = meta.data || [];
      if (!this.options.showLine) {
        let max3 = 0;
        for (let i = data.length - 1; i >= 0; --i) {
          max3 = Math.max(max3, data[i].size(this.resolveDataElementOptions(i)) / 2);
        }
        return max3 > 0 && max3;
      }
      const dataset = meta.dataset;
      const border = dataset.options && dataset.options.borderWidth || 0;
      if (!data.length) {
        return border;
      }
      const firstPoint = data[0].size(this.resolveDataElementOptions(0));
      const lastPoint = data[data.length - 1].size(this.resolveDataElementOptions(data.length - 1));
      return Math.max(border, firstPoint, lastPoint) / 2;
    }
  };
  ScatterController.id = "scatter";
  ScatterController.defaults = {
    datasetElementType: false,
    dataElementType: "point",
    showLine: false,
    fill: false
  };
  ScatterController.overrides = {
    interaction: {
      mode: "point"
    },
    plugins: {
      tooltip: {
        callbacks: {
          title() {
            return "";
          },
          label(item) {
            return "(" + item.label + ", " + item.formattedValue + ")";
          }
        }
      }
    },
    scales: {
      x: {
        type: "linear"
      },
      y: {
        type: "linear"
      }
    }
  };
  var controllers = /* @__PURE__ */ Object.freeze({
    __proto__: null,
    BarController,
    BubbleController,
    DoughnutController,
    LineController,
    PolarAreaController,
    PieController,
    RadarController,
    ScatterController
  });
  function abstract() {
    throw new Error("This method is not implemented: Check that a complete date adapter is provided.");
  }
  var DateAdapter = class {
    constructor(options) {
      this.options = options || {};
    }
    init(chartOptions) {
    }
    formats() {
      return abstract();
    }
    parse(value, format2) {
      return abstract();
    }
    format(timestamp, format2) {
      return abstract();
    }
    add(timestamp, amount, unit) {
      return abstract();
    }
    diff(a, b, unit) {
      return abstract();
    }
    startOf(timestamp, unit, weekday2) {
      return abstract();
    }
    endOf(timestamp, unit) {
      return abstract();
    }
  };
  DateAdapter.override = function(members) {
    Object.assign(DateAdapter.prototype, members);
  };
  var adapters = {
    _date: DateAdapter
  };
  function binarySearch(metaset, axis, value, intersect) {
    const { controller, data, _sorted } = metaset;
    const iScale = controller._cachedMeta.iScale;
    if (iScale && axis === iScale.axis && axis !== "r" && _sorted && data.length) {
      const lookupMethod = iScale._reversePixels ? _rlookupByKey : _lookupByKey;
      if (!intersect) {
        return lookupMethod(data, axis, value);
      } else if (controller._sharedOptions) {
        const el = data[0];
        const range = typeof el.getRange === "function" && el.getRange(axis);
        if (range) {
          const start2 = lookupMethod(data, axis, value - range);
          const end = lookupMethod(data, axis, value + range);
          return { lo: start2.lo, hi: end.hi };
        }
      }
    }
    return { lo: 0, hi: data.length - 1 };
  }
  function evaluateInteractionItems(chart, axis, position, handler, intersect) {
    const metasets = chart.getSortedVisibleDatasetMetas();
    const value = position[axis];
    for (let i = 0, ilen = metasets.length; i < ilen; ++i) {
      const { index: index3, data } = metasets[i];
      const { lo, hi } = binarySearch(metasets[i], axis, value, intersect);
      for (let j = lo; j <= hi; ++j) {
        const element = data[j];
        if (!element.skip) {
          handler(element, index3, j);
        }
      }
    }
  }
  function getDistanceMetricForAxis(axis) {
    const useX = axis.indexOf("x") !== -1;
    const useY = axis.indexOf("y") !== -1;
    return function(pt1, pt2) {
      const deltaX = useX ? Math.abs(pt1.x - pt2.x) : 0;
      const deltaY = useY ? Math.abs(pt1.y - pt2.y) : 0;
      return Math.sqrt(Math.pow(deltaX, 2) + Math.pow(deltaY, 2));
    };
  }
  function getIntersectItems(chart, position, axis, useFinalPosition, includeInvisible) {
    const items = [];
    if (!includeInvisible && !chart.isPointInArea(position)) {
      return items;
    }
    const evaluationFunc = function(element, datasetIndex, index3) {
      if (!includeInvisible && !_isPointInArea(element, chart.chartArea, 0)) {
        return;
      }
      if (element.inRange(position.x, position.y, useFinalPosition)) {
        items.push({ element, datasetIndex, index: index3 });
      }
    };
    evaluateInteractionItems(chart, axis, position, evaluationFunc, true);
    return items;
  }
  function getNearestRadialItems(chart, position, axis, useFinalPosition) {
    let items = [];
    function evaluationFunc(element, datasetIndex, index3) {
      const { startAngle, endAngle } = element.getProps(["startAngle", "endAngle"], useFinalPosition);
      const { angle } = getAngleFromPoint(element, { x: position.x, y: position.y });
      if (_angleBetween(angle, startAngle, endAngle)) {
        items.push({ element, datasetIndex, index: index3 });
      }
    }
    evaluateInteractionItems(chart, axis, position, evaluationFunc);
    return items;
  }
  function getNearestCartesianItems(chart, position, axis, intersect, useFinalPosition, includeInvisible) {
    let items = [];
    const distanceMetric = getDistanceMetricForAxis(axis);
    let minDistance = Number.POSITIVE_INFINITY;
    function evaluationFunc(element, datasetIndex, index3) {
      const inRange2 = element.inRange(position.x, position.y, useFinalPosition);
      if (intersect && !inRange2) {
        return;
      }
      const center = element.getCenterPoint(useFinalPosition);
      const pointInArea = !!includeInvisible || chart.isPointInArea(center);
      if (!pointInArea && !inRange2) {
        return;
      }
      const distance = distanceMetric(position, center);
      if (distance < minDistance) {
        items = [{ element, datasetIndex, index: index3 }];
        minDistance = distance;
      } else if (distance === minDistance) {
        items.push({ element, datasetIndex, index: index3 });
      }
    }
    evaluateInteractionItems(chart, axis, position, evaluationFunc);
    return items;
  }
  function getNearestItems(chart, position, axis, intersect, useFinalPosition, includeInvisible) {
    if (!includeInvisible && !chart.isPointInArea(position)) {
      return [];
    }
    return axis === "r" && !intersect ? getNearestRadialItems(chart, position, axis, useFinalPosition) : getNearestCartesianItems(chart, position, axis, intersect, useFinalPosition, includeInvisible);
  }
  function getAxisItems(chart, position, axis, intersect, useFinalPosition) {
    const items = [];
    const rangeMethod = axis === "x" ? "inXRange" : "inYRange";
    let intersectsItem = false;
    evaluateInteractionItems(chart, axis, position, (element, datasetIndex, index3) => {
      if (element[rangeMethod](position[axis], useFinalPosition)) {
        items.push({ element, datasetIndex, index: index3 });
        intersectsItem = intersectsItem || element.inRange(position.x, position.y, useFinalPosition);
      }
    });
    if (intersect && !intersectsItem) {
      return [];
    }
    return items;
  }
  var Interaction = {
    evaluateInteractionItems,
    modes: {
      index(chart, e, options, useFinalPosition) {
        const position = getRelativePosition(e, chart);
        const axis = options.axis || "x";
        const includeInvisible = options.includeInvisible || false;
        const items = options.intersect ? getIntersectItems(chart, position, axis, useFinalPosition, includeInvisible) : getNearestItems(chart, position, axis, false, useFinalPosition, includeInvisible);
        const elements2 = [];
        if (!items.length) {
          return [];
        }
        chart.getSortedVisibleDatasetMetas().forEach((meta) => {
          const index3 = items[0].index;
          const element = meta.data[index3];
          if (element && !element.skip) {
            elements2.push({ element, datasetIndex: meta.index, index: index3 });
          }
        });
        return elements2;
      },
      dataset(chart, e, options, useFinalPosition) {
        const position = getRelativePosition(e, chart);
        const axis = options.axis || "xy";
        const includeInvisible = options.includeInvisible || false;
        let items = options.intersect ? getIntersectItems(chart, position, axis, useFinalPosition, includeInvisible) : getNearestItems(chart, position, axis, false, useFinalPosition, includeInvisible);
        if (items.length > 0) {
          const datasetIndex = items[0].datasetIndex;
          const data = chart.getDatasetMeta(datasetIndex).data;
          items = [];
          for (let i = 0; i < data.length; ++i) {
            items.push({ element: data[i], datasetIndex, index: i });
          }
        }
        return items;
      },
      point(chart, e, options, useFinalPosition) {
        const position = getRelativePosition(e, chart);
        const axis = options.axis || "xy";
        const includeInvisible = options.includeInvisible || false;
        return getIntersectItems(chart, position, axis, useFinalPosition, includeInvisible);
      },
      nearest(chart, e, options, useFinalPosition) {
        const position = getRelativePosition(e, chart);
        const axis = options.axis || "xy";
        const includeInvisible = options.includeInvisible || false;
        return getNearestItems(chart, position, axis, options.intersect, useFinalPosition, includeInvisible);
      },
      x(chart, e, options, useFinalPosition) {
        const position = getRelativePosition(e, chart);
        return getAxisItems(chart, position, "x", options.intersect, useFinalPosition);
      },
      y(chart, e, options, useFinalPosition) {
        const position = getRelativePosition(e, chart);
        return getAxisItems(chart, position, "y", options.intersect, useFinalPosition);
      }
    }
  };
  var STATIC_POSITIONS = ["left", "top", "right", "bottom"];
  function filterByPosition(array2, position) {
    return array2.filter((v) => v.pos === position);
  }
  function filterDynamicPositionByAxis(array2, axis) {
    return array2.filter((v) => STATIC_POSITIONS.indexOf(v.pos) === -1 && v.box.axis === axis);
  }
  function sortByWeight(array2, reverse) {
    return array2.sort((a, b) => {
      const v0 = reverse ? b : a;
      const v1 = reverse ? a : b;
      return v0.weight === v1.weight ? v0.index - v1.index : v0.weight - v1.weight;
    });
  }
  function wrapBoxes(boxes) {
    const layoutBoxes = [];
    let i, ilen, box, pos, stack, stackWeight;
    for (i = 0, ilen = (boxes || []).length; i < ilen; ++i) {
      box = boxes[i];
      ({ position: pos, options: { stack, stackWeight = 1 } } = box);
      layoutBoxes.push({
        index: i,
        box,
        pos,
        horizontal: box.isHorizontal(),
        weight: box.weight,
        stack: stack && pos + stack,
        stackWeight
      });
    }
    return layoutBoxes;
  }
  function buildStacks(layouts2) {
    const stacks = {};
    for (const wrap of layouts2) {
      const { stack, pos, stackWeight } = wrap;
      if (!stack || !STATIC_POSITIONS.includes(pos)) {
        continue;
      }
      const _stack = stacks[stack] || (stacks[stack] = { count: 0, placed: 0, weight: 0, size: 0 });
      _stack.count++;
      _stack.weight += stackWeight;
    }
    return stacks;
  }
  function setLayoutDims(layouts2, params) {
    const stacks = buildStacks(layouts2);
    const { vBoxMaxWidth, hBoxMaxHeight } = params;
    let i, ilen, layout2;
    for (i = 0, ilen = layouts2.length; i < ilen; ++i) {
      layout2 = layouts2[i];
      const { fullSize } = layout2.box;
      const stack = stacks[layout2.stack];
      const factor = stack && layout2.stackWeight / stack.weight;
      if (layout2.horizontal) {
        layout2.width = factor ? factor * vBoxMaxWidth : fullSize && params.availableWidth;
        layout2.height = hBoxMaxHeight;
      } else {
        layout2.width = vBoxMaxWidth;
        layout2.height = factor ? factor * hBoxMaxHeight : fullSize && params.availableHeight;
      }
    }
    return stacks;
  }
  function buildLayoutBoxes(boxes) {
    const layoutBoxes = wrapBoxes(boxes);
    const fullSize = sortByWeight(layoutBoxes.filter((wrap) => wrap.box.fullSize), true);
    const left = sortByWeight(filterByPosition(layoutBoxes, "left"), true);
    const right = sortByWeight(filterByPosition(layoutBoxes, "right"));
    const top = sortByWeight(filterByPosition(layoutBoxes, "top"), true);
    const bottom = sortByWeight(filterByPosition(layoutBoxes, "bottom"));
    const centerHorizontal = filterDynamicPositionByAxis(layoutBoxes, "x");
    const centerVertical = filterDynamicPositionByAxis(layoutBoxes, "y");
    return {
      fullSize,
      leftAndTop: left.concat(top),
      rightAndBottom: right.concat(centerVertical).concat(bottom).concat(centerHorizontal),
      chartArea: filterByPosition(layoutBoxes, "chartArea"),
      vertical: left.concat(right).concat(centerVertical),
      horizontal: top.concat(bottom).concat(centerHorizontal)
    };
  }
  function getCombinedMax(maxPadding, chartArea, a, b) {
    return Math.max(maxPadding[a], chartArea[a]) + Math.max(maxPadding[b], chartArea[b]);
  }
  function updateMaxPadding(maxPadding, boxPadding) {
    maxPadding.top = Math.max(maxPadding.top, boxPadding.top);
    maxPadding.left = Math.max(maxPadding.left, boxPadding.left);
    maxPadding.bottom = Math.max(maxPadding.bottom, boxPadding.bottom);
    maxPadding.right = Math.max(maxPadding.right, boxPadding.right);
  }
  function updateDims(chartArea, params, layout2, stacks) {
    const { pos, box } = layout2;
    const maxPadding = chartArea.maxPadding;
    if (!isObject(pos)) {
      if (layout2.size) {
        chartArea[pos] -= layout2.size;
      }
      const stack = stacks[layout2.stack] || { size: 0, count: 1 };
      stack.size = Math.max(stack.size, layout2.horizontal ? box.height : box.width);
      layout2.size = stack.size / stack.count;
      chartArea[pos] += layout2.size;
    }
    if (box.getPadding) {
      updateMaxPadding(maxPadding, box.getPadding());
    }
    const newWidth = Math.max(0, params.outerWidth - getCombinedMax(maxPadding, chartArea, "left", "right"));
    const newHeight = Math.max(0, params.outerHeight - getCombinedMax(maxPadding, chartArea, "top", "bottom"));
    const widthChanged = newWidth !== chartArea.w;
    const heightChanged = newHeight !== chartArea.h;
    chartArea.w = newWidth;
    chartArea.h = newHeight;
    return layout2.horizontal ? { same: widthChanged, other: heightChanged } : { same: heightChanged, other: widthChanged };
  }
  function handleMaxPadding(chartArea) {
    const maxPadding = chartArea.maxPadding;
    function updatePos(pos) {
      const change = Math.max(maxPadding[pos] - chartArea[pos], 0);
      chartArea[pos] += change;
      return change;
    }
    chartArea.y += updatePos("top");
    chartArea.x += updatePos("left");
    updatePos("right");
    updatePos("bottom");
  }
  function getMargins(horizontal, chartArea) {
    const maxPadding = chartArea.maxPadding;
    function marginForPositions(positions3) {
      const margin = { left: 0, top: 0, right: 0, bottom: 0 };
      positions3.forEach((pos) => {
        margin[pos] = Math.max(chartArea[pos], maxPadding[pos]);
      });
      return margin;
    }
    return horizontal ? marginForPositions(["left", "right"]) : marginForPositions(["top", "bottom"]);
  }
  function fitBoxes(boxes, chartArea, params, stacks) {
    const refitBoxes = [];
    let i, ilen, layout2, box, refit, changed;
    for (i = 0, ilen = boxes.length, refit = 0; i < ilen; ++i) {
      layout2 = boxes[i];
      box = layout2.box;
      box.update(
        layout2.width || chartArea.w,
        layout2.height || chartArea.h,
        getMargins(layout2.horizontal, chartArea)
      );
      const { same, other } = updateDims(chartArea, params, layout2, stacks);
      refit |= same && refitBoxes.length;
      changed = changed || other;
      if (!box.fullSize) {
        refitBoxes.push(layout2);
      }
    }
    return refit && fitBoxes(refitBoxes, chartArea, params, stacks) || changed;
  }
  function setBoxDims(box, left, top, width, height) {
    box.top = top;
    box.left = left;
    box.right = left + width;
    box.bottom = top + height;
    box.width = width;
    box.height = height;
  }
  function placeBoxes(boxes, chartArea, params, stacks) {
    const userPadding = params.padding;
    let { x, y } = chartArea;
    for (const layout2 of boxes) {
      const box = layout2.box;
      const stack = stacks[layout2.stack] || { count: 1, placed: 0, weight: 1 };
      const weight = layout2.stackWeight / stack.weight || 1;
      if (layout2.horizontal) {
        const width = chartArea.w * weight;
        const height = stack.size || box.height;
        if (defined(stack.start)) {
          y = stack.start;
        }
        if (box.fullSize) {
          setBoxDims(box, userPadding.left, y, params.outerWidth - userPadding.right - userPadding.left, height);
        } else {
          setBoxDims(box, chartArea.left + stack.placed, y, width, height);
        }
        stack.start = y;
        stack.placed += width;
        y = box.bottom;
      } else {
        const height = chartArea.h * weight;
        const width = stack.size || box.width;
        if (defined(stack.start)) {
          x = stack.start;
        }
        if (box.fullSize) {
          setBoxDims(box, x, userPadding.top, width, params.outerHeight - userPadding.bottom - userPadding.top);
        } else {
          setBoxDims(box, x, chartArea.top + stack.placed, width, height);
        }
        stack.start = x;
        stack.placed += height;
        x = box.right;
      }
    }
    chartArea.x = x;
    chartArea.y = y;
  }
  defaults.set("layout", {
    autoPadding: true,
    padding: {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    }
  });
  var layouts = {
    addBox(chart, item) {
      if (!chart.boxes) {
        chart.boxes = [];
      }
      item.fullSize = item.fullSize || false;
      item.position = item.position || "top";
      item.weight = item.weight || 0;
      item._layers = item._layers || function() {
        return [{
          z: 0,
          draw(chartArea) {
            item.draw(chartArea);
          }
        }];
      };
      chart.boxes.push(item);
    },
    removeBox(chart, layoutItem) {
      const index3 = chart.boxes ? chart.boxes.indexOf(layoutItem) : -1;
      if (index3 !== -1) {
        chart.boxes.splice(index3, 1);
      }
    },
    configure(chart, item, options) {
      item.fullSize = options.fullSize;
      item.position = options.position;
      item.weight = options.weight;
    },
    update(chart, width, height, minPadding) {
      if (!chart) {
        return;
      }
      const padding = toPadding(chart.options.layout.padding);
      const availableWidth = Math.max(width - padding.width, 0);
      const availableHeight = Math.max(height - padding.height, 0);
      const boxes = buildLayoutBoxes(chart.boxes);
      const verticalBoxes = boxes.vertical;
      const horizontalBoxes = boxes.horizontal;
      each(chart.boxes, (box) => {
        if (typeof box.beforeLayout === "function") {
          box.beforeLayout();
        }
      });
      const visibleVerticalBoxCount = verticalBoxes.reduce((total, wrap) => wrap.box.options && wrap.box.options.display === false ? total : total + 1, 0) || 1;
      const params = Object.freeze({
        outerWidth: width,
        outerHeight: height,
        padding,
        availableWidth,
        availableHeight,
        vBoxMaxWidth: availableWidth / 2 / visibleVerticalBoxCount,
        hBoxMaxHeight: availableHeight / 2
      });
      const maxPadding = Object.assign({}, padding);
      updateMaxPadding(maxPadding, toPadding(minPadding));
      const chartArea = Object.assign({
        maxPadding,
        w: availableWidth,
        h: availableHeight,
        x: padding.left,
        y: padding.top
      }, padding);
      const stacks = setLayoutDims(verticalBoxes.concat(horizontalBoxes), params);
      fitBoxes(boxes.fullSize, chartArea, params, stacks);
      fitBoxes(verticalBoxes, chartArea, params, stacks);
      if (fitBoxes(horizontalBoxes, chartArea, params, stacks)) {
        fitBoxes(verticalBoxes, chartArea, params, stacks);
      }
      handleMaxPadding(chartArea);
      placeBoxes(boxes.leftAndTop, chartArea, params, stacks);
      chartArea.x += chartArea.w;
      chartArea.y += chartArea.h;
      placeBoxes(boxes.rightAndBottom, chartArea, params, stacks);
      chart.chartArea = {
        left: chartArea.left,
        top: chartArea.top,
        right: chartArea.left + chartArea.w,
        bottom: chartArea.top + chartArea.h,
        height: chartArea.h,
        width: chartArea.w
      };
      each(boxes.chartArea, (layout2) => {
        const box = layout2.box;
        Object.assign(box, chart.chartArea);
        box.update(chartArea.w, chartArea.h, { left: 0, top: 0, right: 0, bottom: 0 });
      });
    }
  };
  var BasePlatform = class {
    acquireContext(canvas, aspectRatio) {
    }
    releaseContext(context) {
      return false;
    }
    addEventListener(chart, type2, listener) {
    }
    removeEventListener(chart, type2, listener) {
    }
    getDevicePixelRatio() {
      return 1;
    }
    getMaximumSize(element, width, height, aspectRatio) {
      width = Math.max(0, width || element.width);
      height = height || element.height;
      return {
        width,
        height: Math.max(0, aspectRatio ? Math.floor(width / aspectRatio) : height)
      };
    }
    isAttached(canvas) {
      return true;
    }
    updateConfig(config) {
    }
  };
  var BasicPlatform = class extends BasePlatform {
    acquireContext(item) {
      return item && item.getContext && item.getContext("2d") || null;
    }
    updateConfig(config) {
      config.options.animation = false;
    }
  };
  var EXPANDO_KEY = "$chartjs";
  var EVENT_TYPES = {
    touchstart: "mousedown",
    touchmove: "mousemove",
    touchend: "mouseup",
    pointerenter: "mouseenter",
    pointerdown: "mousedown",
    pointermove: "mousemove",
    pointerup: "mouseup",
    pointerleave: "mouseout",
    pointerout: "mouseout"
  };
  var isNullOrEmpty = (value) => value === null || value === "";
  function initCanvas(canvas, aspectRatio) {
    const style = canvas.style;
    const renderHeight = canvas.getAttribute("height");
    const renderWidth = canvas.getAttribute("width");
    canvas[EXPANDO_KEY] = {
      initial: {
        height: renderHeight,
        width: renderWidth,
        style: {
          display: style.display,
          height: style.height,
          width: style.width
        }
      }
    };
    style.display = style.display || "block";
    style.boxSizing = style.boxSizing || "border-box";
    if (isNullOrEmpty(renderWidth)) {
      const displayWidth = readUsedSize(canvas, "width");
      if (displayWidth !== void 0) {
        canvas.width = displayWidth;
      }
    }
    if (isNullOrEmpty(renderHeight)) {
      if (canvas.style.height === "") {
        canvas.height = canvas.width / (aspectRatio || 2);
      } else {
        const displayHeight = readUsedSize(canvas, "height");
        if (displayHeight !== void 0) {
          canvas.height = displayHeight;
        }
      }
    }
    return canvas;
  }
  var eventListenerOptions = supportsEventListenerOptions ? { passive: true } : false;
  function addListener(node, type2, listener) {
    node.addEventListener(type2, listener, eventListenerOptions);
  }
  function removeListener(chart, type2, listener) {
    chart.canvas.removeEventListener(type2, listener, eventListenerOptions);
  }
  function fromNativeEvent(event, chart) {
    const type2 = EVENT_TYPES[event.type] || event.type;
    const { x, y } = getRelativePosition(event, chart);
    return {
      type: type2,
      chart,
      native: event,
      x: x !== void 0 ? x : null,
      y: y !== void 0 ? y : null
    };
  }
  function nodeListContains(nodeList, canvas) {
    for (const node of nodeList) {
      if (node === canvas || node.contains(canvas)) {
        return true;
      }
    }
  }
  function createAttachObserver(chart, type2, listener) {
    const canvas = chart.canvas;
    const observer = new MutationObserver((entries) => {
      let trigger = false;
      for (const entry of entries) {
        trigger = trigger || nodeListContains(entry.addedNodes, canvas);
        trigger = trigger && !nodeListContains(entry.removedNodes, canvas);
      }
      if (trigger) {
        listener();
      }
    });
    observer.observe(document, { childList: true, subtree: true });
    return observer;
  }
  function createDetachObserver(chart, type2, listener) {
    const canvas = chart.canvas;
    const observer = new MutationObserver((entries) => {
      let trigger = false;
      for (const entry of entries) {
        trigger = trigger || nodeListContains(entry.removedNodes, canvas);
        trigger = trigger && !nodeListContains(entry.addedNodes, canvas);
      }
      if (trigger) {
        listener();
      }
    });
    observer.observe(document, { childList: true, subtree: true });
    return observer;
  }
  var drpListeningCharts = /* @__PURE__ */ new Map();
  var oldDevicePixelRatio = 0;
  function onWindowResize() {
    const dpr = window.devicePixelRatio;
    if (dpr === oldDevicePixelRatio) {
      return;
    }
    oldDevicePixelRatio = dpr;
    drpListeningCharts.forEach((resize, chart) => {
      if (chart.currentDevicePixelRatio !== dpr) {
        resize();
      }
    });
  }
  function listenDevicePixelRatioChanges(chart, resize) {
    if (!drpListeningCharts.size) {
      window.addEventListener("resize", onWindowResize);
    }
    drpListeningCharts.set(chart, resize);
  }
  function unlistenDevicePixelRatioChanges(chart) {
    drpListeningCharts.delete(chart);
    if (!drpListeningCharts.size) {
      window.removeEventListener("resize", onWindowResize);
    }
  }
  function createResizeObserver(chart, type2, listener) {
    const canvas = chart.canvas;
    const container = canvas && _getParentNode(canvas);
    if (!container) {
      return;
    }
    const resize = throttled((width, height) => {
      const w = container.clientWidth;
      listener(width, height);
      if (w < container.clientWidth) {
        listener();
      }
    }, window);
    const observer = new ResizeObserver((entries) => {
      const entry = entries[0];
      const width = entry.contentRect.width;
      const height = entry.contentRect.height;
      if (width === 0 && height === 0) {
        return;
      }
      resize(width, height);
    });
    observer.observe(container);
    listenDevicePixelRatioChanges(chart, resize);
    return observer;
  }
  function releaseObserver(chart, type2, observer) {
    if (observer) {
      observer.disconnect();
    }
    if (type2 === "resize") {
      unlistenDevicePixelRatioChanges(chart);
    }
  }
  function createProxyAndListen(chart, type2, listener) {
    const canvas = chart.canvas;
    const proxy = throttled((event) => {
      if (chart.ctx !== null) {
        listener(fromNativeEvent(event, chart));
      }
    }, chart, (args) => {
      const event = args[0];
      return [event, event.offsetX, event.offsetY];
    });
    addListener(canvas, type2, proxy);
    return proxy;
  }
  var DomPlatform = class extends BasePlatform {
    acquireContext(canvas, aspectRatio) {
      const context = canvas && canvas.getContext && canvas.getContext("2d");
      if (context && context.canvas === canvas) {
        initCanvas(canvas, aspectRatio);
        return context;
      }
      return null;
    }
    releaseContext(context) {
      const canvas = context.canvas;
      if (!canvas[EXPANDO_KEY]) {
        return false;
      }
      const initial = canvas[EXPANDO_KEY].initial;
      ["height", "width"].forEach((prop) => {
        const value = initial[prop];
        if (isNullOrUndef(value)) {
          canvas.removeAttribute(prop);
        } else {
          canvas.setAttribute(prop, value);
        }
      });
      const style = initial.style || {};
      Object.keys(style).forEach((key) => {
        canvas.style[key] = style[key];
      });
      canvas.width = canvas.width;
      delete canvas[EXPANDO_KEY];
      return true;
    }
    addEventListener(chart, type2, listener) {
      this.removeEventListener(chart, type2);
      const proxies = chart.$proxies || (chart.$proxies = {});
      const handlers = {
        attach: createAttachObserver,
        detach: createDetachObserver,
        resize: createResizeObserver
      };
      const handler = handlers[type2] || createProxyAndListen;
      proxies[type2] = handler(chart, type2, listener);
    }
    removeEventListener(chart, type2) {
      const proxies = chart.$proxies || (chart.$proxies = {});
      const proxy = proxies[type2];
      if (!proxy) {
        return;
      }
      const handlers = {
        attach: releaseObserver,
        detach: releaseObserver,
        resize: releaseObserver
      };
      const handler = handlers[type2] || removeListener;
      handler(chart, type2, proxy);
      proxies[type2] = void 0;
    }
    getDevicePixelRatio() {
      return window.devicePixelRatio;
    }
    getMaximumSize(canvas, width, height, aspectRatio) {
      return getMaximumSize(canvas, width, height, aspectRatio);
    }
    isAttached(canvas) {
      const container = _getParentNode(canvas);
      return !!(container && container.isConnected);
    }
  };
  function _detectPlatform(canvas) {
    if (!_isDomSupported() || typeof OffscreenCanvas !== "undefined" && canvas instanceof OffscreenCanvas) {
      return BasicPlatform;
    }
    return DomPlatform;
  }
  var PluginService = class {
    constructor() {
      this._init = [];
    }
    notify(chart, hook, args, filter2) {
      if (hook === "beforeInit") {
        this._init = this._createDescriptors(chart, true);
        this._notify(this._init, chart, "install");
      }
      const descriptors2 = filter2 ? this._descriptors(chart).filter(filter2) : this._descriptors(chart);
      const result = this._notify(descriptors2, chart, hook, args);
      if (hook === "afterDestroy") {
        this._notify(descriptors2, chart, "stop");
        this._notify(this._init, chart, "uninstall");
      }
      return result;
    }
    _notify(descriptors2, chart, hook, args) {
      args = args || {};
      for (const descriptor of descriptors2) {
        const plugin2 = descriptor.plugin;
        const method = plugin2[hook];
        const params = [chart, args, descriptor.options];
        if (callback(method, params, plugin2) === false && args.cancelable) {
          return false;
        }
      }
      return true;
    }
    invalidate() {
      if (!isNullOrUndef(this._cache)) {
        this._oldCache = this._cache;
        this._cache = void 0;
      }
    }
    _descriptors(chart) {
      if (this._cache) {
        return this._cache;
      }
      const descriptors2 = this._cache = this._createDescriptors(chart);
      this._notifyStateChanges(chart);
      return descriptors2;
    }
    _createDescriptors(chart, all) {
      const config = chart && chart.config;
      const options = valueOrDefault(config.options && config.options.plugins, {});
      const plugins6 = allPlugins(config);
      return options === false && !all ? [] : createDescriptors(chart, plugins6, options, all);
    }
    _notifyStateChanges(chart) {
      const previousDescriptors = this._oldCache || [];
      const descriptors2 = this._cache;
      const diff = (a, b) => a.filter((x) => !b.some((y) => x.plugin.id === y.plugin.id));
      this._notify(diff(previousDescriptors, descriptors2), chart, "stop");
      this._notify(diff(descriptors2, previousDescriptors), chart, "start");
    }
  };
  function allPlugins(config) {
    const localIds = {};
    const plugins6 = [];
    const keys = Object.keys(registry.plugins.items);
    for (let i = 0; i < keys.length; i++) {
      plugins6.push(registry.getPlugin(keys[i]));
    }
    const local = config.plugins || [];
    for (let i = 0; i < local.length; i++) {
      const plugin2 = local[i];
      if (plugins6.indexOf(plugin2) === -1) {
        plugins6.push(plugin2);
        localIds[plugin2.id] = true;
      }
    }
    return { plugins: plugins6, localIds };
  }
  function getOpts(options, all) {
    if (!all && options === false) {
      return null;
    }
    if (options === true) {
      return {};
    }
    return options;
  }
  function createDescriptors(chart, { plugins: plugins6, localIds }, options, all) {
    const result = [];
    const context = chart.getContext();
    for (const plugin2 of plugins6) {
      const id2 = plugin2.id;
      const opts = getOpts(options[id2], all);
      if (opts === null) {
        continue;
      }
      result.push({
        plugin: plugin2,
        options: pluginOpts(chart.config, { plugin: plugin2, local: localIds[id2] }, opts, context)
      });
    }
    return result;
  }
  function pluginOpts(config, { plugin: plugin2, local }, opts, context) {
    const keys = config.pluginScopeKeys(plugin2);
    const scopes = config.getOptionScopes(opts, keys);
    if (local && plugin2.defaults) {
      scopes.push(plugin2.defaults);
    }
    return config.createResolver(scopes, context, [""], {
      scriptable: false,
      indexable: false,
      allKeys: true
    });
  }
  function getIndexAxis(type2, options) {
    const datasetDefaults = defaults.datasets[type2] || {};
    const datasetOptions = (options.datasets || {})[type2] || {};
    return datasetOptions.indexAxis || options.indexAxis || datasetDefaults.indexAxis || "x";
  }
  function getAxisFromDefaultScaleID(id2, indexAxis) {
    let axis = id2;
    if (id2 === "_index_") {
      axis = indexAxis;
    } else if (id2 === "_value_") {
      axis = indexAxis === "x" ? "y" : "x";
    }
    return axis;
  }
  function getDefaultScaleIDFromAxis(axis, indexAxis) {
    return axis === indexAxis ? "_index_" : "_value_";
  }
  function axisFromPosition(position) {
    if (position === "top" || position === "bottom") {
      return "x";
    }
    if (position === "left" || position === "right") {
      return "y";
    }
  }
  function determineAxis(id2, scaleOptions) {
    if (id2 === "x" || id2 === "y") {
      return id2;
    }
    return scaleOptions.axis || axisFromPosition(scaleOptions.position) || id2.charAt(0).toLowerCase();
  }
  function mergeScaleConfig(config, options) {
    const chartDefaults = overrides[config.type] || { scales: {} };
    const configScales = options.scales || {};
    const chartIndexAxis = getIndexAxis(config.type, options);
    const firstIDs = /* @__PURE__ */ Object.create(null);
    const scales2 = /* @__PURE__ */ Object.create(null);
    Object.keys(configScales).forEach((id2) => {
      const scaleConf = configScales[id2];
      if (!isObject(scaleConf)) {
        return console.error(`Invalid scale configuration for scale: ${id2}`);
      }
      if (scaleConf._proxy) {
        return console.warn(`Ignoring resolver passed as options for scale: ${id2}`);
      }
      const axis = determineAxis(id2, scaleConf);
      const defaultId = getDefaultScaleIDFromAxis(axis, chartIndexAxis);
      const defaultScaleOptions = chartDefaults.scales || {};
      firstIDs[axis] = firstIDs[axis] || id2;
      scales2[id2] = mergeIf(/* @__PURE__ */ Object.create(null), [{ axis }, scaleConf, defaultScaleOptions[axis], defaultScaleOptions[defaultId]]);
    });
    config.data.datasets.forEach((dataset) => {
      const type2 = dataset.type || config.type;
      const indexAxis = dataset.indexAxis || getIndexAxis(type2, options);
      const datasetDefaults = overrides[type2] || {};
      const defaultScaleOptions = datasetDefaults.scales || {};
      Object.keys(defaultScaleOptions).forEach((defaultID) => {
        const axis = getAxisFromDefaultScaleID(defaultID, indexAxis);
        const id2 = dataset[axis + "AxisID"] || firstIDs[axis] || axis;
        scales2[id2] = scales2[id2] || /* @__PURE__ */ Object.create(null);
        mergeIf(scales2[id2], [{ axis }, configScales[id2], defaultScaleOptions[defaultID]]);
      });
    });
    Object.keys(scales2).forEach((key) => {
      const scale = scales2[key];
      mergeIf(scale, [defaults.scales[scale.type], defaults.scale]);
    });
    return scales2;
  }
  function initOptions(config) {
    const options = config.options || (config.options = {});
    options.plugins = valueOrDefault(options.plugins, {});
    options.scales = mergeScaleConfig(config, options);
  }
  function initData(data) {
    data = data || {};
    data.datasets = data.datasets || [];
    data.labels = data.labels || [];
    return data;
  }
  function initConfig(config) {
    config = config || {};
    config.data = initData(config.data);
    initOptions(config);
    return config;
  }
  var keyCache = /* @__PURE__ */ new Map();
  var keysCached = /* @__PURE__ */ new Set();
  function cachedKeys(cacheKey, generate) {
    let keys = keyCache.get(cacheKey);
    if (!keys) {
      keys = generate();
      keyCache.set(cacheKey, keys);
      keysCached.add(keys);
    }
    return keys;
  }
  var addIfFound = (set4, obj, key) => {
    const opts = resolveObjectKey(obj, key);
    if (opts !== void 0) {
      set4.add(opts);
    }
  };
  var Config = class {
    constructor(config) {
      this._config = initConfig(config);
      this._scopeCache = /* @__PURE__ */ new Map();
      this._resolverCache = /* @__PURE__ */ new Map();
    }
    get platform() {
      return this._config.platform;
    }
    get type() {
      return this._config.type;
    }
    set type(type2) {
      this._config.type = type2;
    }
    get data() {
      return this._config.data;
    }
    set data(data) {
      this._config.data = initData(data);
    }
    get options() {
      return this._config.options;
    }
    set options(options) {
      this._config.options = options;
    }
    get plugins() {
      return this._config.plugins;
    }
    update() {
      const config = this._config;
      this.clearCache();
      initOptions(config);
    }
    clearCache() {
      this._scopeCache.clear();
      this._resolverCache.clear();
    }
    datasetScopeKeys(datasetType) {
      return cachedKeys(
        datasetType,
        () => [[
          `datasets.${datasetType}`,
          ""
        ]]
      );
    }
    datasetAnimationScopeKeys(datasetType, transition2) {
      return cachedKeys(
        `${datasetType}.transition.${transition2}`,
        () => [
          [
            `datasets.${datasetType}.transitions.${transition2}`,
            `transitions.${transition2}`
          ],
          [
            `datasets.${datasetType}`,
            ""
          ]
        ]
      );
    }
    datasetElementScopeKeys(datasetType, elementType) {
      return cachedKeys(
        `${datasetType}-${elementType}`,
        () => [[
          `datasets.${datasetType}.elements.${elementType}`,
          `datasets.${datasetType}`,
          `elements.${elementType}`,
          ""
        ]]
      );
    }
    pluginScopeKeys(plugin2) {
      const id2 = plugin2.id;
      const type2 = this.type;
      return cachedKeys(
        `${type2}-plugin-${id2}`,
        () => [[
          `plugins.${id2}`,
          ...plugin2.additionalOptionScopes || []
        ]]
      );
    }
    _cachedScopes(mainScope, resetCache) {
      const _scopeCache = this._scopeCache;
      let cache = _scopeCache.get(mainScope);
      if (!cache || resetCache) {
        cache = /* @__PURE__ */ new Map();
        _scopeCache.set(mainScope, cache);
      }
      return cache;
    }
    getOptionScopes(mainScope, keyLists, resetCache) {
      const { options, type: type2 } = this;
      const cache = this._cachedScopes(mainScope, resetCache);
      const cached = cache.get(keyLists);
      if (cached) {
        return cached;
      }
      const scopes = /* @__PURE__ */ new Set();
      keyLists.forEach((keys) => {
        if (mainScope) {
          scopes.add(mainScope);
          keys.forEach((key) => addIfFound(scopes, mainScope, key));
        }
        keys.forEach((key) => addIfFound(scopes, options, key));
        keys.forEach((key) => addIfFound(scopes, overrides[type2] || {}, key));
        keys.forEach((key) => addIfFound(scopes, defaults, key));
        keys.forEach((key) => addIfFound(scopes, descriptors, key));
      });
      const array2 = Array.from(scopes);
      if (array2.length === 0) {
        array2.push(/* @__PURE__ */ Object.create(null));
      }
      if (keysCached.has(keyLists)) {
        cache.set(keyLists, array2);
      }
      return array2;
    }
    chartOptionScopes() {
      const { options, type: type2 } = this;
      return [
        options,
        overrides[type2] || {},
        defaults.datasets[type2] || {},
        { type: type2 },
        defaults,
        descriptors
      ];
    }
    resolveNamedOptions(scopes, names2, context, prefixes2 = [""]) {
      const result = { $shared: true };
      const { resolver, subPrefixes } = getResolver(this._resolverCache, scopes, prefixes2);
      let options = resolver;
      if (needContext(resolver, names2)) {
        result.$shared = false;
        context = isFunction(context) ? context() : context;
        const subResolver = this.createResolver(scopes, context, subPrefixes);
        options = _attachContext(resolver, context, subResolver);
      }
      for (const prop of names2) {
        result[prop] = options[prop];
      }
      return result;
    }
    createResolver(scopes, context, prefixes2 = [""], descriptorDefaults) {
      const { resolver } = getResolver(this._resolverCache, scopes, prefixes2);
      return isObject(context) ? _attachContext(resolver, context, void 0, descriptorDefaults) : resolver;
    }
  };
  function getResolver(resolverCache, scopes, prefixes2) {
    let cache = resolverCache.get(scopes);
    if (!cache) {
      cache = /* @__PURE__ */ new Map();
      resolverCache.set(scopes, cache);
    }
    const cacheKey = prefixes2.join();
    let cached = cache.get(cacheKey);
    if (!cached) {
      const resolver = _createResolver(scopes, prefixes2);
      cached = {
        resolver,
        subPrefixes: prefixes2.filter((p) => !p.toLowerCase().includes("hover"))
      };
      cache.set(cacheKey, cached);
    }
    return cached;
  }
  var hasFunction = (value) => isObject(value) && Object.getOwnPropertyNames(value).reduce((acc, key) => acc || isFunction(value[key]), false);
  function needContext(proxy, names2) {
    const { isScriptable, isIndexable } = _descriptors(proxy);
    for (const prop of names2) {
      const scriptable = isScriptable(prop);
      const indexable = isIndexable(prop);
      const value = (indexable || scriptable) && proxy[prop];
      if (scriptable && (isFunction(value) || hasFunction(value)) || indexable && isArray(value)) {
        return true;
      }
    }
    return false;
  }
  var version = "3.9.1";
  var KNOWN_POSITIONS = ["top", "bottom", "left", "right", "chartArea"];
  function positionIsHorizontal(position, axis) {
    return position === "top" || position === "bottom" || KNOWN_POSITIONS.indexOf(position) === -1 && axis === "x";
  }
  function compare2Level(l1, l2) {
    return function(a, b) {
      return a[l1] === b[l1] ? a[l2] - b[l2] : a[l1] - b[l1];
    };
  }
  function onAnimationsComplete(context) {
    const chart = context.chart;
    const animationOptions2 = chart.options.animation;
    chart.notifyPlugins("afterRender");
    callback(animationOptions2 && animationOptions2.onComplete, [context], chart);
  }
  function onAnimationProgress(context) {
    const chart = context.chart;
    const animationOptions2 = chart.options.animation;
    callback(animationOptions2 && animationOptions2.onProgress, [context], chart);
  }
  function getCanvas(item) {
    if (_isDomSupported() && typeof item === "string") {
      item = document.getElementById(item);
    } else if (item && item.length) {
      item = item[0];
    }
    if (item && item.canvas) {
      item = item.canvas;
    }
    return item;
  }
  var instances = {};
  var getChart = (key) => {
    const canvas = getCanvas(key);
    return Object.values(instances).filter((c) => c.canvas === canvas).pop();
  };
  function moveNumericKeys(obj, start2, move) {
    const keys = Object.keys(obj);
    for (const key of keys) {
      const intKey = +key;
      if (intKey >= start2) {
        const value = obj[key];
        delete obj[key];
        if (move > 0 || intKey > start2) {
          obj[intKey + move] = value;
        }
      }
    }
  }
  function determineLastEvent(e, lastEvent, inChartArea, isClick) {
    if (!inChartArea || e.type === "mouseout") {
      return null;
    }
    if (isClick) {
      return lastEvent;
    }
    return e;
  }
  var Chart = class {
    constructor(item, userConfig) {
      const config = this.config = new Config(userConfig);
      const initialCanvas = getCanvas(item);
      const existingChart = getChart(initialCanvas);
      if (existingChart) {
        throw new Error(
          "Canvas is already in use. Chart with ID '" + existingChart.id + "' must be destroyed before the canvas with ID '" + existingChart.canvas.id + "' can be reused."
        );
      }
      const options = config.createResolver(config.chartOptionScopes(), this.getContext());
      this.platform = new (config.platform || _detectPlatform(initialCanvas))();
      this.platform.updateConfig(config);
      const context = this.platform.acquireContext(initialCanvas, options.aspectRatio);
      const canvas = context && context.canvas;
      const height = canvas && canvas.height;
      const width = canvas && canvas.width;
      this.id = uid();
      this.ctx = context;
      this.canvas = canvas;
      this.width = width;
      this.height = height;
      this._options = options;
      this._aspectRatio = this.aspectRatio;
      this._layers = [];
      this._metasets = [];
      this._stacks = void 0;
      this.boxes = [];
      this.currentDevicePixelRatio = void 0;
      this.chartArea = void 0;
      this._active = [];
      this._lastEvent = void 0;
      this._listeners = {};
      this._responsiveListeners = void 0;
      this._sortedMetasets = [];
      this.scales = {};
      this._plugins = new PluginService();
      this.$proxies = {};
      this._hiddenIndices = {};
      this.attached = false;
      this._animationsDisabled = void 0;
      this.$context = void 0;
      this._doResize = debounce((mode) => this.update(mode), options.resizeDelay || 0);
      this._dataChanges = [];
      instances[this.id] = this;
      if (!context || !canvas) {
        console.error("Failed to create chart: can't acquire context from the given item");
        return;
      }
      animator.listen(this, "complete", onAnimationsComplete);
      animator.listen(this, "progress", onAnimationProgress);
      this._initialize();
      if (this.attached) {
        this.update();
      }
    }
    get aspectRatio() {
      const { options: { aspectRatio, maintainAspectRatio }, width, height, _aspectRatio } = this;
      if (!isNullOrUndef(aspectRatio)) {
        return aspectRatio;
      }
      if (maintainAspectRatio && _aspectRatio) {
        return _aspectRatio;
      }
      return height ? width / height : null;
    }
    get data() {
      return this.config.data;
    }
    set data(data) {
      this.config.data = data;
    }
    get options() {
      return this._options;
    }
    set options(options) {
      this.config.options = options;
    }
    _initialize() {
      this.notifyPlugins("beforeInit");
      if (this.options.responsive) {
        this.resize();
      } else {
        retinaScale(this, this.options.devicePixelRatio);
      }
      this.bindEvents();
      this.notifyPlugins("afterInit");
      return this;
    }
    clear() {
      clearCanvas(this.canvas, this.ctx);
      return this;
    }
    stop() {
      animator.stop(this);
      return this;
    }
    resize(width, height) {
      if (!animator.running(this)) {
        this._resize(width, height);
      } else {
        this._resizeBeforeDraw = { width, height };
      }
    }
    _resize(width, height) {
      const options = this.options;
      const canvas = this.canvas;
      const aspectRatio = options.maintainAspectRatio && this.aspectRatio;
      const newSize = this.platform.getMaximumSize(canvas, width, height, aspectRatio);
      const newRatio = options.devicePixelRatio || this.platform.getDevicePixelRatio();
      const mode = this.width ? "resize" : "attach";
      this.width = newSize.width;
      this.height = newSize.height;
      this._aspectRatio = this.aspectRatio;
      if (!retinaScale(this, newRatio, true)) {
        return;
      }
      this.notifyPlugins("resize", { size: newSize });
      callback(options.onResize, [this, newSize], this);
      if (this.attached) {
        if (this._doResize(mode)) {
          this.render();
        }
      }
    }
    ensureScalesHaveIDs() {
      const options = this.options;
      const scalesOptions = options.scales || {};
      each(scalesOptions, (axisOptions, axisID) => {
        axisOptions.id = axisID;
      });
    }
    buildOrUpdateScales() {
      const options = this.options;
      const scaleOpts = options.scales;
      const scales2 = this.scales;
      const updated = Object.keys(scales2).reduce((obj, id2) => {
        obj[id2] = false;
        return obj;
      }, {});
      let items = [];
      if (scaleOpts) {
        items = items.concat(
          Object.keys(scaleOpts).map((id2) => {
            const scaleOptions = scaleOpts[id2];
            const axis = determineAxis(id2, scaleOptions);
            const isRadial = axis === "r";
            const isHorizontal = axis === "x";
            return {
              options: scaleOptions,
              dposition: isRadial ? "chartArea" : isHorizontal ? "bottom" : "left",
              dtype: isRadial ? "radialLinear" : isHorizontal ? "category" : "linear"
            };
          })
        );
      }
      each(items, (item) => {
        const scaleOptions = item.options;
        const id2 = scaleOptions.id;
        const axis = determineAxis(id2, scaleOptions);
        const scaleType = valueOrDefault(scaleOptions.type, item.dtype);
        if (scaleOptions.position === void 0 || positionIsHorizontal(scaleOptions.position, axis) !== positionIsHorizontal(item.dposition)) {
          scaleOptions.position = item.dposition;
        }
        updated[id2] = true;
        let scale = null;
        if (id2 in scales2 && scales2[id2].type === scaleType) {
          scale = scales2[id2];
        } else {
          const scaleClass = registry.getScale(scaleType);
          scale = new scaleClass({
            id: id2,
            type: scaleType,
            ctx: this.ctx,
            chart: this
          });
          scales2[scale.id] = scale;
        }
        scale.init(scaleOptions, options);
      });
      each(updated, (hasUpdated, id2) => {
        if (!hasUpdated) {
          delete scales2[id2];
        }
      });
      each(scales2, (scale) => {
        layouts.configure(this, scale, scale.options);
        layouts.addBox(this, scale);
      });
    }
    _updateMetasets() {
      const metasets = this._metasets;
      const numData = this.data.datasets.length;
      const numMeta = metasets.length;
      metasets.sort((a, b) => a.index - b.index);
      if (numMeta > numData) {
        for (let i = numData; i < numMeta; ++i) {
          this._destroyDatasetMeta(i);
        }
        metasets.splice(numData, numMeta - numData);
      }
      this._sortedMetasets = metasets.slice(0).sort(compare2Level("order", "index"));
    }
    _removeUnreferencedMetasets() {
      const { _metasets: metasets, data: { datasets } } = this;
      if (metasets.length > datasets.length) {
        delete this._stacks;
      }
      metasets.forEach((meta, index3) => {
        if (datasets.filter((x) => x === meta._dataset).length === 0) {
          this._destroyDatasetMeta(index3);
        }
      });
    }
    buildOrUpdateControllers() {
      const newControllers = [];
      const datasets = this.data.datasets;
      let i, ilen;
      this._removeUnreferencedMetasets();
      for (i = 0, ilen = datasets.length; i < ilen; i++) {
        const dataset = datasets[i];
        let meta = this.getDatasetMeta(i);
        const type2 = dataset.type || this.config.type;
        if (meta.type && meta.type !== type2) {
          this._destroyDatasetMeta(i);
          meta = this.getDatasetMeta(i);
        }
        meta.type = type2;
        meta.indexAxis = dataset.indexAxis || getIndexAxis(type2, this.options);
        meta.order = dataset.order || 0;
        meta.index = i;
        meta.label = "" + dataset.label;
        meta.visible = this.isDatasetVisible(i);
        if (meta.controller) {
          meta.controller.updateIndex(i);
          meta.controller.linkScales();
        } else {
          const ControllerClass = registry.getController(type2);
          const { datasetElementType, dataElementType } = defaults.datasets[type2];
          Object.assign(ControllerClass.prototype, {
            dataElementType: registry.getElement(dataElementType),
            datasetElementType: datasetElementType && registry.getElement(datasetElementType)
          });
          meta.controller = new ControllerClass(this, i);
          newControllers.push(meta.controller);
        }
      }
      this._updateMetasets();
      return newControllers;
    }
    _resetElements() {
      each(this.data.datasets, (dataset, datasetIndex) => {
        this.getDatasetMeta(datasetIndex).controller.reset();
      }, this);
    }
    reset() {
      this._resetElements();
      this.notifyPlugins("reset");
    }
    update(mode) {
      const config = this.config;
      config.update();
      const options = this._options = config.createResolver(config.chartOptionScopes(), this.getContext());
      const animsDisabled = this._animationsDisabled = !options.animation;
      this._updateScales();
      this._checkEventBindings();
      this._updateHiddenIndices();
      this._plugins.invalidate();
      if (this.notifyPlugins("beforeUpdate", { mode, cancelable: true }) === false) {
        return;
      }
      const newControllers = this.buildOrUpdateControllers();
      this.notifyPlugins("beforeElementsUpdate");
      let minPadding = 0;
      for (let i = 0, ilen = this.data.datasets.length; i < ilen; i++) {
        const { controller } = this.getDatasetMeta(i);
        const reset = !animsDisabled && newControllers.indexOf(controller) === -1;
        controller.buildOrUpdateElements(reset);
        minPadding = Math.max(+controller.getMaxOverflow(), minPadding);
      }
      minPadding = this._minPadding = options.layout.autoPadding ? minPadding : 0;
      this._updateLayout(minPadding);
      if (!animsDisabled) {
        each(newControllers, (controller) => {
          controller.reset();
        });
      }
      this._updateDatasets(mode);
      this.notifyPlugins("afterUpdate", { mode });
      this._layers.sort(compare2Level("z", "_idx"));
      const { _active, _lastEvent } = this;
      if (_lastEvent) {
        this._eventHandler(_lastEvent, true);
      } else if (_active.length) {
        this._updateHoverStyles(_active, _active, true);
      }
      this.render();
    }
    _updateScales() {
      each(this.scales, (scale) => {
        layouts.removeBox(this, scale);
      });
      this.ensureScalesHaveIDs();
      this.buildOrUpdateScales();
    }
    _checkEventBindings() {
      const options = this.options;
      const existingEvents = new Set(Object.keys(this._listeners));
      const newEvents = new Set(options.events);
      if (!setsEqual(existingEvents, newEvents) || !!this._responsiveListeners !== options.responsive) {
        this.unbindEvents();
        this.bindEvents();
      }
    }
    _updateHiddenIndices() {
      const { _hiddenIndices } = this;
      const changes = this._getUniformDataChanges() || [];
      for (const { method, start: start2, count } of changes) {
        const move = method === "_removeElements" ? -count : count;
        moveNumericKeys(_hiddenIndices, start2, move);
      }
    }
    _getUniformDataChanges() {
      const _dataChanges = this._dataChanges;
      if (!_dataChanges || !_dataChanges.length) {
        return;
      }
      this._dataChanges = [];
      const datasetCount = this.data.datasets.length;
      const makeSet = (idx) => new Set(
        _dataChanges.filter((c) => c[0] === idx).map((c, i) => i + "," + c.splice(1).join(","))
      );
      const changeSet = makeSet(0);
      for (let i = 1; i < datasetCount; i++) {
        if (!setsEqual(changeSet, makeSet(i))) {
          return;
        }
      }
      return Array.from(changeSet).map((c) => c.split(",")).map((a) => ({ method: a[1], start: +a[2], count: +a[3] }));
    }
    _updateLayout(minPadding) {
      if (this.notifyPlugins("beforeLayout", { cancelable: true }) === false) {
        return;
      }
      layouts.update(this, this.width, this.height, minPadding);
      const area = this.chartArea;
      const noArea = area.width <= 0 || area.height <= 0;
      this._layers = [];
      each(this.boxes, (box) => {
        if (noArea && box.position === "chartArea") {
          return;
        }
        if (box.configure) {
          box.configure();
        }
        this._layers.push(...box._layers());
      }, this);
      this._layers.forEach((item, index3) => {
        item._idx = index3;
      });
      this.notifyPlugins("afterLayout");
    }
    _updateDatasets(mode) {
      if (this.notifyPlugins("beforeDatasetsUpdate", { mode, cancelable: true }) === false) {
        return;
      }
      for (let i = 0, ilen = this.data.datasets.length; i < ilen; ++i) {
        this.getDatasetMeta(i).controller.configure();
      }
      for (let i = 0, ilen = this.data.datasets.length; i < ilen; ++i) {
        this._updateDataset(i, isFunction(mode) ? mode({ datasetIndex: i }) : mode);
      }
      this.notifyPlugins("afterDatasetsUpdate", { mode });
    }
    _updateDataset(index3, mode) {
      const meta = this.getDatasetMeta(index3);
      const args = { meta, index: index3, mode, cancelable: true };
      if (this.notifyPlugins("beforeDatasetUpdate", args) === false) {
        return;
      }
      meta.controller._update(mode);
      args.cancelable = false;
      this.notifyPlugins("afterDatasetUpdate", args);
    }
    render() {
      if (this.notifyPlugins("beforeRender", { cancelable: true }) === false) {
        return;
      }
      if (animator.has(this)) {
        if (this.attached && !animator.running(this)) {
          animator.start(this);
        }
      } else {
        this.draw();
        onAnimationsComplete({ chart: this });
      }
    }
    draw() {
      let i;
      if (this._resizeBeforeDraw) {
        const { width, height } = this._resizeBeforeDraw;
        this._resize(width, height);
        this._resizeBeforeDraw = null;
      }
      this.clear();
      if (this.width <= 0 || this.height <= 0) {
        return;
      }
      if (this.notifyPlugins("beforeDraw", { cancelable: true }) === false) {
        return;
      }
      const layers = this._layers;
      for (i = 0; i < layers.length && layers[i].z <= 0; ++i) {
        layers[i].draw(this.chartArea);
      }
      this._drawDatasets();
      for (; i < layers.length; ++i) {
        layers[i].draw(this.chartArea);
      }
      this.notifyPlugins("afterDraw");
    }
    _getSortedDatasetMetas(filterVisible) {
      const metasets = this._sortedMetasets;
      const result = [];
      let i, ilen;
      for (i = 0, ilen = metasets.length; i < ilen; ++i) {
        const meta = metasets[i];
        if (!filterVisible || meta.visible) {
          result.push(meta);
        }
      }
      return result;
    }
    getSortedVisibleDatasetMetas() {
      return this._getSortedDatasetMetas(true);
    }
    _drawDatasets() {
      if (this.notifyPlugins("beforeDatasetsDraw", { cancelable: true }) === false) {
        return;
      }
      const metasets = this.getSortedVisibleDatasetMetas();
      for (let i = metasets.length - 1; i >= 0; --i) {
        this._drawDataset(metasets[i]);
      }
      this.notifyPlugins("afterDatasetsDraw");
    }
    _drawDataset(meta) {
      const ctx = this.ctx;
      const clip = meta._clip;
      const useClip = !clip.disabled;
      const area = this.chartArea;
      const args = {
        meta,
        index: meta.index,
        cancelable: true
      };
      if (this.notifyPlugins("beforeDatasetDraw", args) === false) {
        return;
      }
      if (useClip) {
        clipArea(ctx, {
          left: clip.left === false ? 0 : area.left - clip.left,
          right: clip.right === false ? this.width : area.right + clip.right,
          top: clip.top === false ? 0 : area.top - clip.top,
          bottom: clip.bottom === false ? this.height : area.bottom + clip.bottom
        });
      }
      meta.controller.draw();
      if (useClip) {
        unclipArea(ctx);
      }
      args.cancelable = false;
      this.notifyPlugins("afterDatasetDraw", args);
    }
    isPointInArea(point) {
      return _isPointInArea(point, this.chartArea, this._minPadding);
    }
    getElementsAtEventForMode(e, mode, options, useFinalPosition) {
      const method = Interaction.modes[mode];
      if (typeof method === "function") {
        return method(this, e, options, useFinalPosition);
      }
      return [];
    }
    getDatasetMeta(datasetIndex) {
      const dataset = this.data.datasets[datasetIndex];
      const metasets = this._metasets;
      let meta = metasets.filter((x) => x && x._dataset === dataset).pop();
      if (!meta) {
        meta = {
          type: null,
          data: [],
          dataset: null,
          controller: null,
          hidden: null,
          xAxisID: null,
          yAxisID: null,
          order: dataset && dataset.order || 0,
          index: datasetIndex,
          _dataset: dataset,
          _parsed: [],
          _sorted: false
        };
        metasets.push(meta);
      }
      return meta;
    }
    getContext() {
      return this.$context || (this.$context = createContext(null, { chart: this, type: "chart" }));
    }
    getVisibleDatasetCount() {
      return this.getSortedVisibleDatasetMetas().length;
    }
    isDatasetVisible(datasetIndex) {
      const dataset = this.data.datasets[datasetIndex];
      if (!dataset) {
        return false;
      }
      const meta = this.getDatasetMeta(datasetIndex);
      return typeof meta.hidden === "boolean" ? !meta.hidden : !dataset.hidden;
    }
    setDatasetVisibility(datasetIndex, visible) {
      const meta = this.getDatasetMeta(datasetIndex);
      meta.hidden = !visible;
    }
    toggleDataVisibility(index3) {
      this._hiddenIndices[index3] = !this._hiddenIndices[index3];
    }
    getDataVisibility(index3) {
      return !this._hiddenIndices[index3];
    }
    _updateVisibility(datasetIndex, dataIndex, visible) {
      const mode = visible ? "show" : "hide";
      const meta = this.getDatasetMeta(datasetIndex);
      const anims = meta.controller._resolveAnimations(void 0, mode);
      if (defined(dataIndex)) {
        meta.data[dataIndex].hidden = !visible;
        this.update();
      } else {
        this.setDatasetVisibility(datasetIndex, visible);
        anims.update(meta, { visible });
        this.update((ctx) => ctx.datasetIndex === datasetIndex ? mode : void 0);
      }
    }
    hide(datasetIndex, dataIndex) {
      this._updateVisibility(datasetIndex, dataIndex, false);
    }
    show(datasetIndex, dataIndex) {
      this._updateVisibility(datasetIndex, dataIndex, true);
    }
    _destroyDatasetMeta(datasetIndex) {
      const meta = this._metasets[datasetIndex];
      if (meta && meta.controller) {
        meta.controller._destroy();
      }
      delete this._metasets[datasetIndex];
    }
    _stop() {
      let i, ilen;
      this.stop();
      animator.remove(this);
      for (i = 0, ilen = this.data.datasets.length; i < ilen; ++i) {
        this._destroyDatasetMeta(i);
      }
    }
    destroy() {
      this.notifyPlugins("beforeDestroy");
      const { canvas, ctx } = this;
      this._stop();
      this.config.clearCache();
      if (canvas) {
        this.unbindEvents();
        clearCanvas(canvas, ctx);
        this.platform.releaseContext(ctx);
        this.canvas = null;
        this.ctx = null;
      }
      this.notifyPlugins("destroy");
      delete instances[this.id];
      this.notifyPlugins("afterDestroy");
    }
    toBase64Image(...args) {
      return this.canvas.toDataURL(...args);
    }
    bindEvents() {
      this.bindUserEvents();
      if (this.options.responsive) {
        this.bindResponsiveEvents();
      } else {
        this.attached = true;
      }
    }
    bindUserEvents() {
      const listeners = this._listeners;
      const platform = this.platform;
      const _add = (type2, listener2) => {
        platform.addEventListener(this, type2, listener2);
        listeners[type2] = listener2;
      };
      const listener = (e, x, y) => {
        e.offsetX = x;
        e.offsetY = y;
        this._eventHandler(e);
      };
      each(this.options.events, (type2) => _add(type2, listener));
    }
    bindResponsiveEvents() {
      if (!this._responsiveListeners) {
        this._responsiveListeners = {};
      }
      const listeners = this._responsiveListeners;
      const platform = this.platform;
      const _add = (type2, listener2) => {
        platform.addEventListener(this, type2, listener2);
        listeners[type2] = listener2;
      };
      const _remove = (type2, listener2) => {
        if (listeners[type2]) {
          platform.removeEventListener(this, type2, listener2);
          delete listeners[type2];
        }
      };
      const listener = (width, height) => {
        if (this.canvas) {
          this.resize(width, height);
        }
      };
      let detached;
      const attached = () => {
        _remove("attach", attached);
        this.attached = true;
        this.resize();
        _add("resize", listener);
        _add("detach", detached);
      };
      detached = () => {
        this.attached = false;
        _remove("resize", listener);
        this._stop();
        this._resize(0, 0);
        _add("attach", attached);
      };
      if (platform.isAttached(this.canvas)) {
        attached();
      } else {
        detached();
      }
    }
    unbindEvents() {
      each(this._listeners, (listener, type2) => {
        this.platform.removeEventListener(this, type2, listener);
      });
      this._listeners = {};
      each(this._responsiveListeners, (listener, type2) => {
        this.platform.removeEventListener(this, type2, listener);
      });
      this._responsiveListeners = void 0;
    }
    updateHoverStyle(items, mode, enabled) {
      const prefix = enabled ? "set" : "remove";
      let meta, item, i, ilen;
      if (mode === "dataset") {
        meta = this.getDatasetMeta(items[0].datasetIndex);
        meta.controller["_" + prefix + "DatasetHoverStyle"]();
      }
      for (i = 0, ilen = items.length; i < ilen; ++i) {
        item = items[i];
        const controller = item && this.getDatasetMeta(item.datasetIndex).controller;
        if (controller) {
          controller[prefix + "HoverStyle"](item.element, item.datasetIndex, item.index);
        }
      }
    }
    getActiveElements() {
      return this._active || [];
    }
    setActiveElements(activeElements) {
      const lastActive = this._active || [];
      const active = activeElements.map(({ datasetIndex, index: index3 }) => {
        const meta = this.getDatasetMeta(datasetIndex);
        if (!meta) {
          throw new Error("No dataset found at index " + datasetIndex);
        }
        return {
          datasetIndex,
          element: meta.data[index3],
          index: index3
        };
      });
      const changed = !_elementsEqual(active, lastActive);
      if (changed) {
        this._active = active;
        this._lastEvent = null;
        this._updateHoverStyles(active, lastActive);
      }
    }
    notifyPlugins(hook, args, filter2) {
      return this._plugins.notify(this, hook, args, filter2);
    }
    _updateHoverStyles(active, lastActive, replay) {
      const hoverOptions = this.options.hover;
      const diff = (a, b) => a.filter((x) => !b.some((y) => x.datasetIndex === y.datasetIndex && x.index === y.index));
      const deactivated = diff(lastActive, active);
      const activated = replay ? active : diff(active, lastActive);
      if (deactivated.length) {
        this.updateHoverStyle(deactivated, hoverOptions.mode, false);
      }
      if (activated.length && hoverOptions.mode) {
        this.updateHoverStyle(activated, hoverOptions.mode, true);
      }
    }
    _eventHandler(e, replay) {
      const args = {
        event: e,
        replay,
        cancelable: true,
        inChartArea: this.isPointInArea(e)
      };
      const eventFilter = (plugin2) => (plugin2.options.events || this.options.events).includes(e.native.type);
      if (this.notifyPlugins("beforeEvent", args, eventFilter) === false) {
        return;
      }
      const changed = this._handleEvent(e, replay, args.inChartArea);
      args.cancelable = false;
      this.notifyPlugins("afterEvent", args, eventFilter);
      if (changed || args.changed) {
        this.render();
      }
      return this;
    }
    _handleEvent(e, replay, inChartArea) {
      const { _active: lastActive = [], options } = this;
      const useFinalPosition = replay;
      const active = this._getActiveElements(e, lastActive, inChartArea, useFinalPosition);
      const isClick = _isClickEvent(e);
      const lastEvent = determineLastEvent(e, this._lastEvent, inChartArea, isClick);
      if (inChartArea) {
        this._lastEvent = null;
        callback(options.onHover, [e, active, this], this);
        if (isClick) {
          callback(options.onClick, [e, active, this], this);
        }
      }
      const changed = !_elementsEqual(active, lastActive);
      if (changed || replay) {
        this._active = active;
        this._updateHoverStyles(active, lastActive, replay);
      }
      this._lastEvent = lastEvent;
      return changed;
    }
    _getActiveElements(e, lastActive, inChartArea, useFinalPosition) {
      if (e.type === "mouseout") {
        return [];
      }
      if (!inChartArea) {
        return lastActive;
      }
      const hoverOptions = this.options.hover;
      return this.getElementsAtEventForMode(e, hoverOptions.mode, hoverOptions, useFinalPosition);
    }
  };
  var invalidatePlugins = () => each(Chart.instances, (chart) => chart._plugins.invalidate());
  var enumerable = true;
  Object.defineProperties(Chart, {
    defaults: {
      enumerable,
      value: defaults
    },
    instances: {
      enumerable,
      value: instances
    },
    overrides: {
      enumerable,
      value: overrides
    },
    registry: {
      enumerable,
      value: registry
    },
    version: {
      enumerable,
      value: version
    },
    getChart: {
      enumerable,
      value: getChart
    },
    register: {
      enumerable,
      value: (...items) => {
        registry.add(...items);
        invalidatePlugins();
      }
    },
    unregister: {
      enumerable,
      value: (...items) => {
        registry.remove(...items);
        invalidatePlugins();
      }
    }
  });
  function clipArc(ctx, element, endAngle) {
    const { startAngle, pixelMargin, x, y, outerRadius, innerRadius } = element;
    let angleMargin = pixelMargin / outerRadius;
    ctx.beginPath();
    ctx.arc(x, y, outerRadius, startAngle - angleMargin, endAngle + angleMargin);
    if (innerRadius > pixelMargin) {
      angleMargin = pixelMargin / innerRadius;
      ctx.arc(x, y, innerRadius, endAngle + angleMargin, startAngle - angleMargin, true);
    } else {
      ctx.arc(x, y, pixelMargin, endAngle + HALF_PI, startAngle - HALF_PI);
    }
    ctx.closePath();
    ctx.clip();
  }
  function toRadiusCorners(value) {
    return _readValueToProps(value, ["outerStart", "outerEnd", "innerStart", "innerEnd"]);
  }
  function parseBorderRadius$1(arc, innerRadius, outerRadius, angleDelta) {
    const o = toRadiusCorners(arc.options.borderRadius);
    const halfThickness = (outerRadius - innerRadius) / 2;
    const innerLimit = Math.min(halfThickness, angleDelta * innerRadius / 2);
    const computeOuterLimit = (val) => {
      const outerArcLimit = (outerRadius - Math.min(halfThickness, val)) * angleDelta / 2;
      return _limitValue(val, 0, Math.min(halfThickness, outerArcLimit));
    };
    return {
      outerStart: computeOuterLimit(o.outerStart),
      outerEnd: computeOuterLimit(o.outerEnd),
      innerStart: _limitValue(o.innerStart, 0, innerLimit),
      innerEnd: _limitValue(o.innerEnd, 0, innerLimit)
    };
  }
  function rThetaToXY(r, theta, x, y) {
    return {
      x: x + r * Math.cos(theta),
      y: y + r * Math.sin(theta)
    };
  }
  function pathArc(ctx, element, offset, spacing, end, circular) {
    const { x, y, startAngle: start2, pixelMargin, innerRadius: innerR } = element;
    const outerRadius = Math.max(element.outerRadius + spacing + offset - pixelMargin, 0);
    const innerRadius = innerR > 0 ? innerR + spacing + offset + pixelMargin : 0;
    let spacingOffset = 0;
    const alpha2 = end - start2;
    if (spacing) {
      const noSpacingInnerRadius = innerR > 0 ? innerR - spacing : 0;
      const noSpacingOuterRadius = outerRadius > 0 ? outerRadius - spacing : 0;
      const avNogSpacingRadius = (noSpacingInnerRadius + noSpacingOuterRadius) / 2;
      const adjustedAngle = avNogSpacingRadius !== 0 ? alpha2 * avNogSpacingRadius / (avNogSpacingRadius + spacing) : alpha2;
      spacingOffset = (alpha2 - adjustedAngle) / 2;
    }
    const beta = Math.max(1e-3, alpha2 * outerRadius - offset / PI) / outerRadius;
    const angleOffset = (alpha2 - beta) / 2;
    const startAngle = start2 + angleOffset + spacingOffset;
    const endAngle = end - angleOffset - spacingOffset;
    const { outerStart, outerEnd, innerStart, innerEnd } = parseBorderRadius$1(element, innerRadius, outerRadius, endAngle - startAngle);
    const outerStartAdjustedRadius = outerRadius - outerStart;
    const outerEndAdjustedRadius = outerRadius - outerEnd;
    const outerStartAdjustedAngle = startAngle + outerStart / outerStartAdjustedRadius;
    const outerEndAdjustedAngle = endAngle - outerEnd / outerEndAdjustedRadius;
    const innerStartAdjustedRadius = innerRadius + innerStart;
    const innerEndAdjustedRadius = innerRadius + innerEnd;
    const innerStartAdjustedAngle = startAngle + innerStart / innerStartAdjustedRadius;
    const innerEndAdjustedAngle = endAngle - innerEnd / innerEndAdjustedRadius;
    ctx.beginPath();
    if (circular) {
      ctx.arc(x, y, outerRadius, outerStartAdjustedAngle, outerEndAdjustedAngle);
      if (outerEnd > 0) {
        const pCenter = rThetaToXY(outerEndAdjustedRadius, outerEndAdjustedAngle, x, y);
        ctx.arc(pCenter.x, pCenter.y, outerEnd, outerEndAdjustedAngle, endAngle + HALF_PI);
      }
      const p4 = rThetaToXY(innerEndAdjustedRadius, endAngle, x, y);
      ctx.lineTo(p4.x, p4.y);
      if (innerEnd > 0) {
        const pCenter = rThetaToXY(innerEndAdjustedRadius, innerEndAdjustedAngle, x, y);
        ctx.arc(pCenter.x, pCenter.y, innerEnd, endAngle + HALF_PI, innerEndAdjustedAngle + Math.PI);
      }
      ctx.arc(x, y, innerRadius, endAngle - innerEnd / innerRadius, startAngle + innerStart / innerRadius, true);
      if (innerStart > 0) {
        const pCenter = rThetaToXY(innerStartAdjustedRadius, innerStartAdjustedAngle, x, y);
        ctx.arc(pCenter.x, pCenter.y, innerStart, innerStartAdjustedAngle + Math.PI, startAngle - HALF_PI);
      }
      const p8 = rThetaToXY(outerStartAdjustedRadius, startAngle, x, y);
      ctx.lineTo(p8.x, p8.y);
      if (outerStart > 0) {
        const pCenter = rThetaToXY(outerStartAdjustedRadius, outerStartAdjustedAngle, x, y);
        ctx.arc(pCenter.x, pCenter.y, outerStart, startAngle - HALF_PI, outerStartAdjustedAngle);
      }
    } else {
      ctx.moveTo(x, y);
      const outerStartX = Math.cos(outerStartAdjustedAngle) * outerRadius + x;
      const outerStartY = Math.sin(outerStartAdjustedAngle) * outerRadius + y;
      ctx.lineTo(outerStartX, outerStartY);
      const outerEndX = Math.cos(outerEndAdjustedAngle) * outerRadius + x;
      const outerEndY = Math.sin(outerEndAdjustedAngle) * outerRadius + y;
      ctx.lineTo(outerEndX, outerEndY);
    }
    ctx.closePath();
  }
  function drawArc(ctx, element, offset, spacing, circular) {
    const { fullCircles, startAngle, circumference } = element;
    let endAngle = element.endAngle;
    if (fullCircles) {
      pathArc(ctx, element, offset, spacing, startAngle + TAU, circular);
      for (let i = 0; i < fullCircles; ++i) {
        ctx.fill();
      }
      if (!isNaN(circumference)) {
        endAngle = startAngle + circumference % TAU;
        if (circumference % TAU === 0) {
          endAngle += TAU;
        }
      }
    }
    pathArc(ctx, element, offset, spacing, endAngle, circular);
    ctx.fill();
    return endAngle;
  }
  function drawFullCircleBorders(ctx, element, inner) {
    const { x, y, startAngle, pixelMargin, fullCircles } = element;
    const outerRadius = Math.max(element.outerRadius - pixelMargin, 0);
    const innerRadius = element.innerRadius + pixelMargin;
    let i;
    if (inner) {
      clipArc(ctx, element, startAngle + TAU);
    }
    ctx.beginPath();
    ctx.arc(x, y, innerRadius, startAngle + TAU, startAngle, true);
    for (i = 0; i < fullCircles; ++i) {
      ctx.stroke();
    }
    ctx.beginPath();
    ctx.arc(x, y, outerRadius, startAngle, startAngle + TAU);
    for (i = 0; i < fullCircles; ++i) {
      ctx.stroke();
    }
  }
  function drawBorder(ctx, element, offset, spacing, endAngle, circular) {
    const { options } = element;
    const { borderWidth: borderWidth3, borderJoinStyle } = options;
    const inner = options.borderAlign === "inner";
    if (!borderWidth3) {
      return;
    }
    if (inner) {
      ctx.lineWidth = borderWidth3 * 2;
      ctx.lineJoin = borderJoinStyle || "round";
    } else {
      ctx.lineWidth = borderWidth3;
      ctx.lineJoin = borderJoinStyle || "bevel";
    }
    if (element.fullCircles) {
      drawFullCircleBorders(ctx, element, inner);
    }
    if (inner) {
      clipArc(ctx, element, endAngle);
    }
    pathArc(ctx, element, offset, spacing, endAngle, circular);
    ctx.stroke();
  }
  var ArcElement = class extends Element {
    constructor(cfg) {
      super();
      this.options = void 0;
      this.circumference = void 0;
      this.startAngle = void 0;
      this.endAngle = void 0;
      this.innerRadius = void 0;
      this.outerRadius = void 0;
      this.pixelMargin = 0;
      this.fullCircles = 0;
      if (cfg) {
        Object.assign(this, cfg);
      }
    }
    inRange(chartX, chartY, useFinalPosition) {
      const point = this.getProps(["x", "y"], useFinalPosition);
      const { angle, distance } = getAngleFromPoint(point, { x: chartX, y: chartY });
      const { startAngle, endAngle, innerRadius, outerRadius, circumference } = this.getProps([
        "startAngle",
        "endAngle",
        "innerRadius",
        "outerRadius",
        "circumference"
      ], useFinalPosition);
      const rAdjust = this.options.spacing / 2;
      const _circumference = valueOrDefault(circumference, endAngle - startAngle);
      const betweenAngles = _circumference >= TAU || _angleBetween(angle, startAngle, endAngle);
      const withinRadius = _isBetween(distance, innerRadius + rAdjust, outerRadius + rAdjust);
      return betweenAngles && withinRadius;
    }
    getCenterPoint(useFinalPosition) {
      const { x, y, startAngle, endAngle, innerRadius, outerRadius } = this.getProps([
        "x",
        "y",
        "startAngle",
        "endAngle",
        "innerRadius",
        "outerRadius",
        "circumference"
      ], useFinalPosition);
      const { offset, spacing } = this.options;
      const halfAngle = (startAngle + endAngle) / 2;
      const halfRadius = (innerRadius + outerRadius + spacing + offset) / 2;
      return {
        x: x + Math.cos(halfAngle) * halfRadius,
        y: y + Math.sin(halfAngle) * halfRadius
      };
    }
    tooltipPosition(useFinalPosition) {
      return this.getCenterPoint(useFinalPosition);
    }
    draw(ctx) {
      const { options, circumference } = this;
      const offset = (options.offset || 0) / 2;
      const spacing = (options.spacing || 0) / 2;
      const circular = options.circular;
      this.pixelMargin = options.borderAlign === "inner" ? 0.33 : 0;
      this.fullCircles = circumference > TAU ? Math.floor(circumference / TAU) : 0;
      if (circumference === 0 || this.innerRadius < 0 || this.outerRadius < 0) {
        return;
      }
      ctx.save();
      let radiusOffset = 0;
      if (offset) {
        radiusOffset = offset / 2;
        const halfAngle = (this.startAngle + this.endAngle) / 2;
        ctx.translate(Math.cos(halfAngle) * radiusOffset, Math.sin(halfAngle) * radiusOffset);
        if (this.circumference >= PI) {
          radiusOffset = offset;
        }
      }
      ctx.fillStyle = options.backgroundColor;
      ctx.strokeStyle = options.borderColor;
      const endAngle = drawArc(ctx, this, radiusOffset, spacing, circular);
      drawBorder(ctx, this, radiusOffset, spacing, endAngle, circular);
      ctx.restore();
    }
  };
  ArcElement.id = "arc";
  ArcElement.defaults = {
    borderAlign: "center",
    borderColor: "#fff",
    borderJoinStyle: void 0,
    borderRadius: 0,
    borderWidth: 2,
    offset: 0,
    spacing: 0,
    angle: void 0,
    circular: true
  };
  ArcElement.defaultRoutes = {
    backgroundColor: "backgroundColor"
  };
  function setStyle(ctx, options, style = options) {
    ctx.lineCap = valueOrDefault(style.borderCapStyle, options.borderCapStyle);
    ctx.setLineDash(valueOrDefault(style.borderDash, options.borderDash));
    ctx.lineDashOffset = valueOrDefault(style.borderDashOffset, options.borderDashOffset);
    ctx.lineJoin = valueOrDefault(style.borderJoinStyle, options.borderJoinStyle);
    ctx.lineWidth = valueOrDefault(style.borderWidth, options.borderWidth);
    ctx.strokeStyle = valueOrDefault(style.borderColor, options.borderColor);
  }
  function lineTo(ctx, previous, target) {
    ctx.lineTo(target.x, target.y);
  }
  function getLineMethod(options) {
    if (options.stepped) {
      return _steppedLineTo;
    }
    if (options.tension || options.cubicInterpolationMode === "monotone") {
      return _bezierCurveTo;
    }
    return lineTo;
  }
  function pathVars(points, segment, params = {}) {
    const count = points.length;
    const { start: paramsStart = 0, end: paramsEnd = count - 1 } = params;
    const { start: segmentStart, end: segmentEnd } = segment;
    const start2 = Math.max(paramsStart, segmentStart);
    const end = Math.min(paramsEnd, segmentEnd);
    const outside = paramsStart < segmentStart && paramsEnd < segmentStart || paramsStart > segmentEnd && paramsEnd > segmentEnd;
    return {
      count,
      start: start2,
      loop: segment.loop,
      ilen: end < start2 && !outside ? count + end - start2 : end - start2
    };
  }
  function pathSegment(ctx, line, segment, params) {
    const { points, options } = line;
    const { count, start: start2, loop, ilen } = pathVars(points, segment, params);
    const lineMethod = getLineMethod(options);
    let { move = true, reverse } = params || {};
    let i, point, prev;
    for (i = 0; i <= ilen; ++i) {
      point = points[(start2 + (reverse ? ilen - i : i)) % count];
      if (point.skip) {
        continue;
      } else if (move) {
        ctx.moveTo(point.x, point.y);
        move = false;
      } else {
        lineMethod(ctx, prev, point, reverse, options.stepped);
      }
      prev = point;
    }
    if (loop) {
      point = points[(start2 + (reverse ? ilen : 0)) % count];
      lineMethod(ctx, prev, point, reverse, options.stepped);
    }
    return !!loop;
  }
  function fastPathSegment(ctx, line, segment, params) {
    const points = line.points;
    const { count, start: start2, ilen } = pathVars(points, segment, params);
    const { move = true, reverse } = params || {};
    let avgX = 0;
    let countX = 0;
    let i, point, prevX, minY, maxY, lastY;
    const pointIndex = (index3) => (start2 + (reverse ? ilen - index3 : index3)) % count;
    const drawX = () => {
      if (minY !== maxY) {
        ctx.lineTo(avgX, maxY);
        ctx.lineTo(avgX, minY);
        ctx.lineTo(avgX, lastY);
      }
    };
    if (move) {
      point = points[pointIndex(0)];
      ctx.moveTo(point.x, point.y);
    }
    for (i = 0; i <= ilen; ++i) {
      point = points[pointIndex(i)];
      if (point.skip) {
        continue;
      }
      const x = point.x;
      const y = point.y;
      const truncX = x | 0;
      if (truncX === prevX) {
        if (y < minY) {
          minY = y;
        } else if (y > maxY) {
          maxY = y;
        }
        avgX = (countX * avgX + x) / ++countX;
      } else {
        drawX();
        ctx.lineTo(x, y);
        prevX = truncX;
        countX = 0;
        minY = maxY = y;
      }
      lastY = y;
    }
    drawX();
  }
  function _getSegmentMethod(line) {
    const opts = line.options;
    const borderDash = opts.borderDash && opts.borderDash.length;
    const useFastPath = !line._decimated && !line._loop && !opts.tension && opts.cubicInterpolationMode !== "monotone" && !opts.stepped && !borderDash;
    return useFastPath ? fastPathSegment : pathSegment;
  }
  function _getInterpolationMethod(options) {
    if (options.stepped) {
      return _steppedInterpolation;
    }
    if (options.tension || options.cubicInterpolationMode === "monotone") {
      return _bezierInterpolation;
    }
    return _pointInLine;
  }
  function strokePathWithCache(ctx, line, start2, count) {
    let path = line._path;
    if (!path) {
      path = line._path = new Path2D();
      if (line.path(path, start2, count)) {
        path.closePath();
      }
    }
    setStyle(ctx, line.options);
    ctx.stroke(path);
  }
  function strokePathDirect(ctx, line, start2, count) {
    const { segments, options } = line;
    const segmentMethod = _getSegmentMethod(line);
    for (const segment of segments) {
      setStyle(ctx, options, segment.style);
      ctx.beginPath();
      if (segmentMethod(ctx, line, segment, { start: start2, end: start2 + count - 1 })) {
        ctx.closePath();
      }
      ctx.stroke();
    }
  }
  var usePath2D = typeof Path2D === "function";
  function draw(ctx, line, start2, count) {
    if (usePath2D && !line.options.segment) {
      strokePathWithCache(ctx, line, start2, count);
    } else {
      strokePathDirect(ctx, line, start2, count);
    }
  }
  var LineElement = class extends Element {
    constructor(cfg) {
      super();
      this.animated = true;
      this.options = void 0;
      this._chart = void 0;
      this._loop = void 0;
      this._fullLoop = void 0;
      this._path = void 0;
      this._points = void 0;
      this._segments = void 0;
      this._decimated = false;
      this._pointsUpdated = false;
      this._datasetIndex = void 0;
      if (cfg) {
        Object.assign(this, cfg);
      }
    }
    updateControlPoints(chartArea, indexAxis) {
      const options = this.options;
      if ((options.tension || options.cubicInterpolationMode === "monotone") && !options.stepped && !this._pointsUpdated) {
        const loop = options.spanGaps ? this._loop : this._fullLoop;
        _updateBezierControlPoints(this._points, options, chartArea, loop, indexAxis);
        this._pointsUpdated = true;
      }
    }
    set points(points) {
      this._points = points;
      delete this._segments;
      delete this._path;
      this._pointsUpdated = false;
    }
    get points() {
      return this._points;
    }
    get segments() {
      return this._segments || (this._segments = _computeSegments(this, this.options.segment));
    }
    first() {
      const segments = this.segments;
      const points = this.points;
      return segments.length && points[segments[0].start];
    }
    last() {
      const segments = this.segments;
      const points = this.points;
      const count = segments.length;
      return count && points[segments[count - 1].end];
    }
    interpolate(point, property) {
      const options = this.options;
      const value = point[property];
      const points = this.points;
      const segments = _boundSegments(this, { property, start: value, end: value });
      if (!segments.length) {
        return;
      }
      const result = [];
      const _interpolate = _getInterpolationMethod(options);
      let i, ilen;
      for (i = 0, ilen = segments.length; i < ilen; ++i) {
        const { start: start2, end } = segments[i];
        const p1 = points[start2];
        const p2 = points[end];
        if (p1 === p2) {
          result.push(p1);
          continue;
        }
        const t = Math.abs((value - p1[property]) / (p2[property] - p1[property]));
        const interpolated = _interpolate(p1, p2, t, options.stepped);
        interpolated[property] = point[property];
        result.push(interpolated);
      }
      return result.length === 1 ? result[0] : result;
    }
    pathSegment(ctx, segment, params) {
      const segmentMethod = _getSegmentMethod(this);
      return segmentMethod(ctx, this, segment, params);
    }
    path(ctx, start2, count) {
      const segments = this.segments;
      const segmentMethod = _getSegmentMethod(this);
      let loop = this._loop;
      start2 = start2 || 0;
      count = count || this.points.length - start2;
      for (const segment of segments) {
        loop &= segmentMethod(ctx, this, segment, { start: start2, end: start2 + count - 1 });
      }
      return !!loop;
    }
    draw(ctx, chartArea, start2, count) {
      const options = this.options || {};
      const points = this.points || [];
      if (points.length && options.borderWidth) {
        ctx.save();
        draw(ctx, this, start2, count);
        ctx.restore();
      }
      if (this.animated) {
        this._pointsUpdated = false;
        this._path = void 0;
      }
    }
  };
  LineElement.id = "line";
  LineElement.defaults = {
    borderCapStyle: "butt",
    borderDash: [],
    borderDashOffset: 0,
    borderJoinStyle: "miter",
    borderWidth: 3,
    capBezierPoints: true,
    cubicInterpolationMode: "default",
    fill: false,
    spanGaps: false,
    stepped: false,
    tension: 0
  };
  LineElement.defaultRoutes = {
    backgroundColor: "backgroundColor",
    borderColor: "borderColor"
  };
  LineElement.descriptors = {
    _scriptable: true,
    _indexable: (name) => name !== "borderDash" && name !== "fill"
  };
  function inRange$1(el, pos, axis, useFinalPosition) {
    const options = el.options;
    const { [axis]: value } = el.getProps([axis], useFinalPosition);
    return Math.abs(pos - value) < options.radius + options.hitRadius;
  }
  var PointElement = class extends Element {
    constructor(cfg) {
      super();
      this.options = void 0;
      this.parsed = void 0;
      this.skip = void 0;
      this.stop = void 0;
      if (cfg) {
        Object.assign(this, cfg);
      }
    }
    inRange(mouseX, mouseY, useFinalPosition) {
      const options = this.options;
      const { x, y } = this.getProps(["x", "y"], useFinalPosition);
      return Math.pow(mouseX - x, 2) + Math.pow(mouseY - y, 2) < Math.pow(options.hitRadius + options.radius, 2);
    }
    inXRange(mouseX, useFinalPosition) {
      return inRange$1(this, mouseX, "x", useFinalPosition);
    }
    inYRange(mouseY, useFinalPosition) {
      return inRange$1(this, mouseY, "y", useFinalPosition);
    }
    getCenterPoint(useFinalPosition) {
      const { x, y } = this.getProps(["x", "y"], useFinalPosition);
      return { x, y };
    }
    size(options) {
      options = options || this.options || {};
      let radius3 = options.radius || 0;
      radius3 = Math.max(radius3, radius3 && options.hoverRadius || 0);
      const borderWidth3 = radius3 && options.borderWidth || 0;
      return (radius3 + borderWidth3) * 2;
    }
    draw(ctx, area) {
      const options = this.options;
      if (this.skip || options.radius < 0.1 || !_isPointInArea(this, area, this.size(options) / 2)) {
        return;
      }
      ctx.strokeStyle = options.borderColor;
      ctx.lineWidth = options.borderWidth;
      ctx.fillStyle = options.backgroundColor;
      drawPoint(ctx, options, this.x, this.y);
    }
    getRange() {
      const options = this.options || {};
      return options.radius + options.hitRadius;
    }
  };
  PointElement.id = "point";
  PointElement.defaults = {
    borderWidth: 1,
    hitRadius: 1,
    hoverBorderWidth: 1,
    hoverRadius: 4,
    pointStyle: "circle",
    radius: 3,
    rotation: 0
  };
  PointElement.defaultRoutes = {
    backgroundColor: "backgroundColor",
    borderColor: "borderColor"
  };
  function getBarBounds(bar, useFinalPosition) {
    const { x, y, base, width, height } = bar.getProps(["x", "y", "base", "width", "height"], useFinalPosition);
    let left, right, top, bottom, half;
    if (bar.horizontal) {
      half = height / 2;
      left = Math.min(x, base);
      right = Math.max(x, base);
      top = y - half;
      bottom = y + half;
    } else {
      half = width / 2;
      left = x - half;
      right = x + half;
      top = Math.min(y, base);
      bottom = Math.max(y, base);
    }
    return { left, top, right, bottom };
  }
  function skipOrLimit(skip2, value, min3, max3) {
    return skip2 ? 0 : _limitValue(value, min3, max3);
  }
  function parseBorderWidth(bar, maxW, maxH) {
    const value = bar.options.borderWidth;
    const skip2 = bar.borderSkipped;
    const o = toTRBL(value);
    return {
      t: skipOrLimit(skip2.top, o.top, 0, maxH),
      r: skipOrLimit(skip2.right, o.right, 0, maxW),
      b: skipOrLimit(skip2.bottom, o.bottom, 0, maxH),
      l: skipOrLimit(skip2.left, o.left, 0, maxW)
    };
  }
  function parseBorderRadius(bar, maxW, maxH) {
    const { enableBorderRadius } = bar.getProps(["enableBorderRadius"]);
    const value = bar.options.borderRadius;
    const o = toTRBLCorners(value);
    const maxR = Math.min(maxW, maxH);
    const skip2 = bar.borderSkipped;
    const enableBorder = enableBorderRadius || isObject(value);
    return {
      topLeft: skipOrLimit(!enableBorder || skip2.top || skip2.left, o.topLeft, 0, maxR),
      topRight: skipOrLimit(!enableBorder || skip2.top || skip2.right, o.topRight, 0, maxR),
      bottomLeft: skipOrLimit(!enableBorder || skip2.bottom || skip2.left, o.bottomLeft, 0, maxR),
      bottomRight: skipOrLimit(!enableBorder || skip2.bottom || skip2.right, o.bottomRight, 0, maxR)
    };
  }
  function boundingRects(bar) {
    const bounds = getBarBounds(bar);
    const width = bounds.right - bounds.left;
    const height = bounds.bottom - bounds.top;
    const border = parseBorderWidth(bar, width / 2, height / 2);
    const radius3 = parseBorderRadius(bar, width / 2, height / 2);
    return {
      outer: {
        x: bounds.left,
        y: bounds.top,
        w: width,
        h: height,
        radius: radius3
      },
      inner: {
        x: bounds.left + border.l,
        y: bounds.top + border.t,
        w: width - border.l - border.r,
        h: height - border.t - border.b,
        radius: {
          topLeft: Math.max(0, radius3.topLeft - Math.max(border.t, border.l)),
          topRight: Math.max(0, radius3.topRight - Math.max(border.t, border.r)),
          bottomLeft: Math.max(0, radius3.bottomLeft - Math.max(border.b, border.l)),
          bottomRight: Math.max(0, radius3.bottomRight - Math.max(border.b, border.r))
        }
      }
    };
  }
  function inRange(bar, x, y, useFinalPosition) {
    const skipX = x === null;
    const skipY = y === null;
    const skipBoth = skipX && skipY;
    const bounds = bar && !skipBoth && getBarBounds(bar, useFinalPosition);
    return bounds && (skipX || _isBetween(x, bounds.left, bounds.right)) && (skipY || _isBetween(y, bounds.top, bounds.bottom));
  }
  function hasRadius(radius3) {
    return radius3.topLeft || radius3.topRight || radius3.bottomLeft || radius3.bottomRight;
  }
  function addNormalRectPath(ctx, rect) {
    ctx.rect(rect.x, rect.y, rect.w, rect.h);
  }
  function inflateRect(rect, amount, refRect = {}) {
    const x = rect.x !== refRect.x ? -amount : 0;
    const y = rect.y !== refRect.y ? -amount : 0;
    const w = (rect.x + rect.w !== refRect.x + refRect.w ? amount : 0) - x;
    const h = (rect.y + rect.h !== refRect.y + refRect.h ? amount : 0) - y;
    return {
      x: rect.x + x,
      y: rect.y + y,
      w: rect.w + w,
      h: rect.h + h,
      radius: rect.radius
    };
  }
  var BarElement = class extends Element {
    constructor(cfg) {
      super();
      this.options = void 0;
      this.horizontal = void 0;
      this.base = void 0;
      this.width = void 0;
      this.height = void 0;
      this.inflateAmount = void 0;
      if (cfg) {
        Object.assign(this, cfg);
      }
    }
    draw(ctx) {
      const { inflateAmount, options: { borderColor: borderColor4, backgroundColor: backgroundColor4 } } = this;
      const { inner, outer } = boundingRects(this);
      const addRectPath = hasRadius(outer.radius) ? addRoundedRectPath : addNormalRectPath;
      ctx.save();
      if (outer.w !== inner.w || outer.h !== inner.h) {
        ctx.beginPath();
        addRectPath(ctx, inflateRect(outer, inflateAmount, inner));
        ctx.clip();
        addRectPath(ctx, inflateRect(inner, -inflateAmount, outer));
        ctx.fillStyle = borderColor4;
        ctx.fill("evenodd");
      }
      ctx.beginPath();
      addRectPath(ctx, inflateRect(inner, inflateAmount));
      ctx.fillStyle = backgroundColor4;
      ctx.fill();
      ctx.restore();
    }
    inRange(mouseX, mouseY, useFinalPosition) {
      return inRange(this, mouseX, mouseY, useFinalPosition);
    }
    inXRange(mouseX, useFinalPosition) {
      return inRange(this, mouseX, null, useFinalPosition);
    }
    inYRange(mouseY, useFinalPosition) {
      return inRange(this, null, mouseY, useFinalPosition);
    }
    getCenterPoint(useFinalPosition) {
      const { x, y, base, horizontal } = this.getProps(["x", "y", "base", "horizontal"], useFinalPosition);
      return {
        x: horizontal ? (x + base) / 2 : x,
        y: horizontal ? y : (y + base) / 2
      };
    }
    getRange(axis) {
      return axis === "x" ? this.width / 2 : this.height / 2;
    }
  };
  BarElement.id = "bar";
  BarElement.defaults = {
    borderSkipped: "start",
    borderWidth: 0,
    borderRadius: 0,
    inflateAmount: "auto",
    pointStyle: void 0
  };
  BarElement.defaultRoutes = {
    backgroundColor: "backgroundColor",
    borderColor: "borderColor"
  };
  var elements = /* @__PURE__ */ Object.freeze({
    __proto__: null,
    ArcElement,
    LineElement,
    PointElement,
    BarElement
  });
  function lttbDecimation(data, start2, count, availableWidth, options) {
    const samples = options.samples || availableWidth;
    if (samples >= count) {
      return data.slice(start2, start2 + count);
    }
    const decimated = [];
    const bucketWidth = (count - 2) / (samples - 2);
    let sampledIndex = 0;
    const endIndex = start2 + count - 1;
    let a = start2;
    let i, maxAreaPoint, maxArea, area, nextA;
    decimated[sampledIndex++] = data[a];
    for (i = 0; i < samples - 2; i++) {
      let avgX = 0;
      let avgY = 0;
      let j;
      const avgRangeStart = Math.floor((i + 1) * bucketWidth) + 1 + start2;
      const avgRangeEnd = Math.min(Math.floor((i + 2) * bucketWidth) + 1, count) + start2;
      const avgRangeLength = avgRangeEnd - avgRangeStart;
      for (j = avgRangeStart; j < avgRangeEnd; j++) {
        avgX += data[j].x;
        avgY += data[j].y;
      }
      avgX /= avgRangeLength;
      avgY /= avgRangeLength;
      const rangeOffs = Math.floor(i * bucketWidth) + 1 + start2;
      const rangeTo = Math.min(Math.floor((i + 1) * bucketWidth) + 1, count) + start2;
      const { x: pointAx, y: pointAy } = data[a];
      maxArea = area = -1;
      for (j = rangeOffs; j < rangeTo; j++) {
        area = 0.5 * Math.abs(
          (pointAx - avgX) * (data[j].y - pointAy) - (pointAx - data[j].x) * (avgY - pointAy)
        );
        if (area > maxArea) {
          maxArea = area;
          maxAreaPoint = data[j];
          nextA = j;
        }
      }
      decimated[sampledIndex++] = maxAreaPoint;
      a = nextA;
    }
    decimated[sampledIndex++] = data[endIndex];
    return decimated;
  }
  function minMaxDecimation(data, start2, count, availableWidth) {
    let avgX = 0;
    let countX = 0;
    let i, point, x, y, prevX, minIndex, maxIndex, startIndex, minY, maxY;
    const decimated = [];
    const endIndex = start2 + count - 1;
    const xMin = data[start2].x;
    const xMax = data[endIndex].x;
    const dx = xMax - xMin;
    for (i = start2; i < start2 + count; ++i) {
      point = data[i];
      x = (point.x - xMin) / dx * availableWidth;
      y = point.y;
      const truncX = x | 0;
      if (truncX === prevX) {
        if (y < minY) {
          minY = y;
          minIndex = i;
        } else if (y > maxY) {
          maxY = y;
          maxIndex = i;
        }
        avgX = (countX * avgX + point.x) / ++countX;
      } else {
        const lastIndex = i - 1;
        if (!isNullOrUndef(minIndex) && !isNullOrUndef(maxIndex)) {
          const intermediateIndex1 = Math.min(minIndex, maxIndex);
          const intermediateIndex2 = Math.max(minIndex, maxIndex);
          if (intermediateIndex1 !== startIndex && intermediateIndex1 !== lastIndex) {
            decimated.push({
              ...data[intermediateIndex1],
              x: avgX
            });
          }
          if (intermediateIndex2 !== startIndex && intermediateIndex2 !== lastIndex) {
            decimated.push({
              ...data[intermediateIndex2],
              x: avgX
            });
          }
        }
        if (i > 0 && lastIndex !== startIndex) {
          decimated.push(data[lastIndex]);
        }
        decimated.push(point);
        prevX = truncX;
        countX = 0;
        minY = maxY = y;
        minIndex = maxIndex = startIndex = i;
      }
    }
    return decimated;
  }
  function cleanDecimatedDataset(dataset) {
    if (dataset._decimated) {
      const data = dataset._data;
      delete dataset._decimated;
      delete dataset._data;
      Object.defineProperty(dataset, "data", { value: data });
    }
  }
  function cleanDecimatedData(chart) {
    chart.data.datasets.forEach((dataset) => {
      cleanDecimatedDataset(dataset);
    });
  }
  function getStartAndCountOfVisiblePointsSimplified(meta, points) {
    const pointCount = points.length;
    let start2 = 0;
    let count;
    const { iScale } = meta;
    const { min: min3, max: max3, minDefined, maxDefined } = iScale.getUserBounds();
    if (minDefined) {
      start2 = _limitValue(_lookupByKey(points, iScale.axis, min3).lo, 0, pointCount - 1);
    }
    if (maxDefined) {
      count = _limitValue(_lookupByKey(points, iScale.axis, max3).hi + 1, start2, pointCount) - start2;
    } else {
      count = pointCount - start2;
    }
    return { start: start2, count };
  }
  var plugin_decimation = {
    id: "decimation",
    defaults: {
      algorithm: "min-max",
      enabled: false
    },
    beforeElementsUpdate: (chart, args, options) => {
      if (!options.enabled) {
        cleanDecimatedData(chart);
        return;
      }
      const availableWidth = chart.width;
      chart.data.datasets.forEach((dataset, datasetIndex) => {
        const { _data, indexAxis } = dataset;
        const meta = chart.getDatasetMeta(datasetIndex);
        const data = _data || dataset.data;
        if (resolve([indexAxis, chart.options.indexAxis]) === "y") {
          return;
        }
        if (!meta.controller.supportsDecimation) {
          return;
        }
        const xAxis = chart.scales[meta.xAxisID];
        if (xAxis.type !== "linear" && xAxis.type !== "time") {
          return;
        }
        if (chart.options.parsing) {
          return;
        }
        let { start: start2, count } = getStartAndCountOfVisiblePointsSimplified(meta, data);
        const threshold = options.threshold || 4 * availableWidth;
        if (count <= threshold) {
          cleanDecimatedDataset(dataset);
          return;
        }
        if (isNullOrUndef(_data)) {
          dataset._data = data;
          delete dataset.data;
          Object.defineProperty(dataset, "data", {
            configurable: true,
            enumerable: true,
            get: function() {
              return this._decimated;
            },
            set: function(d) {
              this._data = d;
            }
          });
        }
        let decimated;
        switch (options.algorithm) {
          case "lttb":
            decimated = lttbDecimation(data, start2, count, availableWidth, options);
            break;
          case "min-max":
            decimated = minMaxDecimation(data, start2, count, availableWidth);
            break;
          default:
            throw new Error(`Unsupported decimation algorithm '${options.algorithm}'`);
        }
        dataset._decimated = decimated;
      });
    },
    destroy(chart) {
      cleanDecimatedData(chart);
    }
  };
  function _segments(line, target, property) {
    const segments = line.segments;
    const points = line.points;
    const tpoints = target.points;
    const parts = [];
    for (const segment of segments) {
      let { start: start2, end } = segment;
      end = _findSegmentEnd(start2, end, points);
      const bounds = _getBounds(property, points[start2], points[end], segment.loop);
      if (!target.segments) {
        parts.push({
          source: segment,
          target: bounds,
          start: points[start2],
          end: points[end]
        });
        continue;
      }
      const targetSegments = _boundSegments(target, bounds);
      for (const tgt of targetSegments) {
        const subBounds = _getBounds(property, tpoints[tgt.start], tpoints[tgt.end], tgt.loop);
        const fillSources = _boundSegment(segment, points, subBounds);
        for (const fillSource of fillSources) {
          parts.push({
            source: fillSource,
            target: tgt,
            start: {
              [property]: _getEdge(bounds, subBounds, "start", Math.max)
            },
            end: {
              [property]: _getEdge(bounds, subBounds, "end", Math.min)
            }
          });
        }
      }
    }
    return parts;
  }
  function _getBounds(property, first, last, loop) {
    if (loop) {
      return;
    }
    let start2 = first[property];
    let end = last[property];
    if (property === "angle") {
      start2 = _normalizeAngle(start2);
      end = _normalizeAngle(end);
    }
    return { property, start: start2, end };
  }
  function _pointsFromSegments(boundary, line) {
    const { x = null, y = null } = boundary || {};
    const linePoints = line.points;
    const points = [];
    line.segments.forEach(({ start: start2, end }) => {
      end = _findSegmentEnd(start2, end, linePoints);
      const first = linePoints[start2];
      const last = linePoints[end];
      if (y !== null) {
        points.push({ x: first.x, y });
        points.push({ x: last.x, y });
      } else if (x !== null) {
        points.push({ x, y: first.y });
        points.push({ x, y: last.y });
      }
    });
    return points;
  }
  function _findSegmentEnd(start2, end, points) {
    for (; end > start2; end--) {
      const point = points[end];
      if (!isNaN(point.x) && !isNaN(point.y)) {
        break;
      }
    }
    return end;
  }
  function _getEdge(a, b, prop, fn) {
    if (a && b) {
      return fn(a[prop], b[prop]);
    }
    return a ? a[prop] : b ? b[prop] : 0;
  }
  function _createBoundaryLine(boundary, line) {
    let points = [];
    let _loop = false;
    if (isArray(boundary)) {
      _loop = true;
      points = boundary;
    } else {
      points = _pointsFromSegments(boundary, line);
    }
    return points.length ? new LineElement({
      points,
      options: { tension: 0 },
      _loop,
      _fullLoop: _loop
    }) : null;
  }
  function _shouldApplyFill(source) {
    return source && source.fill !== false;
  }
  function _resolveTarget(sources, index3, propagate) {
    const source = sources[index3];
    let fill2 = source.fill;
    const visited = [index3];
    let target;
    if (!propagate) {
      return fill2;
    }
    while (fill2 !== false && visited.indexOf(fill2) === -1) {
      if (!isNumberFinite(fill2)) {
        return fill2;
      }
      target = sources[fill2];
      if (!target) {
        return false;
      }
      if (target.visible) {
        return fill2;
      }
      visited.push(fill2);
      fill2 = target.fill;
    }
    return false;
  }
  function _decodeFill(line, index3, count) {
    const fill2 = parseFillOption(line);
    if (isObject(fill2)) {
      return isNaN(fill2.value) ? false : fill2;
    }
    let target = parseFloat(fill2);
    if (isNumberFinite(target) && Math.floor(target) === target) {
      return decodeTargetIndex(fill2[0], index3, target, count);
    }
    return ["origin", "start", "end", "stack", "shape"].indexOf(fill2) >= 0 && fill2;
  }
  function decodeTargetIndex(firstCh, index3, target, count) {
    if (firstCh === "-" || firstCh === "+") {
      target = index3 + target;
    }
    if (target === index3 || target < 0 || target >= count) {
      return false;
    }
    return target;
  }
  function _getTargetPixel(fill2, scale) {
    let pixel = null;
    if (fill2 === "start") {
      pixel = scale.bottom;
    } else if (fill2 === "end") {
      pixel = scale.top;
    } else if (isObject(fill2)) {
      pixel = scale.getPixelForValue(fill2.value);
    } else if (scale.getBasePixel) {
      pixel = scale.getBasePixel();
    }
    return pixel;
  }
  function _getTargetValue(fill2, scale, startValue) {
    let value;
    if (fill2 === "start") {
      value = startValue;
    } else if (fill2 === "end") {
      value = scale.options.reverse ? scale.min : scale.max;
    } else if (isObject(fill2)) {
      value = fill2.value;
    } else {
      value = scale.getBaseValue();
    }
    return value;
  }
  function parseFillOption(line) {
    const options = line.options;
    const fillOption = options.fill;
    let fill2 = valueOrDefault(fillOption && fillOption.target, fillOption);
    if (fill2 === void 0) {
      fill2 = !!options.backgroundColor;
    }
    if (fill2 === false || fill2 === null) {
      return false;
    }
    if (fill2 === true) {
      return "origin";
    }
    return fill2;
  }
  function _buildStackLine(source) {
    const { scale, index: index3, line } = source;
    const points = [];
    const segments = line.segments;
    const sourcePoints = line.points;
    const linesBelow = getLinesBelow(scale, index3);
    linesBelow.push(_createBoundaryLine({ x: null, y: scale.bottom }, line));
    for (let i = 0; i < segments.length; i++) {
      const segment = segments[i];
      for (let j = segment.start; j <= segment.end; j++) {
        addPointsBelow(points, sourcePoints[j], linesBelow);
      }
    }
    return new LineElement({ points, options: {} });
  }
  function getLinesBelow(scale, index3) {
    const below = [];
    const metas = scale.getMatchingVisibleMetas("line");
    for (let i = 0; i < metas.length; i++) {
      const meta = metas[i];
      if (meta.index === index3) {
        break;
      }
      if (!meta.hidden) {
        below.unshift(meta.dataset);
      }
    }
    return below;
  }
  function addPointsBelow(points, sourcePoint, linesBelow) {
    const postponed = [];
    for (let j = 0; j < linesBelow.length; j++) {
      const line = linesBelow[j];
      const { first, last, point } = findPoint(line, sourcePoint, "x");
      if (!point || first && last) {
        continue;
      }
      if (first) {
        postponed.unshift(point);
      } else {
        points.push(point);
        if (!last) {
          break;
        }
      }
    }
    points.push(...postponed);
  }
  function findPoint(line, sourcePoint, property) {
    const point = line.interpolate(sourcePoint, property);
    if (!point) {
      return {};
    }
    const pointValue = point[property];
    const segments = line.segments;
    const linePoints = line.points;
    let first = false;
    let last = false;
    for (let i = 0; i < segments.length; i++) {
      const segment = segments[i];
      const firstValue = linePoints[segment.start][property];
      const lastValue = linePoints[segment.end][property];
      if (_isBetween(pointValue, firstValue, lastValue)) {
        first = pointValue === firstValue;
        last = pointValue === lastValue;
        break;
      }
    }
    return { first, last, point };
  }
  var simpleArc = class {
    constructor(opts) {
      this.x = opts.x;
      this.y = opts.y;
      this.radius = opts.radius;
    }
    pathSegment(ctx, bounds, opts) {
      const { x, y, radius: radius3 } = this;
      bounds = bounds || { start: 0, end: TAU };
      ctx.arc(x, y, radius3, bounds.end, bounds.start, true);
      return !opts.bounds;
    }
    interpolate(point) {
      const { x, y, radius: radius3 } = this;
      const angle = point.angle;
      return {
        x: x + Math.cos(angle) * radius3,
        y: y + Math.sin(angle) * radius3,
        angle
      };
    }
  };
  function _getTarget(source) {
    const { chart, fill: fill2, line } = source;
    if (isNumberFinite(fill2)) {
      return getLineByIndex(chart, fill2);
    }
    if (fill2 === "stack") {
      return _buildStackLine(source);
    }
    if (fill2 === "shape") {
      return true;
    }
    const boundary = computeBoundary(source);
    if (boundary instanceof simpleArc) {
      return boundary;
    }
    return _createBoundaryLine(boundary, line);
  }
  function getLineByIndex(chart, index3) {
    const meta = chart.getDatasetMeta(index3);
    const visible = meta && chart.isDatasetVisible(index3);
    return visible ? meta.dataset : null;
  }
  function computeBoundary(source) {
    const scale = source.scale || {};
    if (scale.getPointPositionForValue) {
      return computeCircularBoundary(source);
    }
    return computeLinearBoundary(source);
  }
  function computeLinearBoundary(source) {
    const { scale = {}, fill: fill2 } = source;
    const pixel = _getTargetPixel(fill2, scale);
    if (isNumberFinite(pixel)) {
      const horizontal = scale.isHorizontal();
      return {
        x: horizontal ? pixel : null,
        y: horizontal ? null : pixel
      };
    }
    return null;
  }
  function computeCircularBoundary(source) {
    const { scale, fill: fill2 } = source;
    const options = scale.options;
    const length = scale.getLabels().length;
    const start2 = options.reverse ? scale.max : scale.min;
    const value = _getTargetValue(fill2, scale, start2);
    const target = [];
    if (options.grid.circular) {
      const center = scale.getPointPositionForValue(0, start2);
      return new simpleArc({
        x: center.x,
        y: center.y,
        radius: scale.getDistanceFromCenterForValue(value)
      });
    }
    for (let i = 0; i < length; ++i) {
      target.push(scale.getPointPositionForValue(i, value));
    }
    return target;
  }
  function _drawfill(ctx, source, area) {
    const target = _getTarget(source);
    const { line, scale, axis } = source;
    const lineOpts = line.options;
    const fillOption = lineOpts.fill;
    const color3 = lineOpts.backgroundColor;
    const { above = color3, below = color3 } = fillOption || {};
    if (target && line.points.length) {
      clipArea(ctx, area);
      doFill(ctx, { line, target, above, below, area, scale, axis });
      unclipArea(ctx);
    }
  }
  function doFill(ctx, cfg) {
    const { line, target, above, below, area, scale } = cfg;
    const property = line._loop ? "angle" : cfg.axis;
    ctx.save();
    if (property === "x" && below !== above) {
      clipVertical(ctx, target, area.top);
      fill(ctx, { line, target, color: above, scale, property });
      ctx.restore();
      ctx.save();
      clipVertical(ctx, target, area.bottom);
    }
    fill(ctx, { line, target, color: below, scale, property });
    ctx.restore();
  }
  function clipVertical(ctx, target, clipY) {
    const { segments, points } = target;
    let first = true;
    let lineLoop = false;
    ctx.beginPath();
    for (const segment of segments) {
      const { start: start2, end } = segment;
      const firstPoint = points[start2];
      const lastPoint = points[_findSegmentEnd(start2, end, points)];
      if (first) {
        ctx.moveTo(firstPoint.x, firstPoint.y);
        first = false;
      } else {
        ctx.lineTo(firstPoint.x, clipY);
        ctx.lineTo(firstPoint.x, firstPoint.y);
      }
      lineLoop = !!target.pathSegment(ctx, segment, { move: lineLoop });
      if (lineLoop) {
        ctx.closePath();
      } else {
        ctx.lineTo(lastPoint.x, clipY);
      }
    }
    ctx.lineTo(target.first().x, clipY);
    ctx.closePath();
    ctx.clip();
  }
  function fill(ctx, cfg) {
    const { line, target, property, color: color3, scale } = cfg;
    const segments = _segments(line, target, property);
    for (const { source: src, target: tgt, start: start2, end } of segments) {
      const { style: { backgroundColor: backgroundColor4 = color3 } = {} } = src;
      const notShape = target !== true;
      ctx.save();
      ctx.fillStyle = backgroundColor4;
      clipBounds(ctx, scale, notShape && _getBounds(property, start2, end));
      ctx.beginPath();
      const lineLoop = !!line.pathSegment(ctx, src);
      let loop;
      if (notShape) {
        if (lineLoop) {
          ctx.closePath();
        } else {
          interpolatedLineTo(ctx, target, end, property);
        }
        const targetLoop = !!target.pathSegment(ctx, tgt, { move: lineLoop, reverse: true });
        loop = lineLoop && targetLoop;
        if (!loop) {
          interpolatedLineTo(ctx, target, start2, property);
        }
      }
      ctx.closePath();
      ctx.fill(loop ? "evenodd" : "nonzero");
      ctx.restore();
    }
  }
  function clipBounds(ctx, scale, bounds) {
    const { top, bottom } = scale.chart.chartArea;
    const { property, start: start2, end } = bounds || {};
    if (property === "x") {
      ctx.beginPath();
      ctx.rect(start2, top, end - start2, bottom - top);
      ctx.clip();
    }
  }
  function interpolatedLineTo(ctx, target, point, property) {
    const interpolatedPoint = target.interpolate(point, property);
    if (interpolatedPoint) {
      ctx.lineTo(interpolatedPoint.x, interpolatedPoint.y);
    }
  }
  var index = {
    id: "filler",
    afterDatasetsUpdate(chart, _args, options) {
      const count = (chart.data.datasets || []).length;
      const sources = [];
      let meta, i, line, source;
      for (i = 0; i < count; ++i) {
        meta = chart.getDatasetMeta(i);
        line = meta.dataset;
        source = null;
        if (line && line.options && line instanceof LineElement) {
          source = {
            visible: chart.isDatasetVisible(i),
            index: i,
            fill: _decodeFill(line, i, count),
            chart,
            axis: meta.controller.options.indexAxis,
            scale: meta.vScale,
            line
          };
        }
        meta.$filler = source;
        sources.push(source);
      }
      for (i = 0; i < count; ++i) {
        source = sources[i];
        if (!source || source.fill === false) {
          continue;
        }
        source.fill = _resolveTarget(sources, i, options.propagate);
      }
    },
    beforeDraw(chart, _args, options) {
      const draw3 = options.drawTime === "beforeDraw";
      const metasets = chart.getSortedVisibleDatasetMetas();
      const area = chart.chartArea;
      for (let i = metasets.length - 1; i >= 0; --i) {
        const source = metasets[i].$filler;
        if (!source) {
          continue;
        }
        source.line.updateControlPoints(area, source.axis);
        if (draw3 && source.fill) {
          _drawfill(chart.ctx, source, area);
        }
      }
    },
    beforeDatasetsDraw(chart, _args, options) {
      if (options.drawTime !== "beforeDatasetsDraw") {
        return;
      }
      const metasets = chart.getSortedVisibleDatasetMetas();
      for (let i = metasets.length - 1; i >= 0; --i) {
        const source = metasets[i].$filler;
        if (_shouldApplyFill(source)) {
          _drawfill(chart.ctx, source, chart.chartArea);
        }
      }
    },
    beforeDatasetDraw(chart, args, options) {
      const source = args.meta.$filler;
      if (!_shouldApplyFill(source) || options.drawTime !== "beforeDatasetDraw") {
        return;
      }
      _drawfill(chart.ctx, source, chart.chartArea);
    },
    defaults: {
      propagate: true,
      drawTime: "beforeDatasetDraw"
    }
  };
  var getBoxSize = (labelOpts, fontSize) => {
    let { boxHeight = fontSize, boxWidth = fontSize } = labelOpts;
    if (labelOpts.usePointStyle) {
      boxHeight = Math.min(boxHeight, fontSize);
      boxWidth = labelOpts.pointStyleWidth || Math.min(boxWidth, fontSize);
    }
    return {
      boxWidth,
      boxHeight,
      itemHeight: Math.max(fontSize, boxHeight)
    };
  };
  var itemsEqual = (a, b) => a !== null && b !== null && a.datasetIndex === b.datasetIndex && a.index === b.index;
  var Legend = class extends Element {
    constructor(config) {
      super();
      this._added = false;
      this.legendHitBoxes = [];
      this._hoveredItem = null;
      this.doughnutMode = false;
      this.chart = config.chart;
      this.options = config.options;
      this.ctx = config.ctx;
      this.legendItems = void 0;
      this.columnSizes = void 0;
      this.lineWidths = void 0;
      this.maxHeight = void 0;
      this.maxWidth = void 0;
      this.top = void 0;
      this.bottom = void 0;
      this.left = void 0;
      this.right = void 0;
      this.height = void 0;
      this.width = void 0;
      this._margins = void 0;
      this.position = void 0;
      this.weight = void 0;
      this.fullSize = void 0;
    }
    update(maxWidth, maxHeight, margins) {
      this.maxWidth = maxWidth;
      this.maxHeight = maxHeight;
      this._margins = margins;
      this.setDimensions();
      this.buildLabels();
      this.fit();
    }
    setDimensions() {
      if (this.isHorizontal()) {
        this.width = this.maxWidth;
        this.left = this._margins.left;
        this.right = this.width;
      } else {
        this.height = this.maxHeight;
        this.top = this._margins.top;
        this.bottom = this.height;
      }
    }
    buildLabels() {
      const labelOpts = this.options.labels || {};
      let legendItems = callback(labelOpts.generateLabels, [this.chart], this) || [];
      if (labelOpts.filter) {
        legendItems = legendItems.filter((item) => labelOpts.filter(item, this.chart.data));
      }
      if (labelOpts.sort) {
        legendItems = legendItems.sort((a, b) => labelOpts.sort(a, b, this.chart.data));
      }
      if (this.options.reverse) {
        legendItems.reverse();
      }
      this.legendItems = legendItems;
    }
    fit() {
      const { options, ctx } = this;
      if (!options.display) {
        this.width = this.height = 0;
        return;
      }
      const labelOpts = options.labels;
      const labelFont = toFont(labelOpts.font);
      const fontSize = labelFont.size;
      const titleHeight = this._computeTitleHeight();
      const { boxWidth, itemHeight } = getBoxSize(labelOpts, fontSize);
      let width, height;
      ctx.font = labelFont.string;
      if (this.isHorizontal()) {
        width = this.maxWidth;
        height = this._fitRows(titleHeight, fontSize, boxWidth, itemHeight) + 10;
      } else {
        height = this.maxHeight;
        width = this._fitCols(titleHeight, fontSize, boxWidth, itemHeight) + 10;
      }
      this.width = Math.min(width, options.maxWidth || this.maxWidth);
      this.height = Math.min(height, options.maxHeight || this.maxHeight);
    }
    _fitRows(titleHeight, fontSize, boxWidth, itemHeight) {
      const { ctx, maxWidth, options: { labels: { padding } } } = this;
      const hitboxes = this.legendHitBoxes = [];
      const lineWidths = this.lineWidths = [0];
      const lineHeight = itemHeight + padding;
      let totalHeight = titleHeight;
      ctx.textAlign = "left";
      ctx.textBaseline = "middle";
      let row = -1;
      let top = -lineHeight;
      this.legendItems.forEach((legendItem, i) => {
        const itemWidth = boxWidth + fontSize / 2 + ctx.measureText(legendItem.text).width;
        if (i === 0 || lineWidths[lineWidths.length - 1] + itemWidth + 2 * padding > maxWidth) {
          totalHeight += lineHeight;
          lineWidths[lineWidths.length - (i > 0 ? 0 : 1)] = 0;
          top += lineHeight;
          row++;
        }
        hitboxes[i] = { left: 0, top, row, width: itemWidth, height: itemHeight };
        lineWidths[lineWidths.length - 1] += itemWidth + padding;
      });
      return totalHeight;
    }
    _fitCols(titleHeight, fontSize, boxWidth, itemHeight) {
      const { ctx, maxHeight, options: { labels: { padding } } } = this;
      const hitboxes = this.legendHitBoxes = [];
      const columnSizes = this.columnSizes = [];
      const heightLimit = maxHeight - titleHeight;
      let totalWidth = padding;
      let currentColWidth = 0;
      let currentColHeight = 0;
      let left = 0;
      let col = 0;
      this.legendItems.forEach((legendItem, i) => {
        const itemWidth = boxWidth + fontSize / 2 + ctx.measureText(legendItem.text).width;
        if (i > 0 && currentColHeight + itemHeight + 2 * padding > heightLimit) {
          totalWidth += currentColWidth + padding;
          columnSizes.push({ width: currentColWidth, height: currentColHeight });
          left += currentColWidth + padding;
          col++;
          currentColWidth = currentColHeight = 0;
        }
        hitboxes[i] = { left, top: currentColHeight, col, width: itemWidth, height: itemHeight };
        currentColWidth = Math.max(currentColWidth, itemWidth);
        currentColHeight += itemHeight + padding;
      });
      totalWidth += currentColWidth;
      columnSizes.push({ width: currentColWidth, height: currentColHeight });
      return totalWidth;
    }
    adjustHitBoxes() {
      if (!this.options.display) {
        return;
      }
      const titleHeight = this._computeTitleHeight();
      const { legendHitBoxes: hitboxes, options: { align, labels: { padding }, rtl } } = this;
      const rtlHelper = getRtlAdapter(rtl, this.left, this.width);
      if (this.isHorizontal()) {
        let row = 0;
        let left = _alignStartEnd(align, this.left + padding, this.right - this.lineWidths[row]);
        for (const hitbox of hitboxes) {
          if (row !== hitbox.row) {
            row = hitbox.row;
            left = _alignStartEnd(align, this.left + padding, this.right - this.lineWidths[row]);
          }
          hitbox.top += this.top + titleHeight + padding;
          hitbox.left = rtlHelper.leftForLtr(rtlHelper.x(left), hitbox.width);
          left += hitbox.width + padding;
        }
      } else {
        let col = 0;
        let top = _alignStartEnd(align, this.top + titleHeight + padding, this.bottom - this.columnSizes[col].height);
        for (const hitbox of hitboxes) {
          if (hitbox.col !== col) {
            col = hitbox.col;
            top = _alignStartEnd(align, this.top + titleHeight + padding, this.bottom - this.columnSizes[col].height);
          }
          hitbox.top = top;
          hitbox.left += this.left + padding;
          hitbox.left = rtlHelper.leftForLtr(rtlHelper.x(hitbox.left), hitbox.width);
          top += hitbox.height + padding;
        }
      }
    }
    isHorizontal() {
      return this.options.position === "top" || this.options.position === "bottom";
    }
    draw() {
      if (this.options.display) {
        const ctx = this.ctx;
        clipArea(ctx, this);
        this._draw();
        unclipArea(ctx);
      }
    }
    _draw() {
      const { options: opts, columnSizes, lineWidths, ctx } = this;
      const { align, labels: labelOpts } = opts;
      const defaultColor = defaults.color;
      const rtlHelper = getRtlAdapter(opts.rtl, this.left, this.width);
      const labelFont = toFont(labelOpts.font);
      const { color: fontColor, padding } = labelOpts;
      const fontSize = labelFont.size;
      const halfFontSize = fontSize / 2;
      let cursor;
      this.drawTitle();
      ctx.textAlign = rtlHelper.textAlign("left");
      ctx.textBaseline = "middle";
      ctx.lineWidth = 0.5;
      ctx.font = labelFont.string;
      const { boxWidth, boxHeight, itemHeight } = getBoxSize(labelOpts, fontSize);
      const drawLegendBox = function(x, y, legendItem) {
        if (isNaN(boxWidth) || boxWidth <= 0 || isNaN(boxHeight) || boxHeight < 0) {
          return;
        }
        ctx.save();
        const lineWidth = valueOrDefault(legendItem.lineWidth, 1);
        ctx.fillStyle = valueOrDefault(legendItem.fillStyle, defaultColor);
        ctx.lineCap = valueOrDefault(legendItem.lineCap, "butt");
        ctx.lineDashOffset = valueOrDefault(legendItem.lineDashOffset, 0);
        ctx.lineJoin = valueOrDefault(legendItem.lineJoin, "miter");
        ctx.lineWidth = lineWidth;
        ctx.strokeStyle = valueOrDefault(legendItem.strokeStyle, defaultColor);
        ctx.setLineDash(valueOrDefault(legendItem.lineDash, []));
        if (labelOpts.usePointStyle) {
          const drawOptions = {
            radius: boxHeight * Math.SQRT2 / 2,
            pointStyle: legendItem.pointStyle,
            rotation: legendItem.rotation,
            borderWidth: lineWidth
          };
          const centerX = rtlHelper.xPlus(x, boxWidth / 2);
          const centerY = y + halfFontSize;
          drawPointLegend(ctx, drawOptions, centerX, centerY, labelOpts.pointStyleWidth && boxWidth);
        } else {
          const yBoxTop = y + Math.max((fontSize - boxHeight) / 2, 0);
          const xBoxLeft = rtlHelper.leftForLtr(x, boxWidth);
          const borderRadius = toTRBLCorners(legendItem.borderRadius);
          ctx.beginPath();
          if (Object.values(borderRadius).some((v) => v !== 0)) {
            addRoundedRectPath(ctx, {
              x: xBoxLeft,
              y: yBoxTop,
              w: boxWidth,
              h: boxHeight,
              radius: borderRadius
            });
          } else {
            ctx.rect(xBoxLeft, yBoxTop, boxWidth, boxHeight);
          }
          ctx.fill();
          if (lineWidth !== 0) {
            ctx.stroke();
          }
        }
        ctx.restore();
      };
      const fillText = function(x, y, legendItem) {
        renderText(ctx, legendItem.text, x, y + itemHeight / 2, labelFont, {
          strikethrough: legendItem.hidden,
          textAlign: rtlHelper.textAlign(legendItem.textAlign)
        });
      };
      const isHorizontal = this.isHorizontal();
      const titleHeight = this._computeTitleHeight();
      if (isHorizontal) {
        cursor = {
          x: _alignStartEnd(align, this.left + padding, this.right - lineWidths[0]),
          y: this.top + padding + titleHeight,
          line: 0
        };
      } else {
        cursor = {
          x: this.left + padding,
          y: _alignStartEnd(align, this.top + titleHeight + padding, this.bottom - columnSizes[0].height),
          line: 0
        };
      }
      overrideTextDirection(this.ctx, opts.textDirection);
      const lineHeight = itemHeight + padding;
      this.legendItems.forEach((legendItem, i) => {
        ctx.strokeStyle = legendItem.fontColor || fontColor;
        ctx.fillStyle = legendItem.fontColor || fontColor;
        const textWidth = ctx.measureText(legendItem.text).width;
        const textAlign = rtlHelper.textAlign(legendItem.textAlign || (legendItem.textAlign = labelOpts.textAlign));
        const width = boxWidth + halfFontSize + textWidth;
        let x = cursor.x;
        let y = cursor.y;
        rtlHelper.setWidth(this.width);
        if (isHorizontal) {
          if (i > 0 && x + width + padding > this.right) {
            y = cursor.y += lineHeight;
            cursor.line++;
            x = cursor.x = _alignStartEnd(align, this.left + padding, this.right - lineWidths[cursor.line]);
          }
        } else if (i > 0 && y + lineHeight > this.bottom) {
          x = cursor.x = x + columnSizes[cursor.line].width + padding;
          cursor.line++;
          y = cursor.y = _alignStartEnd(align, this.top + titleHeight + padding, this.bottom - columnSizes[cursor.line].height);
        }
        const realX = rtlHelper.x(x);
        drawLegendBox(realX, y, legendItem);
        x = _textX(textAlign, x + boxWidth + halfFontSize, isHorizontal ? x + width : this.right, opts.rtl);
        fillText(rtlHelper.x(x), y, legendItem);
        if (isHorizontal) {
          cursor.x += width + padding;
        } else {
          cursor.y += lineHeight;
        }
      });
      restoreTextDirection(this.ctx, opts.textDirection);
    }
    drawTitle() {
      const opts = this.options;
      const titleOpts = opts.title;
      const titleFont = toFont(titleOpts.font);
      const titlePadding = toPadding(titleOpts.padding);
      if (!titleOpts.display) {
        return;
      }
      const rtlHelper = getRtlAdapter(opts.rtl, this.left, this.width);
      const ctx = this.ctx;
      const position = titleOpts.position;
      const halfFontSize = titleFont.size / 2;
      const topPaddingPlusHalfFontSize = titlePadding.top + halfFontSize;
      let y;
      let left = this.left;
      let maxWidth = this.width;
      if (this.isHorizontal()) {
        maxWidth = Math.max(...this.lineWidths);
        y = this.top + topPaddingPlusHalfFontSize;
        left = _alignStartEnd(opts.align, left, this.right - maxWidth);
      } else {
        const maxHeight = this.columnSizes.reduce((acc, size) => Math.max(acc, size.height), 0);
        y = topPaddingPlusHalfFontSize + _alignStartEnd(opts.align, this.top, this.bottom - maxHeight - opts.labels.padding - this._computeTitleHeight());
      }
      const x = _alignStartEnd(position, left, left + maxWidth);
      ctx.textAlign = rtlHelper.textAlign(_toLeftRightCenter(position));
      ctx.textBaseline = "middle";
      ctx.strokeStyle = titleOpts.color;
      ctx.fillStyle = titleOpts.color;
      ctx.font = titleFont.string;
      renderText(ctx, titleOpts.text, x, y, titleFont);
    }
    _computeTitleHeight() {
      const titleOpts = this.options.title;
      const titleFont = toFont(titleOpts.font);
      const titlePadding = toPadding(titleOpts.padding);
      return titleOpts.display ? titleFont.lineHeight + titlePadding.height : 0;
    }
    _getLegendItemAt(x, y) {
      let i, hitBox, lh;
      if (_isBetween(x, this.left, this.right) && _isBetween(y, this.top, this.bottom)) {
        lh = this.legendHitBoxes;
        for (i = 0; i < lh.length; ++i) {
          hitBox = lh[i];
          if (_isBetween(x, hitBox.left, hitBox.left + hitBox.width) && _isBetween(y, hitBox.top, hitBox.top + hitBox.height)) {
            return this.legendItems[i];
          }
        }
      }
      return null;
    }
    handleEvent(e) {
      const opts = this.options;
      if (!isListened(e.type, opts)) {
        return;
      }
      const hoveredItem = this._getLegendItemAt(e.x, e.y);
      if (e.type === "mousemove" || e.type === "mouseout") {
        const previous = this._hoveredItem;
        const sameItem = itemsEqual(previous, hoveredItem);
        if (previous && !sameItem) {
          callback(opts.onLeave, [e, previous, this], this);
        }
        this._hoveredItem = hoveredItem;
        if (hoveredItem && !sameItem) {
          callback(opts.onHover, [e, hoveredItem, this], this);
        }
      } else if (hoveredItem) {
        callback(opts.onClick, [e, hoveredItem, this], this);
      }
    }
  };
  function isListened(type2, opts) {
    if ((type2 === "mousemove" || type2 === "mouseout") && (opts.onHover || opts.onLeave)) {
      return true;
    }
    if (opts.onClick && (type2 === "click" || type2 === "mouseup")) {
      return true;
    }
    return false;
  }
  var plugin_legend = {
    id: "legend",
    _element: Legend,
    start(chart, _args, options) {
      const legend5 = chart.legend = new Legend({ ctx: chart.ctx, options, chart });
      layouts.configure(chart, legend5, options);
      layouts.addBox(chart, legend5);
    },
    stop(chart) {
      layouts.removeBox(chart, chart.legend);
      delete chart.legend;
    },
    beforeUpdate(chart, _args, options) {
      const legend5 = chart.legend;
      layouts.configure(chart, legend5, options);
      legend5.options = options;
    },
    afterUpdate(chart) {
      const legend5 = chart.legend;
      legend5.buildLabels();
      legend5.adjustHitBoxes();
    },
    afterEvent(chart, args) {
      if (!args.replay) {
        chart.legend.handleEvent(args.event);
      }
    },
    defaults: {
      display: true,
      position: "top",
      align: "center",
      fullSize: true,
      reverse: false,
      weight: 1e3,
      onClick(e, legendItem, legend5) {
        const index3 = legendItem.datasetIndex;
        const ci = legend5.chart;
        if (ci.isDatasetVisible(index3)) {
          ci.hide(index3);
          legendItem.hidden = true;
        } else {
          ci.show(index3);
          legendItem.hidden = false;
        }
      },
      onHover: null,
      onLeave: null,
      labels: {
        color: (ctx) => ctx.chart.options.color,
        boxWidth: 40,
        padding: 10,
        generateLabels(chart) {
          const datasets = chart.data.datasets;
          const { labels: { usePointStyle, pointStyle, textAlign, color: color3 } } = chart.legend.options;
          return chart._getSortedDatasetMetas().map((meta) => {
            const style = meta.controller.getStyle(usePointStyle ? 0 : void 0);
            const borderWidth3 = toPadding(style.borderWidth);
            return {
              text: datasets[meta.index].label,
              fillStyle: style.backgroundColor,
              fontColor: color3,
              hidden: !meta.visible,
              lineCap: style.borderCapStyle,
              lineDash: style.borderDash,
              lineDashOffset: style.borderDashOffset,
              lineJoin: style.borderJoinStyle,
              lineWidth: (borderWidth3.width + borderWidth3.height) / 4,
              strokeStyle: style.borderColor,
              pointStyle: pointStyle || style.pointStyle,
              rotation: style.rotation,
              textAlign: textAlign || style.textAlign,
              borderRadius: 0,
              datasetIndex: meta.index
            };
          }, this);
        }
      },
      title: {
        color: (ctx) => ctx.chart.options.color,
        display: false,
        position: "center",
        text: ""
      }
    },
    descriptors: {
      _scriptable: (name) => !name.startsWith("on"),
      labels: {
        _scriptable: (name) => !["generateLabels", "filter", "sort"].includes(name)
      }
    }
  };
  var Title = class extends Element {
    constructor(config) {
      super();
      this.chart = config.chart;
      this.options = config.options;
      this.ctx = config.ctx;
      this._padding = void 0;
      this.top = void 0;
      this.bottom = void 0;
      this.left = void 0;
      this.right = void 0;
      this.width = void 0;
      this.height = void 0;
      this.position = void 0;
      this.weight = void 0;
      this.fullSize = void 0;
    }
    update(maxWidth, maxHeight) {
      const opts = this.options;
      this.left = 0;
      this.top = 0;
      if (!opts.display) {
        this.width = this.height = this.right = this.bottom = 0;
        return;
      }
      this.width = this.right = maxWidth;
      this.height = this.bottom = maxHeight;
      const lineCount = isArray(opts.text) ? opts.text.length : 1;
      this._padding = toPadding(opts.padding);
      const textSize = lineCount * toFont(opts.font).lineHeight + this._padding.height;
      if (this.isHorizontal()) {
        this.height = textSize;
      } else {
        this.width = textSize;
      }
    }
    isHorizontal() {
      const pos = this.options.position;
      return pos === "top" || pos === "bottom";
    }
    _drawArgs(offset) {
      const { top, left, bottom, right, options } = this;
      const align = options.align;
      let rotation = 0;
      let maxWidth, titleX, titleY;
      if (this.isHorizontal()) {
        titleX = _alignStartEnd(align, left, right);
        titleY = top + offset;
        maxWidth = right - left;
      } else {
        if (options.position === "left") {
          titleX = left + offset;
          titleY = _alignStartEnd(align, bottom, top);
          rotation = PI * -0.5;
        } else {
          titleX = right - offset;
          titleY = _alignStartEnd(align, top, bottom);
          rotation = PI * 0.5;
        }
        maxWidth = bottom - top;
      }
      return { titleX, titleY, maxWidth, rotation };
    }
    draw() {
      const ctx = this.ctx;
      const opts = this.options;
      if (!opts.display) {
        return;
      }
      const fontOpts = toFont(opts.font);
      const lineHeight = fontOpts.lineHeight;
      const offset = lineHeight / 2 + this._padding.top;
      const { titleX, titleY, maxWidth, rotation } = this._drawArgs(offset);
      renderText(ctx, opts.text, 0, 0, fontOpts, {
        color: opts.color,
        maxWidth,
        rotation,
        textAlign: _toLeftRightCenter(opts.align),
        textBaseline: "middle",
        translation: [titleX, titleY]
      });
    }
  };
  function createTitle(chart, titleOpts) {
    const title2 = new Title({
      ctx: chart.ctx,
      options: titleOpts,
      chart
    });
    layouts.configure(chart, title2, titleOpts);
    layouts.addBox(chart, title2);
    chart.titleBlock = title2;
  }
  var plugin_title = {
    id: "title",
    _element: Title,
    start(chart, _args, options) {
      createTitle(chart, options);
    },
    stop(chart) {
      const titleBlock = chart.titleBlock;
      layouts.removeBox(chart, titleBlock);
      delete chart.titleBlock;
    },
    beforeUpdate(chart, _args, options) {
      const title2 = chart.titleBlock;
      layouts.configure(chart, title2, options);
      title2.options = options;
    },
    defaults: {
      align: "center",
      display: false,
      font: {
        weight: "bold"
      },
      fullSize: true,
      padding: 10,
      position: "top",
      text: "",
      weight: 2e3
    },
    defaultRoutes: {
      color: "color"
    },
    descriptors: {
      _scriptable: true,
      _indexable: false
    }
  };
  var map2 = /* @__PURE__ */ new WeakMap();
  var plugin_subtitle = {
    id: "subtitle",
    start(chart, _args, options) {
      const title2 = new Title({
        ctx: chart.ctx,
        options,
        chart
      });
      layouts.configure(chart, title2, options);
      layouts.addBox(chart, title2);
      map2.set(chart, title2);
    },
    stop(chart) {
      layouts.removeBox(chart, map2.get(chart));
      map2.delete(chart);
    },
    beforeUpdate(chart, _args, options) {
      const title2 = map2.get(chart);
      layouts.configure(chart, title2, options);
      title2.options = options;
    },
    defaults: {
      align: "center",
      display: false,
      font: {
        weight: "normal"
      },
      fullSize: true,
      padding: 0,
      position: "top",
      text: "",
      weight: 1500
    },
    defaultRoutes: {
      color: "color"
    },
    descriptors: {
      _scriptable: true,
      _indexable: false
    }
  };
  var positioners = {
    average(items) {
      if (!items.length) {
        return false;
      }
      let i, len;
      let x = 0;
      let y = 0;
      let count = 0;
      for (i = 0, len = items.length; i < len; ++i) {
        const el = items[i].element;
        if (el && el.hasValue()) {
          const pos = el.tooltipPosition();
          x += pos.x;
          y += pos.y;
          ++count;
        }
      }
      return {
        x: x / count,
        y: y / count
      };
    },
    nearest(items, eventPosition) {
      if (!items.length) {
        return false;
      }
      let x = eventPosition.x;
      let y = eventPosition.y;
      let minDistance = Number.POSITIVE_INFINITY;
      let i, len, nearestElement;
      for (i = 0, len = items.length; i < len; ++i) {
        const el = items[i].element;
        if (el && el.hasValue()) {
          const center = el.getCenterPoint();
          const d = distanceBetweenPoints(eventPosition, center);
          if (d < minDistance) {
            minDistance = d;
            nearestElement = el;
          }
        }
      }
      if (nearestElement) {
        const tp = nearestElement.tooltipPosition();
        x = tp.x;
        y = tp.y;
      }
      return {
        x,
        y
      };
    }
  };
  function pushOrConcat(base, toPush) {
    if (toPush) {
      if (isArray(toPush)) {
        Array.prototype.push.apply(base, toPush);
      } else {
        base.push(toPush);
      }
    }
    return base;
  }
  function splitNewlines(str) {
    if ((typeof str === "string" || str instanceof String) && str.indexOf("\n") > -1) {
      return str.split("\n");
    }
    return str;
  }
  function createTooltipItem(chart, item) {
    const { element, datasetIndex, index: index3 } = item;
    const controller = chart.getDatasetMeta(datasetIndex).controller;
    const { label, value } = controller.getLabelAndValue(index3);
    return {
      chart,
      label,
      parsed: controller.getParsed(index3),
      raw: chart.data.datasets[datasetIndex].data[index3],
      formattedValue: value,
      dataset: controller.getDataset(),
      dataIndex: index3,
      datasetIndex,
      element
    };
  }
  function getTooltipSize(tooltip5, options) {
    const ctx = tooltip5.chart.ctx;
    const { body, footer, title: title2 } = tooltip5;
    const { boxWidth, boxHeight } = options;
    const bodyFont = toFont(options.bodyFont);
    const titleFont = toFont(options.titleFont);
    const footerFont = toFont(options.footerFont);
    const titleLineCount = title2.length;
    const footerLineCount = footer.length;
    const bodyLineItemCount = body.length;
    const padding = toPadding(options.padding);
    let height = padding.height;
    let width = 0;
    let combinedBodyLength = body.reduce((count, bodyItem) => count + bodyItem.before.length + bodyItem.lines.length + bodyItem.after.length, 0);
    combinedBodyLength += tooltip5.beforeBody.length + tooltip5.afterBody.length;
    if (titleLineCount) {
      height += titleLineCount * titleFont.lineHeight + (titleLineCount - 1) * options.titleSpacing + options.titleMarginBottom;
    }
    if (combinedBodyLength) {
      const bodyLineHeight = options.displayColors ? Math.max(boxHeight, bodyFont.lineHeight) : bodyFont.lineHeight;
      height += bodyLineItemCount * bodyLineHeight + (combinedBodyLength - bodyLineItemCount) * bodyFont.lineHeight + (combinedBodyLength - 1) * options.bodySpacing;
    }
    if (footerLineCount) {
      height += options.footerMarginTop + footerLineCount * footerFont.lineHeight + (footerLineCount - 1) * options.footerSpacing;
    }
    let widthPadding = 0;
    const maxLineWidth = function(line) {
      width = Math.max(width, ctx.measureText(line).width + widthPadding);
    };
    ctx.save();
    ctx.font = titleFont.string;
    each(tooltip5.title, maxLineWidth);
    ctx.font = bodyFont.string;
    each(tooltip5.beforeBody.concat(tooltip5.afterBody), maxLineWidth);
    widthPadding = options.displayColors ? boxWidth + 2 + options.boxPadding : 0;
    each(body, (bodyItem) => {
      each(bodyItem.before, maxLineWidth);
      each(bodyItem.lines, maxLineWidth);
      each(bodyItem.after, maxLineWidth);
    });
    widthPadding = 0;
    ctx.font = footerFont.string;
    each(tooltip5.footer, maxLineWidth);
    ctx.restore();
    width += padding.width;
    return { width, height };
  }
  function determineYAlign(chart, size) {
    const { y, height } = size;
    if (y < height / 2) {
      return "top";
    } else if (y > chart.height - height / 2) {
      return "bottom";
    }
    return "center";
  }
  function doesNotFitWithAlign(xAlign, chart, options, size) {
    const { x, width } = size;
    const caret = options.caretSize + options.caretPadding;
    if (xAlign === "left" && x + width + caret > chart.width) {
      return true;
    }
    if (xAlign === "right" && x - width - caret < 0) {
      return true;
    }
  }
  function determineXAlign(chart, options, size, yAlign) {
    const { x, width } = size;
    const { width: chartWidth, chartArea: { left, right } } = chart;
    let xAlign = "center";
    if (yAlign === "center") {
      xAlign = x <= (left + right) / 2 ? "left" : "right";
    } else if (x <= width / 2) {
      xAlign = "left";
    } else if (x >= chartWidth - width / 2) {
      xAlign = "right";
    }
    if (doesNotFitWithAlign(xAlign, chart, options, size)) {
      xAlign = "center";
    }
    return xAlign;
  }
  function determineAlignment(chart, options, size) {
    const yAlign = size.yAlign || options.yAlign || determineYAlign(chart, size);
    return {
      xAlign: size.xAlign || options.xAlign || determineXAlign(chart, options, size, yAlign),
      yAlign
    };
  }
  function alignX(size, xAlign) {
    let { x, width } = size;
    if (xAlign === "right") {
      x -= width;
    } else if (xAlign === "center") {
      x -= width / 2;
    }
    return x;
  }
  function alignY(size, yAlign, paddingAndSize) {
    let { y, height } = size;
    if (yAlign === "top") {
      y += paddingAndSize;
    } else if (yAlign === "bottom") {
      y -= height + paddingAndSize;
    } else {
      y -= height / 2;
    }
    return y;
  }
  function getBackgroundPoint(options, size, alignment, chart) {
    const { caretSize, caretPadding, cornerRadius } = options;
    const { xAlign, yAlign } = alignment;
    const paddingAndSize = caretSize + caretPadding;
    const { topLeft, topRight, bottomLeft, bottomRight } = toTRBLCorners(cornerRadius);
    let x = alignX(size, xAlign);
    const y = alignY(size, yAlign, paddingAndSize);
    if (yAlign === "center") {
      if (xAlign === "left") {
        x += paddingAndSize;
      } else if (xAlign === "right") {
        x -= paddingAndSize;
      }
    } else if (xAlign === "left") {
      x -= Math.max(topLeft, bottomLeft) + caretSize;
    } else if (xAlign === "right") {
      x += Math.max(topRight, bottomRight) + caretSize;
    }
    return {
      x: _limitValue(x, 0, chart.width - size.width),
      y: _limitValue(y, 0, chart.height - size.height)
    };
  }
  function getAlignedX(tooltip5, align, options) {
    const padding = toPadding(options.padding);
    return align === "center" ? tooltip5.x + tooltip5.width / 2 : align === "right" ? tooltip5.x + tooltip5.width - padding.right : tooltip5.x + padding.left;
  }
  function getBeforeAfterBodyLines(callback2) {
    return pushOrConcat([], splitNewlines(callback2));
  }
  function createTooltipContext(parent, tooltip5, tooltipItems) {
    return createContext(parent, {
      tooltip: tooltip5,
      tooltipItems,
      type: "tooltip"
    });
  }
  function overrideCallbacks(callbacks, context) {
    const override = context && context.dataset && context.dataset.tooltip && context.dataset.tooltip.callbacks;
    return override ? callbacks.override(override) : callbacks;
  }
  var Tooltip = class extends Element {
    constructor(config) {
      super();
      this.opacity = 0;
      this._active = [];
      this._eventPosition = void 0;
      this._size = void 0;
      this._cachedAnimations = void 0;
      this._tooltipItems = [];
      this.$animations = void 0;
      this.$context = void 0;
      this.chart = config.chart || config._chart;
      this._chart = this.chart;
      this.options = config.options;
      this.dataPoints = void 0;
      this.title = void 0;
      this.beforeBody = void 0;
      this.body = void 0;
      this.afterBody = void 0;
      this.footer = void 0;
      this.xAlign = void 0;
      this.yAlign = void 0;
      this.x = void 0;
      this.y = void 0;
      this.height = void 0;
      this.width = void 0;
      this.caretX = void 0;
      this.caretY = void 0;
      this.labelColors = void 0;
      this.labelPointStyles = void 0;
      this.labelTextColors = void 0;
    }
    initialize(options) {
      this.options = options;
      this._cachedAnimations = void 0;
      this.$context = void 0;
    }
    _resolveAnimations() {
      const cached = this._cachedAnimations;
      if (cached) {
        return cached;
      }
      const chart = this.chart;
      const options = this.options.setContext(this.getContext());
      const opts = options.enabled && chart.options.animation && options.animations;
      const animations = new Animations(this.chart, opts);
      if (opts._cacheable) {
        this._cachedAnimations = Object.freeze(animations);
      }
      return animations;
    }
    getContext() {
      return this.$context || (this.$context = createTooltipContext(this.chart.getContext(), this, this._tooltipItems));
    }
    getTitle(context, options) {
      const { callbacks } = options;
      const beforeTitle = callbacks.beforeTitle.apply(this, [context]);
      const title2 = callbacks.title.apply(this, [context]);
      const afterTitle = callbacks.afterTitle.apply(this, [context]);
      let lines = [];
      lines = pushOrConcat(lines, splitNewlines(beforeTitle));
      lines = pushOrConcat(lines, splitNewlines(title2));
      lines = pushOrConcat(lines, splitNewlines(afterTitle));
      return lines;
    }
    getBeforeBody(tooltipItems, options) {
      return getBeforeAfterBodyLines(options.callbacks.beforeBody.apply(this, [tooltipItems]));
    }
    getBody(tooltipItems, options) {
      const { callbacks } = options;
      const bodyItems = [];
      each(tooltipItems, (context) => {
        const bodyItem = {
          before: [],
          lines: [],
          after: []
        };
        const scoped = overrideCallbacks(callbacks, context);
        pushOrConcat(bodyItem.before, splitNewlines(scoped.beforeLabel.call(this, context)));
        pushOrConcat(bodyItem.lines, scoped.label.call(this, context));
        pushOrConcat(bodyItem.after, splitNewlines(scoped.afterLabel.call(this, context)));
        bodyItems.push(bodyItem);
      });
      return bodyItems;
    }
    getAfterBody(tooltipItems, options) {
      return getBeforeAfterBodyLines(options.callbacks.afterBody.apply(this, [tooltipItems]));
    }
    getFooter(tooltipItems, options) {
      const { callbacks } = options;
      const beforeFooter = callbacks.beforeFooter.apply(this, [tooltipItems]);
      const footer = callbacks.footer.apply(this, [tooltipItems]);
      const afterFooter = callbacks.afterFooter.apply(this, [tooltipItems]);
      let lines = [];
      lines = pushOrConcat(lines, splitNewlines(beforeFooter));
      lines = pushOrConcat(lines, splitNewlines(footer));
      lines = pushOrConcat(lines, splitNewlines(afterFooter));
      return lines;
    }
    _createItems(options) {
      const active = this._active;
      const data = this.chart.data;
      const labelColors = [];
      const labelPointStyles = [];
      const labelTextColors = [];
      let tooltipItems = [];
      let i, len;
      for (i = 0, len = active.length; i < len; ++i) {
        tooltipItems.push(createTooltipItem(this.chart, active[i]));
      }
      if (options.filter) {
        tooltipItems = tooltipItems.filter((element, index3, array2) => options.filter(element, index3, array2, data));
      }
      if (options.itemSort) {
        tooltipItems = tooltipItems.sort((a, b) => options.itemSort(a, b, data));
      }
      each(tooltipItems, (context) => {
        const scoped = overrideCallbacks(options.callbacks, context);
        labelColors.push(scoped.labelColor.call(this, context));
        labelPointStyles.push(scoped.labelPointStyle.call(this, context));
        labelTextColors.push(scoped.labelTextColor.call(this, context));
      });
      this.labelColors = labelColors;
      this.labelPointStyles = labelPointStyles;
      this.labelTextColors = labelTextColors;
      this.dataPoints = tooltipItems;
      return tooltipItems;
    }
    update(changed, replay) {
      const options = this.options.setContext(this.getContext());
      const active = this._active;
      let properties;
      let tooltipItems = [];
      if (!active.length) {
        if (this.opacity !== 0) {
          properties = {
            opacity: 0
          };
        }
      } else {
        const position = positioners[options.position].call(this, active, this._eventPosition);
        tooltipItems = this._createItems(options);
        this.title = this.getTitle(tooltipItems, options);
        this.beforeBody = this.getBeforeBody(tooltipItems, options);
        this.body = this.getBody(tooltipItems, options);
        this.afterBody = this.getAfterBody(tooltipItems, options);
        this.footer = this.getFooter(tooltipItems, options);
        const size = this._size = getTooltipSize(this, options);
        const positionAndSize = Object.assign({}, position, size);
        const alignment = determineAlignment(this.chart, options, positionAndSize);
        const backgroundPoint = getBackgroundPoint(options, positionAndSize, alignment, this.chart);
        this.xAlign = alignment.xAlign;
        this.yAlign = alignment.yAlign;
        properties = {
          opacity: 1,
          x: backgroundPoint.x,
          y: backgroundPoint.y,
          width: size.width,
          height: size.height,
          caretX: position.x,
          caretY: position.y
        };
      }
      this._tooltipItems = tooltipItems;
      this.$context = void 0;
      if (properties) {
        this._resolveAnimations().update(this, properties);
      }
      if (changed && options.external) {
        options.external.call(this, { chart: this.chart, tooltip: this, replay });
      }
    }
    drawCaret(tooltipPoint, ctx, size, options) {
      const caretPosition = this.getCaretPosition(tooltipPoint, size, options);
      ctx.lineTo(caretPosition.x1, caretPosition.y1);
      ctx.lineTo(caretPosition.x2, caretPosition.y2);
      ctx.lineTo(caretPosition.x3, caretPosition.y3);
    }
    getCaretPosition(tooltipPoint, size, options) {
      const { xAlign, yAlign } = this;
      const { caretSize, cornerRadius } = options;
      const { topLeft, topRight, bottomLeft, bottomRight } = toTRBLCorners(cornerRadius);
      const { x: ptX, y: ptY } = tooltipPoint;
      const { width, height } = size;
      let x1, x2, x3, y1, y2, y3;
      if (yAlign === "center") {
        y2 = ptY + height / 2;
        if (xAlign === "left") {
          x1 = ptX;
          x2 = x1 - caretSize;
          y1 = y2 + caretSize;
          y3 = y2 - caretSize;
        } else {
          x1 = ptX + width;
          x2 = x1 + caretSize;
          y1 = y2 - caretSize;
          y3 = y2 + caretSize;
        }
        x3 = x1;
      } else {
        if (xAlign === "left") {
          x2 = ptX + Math.max(topLeft, bottomLeft) + caretSize;
        } else if (xAlign === "right") {
          x2 = ptX + width - Math.max(topRight, bottomRight) - caretSize;
        } else {
          x2 = this.caretX;
        }
        if (yAlign === "top") {
          y1 = ptY;
          y2 = y1 - caretSize;
          x1 = x2 - caretSize;
          x3 = x2 + caretSize;
        } else {
          y1 = ptY + height;
          y2 = y1 + caretSize;
          x1 = x2 + caretSize;
          x3 = x2 - caretSize;
        }
        y3 = y1;
      }
      return { x1, x2, x3, y1, y2, y3 };
    }
    drawTitle(pt, ctx, options) {
      const title2 = this.title;
      const length = title2.length;
      let titleFont, titleSpacing, i;
      if (length) {
        const rtlHelper = getRtlAdapter(options.rtl, this.x, this.width);
        pt.x = getAlignedX(this, options.titleAlign, options);
        ctx.textAlign = rtlHelper.textAlign(options.titleAlign);
        ctx.textBaseline = "middle";
        titleFont = toFont(options.titleFont);
        titleSpacing = options.titleSpacing;
        ctx.fillStyle = options.titleColor;
        ctx.font = titleFont.string;
        for (i = 0; i < length; ++i) {
          ctx.fillText(title2[i], rtlHelper.x(pt.x), pt.y + titleFont.lineHeight / 2);
          pt.y += titleFont.lineHeight + titleSpacing;
          if (i + 1 === length) {
            pt.y += options.titleMarginBottom - titleSpacing;
          }
        }
      }
    }
    _drawColorBox(ctx, pt, i, rtlHelper, options) {
      const labelColors = this.labelColors[i];
      const labelPointStyle = this.labelPointStyles[i];
      const { boxHeight, boxWidth, boxPadding } = options;
      const bodyFont = toFont(options.bodyFont);
      const colorX = getAlignedX(this, "left", options);
      const rtlColorX = rtlHelper.x(colorX);
      const yOffSet = boxHeight < bodyFont.lineHeight ? (bodyFont.lineHeight - boxHeight) / 2 : 0;
      const colorY = pt.y + yOffSet;
      if (options.usePointStyle) {
        const drawOptions = {
          radius: Math.min(boxWidth, boxHeight) / 2,
          pointStyle: labelPointStyle.pointStyle,
          rotation: labelPointStyle.rotation,
          borderWidth: 1
        };
        const centerX = rtlHelper.leftForLtr(rtlColorX, boxWidth) + boxWidth / 2;
        const centerY = colorY + boxHeight / 2;
        ctx.strokeStyle = options.multiKeyBackground;
        ctx.fillStyle = options.multiKeyBackground;
        drawPoint(ctx, drawOptions, centerX, centerY);
        ctx.strokeStyle = labelColors.borderColor;
        ctx.fillStyle = labelColors.backgroundColor;
        drawPoint(ctx, drawOptions, centerX, centerY);
      } else {
        ctx.lineWidth = isObject(labelColors.borderWidth) ? Math.max(...Object.values(labelColors.borderWidth)) : labelColors.borderWidth || 1;
        ctx.strokeStyle = labelColors.borderColor;
        ctx.setLineDash(labelColors.borderDash || []);
        ctx.lineDashOffset = labelColors.borderDashOffset || 0;
        const outerX = rtlHelper.leftForLtr(rtlColorX, boxWidth - boxPadding);
        const innerX = rtlHelper.leftForLtr(rtlHelper.xPlus(rtlColorX, 1), boxWidth - boxPadding - 2);
        const borderRadius = toTRBLCorners(labelColors.borderRadius);
        if (Object.values(borderRadius).some((v) => v !== 0)) {
          ctx.beginPath();
          ctx.fillStyle = options.multiKeyBackground;
          addRoundedRectPath(ctx, {
            x: outerX,
            y: colorY,
            w: boxWidth,
            h: boxHeight,
            radius: borderRadius
          });
          ctx.fill();
          ctx.stroke();
          ctx.fillStyle = labelColors.backgroundColor;
          ctx.beginPath();
          addRoundedRectPath(ctx, {
            x: innerX,
            y: colorY + 1,
            w: boxWidth - 2,
            h: boxHeight - 2,
            radius: borderRadius
          });
          ctx.fill();
        } else {
          ctx.fillStyle = options.multiKeyBackground;
          ctx.fillRect(outerX, colorY, boxWidth, boxHeight);
          ctx.strokeRect(outerX, colorY, boxWidth, boxHeight);
          ctx.fillStyle = labelColors.backgroundColor;
          ctx.fillRect(innerX, colorY + 1, boxWidth - 2, boxHeight - 2);
        }
      }
      ctx.fillStyle = this.labelTextColors[i];
    }
    drawBody(pt, ctx, options) {
      const { body } = this;
      const { bodySpacing, bodyAlign, displayColors, boxHeight, boxWidth, boxPadding } = options;
      const bodyFont = toFont(options.bodyFont);
      let bodyLineHeight = bodyFont.lineHeight;
      let xLinePadding = 0;
      const rtlHelper = getRtlAdapter(options.rtl, this.x, this.width);
      const fillLineOfText = function(line) {
        ctx.fillText(line, rtlHelper.x(pt.x + xLinePadding), pt.y + bodyLineHeight / 2);
        pt.y += bodyLineHeight + bodySpacing;
      };
      const bodyAlignForCalculation = rtlHelper.textAlign(bodyAlign);
      let bodyItem, textColor, lines, i, j, ilen, jlen;
      ctx.textAlign = bodyAlign;
      ctx.textBaseline = "middle";
      ctx.font = bodyFont.string;
      pt.x = getAlignedX(this, bodyAlignForCalculation, options);
      ctx.fillStyle = options.bodyColor;
      each(this.beforeBody, fillLineOfText);
      xLinePadding = displayColors && bodyAlignForCalculation !== "right" ? bodyAlign === "center" ? boxWidth / 2 + boxPadding : boxWidth + 2 + boxPadding : 0;
      for (i = 0, ilen = body.length; i < ilen; ++i) {
        bodyItem = body[i];
        textColor = this.labelTextColors[i];
        ctx.fillStyle = textColor;
        each(bodyItem.before, fillLineOfText);
        lines = bodyItem.lines;
        if (displayColors && lines.length) {
          this._drawColorBox(ctx, pt, i, rtlHelper, options);
          bodyLineHeight = Math.max(bodyFont.lineHeight, boxHeight);
        }
        for (j = 0, jlen = lines.length; j < jlen; ++j) {
          fillLineOfText(lines[j]);
          bodyLineHeight = bodyFont.lineHeight;
        }
        each(bodyItem.after, fillLineOfText);
      }
      xLinePadding = 0;
      bodyLineHeight = bodyFont.lineHeight;
      each(this.afterBody, fillLineOfText);
      pt.y -= bodySpacing;
    }
    drawFooter(pt, ctx, options) {
      const footer = this.footer;
      const length = footer.length;
      let footerFont, i;
      if (length) {
        const rtlHelper = getRtlAdapter(options.rtl, this.x, this.width);
        pt.x = getAlignedX(this, options.footerAlign, options);
        pt.y += options.footerMarginTop;
        ctx.textAlign = rtlHelper.textAlign(options.footerAlign);
        ctx.textBaseline = "middle";
        footerFont = toFont(options.footerFont);
        ctx.fillStyle = options.footerColor;
        ctx.font = footerFont.string;
        for (i = 0; i < length; ++i) {
          ctx.fillText(footer[i], rtlHelper.x(pt.x), pt.y + footerFont.lineHeight / 2);
          pt.y += footerFont.lineHeight + options.footerSpacing;
        }
      }
    }
    drawBackground(pt, ctx, tooltipSize, options) {
      const { xAlign, yAlign } = this;
      const { x, y } = pt;
      const { width, height } = tooltipSize;
      const { topLeft, topRight, bottomLeft, bottomRight } = toTRBLCorners(options.cornerRadius);
      ctx.fillStyle = options.backgroundColor;
      ctx.strokeStyle = options.borderColor;
      ctx.lineWidth = options.borderWidth;
      ctx.beginPath();
      ctx.moveTo(x + topLeft, y);
      if (yAlign === "top") {
        this.drawCaret(pt, ctx, tooltipSize, options);
      }
      ctx.lineTo(x + width - topRight, y);
      ctx.quadraticCurveTo(x + width, y, x + width, y + topRight);
      if (yAlign === "center" && xAlign === "right") {
        this.drawCaret(pt, ctx, tooltipSize, options);
      }
      ctx.lineTo(x + width, y + height - bottomRight);
      ctx.quadraticCurveTo(x + width, y + height, x + width - bottomRight, y + height);
      if (yAlign === "bottom") {
        this.drawCaret(pt, ctx, tooltipSize, options);
      }
      ctx.lineTo(x + bottomLeft, y + height);
      ctx.quadraticCurveTo(x, y + height, x, y + height - bottomLeft);
      if (yAlign === "center" && xAlign === "left") {
        this.drawCaret(pt, ctx, tooltipSize, options);
      }
      ctx.lineTo(x, y + topLeft);
      ctx.quadraticCurveTo(x, y, x + topLeft, y);
      ctx.closePath();
      ctx.fill();
      if (options.borderWidth > 0) {
        ctx.stroke();
      }
    }
    _updateAnimationTarget(options) {
      const chart = this.chart;
      const anims = this.$animations;
      const animX = anims && anims.x;
      const animY = anims && anims.y;
      if (animX || animY) {
        const position = positioners[options.position].call(this, this._active, this._eventPosition);
        if (!position) {
          return;
        }
        const size = this._size = getTooltipSize(this, options);
        const positionAndSize = Object.assign({}, position, this._size);
        const alignment = determineAlignment(chart, options, positionAndSize);
        const point = getBackgroundPoint(options, positionAndSize, alignment, chart);
        if (animX._to !== point.x || animY._to !== point.y) {
          this.xAlign = alignment.xAlign;
          this.yAlign = alignment.yAlign;
          this.width = size.width;
          this.height = size.height;
          this.caretX = position.x;
          this.caretY = position.y;
          this._resolveAnimations().update(this, point);
        }
      }
    }
    _willRender() {
      return !!this.opacity;
    }
    draw(ctx) {
      const options = this.options.setContext(this.getContext());
      let opacity = this.opacity;
      if (!opacity) {
        return;
      }
      this._updateAnimationTarget(options);
      const tooltipSize = {
        width: this.width,
        height: this.height
      };
      const pt = {
        x: this.x,
        y: this.y
      };
      opacity = Math.abs(opacity) < 1e-3 ? 0 : opacity;
      const padding = toPadding(options.padding);
      const hasTooltipContent = this.title.length || this.beforeBody.length || this.body.length || this.afterBody.length || this.footer.length;
      if (options.enabled && hasTooltipContent) {
        ctx.save();
        ctx.globalAlpha = opacity;
        this.drawBackground(pt, ctx, tooltipSize, options);
        overrideTextDirection(ctx, options.textDirection);
        pt.y += padding.top;
        this.drawTitle(pt, ctx, options);
        this.drawBody(pt, ctx, options);
        this.drawFooter(pt, ctx, options);
        restoreTextDirection(ctx, options.textDirection);
        ctx.restore();
      }
    }
    getActiveElements() {
      return this._active || [];
    }
    setActiveElements(activeElements, eventPosition) {
      const lastActive = this._active;
      const active = activeElements.map(({ datasetIndex, index: index3 }) => {
        const meta = this.chart.getDatasetMeta(datasetIndex);
        if (!meta) {
          throw new Error("Cannot find a dataset at index " + datasetIndex);
        }
        return {
          datasetIndex,
          element: meta.data[index3],
          index: index3
        };
      });
      const changed = !_elementsEqual(lastActive, active);
      const positionChanged = this._positionChanged(active, eventPosition);
      if (changed || positionChanged) {
        this._active = active;
        this._eventPosition = eventPosition;
        this._ignoreReplayEvents = true;
        this.update(true);
      }
    }
    handleEvent(e, replay, inChartArea = true) {
      if (replay && this._ignoreReplayEvents) {
        return false;
      }
      this._ignoreReplayEvents = false;
      const options = this.options;
      const lastActive = this._active || [];
      const active = this._getActiveElements(e, lastActive, replay, inChartArea);
      const positionChanged = this._positionChanged(active, e);
      const changed = replay || !_elementsEqual(active, lastActive) || positionChanged;
      if (changed) {
        this._active = active;
        if (options.enabled || options.external) {
          this._eventPosition = {
            x: e.x,
            y: e.y
          };
          this.update(true, replay);
        }
      }
      return changed;
    }
    _getActiveElements(e, lastActive, replay, inChartArea) {
      const options = this.options;
      if (e.type === "mouseout") {
        return [];
      }
      if (!inChartArea) {
        return lastActive;
      }
      const active = this.chart.getElementsAtEventForMode(e, options.mode, options, replay);
      if (options.reverse) {
        active.reverse();
      }
      return active;
    }
    _positionChanged(active, e) {
      const { caretX, caretY, options } = this;
      const position = positioners[options.position].call(this, active, e);
      return position !== false && (caretX !== position.x || caretY !== position.y);
    }
  };
  Tooltip.positioners = positioners;
  var plugin_tooltip = {
    id: "tooltip",
    _element: Tooltip,
    positioners,
    afterInit(chart, _args, options) {
      if (options) {
        chart.tooltip = new Tooltip({ chart, options });
      }
    },
    beforeUpdate(chart, _args, options) {
      if (chart.tooltip) {
        chart.tooltip.initialize(options);
      }
    },
    reset(chart, _args, options) {
      if (chart.tooltip) {
        chart.tooltip.initialize(options);
      }
    },
    afterDraw(chart) {
      const tooltip5 = chart.tooltip;
      if (tooltip5 && tooltip5._willRender()) {
        const args = {
          tooltip: tooltip5
        };
        if (chart.notifyPlugins("beforeTooltipDraw", args) === false) {
          return;
        }
        tooltip5.draw(chart.ctx);
        chart.notifyPlugins("afterTooltipDraw", args);
      }
    },
    afterEvent(chart, args) {
      if (chart.tooltip) {
        const useFinalPosition = args.replay;
        if (chart.tooltip.handleEvent(args.event, useFinalPosition, args.inChartArea)) {
          args.changed = true;
        }
      }
    },
    defaults: {
      enabled: true,
      external: null,
      position: "average",
      backgroundColor: "rgba(0,0,0,0.8)",
      titleColor: "#fff",
      titleFont: {
        weight: "bold"
      },
      titleSpacing: 2,
      titleMarginBottom: 6,
      titleAlign: "left",
      bodyColor: "#fff",
      bodySpacing: 2,
      bodyFont: {},
      bodyAlign: "left",
      footerColor: "#fff",
      footerSpacing: 2,
      footerMarginTop: 6,
      footerFont: {
        weight: "bold"
      },
      footerAlign: "left",
      padding: 6,
      caretPadding: 2,
      caretSize: 5,
      cornerRadius: 6,
      boxHeight: (ctx, opts) => opts.bodyFont.size,
      boxWidth: (ctx, opts) => opts.bodyFont.size,
      multiKeyBackground: "#fff",
      displayColors: true,
      boxPadding: 0,
      borderColor: "rgba(0,0,0,0)",
      borderWidth: 0,
      animation: {
        duration: 400,
        easing: "easeOutQuart"
      },
      animations: {
        numbers: {
          type: "number",
          properties: ["x", "y", "width", "height", "caretX", "caretY"]
        },
        opacity: {
          easing: "linear",
          duration: 200
        }
      },
      callbacks: {
        beforeTitle: noop,
        title(tooltipItems) {
          if (tooltipItems.length > 0) {
            const item = tooltipItems[0];
            const labels = item.chart.data.labels;
            const labelCount = labels ? labels.length : 0;
            if (this && this.options && this.options.mode === "dataset") {
              return item.dataset.label || "";
            } else if (item.label) {
              return item.label;
            } else if (labelCount > 0 && item.dataIndex < labelCount) {
              return labels[item.dataIndex];
            }
          }
          return "";
        },
        afterTitle: noop,
        beforeBody: noop,
        beforeLabel: noop,
        label(tooltipItem) {
          if (this && this.options && this.options.mode === "dataset") {
            return tooltipItem.label + ": " + tooltipItem.formattedValue || tooltipItem.formattedValue;
          }
          let label = tooltipItem.dataset.label || "";
          if (label) {
            label += ": ";
          }
          const value = tooltipItem.formattedValue;
          if (!isNullOrUndef(value)) {
            label += value;
          }
          return label;
        },
        labelColor(tooltipItem) {
          const meta = tooltipItem.chart.getDatasetMeta(tooltipItem.datasetIndex);
          const options = meta.controller.getStyle(tooltipItem.dataIndex);
          return {
            borderColor: options.borderColor,
            backgroundColor: options.backgroundColor,
            borderWidth: options.borderWidth,
            borderDash: options.borderDash,
            borderDashOffset: options.borderDashOffset,
            borderRadius: 0
          };
        },
        labelTextColor() {
          return this.options.bodyColor;
        },
        labelPointStyle(tooltipItem) {
          const meta = tooltipItem.chart.getDatasetMeta(tooltipItem.datasetIndex);
          const options = meta.controller.getStyle(tooltipItem.dataIndex);
          return {
            pointStyle: options.pointStyle,
            rotation: options.rotation
          };
        },
        afterLabel: noop,
        afterBody: noop,
        beforeFooter: noop,
        footer: noop,
        afterFooter: noop
      }
    },
    defaultRoutes: {
      bodyFont: "font",
      footerFont: "font",
      titleFont: "font"
    },
    descriptors: {
      _scriptable: (name) => name !== "filter" && name !== "itemSort" && name !== "external",
      _indexable: false,
      callbacks: {
        _scriptable: false,
        _indexable: false
      },
      animation: {
        _fallback: false
      },
      animations: {
        _fallback: "animation"
      }
    },
    additionalOptionScopes: ["interaction"]
  };
  var plugins = /* @__PURE__ */ Object.freeze({
    __proto__: null,
    Decimation: plugin_decimation,
    Filler: index,
    Legend: plugin_legend,
    SubTitle: plugin_subtitle,
    Title: plugin_title,
    Tooltip: plugin_tooltip
  });
  var addIfString = (labels, raw, index3, addedLabels) => {
    if (typeof raw === "string") {
      index3 = labels.push(raw) - 1;
      addedLabels.unshift({ index: index3, label: raw });
    } else if (isNaN(raw)) {
      index3 = null;
    }
    return index3;
  };
  function findOrAddLabel(labels, raw, index3, addedLabels) {
    const first = labels.indexOf(raw);
    if (first === -1) {
      return addIfString(labels, raw, index3, addedLabels);
    }
    const last = labels.lastIndexOf(raw);
    return first !== last ? index3 : first;
  }
  var validIndex = (index3, max3) => index3 === null ? null : _limitValue(Math.round(index3), 0, max3);
  var CategoryScale = class extends Scale {
    constructor(cfg) {
      super(cfg);
      this._startValue = void 0;
      this._valueRange = 0;
      this._addedLabels = [];
    }
    init(scaleOptions) {
      const added = this._addedLabels;
      if (added.length) {
        const labels = this.getLabels();
        for (const { index: index3, label } of added) {
          if (labels[index3] === label) {
            labels.splice(index3, 1);
          }
        }
        this._addedLabels = [];
      }
      super.init(scaleOptions);
    }
    parse(raw, index3) {
      if (isNullOrUndef(raw)) {
        return null;
      }
      const labels = this.getLabels();
      index3 = isFinite(index3) && labels[index3] === raw ? index3 : findOrAddLabel(labels, raw, valueOrDefault(index3, raw), this._addedLabels);
      return validIndex(index3, labels.length - 1);
    }
    determineDataLimits() {
      const { minDefined, maxDefined } = this.getUserBounds();
      let { min: min3, max: max3 } = this.getMinMax(true);
      if (this.options.bounds === "ticks") {
        if (!minDefined) {
          min3 = 0;
        }
        if (!maxDefined) {
          max3 = this.getLabels().length - 1;
        }
      }
      this.min = min3;
      this.max = max3;
    }
    buildTicks() {
      const min3 = this.min;
      const max3 = this.max;
      const offset = this.options.offset;
      const ticks = [];
      let labels = this.getLabels();
      labels = min3 === 0 && max3 === labels.length - 1 ? labels : labels.slice(min3, max3 + 1);
      this._valueRange = Math.max(labels.length - (offset ? 0 : 1), 1);
      this._startValue = this.min - (offset ? 0.5 : 0);
      for (let value = min3; value <= max3; value++) {
        ticks.push({ value });
      }
      return ticks;
    }
    getLabelForValue(value) {
      const labels = this.getLabels();
      if (value >= 0 && value < labels.length) {
        return labels[value];
      }
      return value;
    }
    configure() {
      super.configure();
      if (!this.isHorizontal()) {
        this._reversePixels = !this._reversePixels;
      }
    }
    getPixelForValue(value) {
      if (typeof value !== "number") {
        value = this.parse(value);
      }
      return value === null ? NaN : this.getPixelForDecimal((value - this._startValue) / this._valueRange);
    }
    getPixelForTick(index3) {
      const ticks = this.ticks;
      if (index3 < 0 || index3 > ticks.length - 1) {
        return null;
      }
      return this.getPixelForValue(ticks[index3].value);
    }
    getValueForPixel(pixel) {
      return Math.round(this._startValue + this.getDecimalForPixel(pixel) * this._valueRange);
    }
    getBasePixel() {
      return this.bottom;
    }
  };
  CategoryScale.id = "category";
  CategoryScale.defaults = {
    ticks: {
      callback: CategoryScale.prototype.getLabelForValue
    }
  };
  function generateTicks$1(generationOptions, dataRange) {
    const ticks = [];
    const MIN_SPACING = 1e-14;
    const { bounds, step, min: min3, max: max3, precision, count, maxTicks, maxDigits, includeBounds } = generationOptions;
    const unit = step || 1;
    const maxSpaces = maxTicks - 1;
    const { min: rmin, max: rmax } = dataRange;
    const minDefined = !isNullOrUndef(min3);
    const maxDefined = !isNullOrUndef(max3);
    const countDefined = !isNullOrUndef(count);
    const minSpacing = (rmax - rmin) / (maxDigits + 1);
    let spacing = niceNum((rmax - rmin) / maxSpaces / unit) * unit;
    let factor, niceMin, niceMax, numSpaces;
    if (spacing < MIN_SPACING && !minDefined && !maxDefined) {
      return [{ value: rmin }, { value: rmax }];
    }
    numSpaces = Math.ceil(rmax / spacing) - Math.floor(rmin / spacing);
    if (numSpaces > maxSpaces) {
      spacing = niceNum(numSpaces * spacing / maxSpaces / unit) * unit;
    }
    if (!isNullOrUndef(precision)) {
      factor = Math.pow(10, precision);
      spacing = Math.ceil(spacing * factor) / factor;
    }
    if (bounds === "ticks") {
      niceMin = Math.floor(rmin / spacing) * spacing;
      niceMax = Math.ceil(rmax / spacing) * spacing;
    } else {
      niceMin = rmin;
      niceMax = rmax;
    }
    if (minDefined && maxDefined && step && almostWhole((max3 - min3) / step, spacing / 1e3)) {
      numSpaces = Math.round(Math.min((max3 - min3) / spacing, maxTicks));
      spacing = (max3 - min3) / numSpaces;
      niceMin = min3;
      niceMax = max3;
    } else if (countDefined) {
      niceMin = minDefined ? min3 : niceMin;
      niceMax = maxDefined ? max3 : niceMax;
      numSpaces = count - 1;
      spacing = (niceMax - niceMin) / numSpaces;
    } else {
      numSpaces = (niceMax - niceMin) / spacing;
      if (almostEquals(numSpaces, Math.round(numSpaces), spacing / 1e3)) {
        numSpaces = Math.round(numSpaces);
      } else {
        numSpaces = Math.ceil(numSpaces);
      }
    }
    const decimalPlaces = Math.max(
      _decimalPlaces(spacing),
      _decimalPlaces(niceMin)
    );
    factor = Math.pow(10, isNullOrUndef(precision) ? decimalPlaces : precision);
    niceMin = Math.round(niceMin * factor) / factor;
    niceMax = Math.round(niceMax * factor) / factor;
    let j = 0;
    if (minDefined) {
      if (includeBounds && niceMin !== min3) {
        ticks.push({ value: min3 });
        if (niceMin < min3) {
          j++;
        }
        if (almostEquals(Math.round((niceMin + j * spacing) * factor) / factor, min3, relativeLabelSize(min3, minSpacing, generationOptions))) {
          j++;
        }
      } else if (niceMin < min3) {
        j++;
      }
    }
    for (; j < numSpaces; ++j) {
      ticks.push({ value: Math.round((niceMin + j * spacing) * factor) / factor });
    }
    if (maxDefined && includeBounds && niceMax !== max3) {
      if (ticks.length && almostEquals(ticks[ticks.length - 1].value, max3, relativeLabelSize(max3, minSpacing, generationOptions))) {
        ticks[ticks.length - 1].value = max3;
      } else {
        ticks.push({ value: max3 });
      }
    } else if (!maxDefined || niceMax === max3) {
      ticks.push({ value: niceMax });
    }
    return ticks;
  }
  function relativeLabelSize(value, minSpacing, { horizontal, minRotation }) {
    const rad = toRadians(minRotation);
    const ratio = (horizontal ? Math.sin(rad) : Math.cos(rad)) || 1e-3;
    const length = 0.75 * minSpacing * ("" + value).length;
    return Math.min(minSpacing / ratio, length);
  }
  var LinearScaleBase = class extends Scale {
    constructor(cfg) {
      super(cfg);
      this.start = void 0;
      this.end = void 0;
      this._startValue = void 0;
      this._endValue = void 0;
      this._valueRange = 0;
    }
    parse(raw, index3) {
      if (isNullOrUndef(raw)) {
        return null;
      }
      if ((typeof raw === "number" || raw instanceof Number) && !isFinite(+raw)) {
        return null;
      }
      return +raw;
    }
    handleTickRangeOptions() {
      const { beginAtZero } = this.options;
      const { minDefined, maxDefined } = this.getUserBounds();
      let { min: min3, max: max3 } = this;
      const setMin = (v) => min3 = minDefined ? min3 : v;
      const setMax = (v) => max3 = maxDefined ? max3 : v;
      if (beginAtZero) {
        const minSign = sign(min3);
        const maxSign = sign(max3);
        if (minSign < 0 && maxSign < 0) {
          setMax(0);
        } else if (minSign > 0 && maxSign > 0) {
          setMin(0);
        }
      }
      if (min3 === max3) {
        let offset = 1;
        if (max3 >= Number.MAX_SAFE_INTEGER || min3 <= Number.MIN_SAFE_INTEGER) {
          offset = Math.abs(max3 * 0.05);
        }
        setMax(max3 + offset);
        if (!beginAtZero) {
          setMin(min3 - offset);
        }
      }
      this.min = min3;
      this.max = max3;
    }
    getTickLimit() {
      const tickOpts = this.options.ticks;
      let { maxTicksLimit, stepSize } = tickOpts;
      let maxTicks;
      if (stepSize) {
        maxTicks = Math.ceil(this.max / stepSize) - Math.floor(this.min / stepSize) + 1;
        if (maxTicks > 1e3) {
          console.warn(`scales.${this.id}.ticks.stepSize: ${stepSize} would result generating up to ${maxTicks} ticks. Limiting to 1000.`);
          maxTicks = 1e3;
        }
      } else {
        maxTicks = this.computeTickLimit();
        maxTicksLimit = maxTicksLimit || 11;
      }
      if (maxTicksLimit) {
        maxTicks = Math.min(maxTicksLimit, maxTicks);
      }
      return maxTicks;
    }
    computeTickLimit() {
      return Number.POSITIVE_INFINITY;
    }
    buildTicks() {
      const opts = this.options;
      const tickOpts = opts.ticks;
      let maxTicks = this.getTickLimit();
      maxTicks = Math.max(2, maxTicks);
      const numericGeneratorOptions = {
        maxTicks,
        bounds: opts.bounds,
        min: opts.min,
        max: opts.max,
        precision: tickOpts.precision,
        step: tickOpts.stepSize,
        count: tickOpts.count,
        maxDigits: this._maxDigits(),
        horizontal: this.isHorizontal(),
        minRotation: tickOpts.minRotation || 0,
        includeBounds: tickOpts.includeBounds !== false
      };
      const dataRange = this._range || this;
      const ticks = generateTicks$1(numericGeneratorOptions, dataRange);
      if (opts.bounds === "ticks") {
        _setMinAndMaxByKey(ticks, this, "value");
      }
      if (opts.reverse) {
        ticks.reverse();
        this.start = this.max;
        this.end = this.min;
      } else {
        this.start = this.min;
        this.end = this.max;
      }
      return ticks;
    }
    configure() {
      const ticks = this.ticks;
      let start2 = this.min;
      let end = this.max;
      super.configure();
      if (this.options.offset && ticks.length) {
        const offset = (end - start2) / Math.max(ticks.length - 1, 1) / 2;
        start2 -= offset;
        end += offset;
      }
      this._startValue = start2;
      this._endValue = end;
      this._valueRange = end - start2;
    }
    getLabelForValue(value) {
      return formatNumber(value, this.chart.options.locale, this.options.ticks.format);
    }
  };
  var LinearScale = class extends LinearScaleBase {
    determineDataLimits() {
      const { min: min3, max: max3 } = this.getMinMax(true);
      this.min = isNumberFinite(min3) ? min3 : 0;
      this.max = isNumberFinite(max3) ? max3 : 1;
      this.handleTickRangeOptions();
    }
    computeTickLimit() {
      const horizontal = this.isHorizontal();
      const length = horizontal ? this.width : this.height;
      const minRotation = toRadians(this.options.ticks.minRotation);
      const ratio = (horizontal ? Math.sin(minRotation) : Math.cos(minRotation)) || 1e-3;
      const tickFont = this._resolveTickFontOptions(0);
      return Math.ceil(length / Math.min(40, tickFont.lineHeight / ratio));
    }
    getPixelForValue(value) {
      return value === null ? NaN : this.getPixelForDecimal((value - this._startValue) / this._valueRange);
    }
    getValueForPixel(pixel) {
      return this._startValue + this.getDecimalForPixel(pixel) * this._valueRange;
    }
  };
  LinearScale.id = "linear";
  LinearScale.defaults = {
    ticks: {
      callback: Ticks.formatters.numeric
    }
  };
  function isMajor(tickVal) {
    const remain = tickVal / Math.pow(10, Math.floor(log10(tickVal)));
    return remain === 1;
  }
  function generateTicks(generationOptions, dataRange) {
    const endExp = Math.floor(log10(dataRange.max));
    const endSignificand = Math.ceil(dataRange.max / Math.pow(10, endExp));
    const ticks = [];
    let tickVal = finiteOrDefault(generationOptions.min, Math.pow(10, Math.floor(log10(dataRange.min))));
    let exp = Math.floor(log10(tickVal));
    let significand = Math.floor(tickVal / Math.pow(10, exp));
    let precision = exp < 0 ? Math.pow(10, Math.abs(exp)) : 1;
    do {
      ticks.push({ value: tickVal, major: isMajor(tickVal) });
      ++significand;
      if (significand === 10) {
        significand = 1;
        ++exp;
        precision = exp >= 0 ? 1 : precision;
      }
      tickVal = Math.round(significand * Math.pow(10, exp) * precision) / precision;
    } while (exp < endExp || exp === endExp && significand < endSignificand);
    const lastTick = finiteOrDefault(generationOptions.max, tickVal);
    ticks.push({ value: lastTick, major: isMajor(tickVal) });
    return ticks;
  }
  var LogarithmicScale = class extends Scale {
    constructor(cfg) {
      super(cfg);
      this.start = void 0;
      this.end = void 0;
      this._startValue = void 0;
      this._valueRange = 0;
    }
    parse(raw, index3) {
      const value = LinearScaleBase.prototype.parse.apply(this, [raw, index3]);
      if (value === 0) {
        this._zero = true;
        return void 0;
      }
      return isNumberFinite(value) && value > 0 ? value : null;
    }
    determineDataLimits() {
      const { min: min3, max: max3 } = this.getMinMax(true);
      this.min = isNumberFinite(min3) ? Math.max(0, min3) : null;
      this.max = isNumberFinite(max3) ? Math.max(0, max3) : null;
      if (this.options.beginAtZero) {
        this._zero = true;
      }
      this.handleTickRangeOptions();
    }
    handleTickRangeOptions() {
      const { minDefined, maxDefined } = this.getUserBounds();
      let min3 = this.min;
      let max3 = this.max;
      const setMin = (v) => min3 = minDefined ? min3 : v;
      const setMax = (v) => max3 = maxDefined ? max3 : v;
      const exp = (v, m) => Math.pow(10, Math.floor(log10(v)) + m);
      if (min3 === max3) {
        if (min3 <= 0) {
          setMin(1);
          setMax(10);
        } else {
          setMin(exp(min3, -1));
          setMax(exp(max3, 1));
        }
      }
      if (min3 <= 0) {
        setMin(exp(max3, -1));
      }
      if (max3 <= 0) {
        setMax(exp(min3, 1));
      }
      if (this._zero && this.min !== this._suggestedMin && min3 === exp(this.min, 0)) {
        setMin(exp(min3, -1));
      }
      this.min = min3;
      this.max = max3;
    }
    buildTicks() {
      const opts = this.options;
      const generationOptions = {
        min: this._userMin,
        max: this._userMax
      };
      const ticks = generateTicks(generationOptions, this);
      if (opts.bounds === "ticks") {
        _setMinAndMaxByKey(ticks, this, "value");
      }
      if (opts.reverse) {
        ticks.reverse();
        this.start = this.max;
        this.end = this.min;
      } else {
        this.start = this.min;
        this.end = this.max;
      }
      return ticks;
    }
    getLabelForValue(value) {
      return value === void 0 ? "0" : formatNumber(value, this.chart.options.locale, this.options.ticks.format);
    }
    configure() {
      const start2 = this.min;
      super.configure();
      this._startValue = log10(start2);
      this._valueRange = log10(this.max) - log10(start2);
    }
    getPixelForValue(value) {
      if (value === void 0 || value === 0) {
        value = this.min;
      }
      if (value === null || isNaN(value)) {
        return NaN;
      }
      return this.getPixelForDecimal(value === this.min ? 0 : (log10(value) - this._startValue) / this._valueRange);
    }
    getValueForPixel(pixel) {
      const decimal = this.getDecimalForPixel(pixel);
      return Math.pow(10, this._startValue + decimal * this._valueRange);
    }
  };
  LogarithmicScale.id = "logarithmic";
  LogarithmicScale.defaults = {
    ticks: {
      callback: Ticks.formatters.logarithmic,
      major: {
        enabled: true
      }
    }
  };
  function getTickBackdropHeight(opts) {
    const tickOpts = opts.ticks;
    if (tickOpts.display && opts.display) {
      const padding = toPadding(tickOpts.backdropPadding);
      return valueOrDefault(tickOpts.font && tickOpts.font.size, defaults.font.size) + padding.height;
    }
    return 0;
  }
  function measureLabelSize(ctx, font, label) {
    label = isArray(label) ? label : [label];
    return {
      w: _longestText(ctx, font.string, label),
      h: label.length * font.lineHeight
    };
  }
  function determineLimits(angle, pos, size, min3, max3) {
    if (angle === min3 || angle === max3) {
      return {
        start: pos - size / 2,
        end: pos + size / 2
      };
    } else if (angle < min3 || angle > max3) {
      return {
        start: pos - size,
        end: pos
      };
    }
    return {
      start: pos,
      end: pos + size
    };
  }
  function fitWithPointLabels(scale) {
    const orig = {
      l: scale.left + scale._padding.left,
      r: scale.right - scale._padding.right,
      t: scale.top + scale._padding.top,
      b: scale.bottom - scale._padding.bottom
    };
    const limits = Object.assign({}, orig);
    const labelSizes = [];
    const padding = [];
    const valueCount = scale._pointLabels.length;
    const pointLabelOpts = scale.options.pointLabels;
    const additionalAngle = pointLabelOpts.centerPointLabels ? PI / valueCount : 0;
    for (let i = 0; i < valueCount; i++) {
      const opts = pointLabelOpts.setContext(scale.getPointLabelContext(i));
      padding[i] = opts.padding;
      const pointPosition = scale.getPointPosition(i, scale.drawingArea + padding[i], additionalAngle);
      const plFont = toFont(opts.font);
      const textSize = measureLabelSize(scale.ctx, plFont, scale._pointLabels[i]);
      labelSizes[i] = textSize;
      const angleRadians = _normalizeAngle(scale.getIndexAngle(i) + additionalAngle);
      const angle = Math.round(toDegrees(angleRadians));
      const hLimits = determineLimits(angle, pointPosition.x, textSize.w, 0, 180);
      const vLimits = determineLimits(angle, pointPosition.y, textSize.h, 90, 270);
      updateLimits(limits, orig, angleRadians, hLimits, vLimits);
    }
    scale.setCenterPoint(
      orig.l - limits.l,
      limits.r - orig.r,
      orig.t - limits.t,
      limits.b - orig.b
    );
    scale._pointLabelItems = buildPointLabelItems(scale, labelSizes, padding);
  }
  function updateLimits(limits, orig, angle, hLimits, vLimits) {
    const sin = Math.abs(Math.sin(angle));
    const cos = Math.abs(Math.cos(angle));
    let x = 0;
    let y = 0;
    if (hLimits.start < orig.l) {
      x = (orig.l - hLimits.start) / sin;
      limits.l = Math.min(limits.l, orig.l - x);
    } else if (hLimits.end > orig.r) {
      x = (hLimits.end - orig.r) / sin;
      limits.r = Math.max(limits.r, orig.r + x);
    }
    if (vLimits.start < orig.t) {
      y = (orig.t - vLimits.start) / cos;
      limits.t = Math.min(limits.t, orig.t - y);
    } else if (vLimits.end > orig.b) {
      y = (vLimits.end - orig.b) / cos;
      limits.b = Math.max(limits.b, orig.b + y);
    }
  }
  function buildPointLabelItems(scale, labelSizes, padding) {
    const items = [];
    const valueCount = scale._pointLabels.length;
    const opts = scale.options;
    const extra = getTickBackdropHeight(opts) / 2;
    const outerDistance = scale.drawingArea;
    const additionalAngle = opts.pointLabels.centerPointLabels ? PI / valueCount : 0;
    for (let i = 0; i < valueCount; i++) {
      const pointLabelPosition = scale.getPointPosition(i, outerDistance + extra + padding[i], additionalAngle);
      const angle = Math.round(toDegrees(_normalizeAngle(pointLabelPosition.angle + HALF_PI)));
      const size = labelSizes[i];
      const y = yForAngle(pointLabelPosition.y, size.h, angle);
      const textAlign = getTextAlignForAngle(angle);
      const left = leftForTextAlign(pointLabelPosition.x, size.w, textAlign);
      items.push({
        x: pointLabelPosition.x,
        y,
        textAlign,
        left,
        top: y,
        right: left + size.w,
        bottom: y + size.h
      });
    }
    return items;
  }
  function getTextAlignForAngle(angle) {
    if (angle === 0 || angle === 180) {
      return "center";
    } else if (angle < 180) {
      return "left";
    }
    return "right";
  }
  function leftForTextAlign(x, w, align) {
    if (align === "right") {
      x -= w;
    } else if (align === "center") {
      x -= w / 2;
    }
    return x;
  }
  function yForAngle(y, h, angle) {
    if (angle === 90 || angle === 270) {
      y -= h / 2;
    } else if (angle > 270 || angle < 90) {
      y -= h;
    }
    return y;
  }
  function drawPointLabels(scale, labelCount) {
    const { ctx, options: { pointLabels } } = scale;
    for (let i = labelCount - 1; i >= 0; i--) {
      const optsAtIndex = pointLabels.setContext(scale.getPointLabelContext(i));
      const plFont = toFont(optsAtIndex.font);
      const { x, y, textAlign, left, top, right, bottom } = scale._pointLabelItems[i];
      const { backdropColor } = optsAtIndex;
      if (!isNullOrUndef(backdropColor)) {
        const borderRadius = toTRBLCorners(optsAtIndex.borderRadius);
        const padding = toPadding(optsAtIndex.backdropPadding);
        ctx.fillStyle = backdropColor;
        const backdropLeft = left - padding.left;
        const backdropTop = top - padding.top;
        const backdropWidth = right - left + padding.width;
        const backdropHeight = bottom - top + padding.height;
        if (Object.values(borderRadius).some((v) => v !== 0)) {
          ctx.beginPath();
          addRoundedRectPath(ctx, {
            x: backdropLeft,
            y: backdropTop,
            w: backdropWidth,
            h: backdropHeight,
            radius: borderRadius
          });
          ctx.fill();
        } else {
          ctx.fillRect(backdropLeft, backdropTop, backdropWidth, backdropHeight);
        }
      }
      renderText(
        ctx,
        scale._pointLabels[i],
        x,
        y + plFont.lineHeight / 2,
        plFont,
        {
          color: optsAtIndex.color,
          textAlign,
          textBaseline: "middle"
        }
      );
    }
  }
  function pathRadiusLine(scale, radius3, circular, labelCount) {
    const { ctx } = scale;
    if (circular) {
      ctx.arc(scale.xCenter, scale.yCenter, radius3, 0, TAU);
    } else {
      let pointPosition = scale.getPointPosition(0, radius3);
      ctx.moveTo(pointPosition.x, pointPosition.y);
      for (let i = 1; i < labelCount; i++) {
        pointPosition = scale.getPointPosition(i, radius3);
        ctx.lineTo(pointPosition.x, pointPosition.y);
      }
    }
  }
  function drawRadiusLine(scale, gridLineOpts, radius3, labelCount) {
    const ctx = scale.ctx;
    const circular = gridLineOpts.circular;
    const { color: color3, lineWidth } = gridLineOpts;
    if (!circular && !labelCount || !color3 || !lineWidth || radius3 < 0) {
      return;
    }
    ctx.save();
    ctx.strokeStyle = color3;
    ctx.lineWidth = lineWidth;
    ctx.setLineDash(gridLineOpts.borderDash);
    ctx.lineDashOffset = gridLineOpts.borderDashOffset;
    ctx.beginPath();
    pathRadiusLine(scale, radius3, circular, labelCount);
    ctx.closePath();
    ctx.stroke();
    ctx.restore();
  }
  function createPointLabelContext(parent, index3, label) {
    return createContext(parent, {
      label,
      index: index3,
      type: "pointLabel"
    });
  }
  var RadialLinearScale = class extends LinearScaleBase {
    constructor(cfg) {
      super(cfg);
      this.xCenter = void 0;
      this.yCenter = void 0;
      this.drawingArea = void 0;
      this._pointLabels = [];
      this._pointLabelItems = [];
    }
    setDimensions() {
      const padding = this._padding = toPadding(getTickBackdropHeight(this.options) / 2);
      const w = this.width = this.maxWidth - padding.width;
      const h = this.height = this.maxHeight - padding.height;
      this.xCenter = Math.floor(this.left + w / 2 + padding.left);
      this.yCenter = Math.floor(this.top + h / 2 + padding.top);
      this.drawingArea = Math.floor(Math.min(w, h) / 2);
    }
    determineDataLimits() {
      const { min: min3, max: max3 } = this.getMinMax(false);
      this.min = isNumberFinite(min3) && !isNaN(min3) ? min3 : 0;
      this.max = isNumberFinite(max3) && !isNaN(max3) ? max3 : 0;
      this.handleTickRangeOptions();
    }
    computeTickLimit() {
      return Math.ceil(this.drawingArea / getTickBackdropHeight(this.options));
    }
    generateTickLabels(ticks) {
      LinearScaleBase.prototype.generateTickLabels.call(this, ticks);
      this._pointLabels = this.getLabels().map((value, index3) => {
        const label = callback(this.options.pointLabels.callback, [value, index3], this);
        return label || label === 0 ? label : "";
      }).filter((v, i) => this.chart.getDataVisibility(i));
    }
    fit() {
      const opts = this.options;
      if (opts.display && opts.pointLabels.display) {
        fitWithPointLabels(this);
      } else {
        this.setCenterPoint(0, 0, 0, 0);
      }
    }
    setCenterPoint(leftMovement, rightMovement, topMovement, bottomMovement) {
      this.xCenter += Math.floor((leftMovement - rightMovement) / 2);
      this.yCenter += Math.floor((topMovement - bottomMovement) / 2);
      this.drawingArea -= Math.min(this.drawingArea / 2, Math.max(leftMovement, rightMovement, topMovement, bottomMovement));
    }
    getIndexAngle(index3) {
      const angleMultiplier = TAU / (this._pointLabels.length || 1);
      const startAngle = this.options.startAngle || 0;
      return _normalizeAngle(index3 * angleMultiplier + toRadians(startAngle));
    }
    getDistanceFromCenterForValue(value) {
      if (isNullOrUndef(value)) {
        return NaN;
      }
      const scalingFactor = this.drawingArea / (this.max - this.min);
      if (this.options.reverse) {
        return (this.max - value) * scalingFactor;
      }
      return (value - this.min) * scalingFactor;
    }
    getValueForDistanceFromCenter(distance) {
      if (isNullOrUndef(distance)) {
        return NaN;
      }
      const scaledDistance = distance / (this.drawingArea / (this.max - this.min));
      return this.options.reverse ? this.max - scaledDistance : this.min + scaledDistance;
    }
    getPointLabelContext(index3) {
      const pointLabels = this._pointLabels || [];
      if (index3 >= 0 && index3 < pointLabels.length) {
        const pointLabel = pointLabels[index3];
        return createPointLabelContext(this.getContext(), index3, pointLabel);
      }
    }
    getPointPosition(index3, distanceFromCenter, additionalAngle = 0) {
      const angle = this.getIndexAngle(index3) - HALF_PI + additionalAngle;
      return {
        x: Math.cos(angle) * distanceFromCenter + this.xCenter,
        y: Math.sin(angle) * distanceFromCenter + this.yCenter,
        angle
      };
    }
    getPointPositionForValue(index3, value) {
      return this.getPointPosition(index3, this.getDistanceFromCenterForValue(value));
    }
    getBasePosition(index3) {
      return this.getPointPositionForValue(index3 || 0, this.getBaseValue());
    }
    getPointLabelPosition(index3) {
      const { left, top, right, bottom } = this._pointLabelItems[index3];
      return {
        left,
        top,
        right,
        bottom
      };
    }
    drawBackground() {
      const { backgroundColor: backgroundColor4, grid: { circular } } = this.options;
      if (backgroundColor4) {
        const ctx = this.ctx;
        ctx.save();
        ctx.beginPath();
        pathRadiusLine(this, this.getDistanceFromCenterForValue(this._endValue), circular, this._pointLabels.length);
        ctx.closePath();
        ctx.fillStyle = backgroundColor4;
        ctx.fill();
        ctx.restore();
      }
    }
    drawGrid() {
      const ctx = this.ctx;
      const opts = this.options;
      const { angleLines, grid } = opts;
      const labelCount = this._pointLabels.length;
      let i, offset, position;
      if (opts.pointLabels.display) {
        drawPointLabels(this, labelCount);
      }
      if (grid.display) {
        this.ticks.forEach((tick, index3) => {
          if (index3 !== 0) {
            offset = this.getDistanceFromCenterForValue(tick.value);
            const optsAtIndex = grid.setContext(this.getContext(index3 - 1));
            drawRadiusLine(this, optsAtIndex, offset, labelCount);
          }
        });
      }
      if (angleLines.display) {
        ctx.save();
        for (i = labelCount - 1; i >= 0; i--) {
          const optsAtIndex = angleLines.setContext(this.getPointLabelContext(i));
          const { color: color3, lineWidth } = optsAtIndex;
          if (!lineWidth || !color3) {
            continue;
          }
          ctx.lineWidth = lineWidth;
          ctx.strokeStyle = color3;
          ctx.setLineDash(optsAtIndex.borderDash);
          ctx.lineDashOffset = optsAtIndex.borderDashOffset;
          offset = this.getDistanceFromCenterForValue(opts.ticks.reverse ? this.min : this.max);
          position = this.getPointPosition(i, offset);
          ctx.beginPath();
          ctx.moveTo(this.xCenter, this.yCenter);
          ctx.lineTo(position.x, position.y);
          ctx.stroke();
        }
        ctx.restore();
      }
    }
    drawBorder() {
    }
    drawLabels() {
      const ctx = this.ctx;
      const opts = this.options;
      const tickOpts = opts.ticks;
      if (!tickOpts.display) {
        return;
      }
      const startAngle = this.getIndexAngle(0);
      let offset, width;
      ctx.save();
      ctx.translate(this.xCenter, this.yCenter);
      ctx.rotate(startAngle);
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      this.ticks.forEach((tick, index3) => {
        if (index3 === 0 && !opts.reverse) {
          return;
        }
        const optsAtIndex = tickOpts.setContext(this.getContext(index3));
        const tickFont = toFont(optsAtIndex.font);
        offset = this.getDistanceFromCenterForValue(this.ticks[index3].value);
        if (optsAtIndex.showLabelBackdrop) {
          ctx.font = tickFont.string;
          width = ctx.measureText(tick.label).width;
          ctx.fillStyle = optsAtIndex.backdropColor;
          const padding = toPadding(optsAtIndex.backdropPadding);
          ctx.fillRect(
            -width / 2 - padding.left,
            -offset - tickFont.size / 2 - padding.top,
            width + padding.width,
            tickFont.size + padding.height
          );
        }
        renderText(ctx, tick.label, 0, -offset, tickFont, {
          color: optsAtIndex.color
        });
      });
      ctx.restore();
    }
    drawTitle() {
    }
  };
  RadialLinearScale.id = "radialLinear";
  RadialLinearScale.defaults = {
    display: true,
    animate: true,
    position: "chartArea",
    angleLines: {
      display: true,
      lineWidth: 1,
      borderDash: [],
      borderDashOffset: 0
    },
    grid: {
      circular: false
    },
    startAngle: 0,
    ticks: {
      showLabelBackdrop: true,
      callback: Ticks.formatters.numeric
    },
    pointLabels: {
      backdropColor: void 0,
      backdropPadding: 2,
      display: true,
      font: {
        size: 10
      },
      callback(label) {
        return label;
      },
      padding: 5,
      centerPointLabels: false
    }
  };
  RadialLinearScale.defaultRoutes = {
    "angleLines.color": "borderColor",
    "pointLabels.color": "color",
    "ticks.color": "color"
  };
  RadialLinearScale.descriptors = {
    angleLines: {
      _fallback: "grid"
    }
  };
  var INTERVALS = {
    millisecond: { common: true, size: 1, steps: 1e3 },
    second: { common: true, size: 1e3, steps: 60 },
    minute: { common: true, size: 6e4, steps: 60 },
    hour: { common: true, size: 36e5, steps: 24 },
    day: { common: true, size: 864e5, steps: 30 },
    week: { common: false, size: 6048e5, steps: 4 },
    month: { common: true, size: 2628e6, steps: 12 },
    quarter: { common: false, size: 7884e6, steps: 4 },
    year: { common: true, size: 3154e7 }
  };
  var UNITS = Object.keys(INTERVALS);
  function sorter(a, b) {
    return a - b;
  }
  function parse(scale, input) {
    if (isNullOrUndef(input)) {
      return null;
    }
    const adapter = scale._adapter;
    const { parser, round: round2, isoWeekday } = scale._parseOpts;
    let value = input;
    if (typeof parser === "function") {
      value = parser(value);
    }
    if (!isNumberFinite(value)) {
      value = typeof parser === "string" ? adapter.parse(value, parser) : adapter.parse(value);
    }
    if (value === null) {
      return null;
    }
    if (round2) {
      value = round2 === "week" && (isNumber(isoWeekday) || isoWeekday === true) ? adapter.startOf(value, "isoWeek", isoWeekday) : adapter.startOf(value, round2);
    }
    return +value;
  }
  function determineUnitForAutoTicks(minUnit, min3, max3, capacity) {
    const ilen = UNITS.length;
    for (let i = UNITS.indexOf(minUnit); i < ilen - 1; ++i) {
      const interval2 = INTERVALS[UNITS[i]];
      const factor = interval2.steps ? interval2.steps : Number.MAX_SAFE_INTEGER;
      if (interval2.common && Math.ceil((max3 - min3) / (factor * interval2.size)) <= capacity) {
        return UNITS[i];
      }
    }
    return UNITS[ilen - 1];
  }
  function determineUnitForFormatting(scale, numTicks, minUnit, min3, max3) {
    for (let i = UNITS.length - 1; i >= UNITS.indexOf(minUnit); i--) {
      const unit = UNITS[i];
      if (INTERVALS[unit].common && scale._adapter.diff(max3, min3, unit) >= numTicks - 1) {
        return unit;
      }
    }
    return UNITS[minUnit ? UNITS.indexOf(minUnit) : 0];
  }
  function determineMajorUnit(unit) {
    for (let i = UNITS.indexOf(unit) + 1, ilen = UNITS.length; i < ilen; ++i) {
      if (INTERVALS[UNITS[i]].common) {
        return UNITS[i];
      }
    }
  }
  function addTick(ticks, time, timestamps) {
    if (!timestamps) {
      ticks[time] = true;
    } else if (timestamps.length) {
      const { lo, hi } = _lookup(timestamps, time);
      const timestamp = timestamps[lo] >= time ? timestamps[lo] : timestamps[hi];
      ticks[timestamp] = true;
    }
  }
  function setMajorTicks(scale, ticks, map4, majorUnit) {
    const adapter = scale._adapter;
    const first = +adapter.startOf(ticks[0].value, majorUnit);
    const last = ticks[ticks.length - 1].value;
    let major, index3;
    for (major = first; major <= last; major = +adapter.add(major, 1, majorUnit)) {
      index3 = map4[major];
      if (index3 >= 0) {
        ticks[index3].major = true;
      }
    }
    return ticks;
  }
  function ticksFromTimestamps(scale, values, majorUnit) {
    const ticks = [];
    const map4 = {};
    const ilen = values.length;
    let i, value;
    for (i = 0; i < ilen; ++i) {
      value = values[i];
      map4[value] = i;
      ticks.push({
        value,
        major: false
      });
    }
    return ilen === 0 || !majorUnit ? ticks : setMajorTicks(scale, ticks, map4, majorUnit);
  }
  var TimeScale = class extends Scale {
    constructor(props) {
      super(props);
      this._cache = {
        data: [],
        labels: [],
        all: []
      };
      this._unit = "day";
      this._majorUnit = void 0;
      this._offsets = {};
      this._normalized = false;
      this._parseOpts = void 0;
    }
    init(scaleOpts, opts) {
      const time = scaleOpts.time || (scaleOpts.time = {});
      const adapter = this._adapter = new adapters._date(scaleOpts.adapters.date);
      adapter.init(opts);
      mergeIf(time.displayFormats, adapter.formats());
      this._parseOpts = {
        parser: time.parser,
        round: time.round,
        isoWeekday: time.isoWeekday
      };
      super.init(scaleOpts);
      this._normalized = opts.normalized;
    }
    parse(raw, index3) {
      if (raw === void 0) {
        return null;
      }
      return parse(this, raw);
    }
    beforeLayout() {
      super.beforeLayout();
      this._cache = {
        data: [],
        labels: [],
        all: []
      };
    }
    determineDataLimits() {
      const options = this.options;
      const adapter = this._adapter;
      const unit = options.time.unit || "day";
      let { min: min3, max: max3, minDefined, maxDefined } = this.getUserBounds();
      function _applyBounds(bounds) {
        if (!minDefined && !isNaN(bounds.min)) {
          min3 = Math.min(min3, bounds.min);
        }
        if (!maxDefined && !isNaN(bounds.max)) {
          max3 = Math.max(max3, bounds.max);
        }
      }
      if (!minDefined || !maxDefined) {
        _applyBounds(this._getLabelBounds());
        if (options.bounds !== "ticks" || options.ticks.source !== "labels") {
          _applyBounds(this.getMinMax(false));
        }
      }
      min3 = isNumberFinite(min3) && !isNaN(min3) ? min3 : +adapter.startOf(Date.now(), unit);
      max3 = isNumberFinite(max3) && !isNaN(max3) ? max3 : +adapter.endOf(Date.now(), unit) + 1;
      this.min = Math.min(min3, max3 - 1);
      this.max = Math.max(min3 + 1, max3);
    }
    _getLabelBounds() {
      const arr = this.getLabelTimestamps();
      let min3 = Number.POSITIVE_INFINITY;
      let max3 = Number.NEGATIVE_INFINITY;
      if (arr.length) {
        min3 = arr[0];
        max3 = arr[arr.length - 1];
      }
      return { min: min3, max: max3 };
    }
    buildTicks() {
      const options = this.options;
      const timeOpts = options.time;
      const tickOpts = options.ticks;
      const timestamps = tickOpts.source === "labels" ? this.getLabelTimestamps() : this._generate();
      if (options.bounds === "ticks" && timestamps.length) {
        this.min = this._userMin || timestamps[0];
        this.max = this._userMax || timestamps[timestamps.length - 1];
      }
      const min3 = this.min;
      const max3 = this.max;
      const ticks = _filterBetween(timestamps, min3, max3);
      this._unit = timeOpts.unit || (tickOpts.autoSkip ? determineUnitForAutoTicks(timeOpts.minUnit, this.min, this.max, this._getLabelCapacity(min3)) : determineUnitForFormatting(this, ticks.length, timeOpts.minUnit, this.min, this.max));
      this._majorUnit = !tickOpts.major.enabled || this._unit === "year" ? void 0 : determineMajorUnit(this._unit);
      this.initOffsets(timestamps);
      if (options.reverse) {
        ticks.reverse();
      }
      return ticksFromTimestamps(this, ticks, this._majorUnit);
    }
    afterAutoSkip() {
      if (this.options.offsetAfterAutoskip) {
        this.initOffsets(this.ticks.map((tick) => +tick.value));
      }
    }
    initOffsets(timestamps) {
      let start2 = 0;
      let end = 0;
      let first, last;
      if (this.options.offset && timestamps.length) {
        first = this.getDecimalForValue(timestamps[0]);
        if (timestamps.length === 1) {
          start2 = 1 - first;
        } else {
          start2 = (this.getDecimalForValue(timestamps[1]) - first) / 2;
        }
        last = this.getDecimalForValue(timestamps[timestamps.length - 1]);
        if (timestamps.length === 1) {
          end = last;
        } else {
          end = (last - this.getDecimalForValue(timestamps[timestamps.length - 2])) / 2;
        }
      }
      const limit = timestamps.length < 3 ? 0.5 : 0.25;
      start2 = _limitValue(start2, 0, limit);
      end = _limitValue(end, 0, limit);
      this._offsets = { start: start2, end, factor: 1 / (start2 + 1 + end) };
    }
    _generate() {
      const adapter = this._adapter;
      const min3 = this.min;
      const max3 = this.max;
      const options = this.options;
      const timeOpts = options.time;
      const minor = timeOpts.unit || determineUnitForAutoTicks(timeOpts.minUnit, min3, max3, this._getLabelCapacity(min3));
      const stepSize = valueOrDefault(timeOpts.stepSize, 1);
      const weekday2 = minor === "week" ? timeOpts.isoWeekday : false;
      const hasWeekday = isNumber(weekday2) || weekday2 === true;
      const ticks = {};
      let first = min3;
      let time, count;
      if (hasWeekday) {
        first = +adapter.startOf(first, "isoWeek", weekday2);
      }
      first = +adapter.startOf(first, hasWeekday ? "day" : minor);
      if (adapter.diff(max3, min3, minor) > 1e5 * stepSize) {
        throw new Error(min3 + " and " + max3 + " are too far apart with stepSize of " + stepSize + " " + minor);
      }
      const timestamps = options.ticks.source === "data" && this.getDataTimestamps();
      for (time = first, count = 0; time < max3; time = +adapter.add(time, stepSize, minor), count++) {
        addTick(ticks, time, timestamps);
      }
      if (time === max3 || options.bounds === "ticks" || count === 1) {
        addTick(ticks, time, timestamps);
      }
      return Object.keys(ticks).sort((a, b) => a - b).map((x) => +x);
    }
    getLabelForValue(value) {
      const adapter = this._adapter;
      const timeOpts = this.options.time;
      if (timeOpts.tooltipFormat) {
        return adapter.format(value, timeOpts.tooltipFormat);
      }
      return adapter.format(value, timeOpts.displayFormats.datetime);
    }
    _tickFormatFunction(time, index3, ticks, format2) {
      const options = this.options;
      const formats = options.time.displayFormats;
      const unit = this._unit;
      const majorUnit = this._majorUnit;
      const minorFormat = unit && formats[unit];
      const majorFormat = majorUnit && formats[majorUnit];
      const tick = ticks[index3];
      const major = majorUnit && majorFormat && tick && tick.major;
      const label = this._adapter.format(time, format2 || (major ? majorFormat : minorFormat));
      const formatter2 = options.ticks.callback;
      return formatter2 ? callback(formatter2, [label, index3, ticks], this) : label;
    }
    generateTickLabels(ticks) {
      let i, ilen, tick;
      for (i = 0, ilen = ticks.length; i < ilen; ++i) {
        tick = ticks[i];
        tick.label = this._tickFormatFunction(tick.value, i, ticks);
      }
    }
    getDecimalForValue(value) {
      return value === null ? NaN : (value - this.min) / (this.max - this.min);
    }
    getPixelForValue(value) {
      const offsets = this._offsets;
      const pos = this.getDecimalForValue(value);
      return this.getPixelForDecimal((offsets.start + pos) * offsets.factor);
    }
    getValueForPixel(pixel) {
      const offsets = this._offsets;
      const pos = this.getDecimalForPixel(pixel) / offsets.factor - offsets.end;
      return this.min + pos * (this.max - this.min);
    }
    _getLabelSize(label) {
      const ticksOpts = this.options.ticks;
      const tickLabelWidth = this.ctx.measureText(label).width;
      const angle = toRadians(this.isHorizontal() ? ticksOpts.maxRotation : ticksOpts.minRotation);
      const cosRotation = Math.cos(angle);
      const sinRotation = Math.sin(angle);
      const tickFontSize = this._resolveTickFontOptions(0).size;
      return {
        w: tickLabelWidth * cosRotation + tickFontSize * sinRotation,
        h: tickLabelWidth * sinRotation + tickFontSize * cosRotation
      };
    }
    _getLabelCapacity(exampleTime) {
      const timeOpts = this.options.time;
      const displayFormats = timeOpts.displayFormats;
      const format2 = displayFormats[timeOpts.unit] || displayFormats.millisecond;
      const exampleLabel = this._tickFormatFunction(exampleTime, 0, ticksFromTimestamps(this, [exampleTime], this._majorUnit), format2);
      const size = this._getLabelSize(exampleLabel);
      const capacity = Math.floor(this.isHorizontal() ? this.width / size.w : this.height / size.h) - 1;
      return capacity > 0 ? capacity : 1;
    }
    getDataTimestamps() {
      let timestamps = this._cache.data || [];
      let i, ilen;
      if (timestamps.length) {
        return timestamps;
      }
      const metas = this.getMatchingVisibleMetas();
      if (this._normalized && metas.length) {
        return this._cache.data = metas[0].controller.getAllParsedValues(this);
      }
      for (i = 0, ilen = metas.length; i < ilen; ++i) {
        timestamps = timestamps.concat(metas[i].controller.getAllParsedValues(this));
      }
      return this._cache.data = this.normalize(timestamps);
    }
    getLabelTimestamps() {
      const timestamps = this._cache.labels || [];
      let i, ilen;
      if (timestamps.length) {
        return timestamps;
      }
      const labels = this.getLabels();
      for (i = 0, ilen = labels.length; i < ilen; ++i) {
        timestamps.push(parse(this, labels[i]));
      }
      return this._cache.labels = this._normalized ? timestamps : this.normalize(timestamps);
    }
    normalize(values) {
      return _arrayUnique(values.sort(sorter));
    }
  };
  TimeScale.id = "time";
  TimeScale.defaults = {
    bounds: "data",
    adapters: {},
    time: {
      parser: false,
      unit: false,
      round: false,
      isoWeekday: false,
      minUnit: "millisecond",
      displayFormats: {}
    },
    ticks: {
      source: "auto",
      major: {
        enabled: false
      }
    }
  };
  function interpolate2(table, val, reverse) {
    let lo = 0;
    let hi = table.length - 1;
    let prevSource, nextSource, prevTarget, nextTarget;
    if (reverse) {
      if (val >= table[lo].pos && val <= table[hi].pos) {
        ({ lo, hi } = _lookupByKey(table, "pos", val));
      }
      ({ pos: prevSource, time: prevTarget } = table[lo]);
      ({ pos: nextSource, time: nextTarget } = table[hi]);
    } else {
      if (val >= table[lo].time && val <= table[hi].time) {
        ({ lo, hi } = _lookupByKey(table, "time", val));
      }
      ({ time: prevSource, pos: prevTarget } = table[lo]);
      ({ time: nextSource, pos: nextTarget } = table[hi]);
    }
    const span = nextSource - prevSource;
    return span ? prevTarget + (nextTarget - prevTarget) * (val - prevSource) / span : prevTarget;
  }
  var TimeSeriesScale = class extends TimeScale {
    constructor(props) {
      super(props);
      this._table = [];
      this._minPos = void 0;
      this._tableRange = void 0;
    }
    initOffsets() {
      const timestamps = this._getTimestampsForTable();
      const table = this._table = this.buildLookupTable(timestamps);
      this._minPos = interpolate2(table, this.min);
      this._tableRange = interpolate2(table, this.max) - this._minPos;
      super.initOffsets(timestamps);
    }
    buildLookupTable(timestamps) {
      const { min: min3, max: max3 } = this;
      const items = [];
      const table = [];
      let i, ilen, prev, curr, next;
      for (i = 0, ilen = timestamps.length; i < ilen; ++i) {
        curr = timestamps[i];
        if (curr >= min3 && curr <= max3) {
          items.push(curr);
        }
      }
      if (items.length < 2) {
        return [
          { time: min3, pos: 0 },
          { time: max3, pos: 1 }
        ];
      }
      for (i = 0, ilen = items.length; i < ilen; ++i) {
        next = items[i + 1];
        prev = items[i - 1];
        curr = items[i];
        if (Math.round((next + prev) / 2) !== curr) {
          table.push({ time: curr, pos: i / (ilen - 1) });
        }
      }
      return table;
    }
    _getTimestampsForTable() {
      let timestamps = this._cache.all || [];
      if (timestamps.length) {
        return timestamps;
      }
      const data = this.getDataTimestamps();
      const label = this.getLabelTimestamps();
      if (data.length && label.length) {
        timestamps = this.normalize(data.concat(label));
      } else {
        timestamps = data.length ? data : label;
      }
      timestamps = this._cache.all = timestamps;
      return timestamps;
    }
    getDecimalForValue(value) {
      return (interpolate2(this._table, value) - this._minPos) / this._tableRange;
    }
    getValueForPixel(pixel) {
      const offsets = this._offsets;
      const decimal = this.getDecimalForPixel(pixel) / offsets.factor - offsets.end;
      return interpolate2(this._table, decimal * this._tableRange + this._minPos, true);
    }
  };
  TimeSeriesScale.id = "timeseries";
  TimeSeriesScale.defaults = TimeScale.defaults;
  var scales = /* @__PURE__ */ Object.freeze({
    __proto__: null,
    CategoryScale,
    LinearScale,
    LogarithmicScale,
    RadialLinearScale,
    TimeScale,
    TimeSeriesScale
  });
  var registerables = [
    controllers,
    elements,
    plugins,
    scales
  ];

  // node_modules/chartjs-plugin-annotation/dist/chartjs-plugin-annotation.esm.js
  var interaction = {
    modes: {
      point(state, event) {
        return filterElements(state, event, { intersect: true });
      },
      nearest(state, event, options) {
        return getNearestItem(state, event, options);
      },
      x(state, event, options) {
        return filterElements(state, event, { intersect: options.intersect, axis: "x" });
      },
      y(state, event, options) {
        return filterElements(state, event, { intersect: options.intersect, axis: "y" });
      }
    }
  };
  function getElements(state, event, options) {
    const mode = interaction.modes[options.mode] || interaction.modes.nearest;
    return mode(state, event, options);
  }
  function inRangeByAxis(element, event, axis) {
    if (axis !== "x" && axis !== "y") {
      return element.inRange(event.x, event.y, "x", true) || element.inRange(event.x, event.y, "y", true);
    }
    return element.inRange(event.x, event.y, axis, true);
  }
  function getPointByAxis(event, center, axis) {
    if (axis === "x") {
      return { x: event.x, y: center.y };
    } else if (axis === "y") {
      return { x: center.x, y: event.y };
    }
    return center;
  }
  function filterElements(state, event, options) {
    return state.visibleElements.filter((element) => options.intersect ? element.inRange(event.x, event.y) : inRangeByAxis(element, event, options.axis));
  }
  function getNearestItem(state, event, options) {
    let minDistance = Number.POSITIVE_INFINITY;
    return filterElements(state, event, options).reduce((nearestItems, element) => {
      const center = element.getCenterPoint();
      const evenPoint = getPointByAxis(event, center, options.axis);
      const distance = distanceBetweenPoints(event, evenPoint);
      if (distance < minDistance) {
        nearestItems = [element];
        minDistance = distance;
      } else if (distance === minDistance) {
        nearestItems.push(element);
      }
      return nearestItems;
    }, []).sort((a, b) => a._index - b._index).slice(0, 1);
  }
  var moveHooks = ["enter", "leave"];
  var hooks = moveHooks.concat("click");
  function updateListeners(chart, state, options) {
    state.listened = false;
    state.moveListened = false;
    state._getElements = getElements;
    hooks.forEach((hook) => {
      if (typeof options[hook] === "function") {
        state.listened = true;
        state.listeners[hook] = options[hook];
      } else if (defined(state.listeners[hook])) {
        delete state.listeners[hook];
      }
    });
    moveHooks.forEach((hook) => {
      if (typeof options[hook] === "function") {
        state.moveListened = true;
      }
    });
    if (!state.listened || !state.moveListened) {
      state.annotations.forEach((scope) => {
        if (!state.listened && typeof scope.click === "function") {
          state.listened = true;
        }
        if (!state.moveListened) {
          moveHooks.forEach((hook) => {
            if (typeof scope[hook] === "function") {
              state.listened = true;
              state.moveListened = true;
            }
          });
        }
      });
    }
  }
  function handleEvent(state, event, options) {
    if (state.listened) {
      switch (event.type) {
        case "mousemove":
        case "mouseout":
          return handleMoveEvents(state, event, options);
        case "click":
          return handleClickEvents(state, event, options);
      }
    }
  }
  function handleMoveEvents(state, event, options) {
    if (!state.moveListened) {
      return;
    }
    let elements2;
    if (event.type === "mousemove") {
      elements2 = getElements(state, event, options.interaction);
    } else {
      elements2 = [];
    }
    const previous = state.hovered;
    state.hovered = elements2;
    const context = { state, event };
    let changed = dispatchMoveEvents(context, "leave", previous, elements2);
    return dispatchMoveEvents(context, "enter", elements2, previous) || changed;
  }
  function dispatchMoveEvents({ state, event }, hook, elements2, checkElements) {
    let changed;
    for (const element of elements2) {
      if (checkElements.indexOf(element) < 0) {
        changed = dispatchEvent(element.options[hook] || state.listeners[hook], element, event) || changed;
      }
    }
    return changed;
  }
  function handleClickEvents(state, event, options) {
    const listeners = state.listeners;
    const elements2 = getElements(state, event, options.interaction);
    let changed;
    for (const element of elements2) {
      changed = dispatchEvent(element.options.click || listeners.click, element, event) || changed;
    }
    return changed;
  }
  function dispatchEvent(handler, element, event) {
    return callback(handler, [element.$context, event]) === true;
  }
  var isOlderPart = (act, req) => req > act || act.length > req.length && act.slice(0, req.length) === req;
  var EPSILON2 = 1e-3;
  var clamp = (x, from2, to2) => Math.min(to2, Math.max(from2, x));
  function clampAll(obj, from2, to2) {
    for (const key of Object.keys(obj)) {
      obj[key] = clamp(obj[key], from2, to2);
    }
    return obj;
  }
  function inPointRange(point, center, radius3, borderWidth3) {
    if (!point || !center || radius3 <= 0) {
      return false;
    }
    const hBorderWidth = borderWidth3 / 2;
    return Math.pow(point.x - center.x, 2) + Math.pow(point.y - center.y, 2) <= Math.pow(radius3 + hBorderWidth, 2);
  }
  function inBoxRange(point, { x, y, x2, y2 }, axis, borderWidth3) {
    const hBorderWidth = borderWidth3 / 2;
    const inRangeX = point.x >= x - hBorderWidth - EPSILON2 && point.x <= x2 + hBorderWidth + EPSILON2;
    const inRangeY = point.y >= y - hBorderWidth - EPSILON2 && point.y <= y2 + hBorderWidth + EPSILON2;
    if (axis === "x") {
      return inRangeX;
    } else if (axis === "y") {
      return inRangeY;
    }
    return inRangeX && inRangeY;
  }
  function getElementCenterPoint(element, useFinalPosition) {
    const { centerX, centerY } = element.getProps(["centerX", "centerY"], useFinalPosition);
    return { x: centerX, y: centerY };
  }
  function requireVersion(pkg, min3, ver, strict = true) {
    const parts = ver.split(".");
    let i = 0;
    for (const req of min3.split(".")) {
      const act = parts[i++];
      if (parseInt(req, 10) < parseInt(act, 10)) {
        break;
      }
      if (isOlderPart(act, req)) {
        if (strict) {
          throw new Error(`${pkg} v${ver} is not supported. v${min3} or newer is required.`);
        } else {
          return false;
        }
      }
    }
    return true;
  }
  var isPercentString = (s) => typeof s === "string" && s.endsWith("%");
  var toPercent = (s) => clamp(parseFloat(s) / 100, 0, 1);
  function getRelativePosition2(size, position) {
    if (position === "start") {
      return 0;
    }
    if (position === "end") {
      return size;
    }
    if (isPercentString(position)) {
      return toPercent(position) * size;
    }
    return size / 2;
  }
  function getSize(size, value) {
    if (typeof value === "number") {
      return value;
    } else if (isPercentString(value)) {
      return toPercent(value) * size;
    }
    return size;
  }
  function calculateTextAlignment(size, options) {
    const { x, width } = size;
    const textAlign = options.textAlign;
    if (textAlign === "center") {
      return x + width / 2;
    } else if (textAlign === "end" || textAlign === "right") {
      return x + width;
    }
    return x;
  }
  function toPosition(value) {
    if (isObject(value)) {
      return {
        x: valueOrDefault(value.x, "center"),
        y: valueOrDefault(value.y, "center")
      };
    }
    value = valueOrDefault(value, "center");
    return {
      x: value,
      y: value
    };
  }
  function isBoundToPoint(options) {
    return options && (defined(options.xValue) || defined(options.yValue));
  }
  var widthCache = /* @__PURE__ */ new Map();
  function isImageOrCanvas(content) {
    if (content && typeof content === "object") {
      const type2 = content.toString();
      return type2 === "[object HTMLImageElement]" || type2 === "[object HTMLCanvasElement]";
    }
  }
  function translate(ctx, { x, y }, rotation) {
    if (rotation) {
      ctx.translate(x, y);
      ctx.rotate(toRadians(rotation));
      ctx.translate(-x, -y);
    }
  }
  function setBorderStyle(ctx, options) {
    if (options && options.borderWidth) {
      ctx.lineCap = options.borderCapStyle;
      ctx.setLineDash(options.borderDash);
      ctx.lineDashOffset = options.borderDashOffset;
      ctx.lineJoin = options.borderJoinStyle;
      ctx.lineWidth = options.borderWidth;
      ctx.strokeStyle = options.borderColor;
      return true;
    }
  }
  function setShadowStyle(ctx, options) {
    ctx.shadowColor = options.backgroundShadowColor;
    ctx.shadowBlur = options.shadowBlur;
    ctx.shadowOffsetX = options.shadowOffsetX;
    ctx.shadowOffsetY = options.shadowOffsetY;
  }
  function measureLabelSize2(ctx, options) {
    const content = options.content;
    if (isImageOrCanvas(content)) {
      return {
        width: getSize(content.width, options.width),
        height: getSize(content.height, options.height)
      };
    }
    const font = toFont(options.font);
    const strokeWidth = options.textStrokeWidth;
    const lines = isArray(content) ? content : [content];
    const mapKey = lines.join() + font.string + strokeWidth + (ctx._measureText ? "-spriting" : "");
    if (!widthCache.has(mapKey)) {
      ctx.save();
      ctx.font = font.string;
      const count = lines.length;
      let width = 0;
      for (let i = 0; i < count; i++) {
        const text = lines[i];
        width = Math.max(width, ctx.measureText(text).width + strokeWidth);
      }
      ctx.restore();
      const height = count * font.lineHeight + strokeWidth;
      widthCache.set(mapKey, { width, height });
    }
    return widthCache.get(mapKey);
  }
  function drawBox(ctx, rect, options) {
    const { x, y, width, height } = rect;
    ctx.save();
    setShadowStyle(ctx, options);
    const stroke = setBorderStyle(ctx, options);
    ctx.fillStyle = options.backgroundColor;
    ctx.beginPath();
    addRoundedRectPath(ctx, {
      x,
      y,
      w: width,
      h: height,
      radius: clampAll(toTRBLCorners(options.borderRadius), 0, Math.min(width, height) / 2)
    });
    ctx.closePath();
    ctx.fill();
    if (stroke) {
      ctx.shadowColor = options.borderShadowColor;
      ctx.stroke();
    }
    ctx.restore();
  }
  function drawLabel(ctx, rect, options) {
    const content = options.content;
    if (isImageOrCanvas(content)) {
      ctx.drawImage(content, rect.x, rect.y, rect.width, rect.height);
      return;
    }
    const labels = isArray(content) ? content : [content];
    const font = toFont(options.font);
    const lh = font.lineHeight;
    const x = calculateTextAlignment(rect, options);
    const y = rect.y + lh / 2 + options.textStrokeWidth / 2;
    ctx.save();
    ctx.font = font.string;
    ctx.textBaseline = "middle";
    ctx.textAlign = options.textAlign;
    if (setTextStrokeStyle(ctx, options)) {
      labels.forEach((l, i) => ctx.strokeText(l, x, y + i * lh));
    }
    ctx.fillStyle = options.color;
    labels.forEach((l, i) => ctx.fillText(l, x, y + i * lh));
    ctx.restore();
  }
  function setTextStrokeStyle(ctx, options) {
    if (options.textStrokeWidth > 0) {
      ctx.lineJoin = "round";
      ctx.miterLimit = 2;
      ctx.lineWidth = options.textStrokeWidth;
      ctx.strokeStyle = options.textStrokeColor;
      return true;
    }
  }
  function scaleValue(scale, value, fallback) {
    value = typeof value === "number" ? value : scale.parse(value);
    return isNumberFinite(value) ? scale.getPixelForValue(value) : fallback;
  }
  function retrieveScaleID(scales2, options, key) {
    const scaleID = options[key];
    if (scaleID || key === "scaleID") {
      return scaleID;
    }
    const axis = key.charAt(0);
    const axes = Object.values(scales2).filter((scale) => scale.axis && scale.axis === axis);
    if (axes.length) {
      return axes[0].id;
    }
    return axis;
  }
  function getDimensionByScale(scale, options) {
    if (scale) {
      const reverse = scale.options.reverse;
      const start2 = scaleValue(scale, options.min, reverse ? options.end : options.start);
      const end = scaleValue(scale, options.max, reverse ? options.start : options.end);
      return {
        start: start2,
        end
      };
    }
  }
  function getChartPoint(chart, options) {
    const { chartArea, scales: scales2 } = chart;
    const xScale = scales2[retrieveScaleID(scales2, options, "xScaleID")];
    const yScale = scales2[retrieveScaleID(scales2, options, "yScaleID")];
    let x = chartArea.width / 2;
    let y = chartArea.height / 2;
    if (xScale) {
      x = scaleValue(xScale, options.xValue, xScale.left + xScale.width / 2);
    }
    if (yScale) {
      y = scaleValue(yScale, options.yValue, yScale.top + yScale.height / 2);
    }
    return { x, y };
  }
  function resolveBoxProperties(chart, options) {
    const scales2 = chart.scales;
    const xScale = scales2[retrieveScaleID(scales2, options, "xScaleID")];
    const yScale = scales2[retrieveScaleID(scales2, options, "yScaleID")];
    if (!xScale && !yScale) {
      return {};
    }
    let { left: x, right: x2 } = xScale || chart.chartArea;
    let { top: y, bottom: y2 } = yScale || chart.chartArea;
    const xDim = getChartDimensionByScale(xScale, { min: options.xMin, max: options.xMax, start: x, end: x2 });
    x = xDim.start;
    x2 = xDim.end;
    const yDim = getChartDimensionByScale(yScale, { min: options.yMin, max: options.yMax, start: y2, end: y });
    y = yDim.start;
    y2 = yDim.end;
    return {
      x,
      y,
      x2,
      y2,
      width: x2 - x,
      height: y2 - y,
      centerX: x + (x2 - x) / 2,
      centerY: y + (y2 - y) / 2
    };
  }
  function resolvePointProperties(chart, options) {
    if (!isBoundToPoint(options)) {
      const box = resolveBoxProperties(chart, options);
      let radius3 = options.radius;
      if (!radius3 || isNaN(radius3)) {
        radius3 = Math.min(box.width, box.height) / 2;
        options.radius = radius3;
      }
      const size = radius3 * 2;
      return {
        x: box.x + options.xAdjust,
        y: box.y + options.yAdjust,
        x2: box.x + size + options.xAdjust,
        y2: box.y + size + options.yAdjust,
        centerX: box.centerX + options.xAdjust,
        centerY: box.centerY + options.yAdjust,
        width: size,
        height: size
      };
    }
    return getChartCircle(chart, options);
  }
  function getChartCircle(chart, options) {
    const point = getChartPoint(chart, options);
    const size = options.radius * 2;
    return {
      x: point.x - options.radius + options.xAdjust,
      y: point.y - options.radius + options.yAdjust,
      x2: point.x + options.radius + options.xAdjust,
      y2: point.y + options.radius + options.yAdjust,
      centerX: point.x + options.xAdjust,
      centerY: point.y + options.yAdjust,
      width: size,
      height: size
    };
  }
  function getChartDimensionByScale(scale, options) {
    const result = getDimensionByScale(scale, options) || options;
    return {
      start: Math.min(result.start, result.end),
      end: Math.max(result.start, result.end)
    };
  }
  function rotated(point, center, angle) {
    const cos = Math.cos(angle);
    const sin = Math.sin(angle);
    const cx = center.x;
    const cy = center.y;
    return {
      x: cx + cos * (point.x - cx) - sin * (point.y - cy),
      y: cy + sin * (point.x - cx) + cos * (point.y - cy)
    };
  }
  function adjustScaleRange(chart, scale, annotations5) {
    const range = getScaleLimits(chart.scales, scale, annotations5);
    let changed = changeScaleLimit(scale, range, "min", "suggestedMin");
    changed = changeScaleLimit(scale, range, "max", "suggestedMax") || changed;
    if (changed && typeof scale.handleTickRangeOptions === "function") {
      scale.handleTickRangeOptions();
    }
  }
  function verifyScaleOptions(annotations5, scales2) {
    for (const annotation2 of annotations5) {
      verifyScaleIDs(annotation2, scales2);
    }
  }
  function changeScaleLimit(scale, range, limit, suggestedLimit) {
    if (isNumberFinite(range[limit]) && !scaleLimitDefined(scale.options, limit, suggestedLimit)) {
      const changed = scale[limit] !== range[limit];
      scale[limit] = range[limit];
      return changed;
    }
  }
  function scaleLimitDefined(scaleOptions, limit, suggestedLimit) {
    return defined(scaleOptions[limit]) || defined(scaleOptions[suggestedLimit]);
  }
  function verifyScaleIDs(annotation2, scales2) {
    for (const key of ["scaleID", "xScaleID", "yScaleID"]) {
      const scaleID = retrieveScaleID(scales2, annotation2, key);
      if (scaleID && !scales2[scaleID] && verifyProperties(annotation2, key)) {
        console.warn(`No scale found with id '${scaleID}' for annotation '${annotation2.id}'`);
      }
    }
  }
  function verifyProperties(annotation2, key) {
    if (key === "scaleID") {
      return true;
    }
    const axis = key.charAt(0);
    for (const prop of ["Min", "Max", "Value"]) {
      if (defined(annotation2[axis + prop])) {
        return true;
      }
    }
    return false;
  }
  function getScaleLimits(scales2, scale, annotations5) {
    const axis = scale.axis;
    const scaleID = scale.id;
    const scaleIDOption = axis + "ScaleID";
    const limits = {
      min: valueOrDefault(scale.min, Number.NEGATIVE_INFINITY),
      max: valueOrDefault(scale.max, Number.POSITIVE_INFINITY)
    };
    for (const annotation2 of annotations5) {
      if (annotation2.scaleID === scaleID) {
        updateLimits2(annotation2, scale, ["value", "endValue"], limits);
      } else if (retrieveScaleID(scales2, annotation2, scaleIDOption) === scaleID) {
        updateLimits2(annotation2, scale, [axis + "Min", axis + "Max", axis + "Value"], limits);
      }
    }
    return limits;
  }
  function updateLimits2(annotation2, scale, props, limits) {
    for (const prop of props) {
      const raw = annotation2[prop];
      if (defined(raw)) {
        const value = scale.parse(raw);
        limits.min = Math.min(limits.min, value);
        limits.max = Math.max(limits.max, value);
      }
    }
  }
  var BoxAnnotation = class extends Element {
    inRange(mouseX, mouseY, axis, useFinalPosition) {
      const { x, y } = rotated({ x: mouseX, y: mouseY }, this.getCenterPoint(useFinalPosition), toRadians(-this.options.rotation));
      return inBoxRange({ x, y }, this.getProps(["x", "y", "x2", "y2"], useFinalPosition), axis, this.options.borderWidth);
    }
    getCenterPoint(useFinalPosition) {
      return getElementCenterPoint(this, useFinalPosition);
    }
    draw(ctx) {
      ctx.save();
      translate(ctx, this.getCenterPoint(), this.options.rotation);
      drawBox(ctx, this, this.options);
      ctx.restore();
    }
    get label() {
      return this.elements && this.elements[0];
    }
    resolveElementProperties(chart, options) {
      const properties = resolveBoxProperties(chart, options);
      const { x, y } = properties;
      properties.elements = [{
        type: "label",
        optionScope: "label",
        properties: resolveLabelElementProperties$1(chart, properties, options)
      }];
      properties.initProperties = { x, y };
      return properties;
    }
  };
  BoxAnnotation.id = "boxAnnotation";
  BoxAnnotation.defaults = {
    adjustScaleRange: true,
    backgroundShadowColor: "transparent",
    borderCapStyle: "butt",
    borderDash: [],
    borderDashOffset: 0,
    borderJoinStyle: "miter",
    borderRadius: 0,
    borderShadowColor: "transparent",
    borderWidth: 1,
    display: true,
    label: {
      backgroundColor: "transparent",
      borderWidth: 0,
      callout: {
        display: false
      },
      color: "black",
      content: null,
      display: false,
      drawTime: void 0,
      font: {
        family: void 0,
        lineHeight: void 0,
        size: void 0,
        style: void 0,
        weight: "bold"
      },
      height: void 0,
      padding: 6,
      position: "center",
      rotation: void 0,
      textAlign: "start",
      textStrokeColor: void 0,
      textStrokeWidth: 0,
      width: void 0,
      xAdjust: 0,
      yAdjust: 0,
      z: void 0
    },
    rotation: 0,
    shadowBlur: 0,
    shadowOffsetX: 0,
    shadowOffsetY: 0,
    xMax: void 0,
    xMin: void 0,
    xScaleID: void 0,
    yMax: void 0,
    yMin: void 0,
    yScaleID: void 0,
    z: 0
  };
  BoxAnnotation.defaultRoutes = {
    borderColor: "color",
    backgroundColor: "color"
  };
  BoxAnnotation.descriptors = {
    label: {
      _fallback: true
    }
  };
  function calculateX({ properties, options }, labelSize, position, padding) {
    const { x: start2, x2: end, width: size } = properties;
    return calculatePosition$1({ start: start2, end, size, borderWidth: options.borderWidth }, {
      position: position.x,
      padding: { start: padding.left, end: padding.right },
      adjust: options.label.xAdjust,
      size: labelSize.width
    });
  }
  function calculateY({ properties, options }, labelSize, position, padding) {
    const { y: start2, y2: end, height: size } = properties;
    return calculatePosition$1({ start: start2, end, size, borderWidth: options.borderWidth }, {
      position: position.y,
      padding: { start: padding.top, end: padding.bottom },
      adjust: options.label.yAdjust,
      size: labelSize.height
    });
  }
  function calculatePosition$1(boxOpts, labelOpts) {
    const { start: start2, end, borderWidth: borderWidth3 } = boxOpts;
    const { position, padding: { start: padStart, end: padEnd }, adjust } = labelOpts;
    const availableSize = end - borderWidth3 - start2 - padStart - padEnd - labelOpts.size;
    return start2 + borderWidth3 / 2 + adjust + getRelativePosition2(availableSize, position);
  }
  function resolveLabelElementProperties$1(chart, properties, options) {
    const label = options.label;
    label.backgroundColor = "transparent";
    label.callout.display = false;
    const position = toPosition(label.position);
    const padding = toPadding(label.padding);
    const labelSize = measureLabelSize2(chart.ctx, label);
    const x = calculateX({ properties, options }, labelSize, position, padding);
    const y = calculateY({ properties, options }, labelSize, position, padding);
    const width = labelSize.width + padding.width;
    const height = labelSize.height + padding.height;
    return {
      x,
      y,
      x2: x + width,
      y2: y + height,
      width,
      height,
      centerX: x + width / 2,
      centerY: y + height / 2,
      rotation: label.rotation
    };
  }
  var pointInLine = (p1, p2, t) => ({ x: p1.x + t * (p2.x - p1.x), y: p1.y + t * (p2.y - p1.y) });
  var interpolateX = (y, p1, p2) => pointInLine(p1, p2, Math.abs((y - p1.y) / (p2.y - p1.y))).x;
  var interpolateY = (x, p1, p2) => pointInLine(p1, p2, Math.abs((x - p1.x) / (p2.x - p1.x))).y;
  var sqr = (v) => v * v;
  var rangeLimit = (mouseX, mouseY, { x, y, x2, y2 }, axis) => axis === "y" ? { start: Math.min(y, y2), end: Math.max(y, y2), value: mouseY } : { start: Math.min(x, x2), end: Math.max(x, x2), value: mouseX };
  var LineAnnotation = class extends Element {
    inRange(mouseX, mouseY, axis, useFinalPosition) {
      const hBorderWidth = this.options.borderWidth / 2;
      if (axis !== "x" && axis !== "y") {
        const epsilon = sqr(hBorderWidth);
        const point = { mouseX, mouseY };
        return intersects(this, point, epsilon, useFinalPosition) || isOnLabel(this, point, useFinalPosition);
      }
      const limit = rangeLimit(mouseX, mouseY, this.getProps(["x", "y", "x2", "y2"], useFinalPosition), axis);
      return limit.value >= limit.start - hBorderWidth && limit.value <= limit.end + hBorderWidth || isOnLabel(this, { mouseX, mouseY }, useFinalPosition, axis);
    }
    getCenterPoint(useFinalPosition) {
      return getElementCenterPoint(this, useFinalPosition);
    }
    draw(ctx) {
      const { x, y, x2, y2, options } = this;
      ctx.save();
      if (!setBorderStyle(ctx, options)) {
        return ctx.restore();
      }
      setShadowStyle(ctx, options);
      const angle = Math.atan2(y2 - y, x2 - x);
      const length = Math.sqrt(Math.pow(x2 - x, 2) + Math.pow(y2 - y, 2));
      const { startOpts, endOpts, startAdjust, endAdjust } = getArrowHeads(this);
      ctx.translate(x, y);
      ctx.rotate(angle);
      ctx.beginPath();
      ctx.moveTo(0 + startAdjust, 0);
      ctx.lineTo(length - endAdjust, 0);
      ctx.shadowColor = options.borderShadowColor;
      ctx.stroke();
      drawArrowHead(ctx, 0, startAdjust, startOpts);
      drawArrowHead(ctx, length, -endAdjust, endOpts);
      ctx.restore();
    }
    get label() {
      return this.elements && this.elements[0];
    }
    resolveElementProperties(chart, options) {
      const { scales: scales2, chartArea } = chart;
      const scale = scales2[options.scaleID];
      const area = { x: chartArea.left, y: chartArea.top, x2: chartArea.right, y2: chartArea.bottom };
      let min3, max3;
      if (scale) {
        min3 = scaleValue(scale, options.value, NaN);
        max3 = scaleValue(scale, options.endValue, min3);
        if (scale.isHorizontal()) {
          area.x = min3;
          area.x2 = max3;
        } else {
          area.y = min3;
          area.y2 = max3;
        }
      } else {
        const xScale = scales2[retrieveScaleID(scales2, options, "xScaleID")];
        const yScale = scales2[retrieveScaleID(scales2, options, "yScaleID")];
        if (xScale) {
          applyScaleValueToDimension(area, xScale, { min: options.xMin, max: options.xMax, start: xScale.left, end: xScale.right, startProp: "x", endProp: "x2" });
        }
        if (yScale) {
          applyScaleValueToDimension(area, yScale, { min: options.yMin, max: options.yMax, start: yScale.bottom, end: yScale.top, startProp: "y", endProp: "y2" });
        }
      }
      const { x, y, x2, y2 } = area;
      const inside = isLineInArea(area, chart.chartArea);
      const properties = inside ? limitLineToArea({ x, y }, { x: x2, y: y2 }, chart.chartArea) : { x, y, x2, y2, width: Math.abs(x2 - x), height: Math.abs(y2 - y) };
      properties.centerX = (x2 + x) / 2;
      properties.centerY = (y2 + y) / 2;
      const labelProperties = resolveLabelElementProperties(chart, properties, options.label);
      labelProperties._visible = inside;
      properties.elements = [{
        type: "label",
        optionScope: "label",
        properties: labelProperties
      }];
      return properties;
    }
  };
  LineAnnotation.id = "lineAnnotation";
  var arrowHeadsDefaults = {
    backgroundColor: void 0,
    backgroundShadowColor: void 0,
    borderColor: void 0,
    borderDash: void 0,
    borderDashOffset: void 0,
    borderShadowColor: void 0,
    borderWidth: void 0,
    display: void 0,
    fill: void 0,
    length: void 0,
    shadowBlur: void 0,
    shadowOffsetX: void 0,
    shadowOffsetY: void 0,
    width: void 0
  };
  LineAnnotation.defaults = {
    adjustScaleRange: true,
    arrowHeads: {
      display: false,
      end: Object.assign({}, arrowHeadsDefaults),
      fill: false,
      length: 12,
      start: Object.assign({}, arrowHeadsDefaults),
      width: 6
    },
    borderDash: [],
    borderDashOffset: 0,
    borderShadowColor: "transparent",
    borderWidth: 2,
    display: true,
    endValue: void 0,
    label: {
      backgroundColor: "rgba(0,0,0,0.8)",
      backgroundShadowColor: "transparent",
      borderCapStyle: "butt",
      borderColor: "black",
      borderDash: [],
      borderDashOffset: 0,
      borderJoinStyle: "miter",
      borderRadius: 6,
      borderShadowColor: "transparent",
      borderWidth: 0,
      callout: {
        display: false
      },
      color: "#fff",
      content: null,
      display: false,
      drawTime: void 0,
      font: {
        family: void 0,
        lineHeight: void 0,
        size: void 0,
        style: void 0,
        weight: "bold"
      },
      height: void 0,
      padding: 6,
      position: "center",
      rotation: 0,
      shadowBlur: 0,
      shadowOffsetX: 0,
      shadowOffsetY: 0,
      textAlign: "center",
      textStrokeColor: void 0,
      textStrokeWidth: 0,
      width: void 0,
      xAdjust: 0,
      yAdjust: 0,
      z: void 0
    },
    scaleID: void 0,
    shadowBlur: 0,
    shadowOffsetX: 0,
    shadowOffsetY: 0,
    value: void 0,
    xMax: void 0,
    xMin: void 0,
    xScaleID: void 0,
    yMax: void 0,
    yMin: void 0,
    yScaleID: void 0,
    z: 0
  };
  LineAnnotation.descriptors = {
    arrowHeads: {
      start: {
        _fallback: true
      },
      end: {
        _fallback: true
      },
      _fallback: true
    }
  };
  LineAnnotation.defaultRoutes = {
    borderColor: "color"
  };
  function isLineInArea({ x, y, x2, y2 }, { top, right, bottom, left }) {
    return !(x < left && x2 < left || x > right && x2 > right || y < top && y2 < top || y > bottom && y2 > bottom);
  }
  function limitPointToArea({ x, y }, p2, { top, right, bottom, left }) {
    if (x < left) {
      y = interpolateY(left, { x, y }, p2);
      x = left;
    }
    if (x > right) {
      y = interpolateY(right, { x, y }, p2);
      x = right;
    }
    if (y < top) {
      x = interpolateX(top, { x, y }, p2);
      y = top;
    }
    if (y > bottom) {
      x = interpolateX(bottom, { x, y }, p2);
      y = bottom;
    }
    return { x, y };
  }
  function limitLineToArea(p1, p2, area) {
    const { x, y } = limitPointToArea(p1, p2, area);
    const { x: x2, y: y2 } = limitPointToArea(p2, p1, area);
    return { x, y, x2, y2, width: Math.abs(x2 - x), height: Math.abs(y2 - y) };
  }
  function intersects(element, { mouseX, mouseY }, epsilon = EPSILON2, useFinalPosition) {
    const { x: x1, y: y1, x2, y2 } = element.getProps(["x", "y", "x2", "y2"], useFinalPosition);
    const dx = x2 - x1;
    const dy = y2 - y1;
    const lenSq = sqr(dx) + sqr(dy);
    const t = lenSq === 0 ? -1 : ((mouseX - x1) * dx + (mouseY - y1) * dy) / lenSq;
    let xx, yy;
    if (t < 0) {
      xx = x1;
      yy = y1;
    } else if (t > 1) {
      xx = x2;
      yy = y2;
    } else {
      xx = x1 + t * dx;
      yy = y1 + t * dy;
    }
    return sqr(mouseX - xx) + sqr(mouseY - yy) <= epsilon;
  }
  function isOnLabel(element, { mouseX, mouseY }, useFinalPosition, axis) {
    const label = element.label;
    return label.options.display && label.inRange(mouseX, mouseY, axis, useFinalPosition);
  }
  function applyScaleValueToDimension(area, scale, options) {
    const dim = getDimensionByScale(scale, options);
    area[options.startProp] = dim.start;
    area[options.endProp] = dim.end;
  }
  function resolveLabelElementProperties(chart, properties, options) {
    options.callout.display = false;
    const borderWidth3 = options.borderWidth;
    const padding = toPadding(options.padding);
    const textSize = measureLabelSize2(chart.ctx, options);
    const width = textSize.width + padding.width + borderWidth3;
    const height = textSize.height + padding.height + borderWidth3;
    return calculateLabelPosition(properties, options, { width, height, padding }, chart.chartArea);
  }
  function calculateAutoRotation(properties) {
    const { x, y, x2, y2 } = properties;
    const rotation = Math.atan2(y2 - y, x2 - x);
    return rotation > PI / 2 ? rotation - PI : rotation < PI / -2 ? rotation + PI : rotation;
  }
  function calculateLabelPosition(properties, label, sizes, chartArea) {
    const { width, height, padding } = sizes;
    const { xAdjust, yAdjust } = label;
    const p1 = { x: properties.x, y: properties.y };
    const p2 = { x: properties.x2, y: properties.y2 };
    const rotation = label.rotation === "auto" ? calculateAutoRotation(properties) : toRadians(label.rotation);
    const size = rotatedSize(width, height, rotation);
    const t = calculateT(properties, label, { labelSize: size, padding }, chartArea);
    const pt = pointInLine(p1, p2, t);
    const xCoordinateSizes = { size: size.w, min: chartArea.left, max: chartArea.right, padding: padding.left };
    const yCoordinateSizes = { size: size.h, min: chartArea.top, max: chartArea.bottom, padding: padding.top };
    const centerX = adjustLabelCoordinate(pt.x, xCoordinateSizes) + xAdjust;
    const centerY = adjustLabelCoordinate(pt.y, yCoordinateSizes) + yAdjust;
    return {
      x: centerX - width / 2,
      y: centerY - height / 2,
      x2: centerX + width / 2,
      y2: centerY + height / 2,
      centerX,
      centerY,
      width,
      height,
      rotation: toDegrees(rotation)
    };
  }
  function rotatedSize(width, height, rotation) {
    const cos = Math.cos(rotation);
    const sin = Math.sin(rotation);
    return {
      w: Math.abs(width * cos) + Math.abs(height * sin),
      h: Math.abs(width * sin) + Math.abs(height * cos)
    };
  }
  function calculateT(properties, label, sizes, chartArea) {
    let t;
    const space = spaceAround(properties, chartArea);
    if (label.position === "start") {
      t = calculateTAdjust({ w: properties.x2 - properties.x, h: properties.y2 - properties.y }, sizes, label, space);
    } else if (label.position === "end") {
      t = 1 - calculateTAdjust({ w: properties.x - properties.x2, h: properties.y - properties.y2 }, sizes, label, space);
    } else {
      t = getRelativePosition2(1, label.position);
    }
    return t;
  }
  function calculateTAdjust(lineSize, sizes, label, space) {
    const { labelSize, padding } = sizes;
    const lineW = lineSize.w * space.dx;
    const lineH = lineSize.h * space.dy;
    const x = lineW > 0 && (labelSize.w / 2 + padding.left - space.x) / lineW;
    const y = lineH > 0 && (labelSize.h / 2 + padding.top - space.y) / lineH;
    return clamp(Math.max(x, y), 0, 0.25);
  }
  function spaceAround(properties, chartArea) {
    const { x, x2, y, y2 } = properties;
    const t = Math.min(y, y2) - chartArea.top;
    const l = Math.min(x, x2) - chartArea.left;
    const b = chartArea.bottom - Math.max(y, y2);
    const r = chartArea.right - Math.max(x, x2);
    return {
      x: Math.min(l, r),
      y: Math.min(t, b),
      dx: l <= r ? 1 : -1,
      dy: t <= b ? 1 : -1
    };
  }
  function adjustLabelCoordinate(coordinate, labelSizes) {
    const { size, min: min3, max: max3, padding } = labelSizes;
    const halfSize = size / 2;
    if (size > max3 - min3) {
      return (max3 + min3) / 2;
    }
    if (min3 >= coordinate - padding - halfSize) {
      coordinate = min3 + padding + halfSize;
    }
    if (max3 <= coordinate + padding + halfSize) {
      coordinate = max3 - padding - halfSize;
    }
    return coordinate;
  }
  function getArrowHeads(line) {
    const options = line.options;
    const arrowStartOpts = options.arrowHeads && options.arrowHeads.start;
    const arrowEndOpts = options.arrowHeads && options.arrowHeads.end;
    return {
      startOpts: arrowStartOpts,
      endOpts: arrowEndOpts,
      startAdjust: getLineAdjust(line, arrowStartOpts),
      endAdjust: getLineAdjust(line, arrowEndOpts)
    };
  }
  function getLineAdjust(line, arrowOpts) {
    if (!arrowOpts || !arrowOpts.display) {
      return 0;
    }
    const { length, width } = arrowOpts;
    const adjust = line.options.borderWidth / 2;
    const p1 = { x: length, y: width + adjust };
    const p2 = { x: 0, y: adjust };
    return Math.abs(interpolateX(0, p1, p2));
  }
  function drawArrowHead(ctx, offset, adjust, arrowOpts) {
    if (!arrowOpts || !arrowOpts.display) {
      return;
    }
    const { length, width, fill: fill2, backgroundColor: backgroundColor4, borderColor: borderColor4 } = arrowOpts;
    const arrowOffsetX = Math.abs(offset - length) + adjust;
    ctx.beginPath();
    setShadowStyle(ctx, arrowOpts);
    setBorderStyle(ctx, arrowOpts);
    ctx.moveTo(arrowOffsetX, -width);
    ctx.lineTo(offset + adjust, 0);
    ctx.lineTo(arrowOffsetX, width);
    if (fill2 === true) {
      ctx.fillStyle = backgroundColor4 || borderColor4;
      ctx.closePath();
      ctx.fill();
      ctx.shadowColor = "transparent";
    } else {
      ctx.shadowColor = arrowOpts.borderShadowColor;
    }
    ctx.stroke();
  }
  var EllipseAnnotation = class extends Element {
    inRange(mouseX, mouseY, axis, useFinalPosition) {
      const rotation = this.options.rotation;
      const borderWidth3 = this.options.borderWidth;
      if (axis !== "x" && axis !== "y") {
        return pointInEllipse({ x: mouseX, y: mouseY }, this.getProps(["width", "height", "centerX", "centerY"], useFinalPosition), rotation, borderWidth3);
      }
      const { x, y, x2, y2 } = this.getProps(["x", "y", "x2", "y2"], useFinalPosition);
      const hBorderWidth = borderWidth3 / 2;
      const limit = axis === "y" ? { start: y, end: y2 } : { start: x, end: x2 };
      const rotatedPoint = rotated({ x: mouseX, y: mouseY }, this.getCenterPoint(useFinalPosition), toRadians(-rotation));
      return rotatedPoint[axis] >= limit.start - hBorderWidth - EPSILON2 && rotatedPoint[axis] <= limit.end + hBorderWidth + EPSILON2;
    }
    getCenterPoint(useFinalPosition) {
      return getElementCenterPoint(this, useFinalPosition);
    }
    draw(ctx) {
      const { width, height, centerX, centerY, options } = this;
      ctx.save();
      translate(ctx, this.getCenterPoint(), options.rotation);
      setShadowStyle(ctx, this.options);
      ctx.beginPath();
      ctx.fillStyle = options.backgroundColor;
      const stroke = setBorderStyle(ctx, options);
      ctx.ellipse(centerX, centerY, height / 2, width / 2, PI / 2, 0, 2 * PI);
      ctx.fill();
      if (stroke) {
        ctx.shadowColor = options.borderShadowColor;
        ctx.stroke();
      }
      ctx.restore();
    }
    resolveElementProperties(chart, options) {
      return resolveBoxProperties(chart, options);
    }
  };
  EllipseAnnotation.id = "ellipseAnnotation";
  EllipseAnnotation.defaults = {
    adjustScaleRange: true,
    backgroundShadowColor: "transparent",
    borderDash: [],
    borderDashOffset: 0,
    borderShadowColor: "transparent",
    borderWidth: 1,
    display: true,
    rotation: 0,
    shadowBlur: 0,
    shadowOffsetX: 0,
    shadowOffsetY: 0,
    xMax: void 0,
    xMin: void 0,
    xScaleID: void 0,
    yMax: void 0,
    yMin: void 0,
    yScaleID: void 0,
    z: 0
  };
  EllipseAnnotation.defaultRoutes = {
    borderColor: "color",
    backgroundColor: "color"
  };
  function pointInEllipse(p, ellipse, rotation, borderWidth3) {
    const { width, height, centerX, centerY } = ellipse;
    const xRadius = width / 2;
    const yRadius = height / 2;
    if (xRadius <= 0 || yRadius <= 0) {
      return false;
    }
    const angle = toRadians(rotation || 0);
    const hBorderWidth = borderWidth3 / 2 || 0;
    const cosAngle = Math.cos(angle);
    const sinAngle = Math.sin(angle);
    const a = Math.pow(cosAngle * (p.x - centerX) + sinAngle * (p.y - centerY), 2);
    const b = Math.pow(sinAngle * (p.x - centerX) - cosAngle * (p.y - centerY), 2);
    return a / Math.pow(xRadius + hBorderWidth, 2) + b / Math.pow(yRadius + hBorderWidth, 2) <= 1.0001;
  }
  var positions2 = ["left", "bottom", "top", "right"];
  var LabelAnnotation = class extends Element {
    inRange(mouseX, mouseY, axis, useFinalPosition) {
      const { x, y } = rotated({ x: mouseX, y: mouseY }, this.getCenterPoint(useFinalPosition), toRadians(-this.rotation));
      return inBoxRange({ x, y }, this.getProps(["x", "y", "x2", "y2"], useFinalPosition), axis, this.options.borderWidth);
    }
    getCenterPoint(useFinalPosition) {
      return getElementCenterPoint(this, useFinalPosition);
    }
    draw(ctx) {
      const options = this.options;
      const visible = !defined(this._visible) || this._visible;
      if (!options.display || !options.content || !visible) {
        return;
      }
      ctx.save();
      translate(ctx, this.getCenterPoint(), this.rotation);
      drawCallout(ctx, this);
      drawBox(ctx, this, options);
      drawLabel(ctx, getLabelSize(this), options);
      ctx.restore();
    }
    resolveElementProperties(chart, options) {
      let point;
      if (!isBoundToPoint(options)) {
        const { centerX, centerY } = resolveBoxProperties(chart, options);
        point = { x: centerX, y: centerY };
      } else {
        point = getChartPoint(chart, options);
      }
      const padding = toPadding(options.padding);
      const labelSize = measureLabelSize2(chart.ctx, options);
      const boxSize = measureRect(point, labelSize, options, padding);
      return {
        pointX: point.x,
        pointY: point.y,
        ...boxSize,
        rotation: options.rotation
      };
    }
  };
  LabelAnnotation.id = "labelAnnotation";
  LabelAnnotation.defaults = {
    adjustScaleRange: true,
    backgroundColor: "transparent",
    backgroundShadowColor: "transparent",
    borderCapStyle: "butt",
    borderDash: [],
    borderDashOffset: 0,
    borderJoinStyle: "miter",
    borderRadius: 0,
    borderShadowColor: "transparent",
    borderWidth: 0,
    callout: {
      borderCapStyle: "butt",
      borderColor: void 0,
      borderDash: [],
      borderDashOffset: 0,
      borderJoinStyle: "miter",
      borderWidth: 1,
      display: false,
      margin: 5,
      position: "auto",
      side: 5,
      start: "50%"
    },
    color: "black",
    content: null,
    display: true,
    font: {
      family: void 0,
      lineHeight: void 0,
      size: void 0,
      style: void 0,
      weight: void 0
    },
    height: void 0,
    padding: 6,
    position: "center",
    rotation: 0,
    shadowBlur: 0,
    shadowOffsetX: 0,
    shadowOffsetY: 0,
    textAlign: "center",
    textStrokeColor: void 0,
    textStrokeWidth: 0,
    width: void 0,
    xAdjust: 0,
    xMax: void 0,
    xMin: void 0,
    xScaleID: void 0,
    xValue: void 0,
    yAdjust: 0,
    yMax: void 0,
    yMin: void 0,
    yScaleID: void 0,
    yValue: void 0,
    z: 0
  };
  LabelAnnotation.defaultRoutes = {
    borderColor: "color"
  };
  function measureRect(point, size, options, padding) {
    const width = size.width + padding.width + options.borderWidth;
    const height = size.height + padding.height + options.borderWidth;
    const position = toPosition(options.position);
    const x = calculatePosition(point.x, width, options.xAdjust, position.x);
    const y = calculatePosition(point.y, height, options.yAdjust, position.y);
    return {
      x,
      y,
      x2: x + width,
      y2: y + height,
      width,
      height,
      centerX: x + width / 2,
      centerY: y + height / 2
    };
  }
  function calculatePosition(start2, size, adjust = 0, position) {
    return start2 - getRelativePosition2(size, position) + adjust;
  }
  function drawCallout(ctx, element) {
    const { pointX, pointY, options } = element;
    const callout = options.callout;
    const calloutPosition = callout && callout.display && resolveCalloutPosition(element, callout);
    if (!calloutPosition || isPointInRange(element, callout, calloutPosition)) {
      return;
    }
    ctx.save();
    ctx.beginPath();
    const stroke = setBorderStyle(ctx, callout);
    if (!stroke) {
      return ctx.restore();
    }
    const { separatorStart, separatorEnd } = getCalloutSeparatorCoord(element, calloutPosition);
    const { sideStart, sideEnd } = getCalloutSideCoord(element, calloutPosition, separatorStart);
    if (callout.margin > 0 || options.borderWidth === 0) {
      ctx.moveTo(separatorStart.x, separatorStart.y);
      ctx.lineTo(separatorEnd.x, separatorEnd.y);
    }
    ctx.moveTo(sideStart.x, sideStart.y);
    ctx.lineTo(sideEnd.x, sideEnd.y);
    const rotatedPoint = rotated({ x: pointX, y: pointY }, element.getCenterPoint(), toRadians(-element.rotation));
    ctx.lineTo(rotatedPoint.x, rotatedPoint.y);
    ctx.stroke();
    ctx.restore();
  }
  function getCalloutSeparatorCoord(element, position) {
    const { x, y, x2, y2 } = element;
    const adjust = getCalloutSeparatorAdjust(element, position);
    let separatorStart, separatorEnd;
    if (position === "left" || position === "right") {
      separatorStart = { x: x + adjust, y };
      separatorEnd = { x: separatorStart.x, y: y2 };
    } else {
      separatorStart = { x, y: y + adjust };
      separatorEnd = { x: x2, y: separatorStart.y };
    }
    return { separatorStart, separatorEnd };
  }
  function getCalloutSeparatorAdjust(element, position) {
    const { width, height, options } = element;
    const adjust = options.callout.margin + options.borderWidth / 2;
    if (position === "right") {
      return width + adjust;
    } else if (position === "bottom") {
      return height + adjust;
    }
    return -adjust;
  }
  function getCalloutSideCoord(element, position, separatorStart) {
    const { y, width, height, options } = element;
    const start2 = options.callout.start;
    const side = getCalloutSideAdjust(position, options.callout);
    let sideStart, sideEnd;
    if (position === "left" || position === "right") {
      sideStart = { x: separatorStart.x, y: y + getSize(height, start2) };
      sideEnd = { x: sideStart.x + side, y: sideStart.y };
    } else {
      sideStart = { x: separatorStart.x + getSize(width, start2), y: separatorStart.y };
      sideEnd = { x: sideStart.x, y: sideStart.y + side };
    }
    return { sideStart, sideEnd };
  }
  function getCalloutSideAdjust(position, options) {
    const side = options.side;
    if (position === "left" || position === "top") {
      return -side;
    }
    return side;
  }
  function resolveCalloutPosition(element, options) {
    const position = options.position;
    if (positions2.includes(position)) {
      return position;
    }
    return resolveCalloutAutoPosition(element, options);
  }
  function resolveCalloutAutoPosition(element, options) {
    const { x, y, x2, y2, width, height, pointX, pointY, centerX, centerY, rotation } = element;
    const center = { x: centerX, y: centerY };
    const start2 = options.start;
    const xAdjust = getSize(width, start2);
    const yAdjust = getSize(height, start2);
    const xPoints = [x, x + xAdjust, x + xAdjust, x2];
    const yPoints = [y + yAdjust, y2, y, y2];
    const result = [];
    for (let index3 = 0; index3 < 4; index3++) {
      const rotatedPoint = rotated({ x: xPoints[index3], y: yPoints[index3] }, center, toRadians(rotation));
      result.push({
        position: positions2[index3],
        distance: distanceBetweenPoints(rotatedPoint, { x: pointX, y: pointY })
      });
    }
    return result.sort((a, b) => a.distance - b.distance)[0].position;
  }
  function getLabelSize({ x, y, width, height, options }) {
    const hBorderWidth = options.borderWidth / 2;
    const padding = toPadding(options.padding);
    return {
      x: x + padding.left + hBorderWidth,
      y: y + padding.top + hBorderWidth,
      width: width - padding.left - padding.right - options.borderWidth,
      height: height - padding.top - padding.bottom - options.borderWidth
    };
  }
  function isPointInRange(element, callout, position) {
    const { pointX, pointY } = element;
    const margin = callout.margin;
    let x = pointX;
    let y = pointY;
    if (position === "left") {
      x += margin;
    } else if (position === "right") {
      x -= margin;
    } else if (position === "top") {
      y += margin;
    } else if (position === "bottom") {
      y -= margin;
    }
    return element.inRange(x, y);
  }
  var PointAnnotation = class extends Element {
    inRange(mouseX, mouseY, axis, useFinalPosition) {
      const { x, y, x2, y2, width } = this.getProps(["x", "y", "x2", "y2", "width"], useFinalPosition);
      const borderWidth3 = this.options.borderWidth;
      if (axis !== "x" && axis !== "y") {
        return inPointRange({ x: mouseX, y: mouseY }, this.getCenterPoint(useFinalPosition), width / 2, borderWidth3);
      }
      const hBorderWidth = borderWidth3 / 2;
      const limit = axis === "y" ? { start: y, end: y2, value: mouseY } : { start: x, end: x2, value: mouseX };
      return limit.value >= limit.start - hBorderWidth && limit.value <= limit.end + hBorderWidth;
    }
    getCenterPoint(useFinalPosition) {
      return getElementCenterPoint(this, useFinalPosition);
    }
    draw(ctx) {
      const options = this.options;
      const borderWidth3 = options.borderWidth;
      if (options.radius < 0.1) {
        return;
      }
      ctx.save();
      ctx.fillStyle = options.backgroundColor;
      setShadowStyle(ctx, options);
      const stroke = setBorderStyle(ctx, options);
      options.borderWidth = 0;
      drawPoint(ctx, options, this.centerX, this.centerY);
      if (stroke && !isImageOrCanvas(options.pointStyle)) {
        ctx.shadowColor = options.borderShadowColor;
        ctx.stroke();
      }
      ctx.restore();
      options.borderWidth = borderWidth3;
    }
    resolveElementProperties(chart, options) {
      return resolvePointProperties(chart, options);
    }
  };
  PointAnnotation.id = "pointAnnotation";
  PointAnnotation.defaults = {
    adjustScaleRange: true,
    backgroundShadowColor: "transparent",
    borderDash: [],
    borderDashOffset: 0,
    borderShadowColor: "transparent",
    borderWidth: 1,
    display: true,
    pointStyle: "circle",
    radius: 10,
    rotation: 0,
    shadowBlur: 0,
    shadowOffsetX: 0,
    shadowOffsetY: 0,
    xAdjust: 0,
    xMax: void 0,
    xMin: void 0,
    xScaleID: void 0,
    xValue: void 0,
    yAdjust: 0,
    yMax: void 0,
    yMin: void 0,
    yScaleID: void 0,
    yValue: void 0,
    z: 0
  };
  PointAnnotation.defaultRoutes = {
    borderColor: "color",
    backgroundColor: "color"
  };
  var PolygonAnnotation = class extends Element {
    inRange(mouseX, mouseY, axis, useFinalPosition) {
      if (axis !== "x" && axis !== "y") {
        return this.options.radius >= 0.1 && this.elements.length > 1 && pointIsInPolygon(this.elements, mouseX, mouseY, useFinalPosition);
      }
      const rotatedPoint = rotated({ x: mouseX, y: mouseY }, this.getCenterPoint(useFinalPosition), toRadians(-this.options.rotation));
      const axisPoints = this.elements.map((point) => axis === "y" ? point.bY : point.bX);
      const start2 = Math.min(...axisPoints);
      const end = Math.max(...axisPoints);
      return rotatedPoint[axis] >= start2 && rotatedPoint[axis] <= end;
    }
    getCenterPoint(useFinalPosition) {
      return getElementCenterPoint(this, useFinalPosition);
    }
    draw(ctx) {
      const { elements: elements2, options } = this;
      ctx.save();
      ctx.beginPath();
      ctx.fillStyle = options.backgroundColor;
      setShadowStyle(ctx, options);
      const stroke = setBorderStyle(ctx, options);
      let first = true;
      for (const el of elements2) {
        if (first) {
          ctx.moveTo(el.x, el.y);
          first = false;
        } else {
          ctx.lineTo(el.x, el.y);
        }
      }
      ctx.closePath();
      ctx.fill();
      if (stroke) {
        ctx.shadowColor = options.borderShadowColor;
        ctx.stroke();
      }
      ctx.restore();
    }
    resolveElementProperties(chart, options) {
      const properties = resolvePointProperties(chart, options);
      const { x, y } = properties;
      const { sides, rotation } = options;
      const elements2 = [];
      const angle = 2 * PI / sides;
      let rad = rotation * RAD_PER_DEG;
      for (let i = 0; i < sides; i++, rad += angle) {
        elements2.push(buildPointElement(properties, options, rad));
      }
      properties.elements = elements2;
      properties.initProperties = { x, y };
      return properties;
    }
  };
  PolygonAnnotation.id = "polygonAnnotation";
  PolygonAnnotation.defaults = {
    adjustScaleRange: true,
    backgroundShadowColor: "transparent",
    borderCapStyle: "butt",
    borderDash: [],
    borderDashOffset: 0,
    borderJoinStyle: "miter",
    borderShadowColor: "transparent",
    borderWidth: 1,
    display: true,
    point: {
      radius: 0
    },
    radius: 10,
    rotation: 0,
    shadowBlur: 0,
    shadowOffsetX: 0,
    shadowOffsetY: 0,
    sides: 3,
    xAdjust: 0,
    xMax: void 0,
    xMin: void 0,
    xScaleID: void 0,
    xValue: void 0,
    yAdjust: 0,
    yMax: void 0,
    yMin: void 0,
    yScaleID: void 0,
    yValue: void 0,
    z: 0
  };
  PolygonAnnotation.defaultRoutes = {
    borderColor: "color",
    backgroundColor: "color"
  };
  function buildPointElement({ centerX, centerY }, { radius: radius3, borderWidth: borderWidth3 }, rad) {
    const halfBorder = borderWidth3 / 2;
    const sin = Math.sin(rad);
    const cos = Math.cos(rad);
    const point = { x: centerX + sin * radius3, y: centerY - cos * radius3 };
    return {
      type: "point",
      optionScope: "point",
      properties: {
        x: point.x,
        y: point.y,
        centerX: point.x,
        centerY: point.y,
        bX: centerX + sin * (radius3 + halfBorder),
        bY: centerY - cos * (radius3 + halfBorder)
      }
    };
  }
  function pointIsInPolygon(points, x, y, useFinalPosition) {
    let isInside = false;
    let A = points[points.length - 1].getProps(["bX", "bY"], useFinalPosition);
    for (const point of points) {
      const B = point.getProps(["bX", "bY"], useFinalPosition);
      if (B.bY > y !== A.bY > y && x < (A.bX - B.bX) * (y - B.bY) / (A.bY - B.bY) + B.bX) {
        isInside = !isInside;
      }
      A = B;
    }
    return isInside;
  }
  var annotationTypes = {
    box: BoxAnnotation,
    ellipse: EllipseAnnotation,
    label: LabelAnnotation,
    line: LineAnnotation,
    point: PointAnnotation,
    polygon: PolygonAnnotation
  };
  Object.keys(annotationTypes).forEach((key) => {
    defaults.describe(`elements.${annotationTypes[key].id}`, {
      _fallback: "plugins.annotation.common"
    });
  });
  var directUpdater = {
    update: Object.assign
  };
  function resolveType(type2 = "line") {
    if (annotationTypes[type2]) {
      return type2;
    }
    console.warn(`Unknown annotation type: '${type2}', defaulting to 'line'`);
    return "line";
  }
  function updateElements(chart, state, options, mode) {
    const animations = resolveAnimations(chart, options.animations, mode);
    const annotations5 = state.annotations;
    const elements2 = resyncElements(state.elements, annotations5);
    for (let i = 0; i < annotations5.length; i++) {
      const annotationOptions = annotations5[i];
      const element = getOrCreateElement(elements2, i, annotationOptions.type);
      const resolver = annotationOptions.setContext(getContext(chart, element, annotationOptions));
      const properties = element.resolveElementProperties(chart, resolver);
      properties.skip = toSkip(properties);
      if ("elements" in properties) {
        updateSubElements(element, properties, resolver, animations);
        delete properties.elements;
      }
      if (!defined(element.x)) {
        Object.assign(element, properties);
      }
      properties.options = resolveAnnotationOptions(resolver);
      animations.update(element, properties);
    }
  }
  function toSkip(properties) {
    return isNaN(properties.x) || isNaN(properties.y);
  }
  function resolveAnimations(chart, animOpts, mode) {
    if (mode === "reset" || mode === "none" || mode === "resize") {
      return directUpdater;
    }
    return new Animations(chart, animOpts);
  }
  function updateSubElements(mainElement, { elements: elements2, initProperties }, resolver, animations) {
    const subElements = mainElement.elements || (mainElement.elements = []);
    subElements.length = elements2.length;
    for (let i = 0; i < elements2.length; i++) {
      const definition = elements2[i];
      const properties = definition.properties;
      const subElement = getOrCreateElement(subElements, i, definition.type, initProperties);
      const subResolver = resolver[definition.optionScope].override(definition);
      properties.options = resolveAnnotationOptions(subResolver);
      animations.update(subElement, properties);
    }
  }
  function getOrCreateElement(elements2, index3, type2, initProperties) {
    const elementClass = annotationTypes[resolveType(type2)];
    let element = elements2[index3];
    if (!element || !(element instanceof elementClass)) {
      element = elements2[index3] = new elementClass();
      if (isObject(initProperties)) {
        Object.assign(element, initProperties);
      }
    }
    return element;
  }
  function resolveAnnotationOptions(resolver) {
    const elementClass = annotationTypes[resolveType(resolver.type)];
    const result = {};
    result.id = resolver.id;
    result.type = resolver.type;
    result.drawTime = resolver.drawTime;
    Object.assign(
      result,
      resolveObj(resolver, elementClass.defaults),
      resolveObj(resolver, elementClass.defaultRoutes)
    );
    for (const hook of hooks) {
      result[hook] = resolver[hook];
    }
    return result;
  }
  function resolveObj(resolver, defs) {
    const result = {};
    for (const prop of Object.keys(defs)) {
      const optDefs = defs[prop];
      const value = resolver[prop];
      result[prop] = isObject(optDefs) ? resolveObj(value, optDefs) : value;
    }
    return result;
  }
  function getContext(chart, element, annotation2) {
    return element.$context || (element.$context = Object.assign(Object.create(chart.getContext()), {
      element,
      id: annotation2.id,
      type: "annotation"
    }));
  }
  function resyncElements(elements2, annotations5) {
    const count = annotations5.length;
    const start2 = elements2.length;
    if (start2 < count) {
      const add = count - start2;
      elements2.splice(start2, 0, ...new Array(add));
    } else if (start2 > count) {
      elements2.splice(count, start2 - count);
    }
    return elements2;
  }
  var version2 = "2.0.1";
  var chartStates = /* @__PURE__ */ new Map();
  var annotation = {
    id: "annotation",
    version: version2,
    beforeRegister() {
      requireVersion("chart.js", "3.7", Chart.version);
    },
    afterRegister() {
      Chart.register(annotationTypes);
    },
    afterUnregister() {
      Chart.unregister(annotationTypes);
    },
    beforeInit(chart) {
      chartStates.set(chart, {
        annotations: [],
        elements: [],
        visibleElements: [],
        listeners: {},
        listened: false,
        moveListened: false,
        hovered: []
      });
    },
    beforeUpdate(chart, args, options) {
      const state = chartStates.get(chart);
      const annotations5 = state.annotations = [];
      let annotationOptions = options.annotations;
      if (isObject(annotationOptions)) {
        Object.keys(annotationOptions).forEach((key) => {
          const value = annotationOptions[key];
          if (isObject(value)) {
            value.id = key;
            annotations5.push(value);
          }
        });
      } else if (isArray(annotationOptions)) {
        annotations5.push(...annotationOptions);
      }
      verifyScaleOptions(annotations5, chart.scales);
    },
    afterDataLimits(chart, args) {
      const state = chartStates.get(chart);
      adjustScaleRange(chart, args.scale, state.annotations.filter((a) => a.display && a.adjustScaleRange));
    },
    afterUpdate(chart, args, options) {
      const state = chartStates.get(chart);
      updateListeners(chart, state, options);
      updateElements(chart, state, options, args.mode);
      state.visibleElements = state.elements.filter((el) => !el.skip && el.options.display);
    },
    beforeDatasetsDraw(chart, _args, options) {
      draw2(chart, "beforeDatasetsDraw", options.clip);
    },
    afterDatasetsDraw(chart, _args, options) {
      draw2(chart, "afterDatasetsDraw", options.clip);
    },
    beforeDraw(chart, _args, options) {
      draw2(chart, "beforeDraw", options.clip);
    },
    afterDraw(chart, _args, options) {
      draw2(chart, "afterDraw", options.clip);
    },
    beforeEvent(chart, args, options) {
      const state = chartStates.get(chart);
      if (handleEvent(state, args.event, options)) {
        args.changed = true;
      }
    },
    destroy(chart) {
      chartStates.delete(chart);
    },
    _getState(chart) {
      return chartStates.get(chart);
    },
    defaults: {
      animations: {
        numbers: {
          properties: ["x", "y", "x2", "y2", "width", "height", "centerX", "centerY", "pointX", "pointY", "radius"],
          type: "number"
        }
      },
      clip: true,
      interaction: {
        mode: void 0,
        axis: void 0,
        intersect: void 0
      },
      common: {
        drawTime: "afterDatasetsDraw",
        label: {}
      }
    },
    descriptors: {
      _indexable: false,
      _scriptable: (prop) => !hooks.includes(prop),
      annotations: {
        _allKeys: false,
        _fallback: (prop, opts) => `elements.${annotationTypes[resolveType(opts.type)].id}`
      },
      interaction: {
        _fallback: true
      },
      common: {
        label: {
          _fallback: true
        }
      }
    },
    additionalOptionScopes: [""]
  };
  function draw2(chart, caller, clip) {
    const { ctx, chartArea } = chart;
    const { visibleElements } = chartStates.get(chart);
    if (clip) {
      clipArea(ctx, chartArea);
    }
    const drawableElements = getDrawableElements(visibleElements, caller).sort((a, b) => a.options.z - b.options.z);
    for (const element of drawableElements) {
      element.draw(chart.ctx, chartArea);
    }
    if (clip) {
      unclipArea(ctx);
    }
  }
  function getDrawableElements(elements2, caller) {
    const drawableElements = [];
    for (const el of elements2) {
      if (el.options.drawTime === caller) {
        drawableElements.push(el);
      }
      if (el.elements && el.elements.length) {
        for (const sub of el.elements) {
          if (sub.options.display && sub.options.drawTime === caller) {
            drawableElements.push(sub);
          }
        }
      }
    }
    return drawableElements;
  }

  // node_modules/@sgratzl/boxplots/build/index.js
  var HELPER = Math.sqrt(2 * Math.PI);
  function gaussian(u) {
    return Math.exp(-0.5 * u * u) / HELPER;
  }
  function toSampleVariance(variance, len) {
    return variance * len / (len - 1);
  }
  function nrd(iqr, variance, len) {
    let s = Math.sqrt(toSampleVariance(variance, len));
    if (typeof iqr === "number") {
      s = Math.min(s, iqr / 1.34);
    }
    return 1.06 * s * Math.pow(len, -0.2);
  }
  function kde(stats) {
    const len = stats.items.length;
    const bandwidth = nrd(stats.iqr, stats.variance, len);
    return (x) => {
      let i = 0;
      let sum = 0;
      for (i = 0; i < len; i++) {
        const v = stats.items[i];
        sum += gaussian((x - v) / bandwidth);
      }
      return sum / bandwidth / len;
    };
  }
  function quantilesInterpolate(arr, length, interpolate3) {
    const n1 = length - 1;
    const compute2 = (q) => {
      const index3 = q * n1;
      const lo = Math.floor(index3);
      const h = index3 - lo;
      const a = arr[lo];
      return h === 0 ? a : interpolate3(a, arr[Math.min(lo + 1, n1)], h);
    };
    return {
      q1: compute2(0.25),
      median: compute2(0.5),
      q3: compute2(0.75)
    };
  }
  function quantilesType7(arr, length = arr.length) {
    return quantilesInterpolate(arr, length, (a, b, alpha2) => a + alpha2 * (b - a));
  }
  function quantilesLinear(arr, length = arr.length) {
    return quantilesInterpolate(arr, length, (i, j, fraction) => i + (j - i) * fraction);
  }
  function quantilesLower(arr, length = arr.length) {
    return quantilesInterpolate(arr, length, (i) => i);
  }
  function quantilesHigher(arr, length = arr.length) {
    return quantilesInterpolate(arr, length, (_, j) => j);
  }
  function quantilesNearest(arr, length = arr.length) {
    return quantilesInterpolate(arr, length, (i, j, fraction) => fraction < 0.5 ? i : j);
  }
  function quantilesMidpoint(arr, length = arr.length) {
    return quantilesInterpolate(arr, length, (i, j) => (i + j) * 0.5);
  }
  function quantilesFivenum(arr, length = arr.length) {
    const n = length;
    const n4 = Math.floor((n + 3) / 2) / 2;
    const compute2 = (d) => 0.5 * (arr[Math.floor(d) - 1] + arr[Math.ceil(d) - 1]);
    return {
      q1: compute2(n4),
      median: compute2((n + 1) / 2),
      q3: compute2(n + 1 - n4)
    };
  }
  function quantilesHinges(arr, length = arr.length) {
    return quantilesFivenum(arr, length);
  }
  function createSortedData(data) {
    let valid = 0;
    const { length } = data;
    const vs = data instanceof Float64Array ? new Float64Array(length) : new Float32Array(length);
    for (let i = 0; i < length; i += 1) {
      const v = data[i];
      if (v == null || Number.isNaN(v)) {
        continue;
      }
      vs[valid] = v;
      valid += 1;
    }
    const missing = length - valid;
    if (valid === 0) {
      return {
        min: Number.NaN,
        max: Number.NaN,
        missing,
        s: []
      };
    }
    const validData = valid === length ? vs : vs.subarray(0, valid);
    validData.sort((a, b) => a === b ? 0 : a < b ? -1 : 1);
    const min3 = validData[0];
    const max3 = validData[validData.length - 1];
    return {
      min: min3,
      max: max3,
      missing,
      s: validData
    };
  }
  function withSortedData(data) {
    if (data.length === 0) {
      return {
        min: Number.NaN,
        max: Number.NaN,
        missing: 0,
        s: []
      };
    }
    const min3 = data[0];
    const max3 = data[data.length - 1];
    return {
      min: min3,
      max: max3,
      missing: 0,
      s: data
    };
  }
  function computeWhiskers(s, valid, min3, max3, { eps, quantiles, coef, whiskersMode }) {
    const same = (a, b) => Math.abs(a - b) < eps;
    const { median, q1, q3 } = quantiles(s, valid);
    const iqr = q3 - q1;
    const isCoefValid = typeof coef === "number" && coef > 0;
    let whiskerLow = isCoefValid ? Math.max(min3, q1 - coef * iqr) : min3;
    let whiskerHigh = isCoefValid ? Math.min(max3, q3 + coef * iqr) : max3;
    const outlierLow = [];
    for (let i = 0; i < valid; i += 1) {
      const v = s[i];
      if (v >= whiskerLow || same(v, whiskerLow)) {
        if (whiskersMode === "nearest") {
          whiskerLow = v;
        }
        break;
      }
      if (outlierLow.length === 0 || !same(outlierLow[outlierLow.length - 1], v)) {
        outlierLow.push(v);
      }
    }
    const reversedOutlierHigh = [];
    for (let i = valid - 1; i >= 0; i -= 1) {
      const v = s[i];
      if (v <= whiskerHigh || same(v, whiskerHigh)) {
        if (whiskersMode === "nearest") {
          whiskerHigh = v;
        }
        break;
      }
      if ((reversedOutlierHigh.length === 0 || !same(reversedOutlierHigh[reversedOutlierHigh.length - 1], v)) && (outlierLow.length === 0 || !same(outlierLow[outlierLow.length - 1], v))) {
        reversedOutlierHigh.push(v);
      }
    }
    const outlier = outlierLow.concat(reversedOutlierHigh.reverse());
    return {
      median,
      q1,
      q3,
      iqr,
      outlier,
      whiskerHigh,
      whiskerLow
    };
  }
  function computeStats(s, valid) {
    let mean2 = 0;
    for (let i = 0; i < valid; i++) {
      const v = s[i];
      mean2 += v;
    }
    mean2 /= valid;
    let variance = 0;
    for (let i = 0; i < valid; i++) {
      const v = s[i];
      variance += (v - mean2) * (v - mean2);
    }
    variance /= valid;
    return {
      mean: mean2,
      variance
    };
  }
  function boxplot(data, options = {}) {
    const fullOptions = {
      coef: 1.5,
      eps: 0.01,
      quantiles: quantilesType7,
      validAndSorted: false,
      whiskersMode: "nearest",
      ...options
    };
    const { missing, s, min: min3, max: max3 } = fullOptions.validAndSorted ? withSortedData(data) : createSortedData(data);
    const invalid = {
      min: Number.NaN,
      max: Number.NaN,
      mean: Number.NaN,
      missing,
      iqr: Number.NaN,
      count: data.length,
      whiskerHigh: Number.NaN,
      whiskerLow: Number.NaN,
      outlier: [],
      median: Number.NaN,
      q1: Number.NaN,
      q3: Number.NaN,
      variance: 0,
      items: [],
      kde: () => 0
    };
    const valid = data.length - missing;
    if (valid === 0) {
      return invalid;
    }
    const result = {
      min: min3,
      max: max3,
      count: data.length,
      missing,
      items: s,
      ...computeStats(s, valid),
      ...computeWhiskers(s, valid, min3, max3, fullOptions)
    };
    return {
      ...result,
      kde: kde(result)
    };
  }

  // node_modules/@sgratzl/chartjs-chart-boxplot/build/index.js
  function whiskers(boxplot3, arr, coef = 1.5) {
    const iqr = boxplot3.q3 - boxplot3.q1;
    const coefValid = typeof coef === "number" && coef > 0;
    let whiskerMin = coefValid ? Math.max(boxplot3.min, boxplot3.q1 - coef * iqr) : boxplot3.min;
    let whiskerMax = coefValid ? Math.min(boxplot3.max, boxplot3.q3 + coef * iqr) : boxplot3.max;
    if (Array.isArray(arr)) {
      for (let i = 0; i < arr.length; i += 1) {
        const v = arr[i];
        if (v >= whiskerMin) {
          whiskerMin = v;
          break;
        }
      }
      for (let i = arr.length - 1; i >= 0; i -= 1) {
        const v = arr[i];
        if (v <= whiskerMax) {
          whiskerMax = v;
          break;
        }
      }
    }
    return {
      whiskerMin,
      whiskerMax
    };
  }
  var defaultStatsOptions = {
    coef: 1.5,
    quantiles: 7
  };
  function determineQuantiles(q) {
    if (typeof q === "function") {
      return q;
    }
    const lookup = {
      hinges: quantilesHinges,
      fivenum: quantilesFivenum,
      7: quantilesType7,
      quantiles: quantilesType7,
      linear: quantilesLinear,
      lower: quantilesLower,
      higher: quantilesHigher,
      nearest: quantilesNearest,
      midpoint: quantilesMidpoint
    };
    return lookup[q] || quantilesType7;
  }
  function determineStatsOptions(options) {
    const coef = options == null || typeof options.coef !== "number" ? defaultStatsOptions.coef : options.coef;
    const q = options == null || options.quantiles == null ? quantilesType7 : options.quantiles;
    const quantiles = determineQuantiles(q);
    return {
      coef,
      quantiles
    };
  }
  function boxplotStats(arr, options) {
    const r = boxplot(arr, determineStatsOptions(options));
    return {
      items: Array.from(r.items),
      outliers: r.outlier,
      whiskerMax: r.whiskerHigh,
      whiskerMin: r.whiskerLow,
      max: r.max,
      median: r.median,
      mean: r.mean,
      min: r.min,
      q1: r.q1,
      q3: r.q3
    };
  }
  function computeSamples(min3, max3, points) {
    const range = max3 - min3;
    const samples = [];
    const inc = range / points;
    for (let v = min3; v <= max3 && inc > 0; v += inc) {
      samples.push(v);
    }
    if (samples[samples.length - 1] !== max3) {
      samples.push(max3);
    }
    return samples;
  }
  function violinStats(arr, options) {
    if (arr.length === 0) {
      return void 0;
    }
    const stats = boxplot(arr, determineStatsOptions(options));
    const samples = computeSamples(stats.min, stats.max, options.points);
    const coords = samples.map((v) => ({ v, estimate: stats.kde(v) }));
    const maxEstimate = coords.reduce((a, d) => Math.max(a, d.estimate), Number.NEGATIVE_INFINITY);
    return {
      max: stats.max,
      min: stats.min,
      mean: stats.mean,
      median: stats.median,
      q1: stats.q1,
      q3: stats.q3,
      items: Array.from(stats.items),
      coords,
      outliers: [],
      maxEstimate
    };
  }
  function asBoxPlotStats(value, options) {
    if (!value) {
      return void 0;
    }
    if (typeof value.median === "number" && typeof value.q1 === "number" && typeof value.q3 === "number") {
      if (typeof value.whiskerMin === "undefined") {
        const { coef } = determineStatsOptions(options);
        const { whiskerMin, whiskerMax } = whiskers(value, Array.isArray(value.items) ? value.items.slice().sort((a, b) => a - b) : null, coef);
        value.whiskerMin = whiskerMin;
        value.whiskerMax = whiskerMax;
      }
      return value;
    }
    if (!Array.isArray(value)) {
      return void 0;
    }
    return boxplotStats(value, options);
  }
  function asViolinStats(value, options) {
    if (!value) {
      return void 0;
    }
    if (typeof value.median === "number" && Array.isArray(value.coords)) {
      return value;
    }
    if (!Array.isArray(value)) {
      return void 0;
    }
    return violinStats(value, options);
  }
  function rnd(seed = Date.now()) {
    let s = seed;
    return () => {
      s = (s * 9301 + 49297) % 233280;
      return s / 233280;
    };
  }
  var baseDefaults$1 = {
    borderWidth: 1,
    outlierStyle: "circle",
    outlierRadius: 2,
    outlierBorderWidth: 1,
    itemStyle: "circle",
    itemRadius: 0,
    itemBorderWidth: 0,
    meanStyle: "circle",
    meanRadius: 3,
    meanBorderWidth: 1,
    hitPadding: 2,
    outlierHitRadius: 4
  };
  var baseRoutes = {
    outlierBackgroundColor: "backgroundColor",
    outlierBorderColor: "borderColor",
    itemBackgroundColor: "backgroundColor",
    itemBorderColor: "borderColor",
    meanBackgroundColor: "backgroundColor",
    meanBorderColor: "borderColor"
  };
  var baseOptionKeys = (() => Object.keys(baseDefaults$1).concat(Object.keys(baseRoutes)))();
  var StatsBase$1 = class extends Element {
    isVertical() {
      return !this.horizontal;
    }
    _drawItems(ctx) {
      const vert = this.isVertical();
      const props = this.getProps(["x", "y", "items", "width", "height", "outliers"]);
      const { options } = this;
      if (options.itemRadius <= 0 || !props.items || props.items.length <= 0) {
        return;
      }
      ctx.save();
      ctx.strokeStyle = options.itemBorderColor;
      ctx.fillStyle = options.itemBackgroundColor;
      ctx.lineWidth = options.itemBorderWidth;
      const random = rnd(this._datasetIndex * 1e3 + this._index);
      const pointOptions = {
        pointStyle: options.itemStyle,
        radius: options.itemRadius,
        borderWidth: options.itemBorderWidth
      };
      const outliers = new Set(props.outliers || []);
      if (vert) {
        props.items.forEach((v) => {
          if (!outliers.has(v)) {
            drawPoint(ctx, pointOptions, props.x - props.width / 2 + random() * props.width, v);
          }
        });
      } else {
        props.items.forEach((v) => {
          if (!outliers.has(v)) {
            drawPoint(ctx, pointOptions, v, props.y - props.height / 2 + random() * props.height);
          }
        });
      }
      ctx.restore();
    }
    _drawOutliers(ctx) {
      const vert = this.isVertical();
      const props = this.getProps(["x", "y", "outliers"]);
      const { options } = this;
      if (options.outlierRadius <= 0 || !props.outliers || props.outliers.length === 0) {
        return;
      }
      ctx.save();
      ctx.fillStyle = options.outlierBackgroundColor;
      ctx.strokeStyle = options.outlierBorderColor;
      ctx.lineWidth = options.outlierBorderWidth;
      const pointOptions = {
        pointStyle: options.outlierStyle,
        radius: options.outlierRadius,
        borderWidth: options.outlierBorderWidth
      };
      if (vert) {
        props.outliers.forEach((v) => {
          drawPoint(ctx, pointOptions, props.x, v);
        });
      } else {
        props.outliers.forEach((v) => {
          drawPoint(ctx, pointOptions, v, props.y);
        });
      }
      ctx.restore();
    }
    _drawMeanDot(ctx) {
      const vert = this.isVertical();
      const props = this.getProps(["x", "y", "mean"]);
      const { options } = this;
      if (options.meanRadius <= 0 || props.mean == null || Number.isNaN(props.mean)) {
        return;
      }
      ctx.save();
      ctx.fillStyle = options.meanBackgroundColor;
      ctx.strokeStyle = options.meanBorderColor;
      ctx.lineWidth = options.meanBorderWidth;
      const pointOptions = {
        pointStyle: options.meanStyle,
        radius: options.meanRadius,
        borderWidth: options.meanBorderWidth
      };
      if (vert) {
        drawPoint(ctx, pointOptions, props.x, props.mean);
      } else {
        drawPoint(ctx, pointOptions, props.mean, props.y);
      }
      ctx.restore();
    }
    _getBounds(_useFinalPosition) {
      return {
        left: 0,
        top: 0,
        right: 0,
        bottom: 0
      };
    }
    _getHitBounds(useFinalPosition) {
      const padding = this.options.hitPadding;
      const b = this._getBounds(useFinalPosition);
      return {
        left: b.left - padding,
        top: b.top - padding,
        right: b.right + padding,
        bottom: b.bottom + padding
      };
    }
    inRange(mouseX, mouseY, useFinalPosition) {
      if (Number.isNaN(this.x) && Number.isNaN(this.y)) {
        return false;
      }
      return this._boxInRange(mouseX, mouseY, useFinalPosition) || this._outlierIndexInRange(mouseX, mouseY, useFinalPosition) >= 0;
    }
    inXRange(mouseX, useFinalPosition) {
      const bounds = this._getHitBounds(useFinalPosition);
      return mouseX >= bounds.left && mouseX <= bounds.right;
    }
    inYRange(mouseY, useFinalPosition) {
      const bounds = this._getHitBounds(useFinalPosition);
      return mouseY >= bounds.top && mouseY <= bounds.bottom;
    }
    _outlierIndexInRange(mouseX, mouseY, useFinalPosition) {
      const props = this.getProps(["x", "y"], useFinalPosition);
      const hitRadius = this.options.outlierHitRadius;
      const outliers = this._getOutliers(useFinalPosition);
      const vertical = this.isVertical();
      if (vertical && Math.abs(mouseX - props.x) > hitRadius || !vertical && Math.abs(mouseY - props.y) > hitRadius) {
        return -1;
      }
      const toCompare = vertical ? mouseY : mouseX;
      for (let i = 0; i < outliers.length; i += 1) {
        if (Math.abs(outliers[i] - toCompare) <= hitRadius) {
          return i;
        }
      }
      return -1;
    }
    _boxInRange(mouseX, mouseY, useFinalPosition) {
      const bounds = this._getHitBounds(useFinalPosition);
      return mouseX >= bounds.left && mouseX <= bounds.right && mouseY >= bounds.top && mouseY <= bounds.bottom;
    }
    getCenterPoint(useFinalPosition) {
      const props = this.getProps(["x", "y"], useFinalPosition);
      return {
        x: props.x,
        y: props.y
      };
    }
    _getOutliers(useFinalPosition) {
      const props = this.getProps(["outliers"], useFinalPosition);
      return props.outliers || [];
    }
    tooltipPosition(eventPosition, tooltip5) {
      if (!eventPosition || typeof eventPosition === "boolean") {
        return this.getCenterPoint();
      }
      if (tooltip5) {
        delete tooltip5._tooltipOutlier;
      }
      const props = this.getProps(["x", "y"]);
      const index3 = this._outlierIndexInRange(eventPosition.x, eventPosition.y);
      if (index3 < 0 || !tooltip5) {
        return this.getCenterPoint();
      }
      tooltip5._tooltipOutlier = {
        index: index3,
        datasetIndex: this._datasetIndex
      };
      if (this.isVertical()) {
        return {
          x: props.x,
          y: this._getOutliers()[index3]
        };
      }
      return {
        x: this._getOutliers()[index3],
        y: props.y
      };
    }
  };
  var boxOptionsKeys = baseOptionKeys.concat(["medianColor", "lowerBackgroundColor"]);
  var BoxAndWiskers = class extends StatsBase$1 {
    draw(ctx) {
      ctx.save();
      ctx.fillStyle = this.options.backgroundColor;
      ctx.strokeStyle = this.options.borderColor;
      ctx.lineWidth = this.options.borderWidth;
      this._drawBoxPlot(ctx);
      this._drawOutliers(ctx);
      this._drawMeanDot(ctx);
      ctx.restore();
      this._drawItems(ctx);
    }
    _drawBoxPlot(ctx) {
      if (this.isVertical()) {
        this._drawBoxPlotVertical(ctx);
      } else {
        this._drawBoxPlotHorizontal(ctx);
      }
    }
    _drawBoxPlotVertical(ctx) {
      const { options } = this;
      const props = this.getProps(["x", "width", "q1", "q3", "median", "whiskerMin", "whiskerMax"]);
      const { x } = props;
      const { width } = props;
      const x0 = x - width / 2;
      if (props.q3 > props.q1) {
        ctx.fillRect(x0, props.q1, width, props.q3 - props.q1);
      } else {
        ctx.fillRect(x0, props.q3, width, props.q1 - props.q3);
      }
      ctx.save();
      if (options.medianColor && options.medianColor !== "transparent" && options.medianColor !== "#0000") {
        ctx.strokeStyle = options.medianColor;
      }
      ctx.beginPath();
      ctx.moveTo(x0, props.median);
      ctx.lineTo(x0 + width, props.median);
      ctx.closePath();
      ctx.stroke();
      ctx.restore();
      ctx.save();
      if (options.lowerBackgroundColor && options.lowerBackgroundColor !== "transparent" && options.lowerBackgroundColor !== "#0000") {
        ctx.fillStyle = options.lowerBackgroundColor;
        if (props.q3 > props.q1) {
          ctx.fillRect(x0, props.median, width, props.q3 - props.median);
        } else {
          ctx.fillRect(x0, props.median, width, props.q1 - props.median);
        }
      }
      ctx.restore();
      if (props.q3 > props.q1) {
        ctx.strokeRect(x0, props.q1, width, props.q3 - props.q1);
      } else {
        ctx.strokeRect(x0, props.q3, width, props.q1 - props.q3);
      }
      ctx.beginPath();
      ctx.moveTo(x0, props.whiskerMin);
      ctx.lineTo(x0 + width, props.whiskerMin);
      ctx.moveTo(x, props.whiskerMin);
      ctx.lineTo(x, props.q1);
      ctx.moveTo(x0, props.whiskerMax);
      ctx.lineTo(x0 + width, props.whiskerMax);
      ctx.moveTo(x, props.whiskerMax);
      ctx.lineTo(x, props.q3);
      ctx.closePath();
      ctx.stroke();
    }
    _drawBoxPlotHorizontal(ctx) {
      const { options } = this;
      const props = this.getProps(["y", "height", "q1", "q3", "median", "whiskerMin", "whiskerMax"]);
      const { y } = props;
      const { height } = props;
      const y0 = y - height / 2;
      if (props.q3 > props.q1) {
        ctx.fillRect(props.q1, y0, props.q3 - props.q1, height);
      } else {
        ctx.fillRect(props.q3, y0, props.q1 - props.q3, height);
      }
      ctx.save();
      if (options.medianColor && options.medianColor !== "transparent") {
        ctx.strokeStyle = options.medianColor;
      }
      ctx.beginPath();
      ctx.moveTo(props.median, y0);
      ctx.lineTo(props.median, y0 + height);
      ctx.closePath();
      ctx.stroke();
      ctx.restore();
      ctx.save();
      if (options.lowerBackgroundColor && options.lowerBackgroundColor !== "transparent") {
        ctx.fillStyle = options.lowerBackgroundColor;
        if (props.q3 > props.q1) {
          ctx.fillRect(props.median, y0, props.q3 - props.median, height);
        } else {
          ctx.fillRect(props.median, y0, props.q1 - props.median, height);
        }
      }
      ctx.restore();
      if (props.q3 > props.q1) {
        ctx.strokeRect(props.q1, y0, props.q3 - props.q1, height);
      } else {
        ctx.strokeRect(props.q3, y0, props.q1 - props.q3, height);
      }
      ctx.beginPath();
      ctx.moveTo(props.whiskerMin, y0);
      ctx.lineTo(props.whiskerMin, y0 + height);
      ctx.moveTo(props.whiskerMin, y);
      ctx.lineTo(props.q1, y);
      ctx.moveTo(props.whiskerMax, y0);
      ctx.lineTo(props.whiskerMax, y0 + height);
      ctx.moveTo(props.whiskerMax, y);
      ctx.lineTo(props.q3, y);
      ctx.closePath();
      ctx.stroke();
    }
    _getBounds(useFinalPosition) {
      const vert = this.isVertical();
      if (this.x == null) {
        return {
          left: 0,
          top: 0,
          right: 0,
          bottom: 0
        };
      }
      if (vert) {
        const { x, width, whiskerMax: whiskerMax2, whiskerMin: whiskerMin2 } = this.getProps(["x", "width", "whiskerMin", "whiskerMax"], useFinalPosition);
        const x0 = x - width / 2;
        return {
          left: x0,
          top: whiskerMax2,
          right: x0 + width,
          bottom: whiskerMin2
        };
      }
      const { y, height, whiskerMax, whiskerMin } = this.getProps(["y", "height", "whiskerMin", "whiskerMax"], useFinalPosition);
      const y0 = y - height / 2;
      return {
        left: whiskerMin,
        top: y0,
        right: whiskerMax,
        bottom: y0 + height
      };
    }
  };
  BoxAndWiskers.id = "boxandwhiskers";
  BoxAndWiskers.defaults = {
    ...BarElement.defaults,
    ...baseDefaults$1,
    medianColor: "transparent",
    lowerBackgroundColor: "transparent"
  };
  BoxAndWiskers.defaultRoutes = { ...BarElement.defaultRoutes, ...baseRoutes };
  var Violin = class extends StatsBase$1 {
    draw(ctx) {
      ctx.save();
      ctx.fillStyle = this.options.backgroundColor;
      ctx.strokeStyle = this.options.borderColor;
      ctx.lineWidth = this.options.borderWidth;
      const props = this.getProps(["x", "y", "median", "width", "height", "min", "max", "coords", "maxEstimate"]);
      if (props.median != null) {
        drawPoint(ctx, {
          pointStyle: "rectRot",
          radius: 5,
          borderWidth: this.options.borderWidth
        }, props.x, props.y);
      }
      if (props.coords && props.coords.length > 0) {
        this._drawCoords(ctx, props);
      }
      this._drawOutliers(ctx);
      this._drawMeanDot(ctx);
      ctx.restore();
      this._drawItems(ctx);
    }
    _drawCoords(ctx, props) {
      let maxEstimate;
      if (props.maxEstimate == null) {
        maxEstimate = props.coords.reduce((a, d) => Math.max(a, d.estimate), Number.NEGATIVE_INFINITY);
      } else {
        maxEstimate = props.maxEstimate;
      }
      if (this.isVertical()) {
        const { x, width } = props;
        const factor = width / 2 / maxEstimate;
        ctx.moveTo(x, props.min);
        props.coords.forEach((c) => {
          ctx.lineTo(x - c.estimate * factor, c.v);
        });
        ctx.lineTo(x, props.max);
        ctx.moveTo(x, props.min);
        props.coords.forEach((c) => {
          ctx.lineTo(x + c.estimate * factor, c.v);
        });
        ctx.lineTo(x, props.max);
      } else {
        const { y, height } = props;
        const factor = height / 2 / maxEstimate;
        ctx.moveTo(props.min, y);
        props.coords.forEach((c) => {
          ctx.lineTo(c.v, y - c.estimate * factor);
        });
        ctx.lineTo(props.max, y);
        ctx.moveTo(props.min, y);
        props.coords.forEach((c) => {
          ctx.lineTo(c.v, y + c.estimate * factor);
        });
        ctx.lineTo(props.max, y);
      }
      ctx.closePath();
      ctx.stroke();
      ctx.fill();
    }
    _getBounds(useFinalPosition) {
      if (this.isVertical()) {
        const { x, width, min: min4, max: max4 } = this.getProps(["x", "width", "min", "max"], useFinalPosition);
        const x0 = x - width / 2;
        return {
          left: x0,
          top: max4,
          right: x0 + width,
          bottom: min4
        };
      }
      const { y, height, min: min3, max: max3 } = this.getProps(["y", "height", "min", "max"], useFinalPosition);
      const y0 = y - height / 2;
      return {
        left: min3,
        top: y0,
        right: max3,
        bottom: y0 + height
      };
    }
  };
  Violin.id = "violin";
  Violin.defaults = { ...BarElement.defaults, ...baseDefaults$1 };
  Violin.defaultRoutes = { ...BarElement.defaultRoutes, ...baseRoutes };
  var interpolators2 = {
    number(from2, to2, factor) {
      if (from2 === to2) {
        return to2;
      }
      if (from2 == null) {
        return to2;
      }
      if (to2 == null) {
        return from2;
      }
      return from2 + (to2 - from2) * factor;
    }
  };
  function interpolateNumberArray(from2, to2, factor) {
    if (typeof from2 === "number" && typeof to2 === "number") {
      return interpolators2.number(from2, to2, factor);
    }
    if (Array.isArray(from2) && Array.isArray(to2)) {
      return to2.map((t, i) => interpolators2.number(from2[i], t, factor));
    }
    return to2;
  }
  function interpolateKdeCoords(from2, to2, factor) {
    if (Array.isArray(from2) && Array.isArray(to2)) {
      return to2.map((t, i) => ({
        v: interpolators2.number(from2[i] ? from2[i].v : null, t.v, factor),
        estimate: interpolators2.number(from2[i] ? from2[i].estimate : null, t.estimate, factor)
      }));
    }
    return to2;
  }
  function patchInHoveredOutlier(item) {
    const value = item.formattedValue;
    const that = this;
    if (value && that._tooltipOutlier != null && item.datasetIndex === that._tooltipOutlier.datasetIndex) {
      value.hoveredOutlierIndex = that._tooltipOutlier.index;
    }
  }
  function outlierPositioner(items, eventPosition) {
    if (!items.length) {
      return false;
    }
    let x = 0;
    let y = 0;
    let count = 0;
    for (let i = 0; i < items.length; i += 1) {
      const el = items[i].element;
      if (el && el.hasValue()) {
        const pos = el.tooltipPosition(eventPosition, this);
        x += pos.x;
        y += pos.y;
        count += 1;
      }
    }
    return {
      x: x / count,
      y: y / count
    };
  }
  outlierPositioner.id = "average";
  outlierPositioner.register = () => {
    plugin_tooltip.positioners.average = outlierPositioner;
    return outlierPositioner;
  };
  function baseDefaults(keys) {
    const colorKeys = ["borderColor", "backgroundColor"].concat(keys.filter((c) => c.endsWith("Color")));
    return {
      animations: {
        numberArray: {
          fn: interpolateNumberArray,
          properties: ["outliers", "items"]
        },
        colors: {
          type: "color",
          properties: colorKeys
        }
      },
      transitions: {
        show: {
          animations: {
            colors: {
              type: "color",
              properties: colorKeys,
              from: "transparent"
            }
          }
        },
        hide: {
          animations: {
            colors: {
              type: "color",
              properties: colorKeys,
              to: "transparent"
            }
          }
        }
      },
      minStats: "min",
      maxStats: "max",
      ...defaultStatsOptions
    };
  }
  function defaultOverrides() {
    return {
      plugins: {
        tooltip: {
          position: outlierPositioner.register().id,
          callbacks: {
            beforeLabel: patchInHoveredOutlier
          }
        }
      }
    };
  }
  var StatsBase = class extends BarController {
    _transformStats(target, source, mapper) {
      for (const key of ["min", "max", "median", "q3", "q1", "mean"]) {
        const v = source[key];
        if (typeof v === "number") {
          target[key] = mapper(v);
        }
      }
      for (const key of ["outliers", "items"]) {
        if (Array.isArray(source[key])) {
          target[key] = source[key].map(mapper);
        }
      }
    }
    getMinMax(scale, canStack) {
      const bak = scale.axis;
      const config = this.options;
      scale.axis = config.minStats;
      const { min: min3 } = super.getMinMax(scale, canStack);
      scale.axis = config.maxStats;
      const { max: max3 } = super.getMinMax(scale, canStack);
      scale.axis = bak;
      return { min: min3, max: max3 };
    }
    parsePrimitiveData(meta, data, start2, count) {
      const vScale = meta.vScale;
      const iScale = meta.iScale;
      const labels = iScale.getLabels();
      const r = [];
      for (let i = 0; i < count; i += 1) {
        const index3 = i + start2;
        const parsed = {};
        parsed[iScale.axis] = iScale.parse(labels[index3], index3);
        const stats = this._parseStats(data == null ? null : data[index3], this.options);
        if (stats) {
          Object.assign(parsed, stats);
          parsed[vScale.axis] = stats.median;
        }
        r.push(parsed);
      }
      return r;
    }
    parseArrayData(meta, data, start2, count) {
      return this.parsePrimitiveData(meta, data, start2, count);
    }
    parseObjectData(meta, data, start2, count) {
      return this.parsePrimitiveData(meta, data, start2, count);
    }
    getLabelAndValue(index3) {
      const r = super.getLabelAndValue(index3);
      const { vScale } = this._cachedMeta;
      const parsed = this.getParsed(index3);
      if (!vScale || !parsed || r.value === "NaN") {
        return r;
      }
      r.value = {
        raw: parsed,
        hoveredOutlierIndex: -1
      };
      this._transformStats(r.value, parsed, (v) => vScale.getLabelForValue(v));
      const s = this._toStringStats(r.value.raw);
      r.value.toString = function toString() {
        if (this.hoveredOutlierIndex >= 0) {
          return `(outlier: ${this.outliers[this.hoveredOutlierIndex]})`;
        }
        return s;
      };
      return r;
    }
    _toStringStats(b) {
      const f = (v) => v == null ? "NaN" : formatNumber(v, this.chart.options.locale, {});
      return `(min: ${f(b.min)}, 25% quantile: ${f(b.q1)}, median: ${f(b.median)}, mean: ${f(b.mean)}, 75% quantile: ${f(b.q3)}, max: ${f(b.max)})`;
    }
    updateElement(rectangle, index3, properties, mode) {
      const reset = mode === "reset";
      const scale = this._cachedMeta.vScale;
      const parsed = this.getParsed(index3);
      const base = scale.getBasePixel();
      properties._datasetIndex = this.index;
      properties._index = index3;
      this._transformStats(properties, parsed, (v) => reset ? base : scale.getPixelForValue(v, index3));
      super.updateElement(rectangle, index3, properties, mode);
    }
  };
  function patchController(type2, config, controller, elements2 = [], scales2 = []) {
    registry.addControllers(controller);
    if (Array.isArray(elements2)) {
      registry.addElements(...elements2);
    } else {
      registry.addElements(elements2);
    }
    if (Array.isArray(scales2)) {
      registry.addScales(...scales2);
    } else {
      registry.addScales(scales2);
    }
    const c = config;
    c.type = type2;
    return c;
  }
  var BoxPlotController = class extends StatsBase {
    _parseStats(value, config) {
      return asBoxPlotStats(value, config);
    }
    _transformStats(target, source, mapper) {
      super._transformStats(target, source, mapper);
      for (const key of ["whiskerMin", "whiskerMax"]) {
        target[key] = mapper(source[key]);
      }
    }
  };
  BoxPlotController.id = "boxplot";
  BoxPlotController.defaults = merge({}, [
    BarController.defaults,
    baseDefaults(boxOptionsKeys),
    {
      animations: {
        numbers: {
          type: "number",
          properties: BarController.defaults.animations.numbers.properties.concat(["q1", "q3", "min", "max", "median", "whiskerMin", "whiskerMax", "mean"], boxOptionsKeys.filter((c) => !c.endsWith("Color")))
        }
      },
      dataElementType: BoxAndWiskers.id
    }
  ]);
  BoxPlotController.overrides = merge({}, [BarController.overrides, defaultOverrides()]);
  var BoxPlotChart = class extends Chart {
    constructor(item, config) {
      super(item, patchController("boxplot", config, BoxPlotController, BoxAndWiskers, [LinearScale, CategoryScale]));
    }
  };
  BoxPlotChart.id = BoxPlotController.id;
  var ViolinController = class extends StatsBase {
    _parseStats(value, config) {
      return asViolinStats(value, config);
    }
    _transformStats(target, source, mapper) {
      super._transformStats(target, source, mapper);
      target.maxEstimate = source.maxEstimate;
      if (Array.isArray(source.coords)) {
        target.coords = source.coords.map((c) => ({ ...c, v: mapper(c.v) }));
      }
    }
  };
  ViolinController.id = "violin";
  ViolinController.defaults = merge({}, [
    BarController.defaults,
    baseDefaults(baseOptionKeys),
    {
      points: 100,
      animations: {
        numbers: {
          type: "number",
          properties: BarController.defaults.animations.numbers.properties.concat(["q1", "q3", "min", "max", "median", "maxEstimate"], baseOptionKeys.filter((c) => !c.endsWith("Color")))
        },
        kdeCoords: {
          fn: interpolateKdeCoords,
          properties: ["coords"]
        }
      },
      dataElementType: Violin.id
    }
  ]);
  ViolinController.overrides = merge({}, [BarController.overrides, defaultOverrides()]);
  var ViolinChart = class extends Chart {
    constructor(item, config) {
      super(item, patchController("violin", config, ViolinController, Violin, [LinearScale, CategoryScale]));
    }
  };
  ViolinChart.id = ViolinController.id;

  // node_modules/chartjs-plugin-datalabels/dist/chartjs-plugin-datalabels.esm.js
  var devicePixelRatio = function() {
    if (typeof window !== "undefined") {
      if (window.devicePixelRatio) {
        return window.devicePixelRatio;
      }
      var screen = window.screen;
      if (screen) {
        return (screen.deviceXDPI || 1) / (screen.logicalXDPI || 1);
      }
    }
    return 1;
  }();
  var utils = {
    toTextLines: function(inputs) {
      var lines = [];
      var input;
      inputs = [].concat(inputs);
      while (inputs.length) {
        input = inputs.pop();
        if (typeof input === "string") {
          lines.unshift.apply(lines, input.split("\n"));
        } else if (Array.isArray(input)) {
          inputs.push.apply(inputs, input);
        } else if (!isNullOrUndef(inputs)) {
          lines.unshift("" + input);
        }
      }
      return lines;
    },
    textSize: function(ctx, lines, font) {
      var items = [].concat(lines);
      var ilen = items.length;
      var prev = ctx.font;
      var width = 0;
      var i;
      ctx.font = font.string;
      for (i = 0; i < ilen; ++i) {
        width = Math.max(ctx.measureText(items[i]).width, width);
      }
      ctx.font = prev;
      return {
        height: ilen * font.lineHeight,
        width
      };
    },
    bound: function(min3, value, max3) {
      return Math.max(min3, Math.min(value, max3));
    },
    arrayDiff: function(a0, a1) {
      var prev = a0.slice();
      var updates = [];
      var i, j, ilen, v;
      for (i = 0, ilen = a1.length; i < ilen; ++i) {
        v = a1[i];
        j = prev.indexOf(v);
        if (j === -1) {
          updates.push([v, 1]);
        } else {
          prev.splice(j, 1);
        }
      }
      for (i = 0, ilen = prev.length; i < ilen; ++i) {
        updates.push([prev[i], -1]);
      }
      return updates;
    },
    rasterize: function(v) {
      return Math.round(v * devicePixelRatio) / devicePixelRatio;
    }
  };
  function orient(point, origin) {
    var x0 = origin.x;
    var y0 = origin.y;
    if (x0 === null) {
      return { x: 0, y: -1 };
    }
    if (y0 === null) {
      return { x: 1, y: 0 };
    }
    var dx = point.x - x0;
    var dy = point.y - y0;
    var ln = Math.sqrt(dx * dx + dy * dy);
    return {
      x: ln ? dx / ln : 0,
      y: ln ? dy / ln : -1
    };
  }
  function aligned(x, y, vx, vy, align) {
    switch (align) {
      case "center":
        vx = vy = 0;
        break;
      case "bottom":
        vx = 0;
        vy = 1;
        break;
      case "right":
        vx = 1;
        vy = 0;
        break;
      case "left":
        vx = -1;
        vy = 0;
        break;
      case "top":
        vx = 0;
        vy = -1;
        break;
      case "start":
        vx = -vx;
        vy = -vy;
        break;
      case "end":
        break;
      default:
        align *= Math.PI / 180;
        vx = Math.cos(align);
        vy = Math.sin(align);
        break;
    }
    return {
      x,
      y,
      vx,
      vy
    };
  }
  var R_INSIDE = 0;
  var R_LEFT = 1;
  var R_RIGHT = 2;
  var R_BOTTOM = 4;
  var R_TOP = 8;
  function region(x, y, rect) {
    var res = R_INSIDE;
    if (x < rect.left) {
      res |= R_LEFT;
    } else if (x > rect.right) {
      res |= R_RIGHT;
    }
    if (y < rect.top) {
      res |= R_TOP;
    } else if (y > rect.bottom) {
      res |= R_BOTTOM;
    }
    return res;
  }
  function clipped(segment, area) {
    var x0 = segment.x0;
    var y0 = segment.y0;
    var x1 = segment.x1;
    var y1 = segment.y1;
    var r0 = region(x0, y0, area);
    var r1 = region(x1, y1, area);
    var r, x, y;
    while (true) {
      if (!(r0 | r1) || r0 & r1) {
        break;
      }
      r = r0 || r1;
      if (r & R_TOP) {
        x = x0 + (x1 - x0) * (area.top - y0) / (y1 - y0);
        y = area.top;
      } else if (r & R_BOTTOM) {
        x = x0 + (x1 - x0) * (area.bottom - y0) / (y1 - y0);
        y = area.bottom;
      } else if (r & R_RIGHT) {
        y = y0 + (y1 - y0) * (area.right - x0) / (x1 - x0);
        x = area.right;
      } else if (r & R_LEFT) {
        y = y0 + (y1 - y0) * (area.left - x0) / (x1 - x0);
        x = area.left;
      }
      if (r === r0) {
        x0 = x;
        y0 = y;
        r0 = region(x0, y0, area);
      } else {
        x1 = x;
        y1 = y;
        r1 = region(x1, y1, area);
      }
    }
    return {
      x0,
      x1,
      y0,
      y1
    };
  }
  function compute$1(range, config) {
    var anchor = config.anchor;
    var segment = range;
    var x, y;
    if (config.clamp) {
      segment = clipped(segment, config.area);
    }
    if (anchor === "start") {
      x = segment.x0;
      y = segment.y0;
    } else if (anchor === "end") {
      x = segment.x1;
      y = segment.y1;
    } else {
      x = (segment.x0 + segment.x1) / 2;
      y = (segment.y0 + segment.y1) / 2;
    }
    return aligned(x, y, range.vx, range.vy, config.align);
  }
  var positioners2 = {
    arc: function(el, config) {
      var angle = (el.startAngle + el.endAngle) / 2;
      var vx = Math.cos(angle);
      var vy = Math.sin(angle);
      var r0 = el.innerRadius;
      var r1 = el.outerRadius;
      return compute$1({
        x0: el.x + vx * r0,
        y0: el.y + vy * r0,
        x1: el.x + vx * r1,
        y1: el.y + vy * r1,
        vx,
        vy
      }, config);
    },
    point: function(el, config) {
      var v = orient(el, config.origin);
      var rx = v.x * el.options.radius;
      var ry = v.y * el.options.radius;
      return compute$1({
        x0: el.x - rx,
        y0: el.y - ry,
        x1: el.x + rx,
        y1: el.y + ry,
        vx: v.x,
        vy: v.y
      }, config);
    },
    bar: function(el, config) {
      var v = orient(el, config.origin);
      var x = el.x;
      var y = el.y;
      var sx = 0;
      var sy = 0;
      if (el.horizontal) {
        x = Math.min(el.x, el.base);
        sx = Math.abs(el.base - el.x);
      } else {
        y = Math.min(el.y, el.base);
        sy = Math.abs(el.base - el.y);
      }
      return compute$1({
        x0: x,
        y0: y + sy,
        x1: x + sx,
        y1: y,
        vx: v.x,
        vy: v.y
      }, config);
    },
    fallback: function(el, config) {
      var v = orient(el, config.origin);
      return compute$1({
        x0: el.x,
        y0: el.y,
        x1: el.x + (el.width || 0),
        y1: el.y + (el.height || 0),
        vx: v.x,
        vy: v.y
      }, config);
    }
  };
  var rasterize = utils.rasterize;
  function boundingRects2(model) {
    var borderWidth3 = model.borderWidth || 0;
    var padding = model.padding;
    var th = model.size.height;
    var tw = model.size.width;
    var tx = -tw / 2;
    var ty = -th / 2;
    return {
      frame: {
        x: tx - padding.left - borderWidth3,
        y: ty - padding.top - borderWidth3,
        w: tw + padding.width + borderWidth3 * 2,
        h: th + padding.height + borderWidth3 * 2
      },
      text: {
        x: tx,
        y: ty,
        w: tw,
        h: th
      }
    };
  }
  function getScaleOrigin(el, context) {
    var scale = context.chart.getDatasetMeta(context.datasetIndex).vScale;
    if (!scale) {
      return null;
    }
    if (scale.xCenter !== void 0 && scale.yCenter !== void 0) {
      return { x: scale.xCenter, y: scale.yCenter };
    }
    var pixel = scale.getBasePixel();
    return el.horizontal ? { x: pixel, y: null } : { x: null, y: pixel };
  }
  function getPositioner(el) {
    if (el instanceof ArcElement) {
      return positioners2.arc;
    }
    if (el instanceof PointElement) {
      return positioners2.point;
    }
    if (el instanceof BarElement) {
      return positioners2.bar;
    }
    return positioners2.fallback;
  }
  function drawRoundedRect(ctx, x, y, w, h, radius3) {
    var HALF_PI2 = Math.PI / 2;
    if (radius3) {
      var r = Math.min(radius3, h / 2, w / 2);
      var left = x + r;
      var top = y + r;
      var right = x + w - r;
      var bottom = y + h - r;
      ctx.moveTo(x, top);
      if (left < right && top < bottom) {
        ctx.arc(left, top, r, -Math.PI, -HALF_PI2);
        ctx.arc(right, top, r, -HALF_PI2, 0);
        ctx.arc(right, bottom, r, 0, HALF_PI2);
        ctx.arc(left, bottom, r, HALF_PI2, Math.PI);
      } else if (left < right) {
        ctx.moveTo(left, y);
        ctx.arc(right, top, r, -HALF_PI2, HALF_PI2);
        ctx.arc(left, top, r, HALF_PI2, Math.PI + HALF_PI2);
      } else if (top < bottom) {
        ctx.arc(left, top, r, -Math.PI, 0);
        ctx.arc(left, bottom, r, 0, Math.PI);
      } else {
        ctx.arc(left, top, r, -Math.PI, Math.PI);
      }
      ctx.closePath();
      ctx.moveTo(x, y);
    } else {
      ctx.rect(x, y, w, h);
    }
  }
  function drawFrame(ctx, rect, model) {
    var bgColor = model.backgroundColor;
    var borderColor4 = model.borderColor;
    var borderWidth3 = model.borderWidth;
    if (!bgColor && (!borderColor4 || !borderWidth3)) {
      return;
    }
    ctx.beginPath();
    drawRoundedRect(
      ctx,
      rasterize(rect.x) + borderWidth3 / 2,
      rasterize(rect.y) + borderWidth3 / 2,
      rasterize(rect.w) - borderWidth3,
      rasterize(rect.h) - borderWidth3,
      model.borderRadius
    );
    ctx.closePath();
    if (bgColor) {
      ctx.fillStyle = bgColor;
      ctx.fill();
    }
    if (borderColor4 && borderWidth3) {
      ctx.strokeStyle = borderColor4;
      ctx.lineWidth = borderWidth3;
      ctx.lineJoin = "miter";
      ctx.stroke();
    }
  }
  function textGeometry(rect, align, font) {
    var h = font.lineHeight;
    var w = rect.w;
    var x = rect.x;
    var y = rect.y + h / 2;
    if (align === "center") {
      x += w / 2;
    } else if (align === "end" || align === "right") {
      x += w;
    }
    return {
      h,
      w,
      x,
      y
    };
  }
  function drawTextLine(ctx, text, cfg) {
    var shadow = ctx.shadowBlur;
    var stroked = cfg.stroked;
    var x = rasterize(cfg.x);
    var y = rasterize(cfg.y);
    var w = rasterize(cfg.w);
    if (stroked) {
      ctx.strokeText(text, x, y, w);
    }
    if (cfg.filled) {
      if (shadow && stroked) {
        ctx.shadowBlur = 0;
      }
      ctx.fillText(text, x, y, w);
      if (shadow && stroked) {
        ctx.shadowBlur = shadow;
      }
    }
  }
  function drawText(ctx, lines, rect, model) {
    var align = model.textAlign;
    var color3 = model.color;
    var filled = !!color3;
    var font = model.font;
    var ilen = lines.length;
    var strokeColor = model.textStrokeColor;
    var strokeWidth = model.textStrokeWidth;
    var stroked = strokeColor && strokeWidth;
    var i;
    if (!ilen || !filled && !stroked) {
      return;
    }
    rect = textGeometry(rect, align, font);
    ctx.font = font.string;
    ctx.textAlign = align;
    ctx.textBaseline = "middle";
    ctx.shadowBlur = model.textShadowBlur;
    ctx.shadowColor = model.textShadowColor;
    if (filled) {
      ctx.fillStyle = color3;
    }
    if (stroked) {
      ctx.lineJoin = "round";
      ctx.lineWidth = strokeWidth;
      ctx.strokeStyle = strokeColor;
    }
    for (i = 0, ilen = lines.length; i < ilen; ++i) {
      drawTextLine(ctx, lines[i], {
        stroked,
        filled,
        w: rect.w,
        x: rect.x,
        y: rect.y + rect.h * i
      });
    }
  }
  var Label = function(config, ctx, el, index3) {
    var me = this;
    me._config = config;
    me._index = index3;
    me._model = null;
    me._rects = null;
    me._ctx = ctx;
    me._el = el;
  };
  merge(Label.prototype, {
    _modelize: function(display, lines, config, context) {
      var me = this;
      var index3 = me._index;
      var font = toFont(resolve([config.font, {}], context, index3));
      var color3 = resolve([config.color, defaults.color], context, index3);
      return {
        align: resolve([config.align, "center"], context, index3),
        anchor: resolve([config.anchor, "center"], context, index3),
        area: context.chart.chartArea,
        backgroundColor: resolve([config.backgroundColor, null], context, index3),
        borderColor: resolve([config.borderColor, null], context, index3),
        borderRadius: resolve([config.borderRadius, 0], context, index3),
        borderWidth: resolve([config.borderWidth, 0], context, index3),
        clamp: resolve([config.clamp, false], context, index3),
        clip: resolve([config.clip, false], context, index3),
        color: color3,
        display,
        font,
        lines,
        offset: resolve([config.offset, 4], context, index3),
        opacity: resolve([config.opacity, 1], context, index3),
        origin: getScaleOrigin(me._el, context),
        padding: toPadding(resolve([config.padding, 4], context, index3)),
        positioner: getPositioner(me._el),
        rotation: resolve([config.rotation, 0], context, index3) * (Math.PI / 180),
        size: utils.textSize(me._ctx, lines, font),
        textAlign: resolve([config.textAlign, "start"], context, index3),
        textShadowBlur: resolve([config.textShadowBlur, 0], context, index3),
        textShadowColor: resolve([config.textShadowColor, color3], context, index3),
        textStrokeColor: resolve([config.textStrokeColor, color3], context, index3),
        textStrokeWidth: resolve([config.textStrokeWidth, 0], context, index3)
      };
    },
    update: function(context) {
      var me = this;
      var model = null;
      var rects = null;
      var index3 = me._index;
      var config = me._config;
      var value, label, lines;
      var display = resolve([config.display, true], context, index3);
      if (display) {
        value = context.dataset.data[index3];
        label = valueOrDefault(callback(config.formatter, [value, context]), value);
        lines = isNullOrUndef(label) ? [] : utils.toTextLines(label);
        if (lines.length) {
          model = me._modelize(display, lines, config, context);
          rects = boundingRects2(model);
        }
      }
      me._model = model;
      me._rects = rects;
    },
    geometry: function() {
      return this._rects ? this._rects.frame : {};
    },
    rotation: function() {
      return this._model ? this._model.rotation : 0;
    },
    visible: function() {
      return this._model && this._model.opacity;
    },
    model: function() {
      return this._model;
    },
    draw: function(chart, center) {
      var me = this;
      var ctx = chart.ctx;
      var model = me._model;
      var rects = me._rects;
      var area;
      if (!this.visible()) {
        return;
      }
      ctx.save();
      if (model.clip) {
        area = model.area;
        ctx.beginPath();
        ctx.rect(
          area.left,
          area.top,
          area.right - area.left,
          area.bottom - area.top
        );
        ctx.clip();
      }
      ctx.globalAlpha = utils.bound(0, model.opacity, 1);
      ctx.translate(rasterize(center.x), rasterize(center.y));
      ctx.rotate(model.rotation);
      drawFrame(ctx, rects.frame, model);
      drawText(ctx, model.lines, rects.text, model);
      ctx.restore();
    }
  });
  var MIN_INTEGER = Number.MIN_SAFE_INTEGER || -9007199254740991;
  var MAX_INTEGER = Number.MAX_SAFE_INTEGER || 9007199254740991;
  function rotated2(point, center, angle) {
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);
    var cx = center.x;
    var cy = center.y;
    return {
      x: cx + cos * (point.x - cx) - sin * (point.y - cy),
      y: cy + sin * (point.x - cx) + cos * (point.y - cy)
    };
  }
  function projected(points, axis) {
    var min3 = MAX_INTEGER;
    var max3 = MIN_INTEGER;
    var origin = axis.origin;
    var i, pt, vx, vy, dp;
    for (i = 0; i < points.length; ++i) {
      pt = points[i];
      vx = pt.x - origin.x;
      vy = pt.y - origin.y;
      dp = axis.vx * vx + axis.vy * vy;
      min3 = Math.min(min3, dp);
      max3 = Math.max(max3, dp);
    }
    return {
      min: min3,
      max: max3
    };
  }
  function toAxis(p0, p1) {
    var vx = p1.x - p0.x;
    var vy = p1.y - p0.y;
    var ln = Math.sqrt(vx * vx + vy * vy);
    return {
      vx: (p1.x - p0.x) / ln,
      vy: (p1.y - p0.y) / ln,
      origin: p0,
      ln
    };
  }
  var HitBox = function() {
    this._rotation = 0;
    this._rect = {
      x: 0,
      y: 0,
      w: 0,
      h: 0
    };
  };
  merge(HitBox.prototype, {
    center: function() {
      var r = this._rect;
      return {
        x: r.x + r.w / 2,
        y: r.y + r.h / 2
      };
    },
    update: function(center, rect, rotation) {
      this._rotation = rotation;
      this._rect = {
        x: rect.x + center.x,
        y: rect.y + center.y,
        w: rect.w,
        h: rect.h
      };
    },
    contains: function(point) {
      var me = this;
      var margin = 1;
      var rect = me._rect;
      point = rotated2(point, me.center(), -me._rotation);
      return !(point.x < rect.x - margin || point.y < rect.y - margin || point.x > rect.x + rect.w + margin * 2 || point.y > rect.y + rect.h + margin * 2);
    },
    intersects: function(other) {
      var r0 = this._points();
      var r1 = other._points();
      var axes = [
        toAxis(r0[0], r0[1]),
        toAxis(r0[0], r0[3])
      ];
      var i, pr0, pr1;
      if (this._rotation !== other._rotation) {
        axes.push(
          toAxis(r1[0], r1[1]),
          toAxis(r1[0], r1[3])
        );
      }
      for (i = 0; i < axes.length; ++i) {
        pr0 = projected(r0, axes[i]);
        pr1 = projected(r1, axes[i]);
        if (pr0.max < pr1.min || pr1.max < pr0.min) {
          return false;
        }
      }
      return true;
    },
    _points: function() {
      var me = this;
      var rect = me._rect;
      var angle = me._rotation;
      var center = me.center();
      return [
        rotated2({ x: rect.x, y: rect.y }, center, angle),
        rotated2({ x: rect.x + rect.w, y: rect.y }, center, angle),
        rotated2({ x: rect.x + rect.w, y: rect.y + rect.h }, center, angle),
        rotated2({ x: rect.x, y: rect.y + rect.h }, center, angle)
      ];
    }
  });
  function coordinates(el, model, geometry) {
    var point = model.positioner(el, model);
    var vx = point.vx;
    var vy = point.vy;
    if (!vx && !vy) {
      return { x: point.x, y: point.y };
    }
    var w = geometry.w;
    var h = geometry.h;
    var rotation = model.rotation;
    var dx = Math.abs(w / 2 * Math.cos(rotation)) + Math.abs(h / 2 * Math.sin(rotation));
    var dy = Math.abs(w / 2 * Math.sin(rotation)) + Math.abs(h / 2 * Math.cos(rotation));
    var vs = 1 / Math.max(Math.abs(vx), Math.abs(vy));
    dx *= vx * vs;
    dy *= vy * vs;
    dx += model.offset * vx;
    dy += model.offset * vy;
    return {
      x: point.x + dx,
      y: point.y + dy
    };
  }
  function collide(labels, collider) {
    var i, j, s0, s1;
    for (i = labels.length - 1; i >= 0; --i) {
      s0 = labels[i].$layout;
      for (j = i - 1; j >= 0 && s0._visible; --j) {
        s1 = labels[j].$layout;
        if (s1._visible && s0._box.intersects(s1._box)) {
          collider(s0, s1);
        }
      }
    }
    return labels;
  }
  function compute(labels) {
    var i, ilen, label, state, geometry, center, proxy;
    for (i = 0, ilen = labels.length; i < ilen; ++i) {
      label = labels[i];
      state = label.$layout;
      if (state._visible) {
        proxy = new Proxy(label._el, { get: (el, p) => el.getProps([p], true)[p] });
        geometry = label.geometry();
        center = coordinates(proxy, label.model(), geometry);
        state._box.update(center, geometry, label.rotation());
      }
    }
    return collide(labels, function(s0, s1) {
      var h0 = s0._hidable;
      var h12 = s1._hidable;
      if (h0 && h12 || h12) {
        s1._visible = false;
      } else if (h0) {
        s0._visible = false;
      }
    });
  }
  var layout = {
    prepare: function(datasets) {
      var labels = [];
      var i, j, ilen, jlen, label;
      for (i = 0, ilen = datasets.length; i < ilen; ++i) {
        for (j = 0, jlen = datasets[i].length; j < jlen; ++j) {
          label = datasets[i][j];
          labels.push(label);
          label.$layout = {
            _box: new HitBox(),
            _hidable: false,
            _visible: true,
            _set: i,
            _idx: label._index
          };
        }
      }
      labels.sort(function(a, b) {
        var sa = a.$layout;
        var sb = b.$layout;
        return sa._idx === sb._idx ? sb._set - sa._set : sb._idx - sa._idx;
      });
      this.update(labels);
      return labels;
    },
    update: function(labels) {
      var dirty = false;
      var i, ilen, label, model, state;
      for (i = 0, ilen = labels.length; i < ilen; ++i) {
        label = labels[i];
        model = label.model();
        state = label.$layout;
        state._hidable = model && model.display === "auto";
        state._visible = label.visible();
        dirty |= state._hidable;
      }
      if (dirty) {
        compute(labels);
      }
    },
    lookup: function(labels, point) {
      var i, state;
      for (i = labels.length - 1; i >= 0; --i) {
        state = labels[i].$layout;
        if (state && state._visible && state._box.contains(point)) {
          return labels[i];
        }
      }
      return null;
    },
    draw: function(chart, labels) {
      var i, ilen, label, state, geometry, center;
      for (i = 0, ilen = labels.length; i < ilen; ++i) {
        label = labels[i];
        state = label.$layout;
        if (state._visible) {
          geometry = label.geometry();
          center = coordinates(label._el, label.model(), geometry);
          state._box.update(center, geometry, label.rotation());
          label.draw(chart, center);
        }
      }
    }
  };
  var formatter = function(value) {
    if (isNullOrUndef(value)) {
      return null;
    }
    var label = value;
    var keys, klen, k;
    if (isObject(value)) {
      if (!isNullOrUndef(value.label)) {
        label = value.label;
      } else if (!isNullOrUndef(value.r)) {
        label = value.r;
      } else {
        label = "";
        keys = Object.keys(value);
        for (k = 0, klen = keys.length; k < klen; ++k) {
          label += (k !== 0 ? ", " : "") + keys[k] + ": " + value[keys[k]];
        }
      }
    }
    return "" + label;
  };
  var defaults2 = {
    align: "center",
    anchor: "center",
    backgroundColor: null,
    borderColor: null,
    borderRadius: 0,
    borderWidth: 0,
    clamp: false,
    clip: false,
    color: void 0,
    display: true,
    font: {
      family: void 0,
      lineHeight: 1.2,
      size: void 0,
      style: void 0,
      weight: null
    },
    formatter,
    labels: void 0,
    listeners: {},
    offset: 4,
    opacity: 1,
    padding: {
      top: 4,
      right: 4,
      bottom: 4,
      left: 4
    },
    rotation: 0,
    textAlign: "start",
    textStrokeColor: void 0,
    textStrokeWidth: 0,
    textShadowBlur: 0,
    textShadowColor: void 0
  };
  var EXPANDO_KEY2 = "$datalabels";
  var DEFAULT_KEY = "$default";
  function configure(dataset, options) {
    var override = dataset.datalabels;
    var listeners = {};
    var configs = [];
    var labels, keys;
    if (override === false) {
      return null;
    }
    if (override === true) {
      override = {};
    }
    options = merge({}, [options, override]);
    labels = options.labels || {};
    keys = Object.keys(labels);
    delete options.labels;
    if (keys.length) {
      keys.forEach(function(key) {
        if (labels[key]) {
          configs.push(merge({}, [
            options,
            labels[key],
            { _key: key }
          ]));
        }
      });
    } else {
      configs.push(options);
    }
    listeners = configs.reduce(function(target, config) {
      each(config.listeners || {}, function(fn, event) {
        target[event] = target[event] || {};
        target[event][config._key || DEFAULT_KEY] = fn;
      });
      delete config.listeners;
      return target;
    }, {});
    return {
      labels: configs,
      listeners
    };
  }
  function dispatchEvent2(chart, listeners, label, event) {
    if (!listeners) {
      return;
    }
    var context = label.$context;
    var groups2 = label.$groups;
    var callback$1;
    if (!listeners[groups2._set]) {
      return;
    }
    callback$1 = listeners[groups2._set][groups2._key];
    if (!callback$1) {
      return;
    }
    if (callback(callback$1, [context, event]) === true) {
      chart[EXPANDO_KEY2]._dirty = true;
      label.update(context);
    }
  }
  function dispatchMoveEvents2(chart, listeners, previous, label, event) {
    var enter, leave;
    if (!previous && !label) {
      return;
    }
    if (!previous) {
      enter = true;
    } else if (!label) {
      leave = true;
    } else if (previous !== label) {
      leave = enter = true;
    }
    if (leave) {
      dispatchEvent2(chart, listeners.leave, previous, event);
    }
    if (enter) {
      dispatchEvent2(chart, listeners.enter, label, event);
    }
  }
  function handleMoveEvents2(chart, event) {
    var expando = chart[EXPANDO_KEY2];
    var listeners = expando._listeners;
    var previous, label;
    if (!listeners.enter && !listeners.leave) {
      return;
    }
    if (event.type === "mousemove") {
      label = layout.lookup(expando._labels, event);
    } else if (event.type !== "mouseout") {
      return;
    }
    previous = expando._hovered;
    expando._hovered = label;
    dispatchMoveEvents2(chart, listeners, previous, label, event);
  }
  function handleClickEvents2(chart, event) {
    var expando = chart[EXPANDO_KEY2];
    var handlers = expando._listeners.click;
    var label = handlers && layout.lookup(expando._labels, event);
    if (label) {
      dispatchEvent2(chart, handlers, label, event);
    }
  }
  var plugin = {
    id: "datalabels",
    defaults: defaults2,
    beforeInit: function(chart) {
      chart[EXPANDO_KEY2] = {
        _actives: []
      };
    },
    beforeUpdate: function(chart) {
      var expando = chart[EXPANDO_KEY2];
      expando._listened = false;
      expando._listeners = {};
      expando._datasets = [];
      expando._labels = [];
    },
    afterDatasetUpdate: function(chart, args, options) {
      var datasetIndex = args.index;
      var expando = chart[EXPANDO_KEY2];
      var labels = expando._datasets[datasetIndex] = [];
      var visible = chart.isDatasetVisible(datasetIndex);
      var dataset = chart.data.datasets[datasetIndex];
      var config = configure(dataset, options);
      var elements2 = args.meta.data || [];
      var ctx = chart.ctx;
      var i, j, ilen, jlen, cfg, key, el, label;
      ctx.save();
      for (i = 0, ilen = elements2.length; i < ilen; ++i) {
        el = elements2[i];
        el[EXPANDO_KEY2] = [];
        if (visible && el && chart.getDataVisibility(i) && !el.skip) {
          for (j = 0, jlen = config.labels.length; j < jlen; ++j) {
            cfg = config.labels[j];
            key = cfg._key;
            label = new Label(cfg, ctx, el, i);
            label.$groups = {
              _set: datasetIndex,
              _key: key || DEFAULT_KEY
            };
            label.$context = {
              active: false,
              chart,
              dataIndex: i,
              dataset,
              datasetIndex
            };
            label.update(label.$context);
            el[EXPANDO_KEY2].push(label);
            labels.push(label);
          }
        }
      }
      ctx.restore();
      merge(expando._listeners, config.listeners, {
        merger: function(event, target, source) {
          target[event] = target[event] || {};
          target[event][args.index] = source[event];
          expando._listened = true;
        }
      });
    },
    afterUpdate: function(chart) {
      chart[EXPANDO_KEY2]._labels = layout.prepare(chart[EXPANDO_KEY2]._datasets);
    },
    afterDatasetsDraw: function(chart) {
      layout.draw(chart, chart[EXPANDO_KEY2]._labels);
    },
    beforeEvent: function(chart, args) {
      if (chart[EXPANDO_KEY2]._listened) {
        var event = args.event;
        switch (event.type) {
          case "mousemove":
          case "mouseout":
            handleMoveEvents2(chart, event);
            break;
          case "click":
            handleClickEvents2(chart, event);
            break;
        }
      }
    },
    afterEvent: function(chart) {
      var expando = chart[EXPANDO_KEY2];
      var previous = expando._actives;
      var actives = expando._actives = chart.getActiveElements();
      var updates = utils.arrayDiff(previous, actives);
      var i, ilen, j, jlen, update, label, labels;
      for (i = 0, ilen = updates.length; i < ilen; ++i) {
        update = updates[i];
        if (update[1]) {
          labels = update[0].element[EXPANDO_KEY2] || [];
          for (j = 0, jlen = labels.length; j < jlen; ++j) {
            label = labels[j];
            label.$context.active = update[1] === 1;
            label.update(label.$context);
          }
        }
      }
      if (expando._dirty || updates.length) {
        layout.update(expando._labels);
        chart.render();
      }
      delete expando._dirty;
    }
  };

  // node_modules/d3-array/src/ascending.js
  function ascending(a, b) {
    return a == null || b == null ? NaN : a < b ? -1 : a > b ? 1 : a >= b ? 0 : NaN;
  }

  // node_modules/d3-array/src/descending.js
  function descending(a, b) {
    return a == null || b == null ? NaN : b < a ? -1 : b > a ? 1 : b >= a ? 0 : NaN;
  }

  // node_modules/internmap/src/index.js
  var InternMap = class extends Map {
    constructor(entries, key = keyof) {
      super();
      Object.defineProperties(this, { _intern: { value: /* @__PURE__ */ new Map() }, _key: { value: key } });
      if (entries != null)
        for (const [key2, value] of entries)
          this.set(key2, value);
    }
    get(key) {
      return super.get(intern_get(this, key));
    }
    has(key) {
      return super.has(intern_get(this, key));
    }
    set(key, value) {
      return super.set(intern_set(this, key), value);
    }
    delete(key) {
      return super.delete(intern_delete(this, key));
    }
  };
  function intern_get({ _intern, _key }, value) {
    const key = _key(value);
    return _intern.has(key) ? _intern.get(key) : value;
  }
  function intern_set({ _intern, _key }, value) {
    const key = _key(value);
    if (_intern.has(key))
      return _intern.get(key);
    _intern.set(key, value);
    return value;
  }
  function intern_delete({ _intern, _key }, value) {
    const key = _key(value);
    if (_intern.has(key)) {
      value = _intern.get(key);
      _intern.delete(key);
    }
    return value;
  }
  function keyof(value) {
    return value !== null && typeof value === "object" ? value.valueOf() : value;
  }

  // node_modules/d3-array/src/identity.js
  function identity(x) {
    return x;
  }

  // node_modules/d3-array/src/group.js
  function rollup(values, reduce, ...keys) {
    return nest(values, identity, reduce, keys);
  }
  function rollups(values, reduce, ...keys) {
    return nest(values, Array.from, reduce, keys);
  }
  function nest(values, map4, reduce, keys) {
    return function regroup(values2, i) {
      if (i >= keys.length)
        return reduce(values2);
      const groups2 = new InternMap();
      const keyof2 = keys[i++];
      let index3 = -1;
      for (const value of values2) {
        const key = keyof2(value, ++index3, values2);
        const group2 = groups2.get(key);
        if (group2)
          group2.push(value);
        else
          groups2.set(key, [value]);
      }
      for (const [key, values3] of groups2) {
        groups2.set(key, regroup(values3, i));
      }
      return map4(groups2);
    }(values, 0);
  }

  // node_modules/d3-array/src/max.js
  function max(values, valueof) {
    let max3;
    if (valueof === void 0) {
      for (const value of values) {
        if (value != null && (max3 < value || max3 === void 0 && value >= value)) {
          max3 = value;
        }
      }
    } else {
      let index3 = -1;
      for (let value of values) {
        if ((value = valueof(value, ++index3, values)) != null && (max3 < value || max3 === void 0 && value >= value)) {
          max3 = value;
        }
      }
    }
    return max3;
  }

  // node_modules/d3-array/src/min.js
  function min(values, valueof) {
    let min3;
    if (valueof === void 0) {
      for (const value of values) {
        if (value != null && (min3 > value || min3 === void 0 && value >= value)) {
          min3 = value;
        }
      }
    } else {
      let index3 = -1;
      for (let value of values) {
        if ((value = valueof(value, ++index3, values)) != null && (min3 > value || min3 === void 0 && value >= value)) {
          min3 = value;
        }
      }
    }
    return min3;
  }

  // node_modules/d3-array/src/mean.js
  function mean(values, valueof) {
    let count = 0;
    let sum = 0;
    if (valueof === void 0) {
      for (let value of values) {
        if (value != null && (value = +value) >= value) {
          ++count, sum += value;
        }
      }
    } else {
      let index3 = -1;
      for (let value of values) {
        if ((value = valueof(value, ++index3, values)) != null && (value = +value) >= value) {
          ++count, sum += value;
        }
      }
    }
    if (count)
      return sum / count;
  }

  // node_modules/d3-dispatch/src/dispatch.js
  var noop2 = { value: () => {
  } };
  function dispatch() {
    for (var i = 0, n = arguments.length, _ = {}, t; i < n; ++i) {
      if (!(t = arguments[i] + "") || t in _ || /[\s.]/.test(t))
        throw new Error("illegal type: " + t);
      _[t] = [];
    }
    return new Dispatch(_);
  }
  function Dispatch(_) {
    this._ = _;
  }
  function parseTypenames(typenames, types) {
    return typenames.trim().split(/^|\s+/).map(function(t) {
      var name = "", i = t.indexOf(".");
      if (i >= 0)
        name = t.slice(i + 1), t = t.slice(0, i);
      if (t && !types.hasOwnProperty(t))
        throw new Error("unknown type: " + t);
      return { type: t, name };
    });
  }
  Dispatch.prototype = dispatch.prototype = {
    constructor: Dispatch,
    on: function(typename, callback2) {
      var _ = this._, T = parseTypenames(typename + "", _), t, i = -1, n = T.length;
      if (arguments.length < 2) {
        while (++i < n)
          if ((t = (typename = T[i]).type) && (t = get(_[t], typename.name)))
            return t;
        return;
      }
      if (callback2 != null && typeof callback2 !== "function")
        throw new Error("invalid callback: " + callback2);
      while (++i < n) {
        if (t = (typename = T[i]).type)
          _[t] = set2(_[t], typename.name, callback2);
        else if (callback2 == null)
          for (t in _)
            _[t] = set2(_[t], typename.name, null);
      }
      return this;
    },
    copy: function() {
      var copy = {}, _ = this._;
      for (var t in _)
        copy[t] = _[t].slice();
      return new Dispatch(copy);
    },
    call: function(type2, that) {
      if ((n = arguments.length - 2) > 0)
        for (var args = new Array(n), i = 0, n, t; i < n; ++i)
          args[i] = arguments[i + 2];
      if (!this._.hasOwnProperty(type2))
        throw new Error("unknown type: " + type2);
      for (t = this._[type2], i = 0, n = t.length; i < n; ++i)
        t[i].value.apply(that, args);
    },
    apply: function(type2, that, args) {
      if (!this._.hasOwnProperty(type2))
        throw new Error("unknown type: " + type2);
      for (var t = this._[type2], i = 0, n = t.length; i < n; ++i)
        t[i].value.apply(that, args);
    }
  };
  function get(type2, name) {
    for (var i = 0, n = type2.length, c; i < n; ++i) {
      if ((c = type2[i]).name === name) {
        return c.value;
      }
    }
  }
  function set2(type2, name, callback2) {
    for (var i = 0, n = type2.length; i < n; ++i) {
      if (type2[i].name === name) {
        type2[i] = noop2, type2 = type2.slice(0, i).concat(type2.slice(i + 1));
        break;
      }
    }
    if (callback2 != null)
      type2.push({ name, value: callback2 });
    return type2;
  }
  var dispatch_default = dispatch;

  // node_modules/d3-selection/src/namespaces.js
  var xhtml = "http://www.w3.org/1999/xhtml";
  var namespaces_default = {
    svg: "http://www.w3.org/2000/svg",
    xhtml,
    xlink: "http://www.w3.org/1999/xlink",
    xml: "http://www.w3.org/XML/1998/namespace",
    xmlns: "http://www.w3.org/2000/xmlns/"
  };

  // node_modules/d3-selection/src/namespace.js
  function namespace_default(name) {
    var prefix = name += "", i = prefix.indexOf(":");
    if (i >= 0 && (prefix = name.slice(0, i)) !== "xmlns")
      name = name.slice(i + 1);
    return namespaces_default.hasOwnProperty(prefix) ? { space: namespaces_default[prefix], local: name } : name;
  }

  // node_modules/d3-selection/src/creator.js
  function creatorInherit(name) {
    return function() {
      var document2 = this.ownerDocument, uri = this.namespaceURI;
      return uri === xhtml && document2.documentElement.namespaceURI === xhtml ? document2.createElement(name) : document2.createElementNS(uri, name);
    };
  }
  function creatorFixed(fullname) {
    return function() {
      return this.ownerDocument.createElementNS(fullname.space, fullname.local);
    };
  }
  function creator_default(name) {
    var fullname = namespace_default(name);
    return (fullname.local ? creatorFixed : creatorInherit)(fullname);
  }

  // node_modules/d3-selection/src/selector.js
  function none() {
  }
  function selector_default(selector) {
    return selector == null ? none : function() {
      return this.querySelector(selector);
    };
  }

  // node_modules/d3-selection/src/selection/select.js
  function select_default(select) {
    if (typeof select !== "function")
      select = selector_default(select);
    for (var groups2 = this._groups, m = groups2.length, subgroups = new Array(m), j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, subgroup = subgroups[j] = new Array(n), node, subnode, i = 0; i < n; ++i) {
        if ((node = group2[i]) && (subnode = select.call(node, node.__data__, i, group2))) {
          if ("__data__" in node)
            subnode.__data__ = node.__data__;
          subgroup[i] = subnode;
        }
      }
    }
    return new Selection(subgroups, this._parents);
  }

  // node_modules/d3-selection/src/array.js
  function array(x) {
    return x == null ? [] : Array.isArray(x) ? x : Array.from(x);
  }

  // node_modules/d3-selection/src/selectorAll.js
  function empty() {
    return [];
  }
  function selectorAll_default(selector) {
    return selector == null ? empty : function() {
      return this.querySelectorAll(selector);
    };
  }

  // node_modules/d3-selection/src/selection/selectAll.js
  function arrayAll(select) {
    return function() {
      return array(select.apply(this, arguments));
    };
  }
  function selectAll_default(select) {
    if (typeof select === "function")
      select = arrayAll(select);
    else
      select = selectorAll_default(select);
    for (var groups2 = this._groups, m = groups2.length, subgroups = [], parents = [], j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, node, i = 0; i < n; ++i) {
        if (node = group2[i]) {
          subgroups.push(select.call(node, node.__data__, i, group2));
          parents.push(node);
        }
      }
    }
    return new Selection(subgroups, parents);
  }

  // node_modules/d3-selection/src/matcher.js
  function matcher_default(selector) {
    return function() {
      return this.matches(selector);
    };
  }
  function childMatcher(selector) {
    return function(node) {
      return node.matches(selector);
    };
  }

  // node_modules/d3-selection/src/selection/selectChild.js
  var find = Array.prototype.find;
  function childFind(match) {
    return function() {
      return find.call(this.children, match);
    };
  }
  function childFirst() {
    return this.firstElementChild;
  }
  function selectChild_default(match) {
    return this.select(match == null ? childFirst : childFind(typeof match === "function" ? match : childMatcher(match)));
  }

  // node_modules/d3-selection/src/selection/selectChildren.js
  var filter = Array.prototype.filter;
  function children() {
    return Array.from(this.children);
  }
  function childrenFilter(match) {
    return function() {
      return filter.call(this.children, match);
    };
  }
  function selectChildren_default(match) {
    return this.selectAll(match == null ? children : childrenFilter(typeof match === "function" ? match : childMatcher(match)));
  }

  // node_modules/d3-selection/src/selection/filter.js
  function filter_default(match) {
    if (typeof match !== "function")
      match = matcher_default(match);
    for (var groups2 = this._groups, m = groups2.length, subgroups = new Array(m), j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, subgroup = subgroups[j] = [], node, i = 0; i < n; ++i) {
        if ((node = group2[i]) && match.call(node, node.__data__, i, group2)) {
          subgroup.push(node);
        }
      }
    }
    return new Selection(subgroups, this._parents);
  }

  // node_modules/d3-selection/src/selection/sparse.js
  function sparse_default(update) {
    return new Array(update.length);
  }

  // node_modules/d3-selection/src/selection/enter.js
  function enter_default() {
    return new Selection(this._enter || this._groups.map(sparse_default), this._parents);
  }
  function EnterNode(parent, datum2) {
    this.ownerDocument = parent.ownerDocument;
    this.namespaceURI = parent.namespaceURI;
    this._next = null;
    this._parent = parent;
    this.__data__ = datum2;
  }
  EnterNode.prototype = {
    constructor: EnterNode,
    appendChild: function(child) {
      return this._parent.insertBefore(child, this._next);
    },
    insertBefore: function(child, next) {
      return this._parent.insertBefore(child, next);
    },
    querySelector: function(selector) {
      return this._parent.querySelector(selector);
    },
    querySelectorAll: function(selector) {
      return this._parent.querySelectorAll(selector);
    }
  };

  // node_modules/d3-selection/src/constant.js
  function constant_default(x) {
    return function() {
      return x;
    };
  }

  // node_modules/d3-selection/src/selection/data.js
  function bindIndex(parent, group2, enter, update, exit, data) {
    var i = 0, node, groupLength = group2.length, dataLength = data.length;
    for (; i < dataLength; ++i) {
      if (node = group2[i]) {
        node.__data__ = data[i];
        update[i] = node;
      } else {
        enter[i] = new EnterNode(parent, data[i]);
      }
    }
    for (; i < groupLength; ++i) {
      if (node = group2[i]) {
        exit[i] = node;
      }
    }
  }
  function bindKey(parent, group2, enter, update, exit, data, key) {
    var i, node, nodeByKeyValue = /* @__PURE__ */ new Map(), groupLength = group2.length, dataLength = data.length, keyValues = new Array(groupLength), keyValue;
    for (i = 0; i < groupLength; ++i) {
      if (node = group2[i]) {
        keyValues[i] = keyValue = key.call(node, node.__data__, i, group2) + "";
        if (nodeByKeyValue.has(keyValue)) {
          exit[i] = node;
        } else {
          nodeByKeyValue.set(keyValue, node);
        }
      }
    }
    for (i = 0; i < dataLength; ++i) {
      keyValue = key.call(parent, data[i], i, data) + "";
      if (node = nodeByKeyValue.get(keyValue)) {
        update[i] = node;
        node.__data__ = data[i];
        nodeByKeyValue.delete(keyValue);
      } else {
        enter[i] = new EnterNode(parent, data[i]);
      }
    }
    for (i = 0; i < groupLength; ++i) {
      if ((node = group2[i]) && nodeByKeyValue.get(keyValues[i]) === node) {
        exit[i] = node;
      }
    }
  }
  function datum(node) {
    return node.__data__;
  }
  function data_default(value, key) {
    if (!arguments.length)
      return Array.from(this, datum);
    var bind = key ? bindKey : bindIndex, parents = this._parents, groups2 = this._groups;
    if (typeof value !== "function")
      value = constant_default(value);
    for (var m = groups2.length, update = new Array(m), enter = new Array(m), exit = new Array(m), j = 0; j < m; ++j) {
      var parent = parents[j], group2 = groups2[j], groupLength = group2.length, data = arraylike(value.call(parent, parent && parent.__data__, j, parents)), dataLength = data.length, enterGroup = enter[j] = new Array(dataLength), updateGroup = update[j] = new Array(dataLength), exitGroup = exit[j] = new Array(groupLength);
      bind(parent, group2, enterGroup, updateGroup, exitGroup, data, key);
      for (var i0 = 0, i1 = 0, previous, next; i0 < dataLength; ++i0) {
        if (previous = enterGroup[i0]) {
          if (i0 >= i1)
            i1 = i0 + 1;
          while (!(next = updateGroup[i1]) && ++i1 < dataLength)
            ;
          previous._next = next || null;
        }
      }
    }
    update = new Selection(update, parents);
    update._enter = enter;
    update._exit = exit;
    return update;
  }
  function arraylike(data) {
    return typeof data === "object" && "length" in data ? data : Array.from(data);
  }

  // node_modules/d3-selection/src/selection/exit.js
  function exit_default() {
    return new Selection(this._exit || this._groups.map(sparse_default), this._parents);
  }

  // node_modules/d3-selection/src/selection/join.js
  function join_default(onenter, onupdate, onexit) {
    var enter = this.enter(), update = this, exit = this.exit();
    if (typeof onenter === "function") {
      enter = onenter(enter);
      if (enter)
        enter = enter.selection();
    } else {
      enter = enter.append(onenter + "");
    }
    if (onupdate != null) {
      update = onupdate(update);
      if (update)
        update = update.selection();
    }
    if (onexit == null)
      exit.remove();
    else
      onexit(exit);
    return enter && update ? enter.merge(update).order() : update;
  }

  // node_modules/d3-selection/src/selection/merge.js
  function merge_default(context) {
    var selection2 = context.selection ? context.selection() : context;
    for (var groups0 = this._groups, groups1 = selection2._groups, m0 = groups0.length, m1 = groups1.length, m = Math.min(m0, m1), merges = new Array(m0), j = 0; j < m; ++j) {
      for (var group0 = groups0[j], group1 = groups1[j], n = group0.length, merge2 = merges[j] = new Array(n), node, i = 0; i < n; ++i) {
        if (node = group0[i] || group1[i]) {
          merge2[i] = node;
        }
      }
    }
    for (; j < m0; ++j) {
      merges[j] = groups0[j];
    }
    return new Selection(merges, this._parents);
  }

  // node_modules/d3-selection/src/selection/order.js
  function order_default() {
    for (var groups2 = this._groups, j = -1, m = groups2.length; ++j < m; ) {
      for (var group2 = groups2[j], i = group2.length - 1, next = group2[i], node; --i >= 0; ) {
        if (node = group2[i]) {
          if (next && node.compareDocumentPosition(next) ^ 4)
            next.parentNode.insertBefore(node, next);
          next = node;
        }
      }
    }
    return this;
  }

  // node_modules/d3-selection/src/selection/sort.js
  function sort_default(compare) {
    if (!compare)
      compare = ascending2;
    function compareNode(a, b) {
      return a && b ? compare(a.__data__, b.__data__) : !a - !b;
    }
    for (var groups2 = this._groups, m = groups2.length, sortgroups = new Array(m), j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, sortgroup = sortgroups[j] = new Array(n), node, i = 0; i < n; ++i) {
        if (node = group2[i]) {
          sortgroup[i] = node;
        }
      }
      sortgroup.sort(compareNode);
    }
    return new Selection(sortgroups, this._parents).order();
  }
  function ascending2(a, b) {
    return a < b ? -1 : a > b ? 1 : a >= b ? 0 : NaN;
  }

  // node_modules/d3-selection/src/selection/call.js
  function call_default() {
    var callback2 = arguments[0];
    arguments[0] = this;
    callback2.apply(null, arguments);
    return this;
  }

  // node_modules/d3-selection/src/selection/nodes.js
  function nodes_default() {
    return Array.from(this);
  }

  // node_modules/d3-selection/src/selection/node.js
  function node_default() {
    for (var groups2 = this._groups, j = 0, m = groups2.length; j < m; ++j) {
      for (var group2 = groups2[j], i = 0, n = group2.length; i < n; ++i) {
        var node = group2[i];
        if (node)
          return node;
      }
    }
    return null;
  }

  // node_modules/d3-selection/src/selection/size.js
  function size_default() {
    let size = 0;
    for (const node of this)
      ++size;
    return size;
  }

  // node_modules/d3-selection/src/selection/empty.js
  function empty_default() {
    return !this.node();
  }

  // node_modules/d3-selection/src/selection/each.js
  function each_default(callback2) {
    for (var groups2 = this._groups, j = 0, m = groups2.length; j < m; ++j) {
      for (var group2 = groups2[j], i = 0, n = group2.length, node; i < n; ++i) {
        if (node = group2[i])
          callback2.call(node, node.__data__, i, group2);
      }
    }
    return this;
  }

  // node_modules/d3-selection/src/selection/attr.js
  function attrRemove(name) {
    return function() {
      this.removeAttribute(name);
    };
  }
  function attrRemoveNS(fullname) {
    return function() {
      this.removeAttributeNS(fullname.space, fullname.local);
    };
  }
  function attrConstant(name, value) {
    return function() {
      this.setAttribute(name, value);
    };
  }
  function attrConstantNS(fullname, value) {
    return function() {
      this.setAttributeNS(fullname.space, fullname.local, value);
    };
  }
  function attrFunction(name, value) {
    return function() {
      var v = value.apply(this, arguments);
      if (v == null)
        this.removeAttribute(name);
      else
        this.setAttribute(name, v);
    };
  }
  function attrFunctionNS(fullname, value) {
    return function() {
      var v = value.apply(this, arguments);
      if (v == null)
        this.removeAttributeNS(fullname.space, fullname.local);
      else
        this.setAttributeNS(fullname.space, fullname.local, v);
    };
  }
  function attr_default(name, value) {
    var fullname = namespace_default(name);
    if (arguments.length < 2) {
      var node = this.node();
      return fullname.local ? node.getAttributeNS(fullname.space, fullname.local) : node.getAttribute(fullname);
    }
    return this.each((value == null ? fullname.local ? attrRemoveNS : attrRemove : typeof value === "function" ? fullname.local ? attrFunctionNS : attrFunction : fullname.local ? attrConstantNS : attrConstant)(fullname, value));
  }

  // node_modules/d3-selection/src/window.js
  function window_default(node) {
    return node.ownerDocument && node.ownerDocument.defaultView || node.document && node || node.defaultView;
  }

  // node_modules/d3-selection/src/selection/style.js
  function styleRemove(name) {
    return function() {
      this.style.removeProperty(name);
    };
  }
  function styleConstant(name, value, priority) {
    return function() {
      this.style.setProperty(name, value, priority);
    };
  }
  function styleFunction(name, value, priority) {
    return function() {
      var v = value.apply(this, arguments);
      if (v == null)
        this.style.removeProperty(name);
      else
        this.style.setProperty(name, v, priority);
    };
  }
  function style_default(name, value, priority) {
    return arguments.length > 1 ? this.each((value == null ? styleRemove : typeof value === "function" ? styleFunction : styleConstant)(name, value, priority == null ? "" : priority)) : styleValue(this.node(), name);
  }
  function styleValue(node, name) {
    return node.style.getPropertyValue(name) || window_default(node).getComputedStyle(node, null).getPropertyValue(name);
  }

  // node_modules/d3-selection/src/selection/property.js
  function propertyRemove(name) {
    return function() {
      delete this[name];
    };
  }
  function propertyConstant(name, value) {
    return function() {
      this[name] = value;
    };
  }
  function propertyFunction(name, value) {
    return function() {
      var v = value.apply(this, arguments);
      if (v == null)
        delete this[name];
      else
        this[name] = v;
    };
  }
  function property_default(name, value) {
    return arguments.length > 1 ? this.each((value == null ? propertyRemove : typeof value === "function" ? propertyFunction : propertyConstant)(name, value)) : this.node()[name];
  }

  // node_modules/d3-selection/src/selection/classed.js
  function classArray(string) {
    return string.trim().split(/^|\s+/);
  }
  function classList(node) {
    return node.classList || new ClassList(node);
  }
  function ClassList(node) {
    this._node = node;
    this._names = classArray(node.getAttribute("class") || "");
  }
  ClassList.prototype = {
    add: function(name) {
      var i = this._names.indexOf(name);
      if (i < 0) {
        this._names.push(name);
        this._node.setAttribute("class", this._names.join(" "));
      }
    },
    remove: function(name) {
      var i = this._names.indexOf(name);
      if (i >= 0) {
        this._names.splice(i, 1);
        this._node.setAttribute("class", this._names.join(" "));
      }
    },
    contains: function(name) {
      return this._names.indexOf(name) >= 0;
    }
  };
  function classedAdd(node, names2) {
    var list = classList(node), i = -1, n = names2.length;
    while (++i < n)
      list.add(names2[i]);
  }
  function classedRemove(node, names2) {
    var list = classList(node), i = -1, n = names2.length;
    while (++i < n)
      list.remove(names2[i]);
  }
  function classedTrue(names2) {
    return function() {
      classedAdd(this, names2);
    };
  }
  function classedFalse(names2) {
    return function() {
      classedRemove(this, names2);
    };
  }
  function classedFunction(names2, value) {
    return function() {
      (value.apply(this, arguments) ? classedAdd : classedRemove)(this, names2);
    };
  }
  function classed_default(name, value) {
    var names2 = classArray(name + "");
    if (arguments.length < 2) {
      var list = classList(this.node()), i = -1, n = names2.length;
      while (++i < n)
        if (!list.contains(names2[i]))
          return false;
      return true;
    }
    return this.each((typeof value === "function" ? classedFunction : value ? classedTrue : classedFalse)(names2, value));
  }

  // node_modules/d3-selection/src/selection/text.js
  function textRemove() {
    this.textContent = "";
  }
  function textConstant(value) {
    return function() {
      this.textContent = value;
    };
  }
  function textFunction(value) {
    return function() {
      var v = value.apply(this, arguments);
      this.textContent = v == null ? "" : v;
    };
  }
  function text_default(value) {
    return arguments.length ? this.each(value == null ? textRemove : (typeof value === "function" ? textFunction : textConstant)(value)) : this.node().textContent;
  }

  // node_modules/d3-selection/src/selection/html.js
  function htmlRemove() {
    this.innerHTML = "";
  }
  function htmlConstant(value) {
    return function() {
      this.innerHTML = value;
    };
  }
  function htmlFunction(value) {
    return function() {
      var v = value.apply(this, arguments);
      this.innerHTML = v == null ? "" : v;
    };
  }
  function html_default(value) {
    return arguments.length ? this.each(value == null ? htmlRemove : (typeof value === "function" ? htmlFunction : htmlConstant)(value)) : this.node().innerHTML;
  }

  // node_modules/d3-selection/src/selection/raise.js
  function raise() {
    if (this.nextSibling)
      this.parentNode.appendChild(this);
  }
  function raise_default() {
    return this.each(raise);
  }

  // node_modules/d3-selection/src/selection/lower.js
  function lower() {
    if (this.previousSibling)
      this.parentNode.insertBefore(this, this.parentNode.firstChild);
  }
  function lower_default() {
    return this.each(lower);
  }

  // node_modules/d3-selection/src/selection/append.js
  function append_default(name) {
    var create2 = typeof name === "function" ? name : creator_default(name);
    return this.select(function() {
      return this.appendChild(create2.apply(this, arguments));
    });
  }

  // node_modules/d3-selection/src/selection/insert.js
  function constantNull() {
    return null;
  }
  function insert_default(name, before) {
    var create2 = typeof name === "function" ? name : creator_default(name), select = before == null ? constantNull : typeof before === "function" ? before : selector_default(before);
    return this.select(function() {
      return this.insertBefore(create2.apply(this, arguments), select.apply(this, arguments) || null);
    });
  }

  // node_modules/d3-selection/src/selection/remove.js
  function remove() {
    var parent = this.parentNode;
    if (parent)
      parent.removeChild(this);
  }
  function remove_default() {
    return this.each(remove);
  }

  // node_modules/d3-selection/src/selection/clone.js
  function selection_cloneShallow() {
    var clone2 = this.cloneNode(false), parent = this.parentNode;
    return parent ? parent.insertBefore(clone2, this.nextSibling) : clone2;
  }
  function selection_cloneDeep() {
    var clone2 = this.cloneNode(true), parent = this.parentNode;
    return parent ? parent.insertBefore(clone2, this.nextSibling) : clone2;
  }
  function clone_default(deep) {
    return this.select(deep ? selection_cloneDeep : selection_cloneShallow);
  }

  // node_modules/d3-selection/src/selection/datum.js
  function datum_default(value) {
    return arguments.length ? this.property("__data__", value) : this.node().__data__;
  }

  // node_modules/d3-selection/src/selection/on.js
  function contextListener(listener) {
    return function(event) {
      listener.call(this, event, this.__data__);
    };
  }
  function parseTypenames2(typenames) {
    return typenames.trim().split(/^|\s+/).map(function(t) {
      var name = "", i = t.indexOf(".");
      if (i >= 0)
        name = t.slice(i + 1), t = t.slice(0, i);
      return { type: t, name };
    });
  }
  function onRemove(typename) {
    return function() {
      var on = this.__on;
      if (!on)
        return;
      for (var j = 0, i = -1, m = on.length, o; j < m; ++j) {
        if (o = on[j], (!typename.type || o.type === typename.type) && o.name === typename.name) {
          this.removeEventListener(o.type, o.listener, o.options);
        } else {
          on[++i] = o;
        }
      }
      if (++i)
        on.length = i;
      else
        delete this.__on;
    };
  }
  function onAdd(typename, value, options) {
    return function() {
      var on = this.__on, o, listener = contextListener(value);
      if (on)
        for (var j = 0, m = on.length; j < m; ++j) {
          if ((o = on[j]).type === typename.type && o.name === typename.name) {
            this.removeEventListener(o.type, o.listener, o.options);
            this.addEventListener(o.type, o.listener = listener, o.options = options);
            o.value = value;
            return;
          }
        }
      this.addEventListener(typename.type, listener, options);
      o = { type: typename.type, name: typename.name, value, listener, options };
      if (!on)
        this.__on = [o];
      else
        on.push(o);
    };
  }
  function on_default(typename, value, options) {
    var typenames = parseTypenames2(typename + ""), i, n = typenames.length, t;
    if (arguments.length < 2) {
      var on = this.node().__on;
      if (on)
        for (var j = 0, m = on.length, o; j < m; ++j) {
          for (i = 0, o = on[j]; i < n; ++i) {
            if ((t = typenames[i]).type === o.type && t.name === o.name) {
              return o.value;
            }
          }
        }
      return;
    }
    on = value ? onAdd : onRemove;
    for (i = 0; i < n; ++i)
      this.each(on(typenames[i], value, options));
    return this;
  }

  // node_modules/d3-selection/src/selection/dispatch.js
  function dispatchEvent3(node, type2, params) {
    var window2 = window_default(node), event = window2.CustomEvent;
    if (typeof event === "function") {
      event = new event(type2, params);
    } else {
      event = window2.document.createEvent("Event");
      if (params)
        event.initEvent(type2, params.bubbles, params.cancelable), event.detail = params.detail;
      else
        event.initEvent(type2, false, false);
    }
    node.dispatchEvent(event);
  }
  function dispatchConstant(type2, params) {
    return function() {
      return dispatchEvent3(this, type2, params);
    };
  }
  function dispatchFunction(type2, params) {
    return function() {
      return dispatchEvent3(this, type2, params.apply(this, arguments));
    };
  }
  function dispatch_default2(type2, params) {
    return this.each((typeof params === "function" ? dispatchFunction : dispatchConstant)(type2, params));
  }

  // node_modules/d3-selection/src/selection/iterator.js
  function* iterator_default() {
    for (var groups2 = this._groups, j = 0, m = groups2.length; j < m; ++j) {
      for (var group2 = groups2[j], i = 0, n = group2.length, node; i < n; ++i) {
        if (node = group2[i])
          yield node;
      }
    }
  }

  // node_modules/d3-selection/src/selection/index.js
  var root = [null];
  function Selection(groups2, parents) {
    this._groups = groups2;
    this._parents = parents;
  }
  function selection() {
    return new Selection([[document.documentElement]], root);
  }
  function selection_selection() {
    return this;
  }
  Selection.prototype = selection.prototype = {
    constructor: Selection,
    select: select_default,
    selectAll: selectAll_default,
    selectChild: selectChild_default,
    selectChildren: selectChildren_default,
    filter: filter_default,
    data: data_default,
    enter: enter_default,
    exit: exit_default,
    join: join_default,
    merge: merge_default,
    selection: selection_selection,
    order: order_default,
    sort: sort_default,
    call: call_default,
    nodes: nodes_default,
    node: node_default,
    size: size_default,
    empty: empty_default,
    each: each_default,
    attr: attr_default,
    style: style_default,
    property: property_default,
    classed: classed_default,
    text: text_default,
    html: html_default,
    raise: raise_default,
    lower: lower_default,
    append: append_default,
    insert: insert_default,
    remove: remove_default,
    clone: clone_default,
    datum: datum_default,
    on: on_default,
    dispatch: dispatch_default2,
    [Symbol.iterator]: iterator_default
  };
  var selection_default = selection;

  // node_modules/d3-color/src/define.js
  function define_default(constructor, factory, prototype) {
    constructor.prototype = factory.prototype = prototype;
    prototype.constructor = constructor;
  }
  function extend(parent, definition) {
    var prototype = Object.create(parent.prototype);
    for (var key in definition)
      prototype[key] = definition[key];
    return prototype;
  }

  // node_modules/d3-color/src/color.js
  function Color2() {
  }
  var darker = 0.7;
  var brighter = 1 / darker;
  var reI = "\\s*([+-]?\\d+)\\s*";
  var reN = "\\s*([+-]?(?:\\d*\\.)?\\d+(?:[eE][+-]?\\d+)?)\\s*";
  var reP = "\\s*([+-]?(?:\\d*\\.)?\\d+(?:[eE][+-]?\\d+)?)%\\s*";
  var reHex = /^#([0-9a-f]{3,8})$/;
  var reRgbInteger = new RegExp(`^rgb\\(${reI},${reI},${reI}\\)$`);
  var reRgbPercent = new RegExp(`^rgb\\(${reP},${reP},${reP}\\)$`);
  var reRgbaInteger = new RegExp(`^rgba\\(${reI},${reI},${reI},${reN}\\)$`);
  var reRgbaPercent = new RegExp(`^rgba\\(${reP},${reP},${reP},${reN}\\)$`);
  var reHslPercent = new RegExp(`^hsl\\(${reN},${reP},${reP}\\)$`);
  var reHslaPercent = new RegExp(`^hsla\\(${reN},${reP},${reP},${reN}\\)$`);
  var named = {
    aliceblue: 15792383,
    antiquewhite: 16444375,
    aqua: 65535,
    aquamarine: 8388564,
    azure: 15794175,
    beige: 16119260,
    bisque: 16770244,
    black: 0,
    blanchedalmond: 16772045,
    blue: 255,
    blueviolet: 9055202,
    brown: 10824234,
    burlywood: 14596231,
    cadetblue: 6266528,
    chartreuse: 8388352,
    chocolate: 13789470,
    coral: 16744272,
    cornflowerblue: 6591981,
    cornsilk: 16775388,
    crimson: 14423100,
    cyan: 65535,
    darkblue: 139,
    darkcyan: 35723,
    darkgoldenrod: 12092939,
    darkgray: 11119017,
    darkgreen: 25600,
    darkgrey: 11119017,
    darkkhaki: 12433259,
    darkmagenta: 9109643,
    darkolivegreen: 5597999,
    darkorange: 16747520,
    darkorchid: 10040012,
    darkred: 9109504,
    darksalmon: 15308410,
    darkseagreen: 9419919,
    darkslateblue: 4734347,
    darkslategray: 3100495,
    darkslategrey: 3100495,
    darkturquoise: 52945,
    darkviolet: 9699539,
    deeppink: 16716947,
    deepskyblue: 49151,
    dimgray: 6908265,
    dimgrey: 6908265,
    dodgerblue: 2003199,
    firebrick: 11674146,
    floralwhite: 16775920,
    forestgreen: 2263842,
    fuchsia: 16711935,
    gainsboro: 14474460,
    ghostwhite: 16316671,
    gold: 16766720,
    goldenrod: 14329120,
    gray: 8421504,
    green: 32768,
    greenyellow: 11403055,
    grey: 8421504,
    honeydew: 15794160,
    hotpink: 16738740,
    indianred: 13458524,
    indigo: 4915330,
    ivory: 16777200,
    khaki: 15787660,
    lavender: 15132410,
    lavenderblush: 16773365,
    lawngreen: 8190976,
    lemonchiffon: 16775885,
    lightblue: 11393254,
    lightcoral: 15761536,
    lightcyan: 14745599,
    lightgoldenrodyellow: 16448210,
    lightgray: 13882323,
    lightgreen: 9498256,
    lightgrey: 13882323,
    lightpink: 16758465,
    lightsalmon: 16752762,
    lightseagreen: 2142890,
    lightskyblue: 8900346,
    lightslategray: 7833753,
    lightslategrey: 7833753,
    lightsteelblue: 11584734,
    lightyellow: 16777184,
    lime: 65280,
    limegreen: 3329330,
    linen: 16445670,
    magenta: 16711935,
    maroon: 8388608,
    mediumaquamarine: 6737322,
    mediumblue: 205,
    mediumorchid: 12211667,
    mediumpurple: 9662683,
    mediumseagreen: 3978097,
    mediumslateblue: 8087790,
    mediumspringgreen: 64154,
    mediumturquoise: 4772300,
    mediumvioletred: 13047173,
    midnightblue: 1644912,
    mintcream: 16121850,
    mistyrose: 16770273,
    moccasin: 16770229,
    navajowhite: 16768685,
    navy: 128,
    oldlace: 16643558,
    olive: 8421376,
    olivedrab: 7048739,
    orange: 16753920,
    orangered: 16729344,
    orchid: 14315734,
    palegoldenrod: 15657130,
    palegreen: 10025880,
    paleturquoise: 11529966,
    palevioletred: 14381203,
    papayawhip: 16773077,
    peachpuff: 16767673,
    peru: 13468991,
    pink: 16761035,
    plum: 14524637,
    powderblue: 11591910,
    purple: 8388736,
    rebeccapurple: 6697881,
    red: 16711680,
    rosybrown: 12357519,
    royalblue: 4286945,
    saddlebrown: 9127187,
    salmon: 16416882,
    sandybrown: 16032864,
    seagreen: 3050327,
    seashell: 16774638,
    sienna: 10506797,
    silver: 12632256,
    skyblue: 8900331,
    slateblue: 6970061,
    slategray: 7372944,
    slategrey: 7372944,
    snow: 16775930,
    springgreen: 65407,
    steelblue: 4620980,
    tan: 13808780,
    teal: 32896,
    thistle: 14204888,
    tomato: 16737095,
    turquoise: 4251856,
    violet: 15631086,
    wheat: 16113331,
    white: 16777215,
    whitesmoke: 16119285,
    yellow: 16776960,
    yellowgreen: 10145074
  };
  define_default(Color2, color2, {
    copy(channels) {
      return Object.assign(new this.constructor(), this, channels);
    },
    displayable() {
      return this.rgb().displayable();
    },
    hex: color_formatHex,
    formatHex: color_formatHex,
    formatHex8: color_formatHex8,
    formatHsl: color_formatHsl,
    formatRgb: color_formatRgb,
    toString: color_formatRgb
  });
  function color_formatHex() {
    return this.rgb().formatHex();
  }
  function color_formatHex8() {
    return this.rgb().formatHex8();
  }
  function color_formatHsl() {
    return hslConvert(this).formatHsl();
  }
  function color_formatRgb() {
    return this.rgb().formatRgb();
  }
  function color2(format2) {
    var m, l;
    format2 = (format2 + "").trim().toLowerCase();
    return (m = reHex.exec(format2)) ? (l = m[1].length, m = parseInt(m[1], 16), l === 6 ? rgbn(m) : l === 3 ? new Rgb(m >> 8 & 15 | m >> 4 & 240, m >> 4 & 15 | m & 240, (m & 15) << 4 | m & 15, 1) : l === 8 ? rgba(m >> 24 & 255, m >> 16 & 255, m >> 8 & 255, (m & 255) / 255) : l === 4 ? rgba(m >> 12 & 15 | m >> 8 & 240, m >> 8 & 15 | m >> 4 & 240, m >> 4 & 15 | m & 240, ((m & 15) << 4 | m & 15) / 255) : null) : (m = reRgbInteger.exec(format2)) ? new Rgb(m[1], m[2], m[3], 1) : (m = reRgbPercent.exec(format2)) ? new Rgb(m[1] * 255 / 100, m[2] * 255 / 100, m[3] * 255 / 100, 1) : (m = reRgbaInteger.exec(format2)) ? rgba(m[1], m[2], m[3], m[4]) : (m = reRgbaPercent.exec(format2)) ? rgba(m[1] * 255 / 100, m[2] * 255 / 100, m[3] * 255 / 100, m[4]) : (m = reHslPercent.exec(format2)) ? hsla(m[1], m[2] / 100, m[3] / 100, 1) : (m = reHslaPercent.exec(format2)) ? hsla(m[1], m[2] / 100, m[3] / 100, m[4]) : named.hasOwnProperty(format2) ? rgbn(named[format2]) : format2 === "transparent" ? new Rgb(NaN, NaN, NaN, 0) : null;
  }
  function rgbn(n) {
    return new Rgb(n >> 16 & 255, n >> 8 & 255, n & 255, 1);
  }
  function rgba(r, g, b, a) {
    if (a <= 0)
      r = g = b = NaN;
    return new Rgb(r, g, b, a);
  }
  function rgbConvert(o) {
    if (!(o instanceof Color2))
      o = color2(o);
    if (!o)
      return new Rgb();
    o = o.rgb();
    return new Rgb(o.r, o.g, o.b, o.opacity);
  }
  function rgb(r, g, b, opacity) {
    return arguments.length === 1 ? rgbConvert(r) : new Rgb(r, g, b, opacity == null ? 1 : opacity);
  }
  function Rgb(r, g, b, opacity) {
    this.r = +r;
    this.g = +g;
    this.b = +b;
    this.opacity = +opacity;
  }
  define_default(Rgb, rgb, extend(Color2, {
    brighter(k) {
      k = k == null ? brighter : Math.pow(brighter, k);
      return new Rgb(this.r * k, this.g * k, this.b * k, this.opacity);
    },
    darker(k) {
      k = k == null ? darker : Math.pow(darker, k);
      return new Rgb(this.r * k, this.g * k, this.b * k, this.opacity);
    },
    rgb() {
      return this;
    },
    clamp() {
      return new Rgb(clampi(this.r), clampi(this.g), clampi(this.b), clampa(this.opacity));
    },
    displayable() {
      return -0.5 <= this.r && this.r < 255.5 && (-0.5 <= this.g && this.g < 255.5) && (-0.5 <= this.b && this.b < 255.5) && (0 <= this.opacity && this.opacity <= 1);
    },
    hex: rgb_formatHex,
    formatHex: rgb_formatHex,
    formatHex8: rgb_formatHex8,
    formatRgb: rgb_formatRgb,
    toString: rgb_formatRgb
  }));
  function rgb_formatHex() {
    return `#${hex2(this.r)}${hex2(this.g)}${hex2(this.b)}`;
  }
  function rgb_formatHex8() {
    return `#${hex2(this.r)}${hex2(this.g)}${hex2(this.b)}${hex2((isNaN(this.opacity) ? 1 : this.opacity) * 255)}`;
  }
  function rgb_formatRgb() {
    const a = clampa(this.opacity);
    return `${a === 1 ? "rgb(" : "rgba("}${clampi(this.r)}, ${clampi(this.g)}, ${clampi(this.b)}${a === 1 ? ")" : `, ${a})`}`;
  }
  function clampa(opacity) {
    return isNaN(opacity) ? 1 : Math.max(0, Math.min(1, opacity));
  }
  function clampi(value) {
    return Math.max(0, Math.min(255, Math.round(value) || 0));
  }
  function hex2(value) {
    value = clampi(value);
    return (value < 16 ? "0" : "") + value.toString(16);
  }
  function hsla(h, s, l, a) {
    if (a <= 0)
      h = s = l = NaN;
    else if (l <= 0 || l >= 1)
      h = s = NaN;
    else if (s <= 0)
      h = NaN;
    return new Hsl(h, s, l, a);
  }
  function hslConvert(o) {
    if (o instanceof Hsl)
      return new Hsl(o.h, o.s, o.l, o.opacity);
    if (!(o instanceof Color2))
      o = color2(o);
    if (!o)
      return new Hsl();
    if (o instanceof Hsl)
      return o;
    o = o.rgb();
    var r = o.r / 255, g = o.g / 255, b = o.b / 255, min3 = Math.min(r, g, b), max3 = Math.max(r, g, b), h = NaN, s = max3 - min3, l = (max3 + min3) / 2;
    if (s) {
      if (r === max3)
        h = (g - b) / s + (g < b) * 6;
      else if (g === max3)
        h = (b - r) / s + 2;
      else
        h = (r - g) / s + 4;
      s /= l < 0.5 ? max3 + min3 : 2 - max3 - min3;
      h *= 60;
    } else {
      s = l > 0 && l < 1 ? 0 : h;
    }
    return new Hsl(h, s, l, o.opacity);
  }
  function hsl(h, s, l, opacity) {
    return arguments.length === 1 ? hslConvert(h) : new Hsl(h, s, l, opacity == null ? 1 : opacity);
  }
  function Hsl(h, s, l, opacity) {
    this.h = +h;
    this.s = +s;
    this.l = +l;
    this.opacity = +opacity;
  }
  define_default(Hsl, hsl, extend(Color2, {
    brighter(k) {
      k = k == null ? brighter : Math.pow(brighter, k);
      return new Hsl(this.h, this.s, this.l * k, this.opacity);
    },
    darker(k) {
      k = k == null ? darker : Math.pow(darker, k);
      return new Hsl(this.h, this.s, this.l * k, this.opacity);
    },
    rgb() {
      var h = this.h % 360 + (this.h < 0) * 360, s = isNaN(h) || isNaN(this.s) ? 0 : this.s, l = this.l, m2 = l + (l < 0.5 ? l : 1 - l) * s, m1 = 2 * l - m2;
      return new Rgb(
        hsl2rgb2(h >= 240 ? h - 240 : h + 120, m1, m2),
        hsl2rgb2(h, m1, m2),
        hsl2rgb2(h < 120 ? h + 240 : h - 120, m1, m2),
        this.opacity
      );
    },
    clamp() {
      return new Hsl(clamph(this.h), clampt(this.s), clampt(this.l), clampa(this.opacity));
    },
    displayable() {
      return (0 <= this.s && this.s <= 1 || isNaN(this.s)) && (0 <= this.l && this.l <= 1) && (0 <= this.opacity && this.opacity <= 1);
    },
    formatHsl() {
      const a = clampa(this.opacity);
      return `${a === 1 ? "hsl(" : "hsla("}${clamph(this.h)}, ${clampt(this.s) * 100}%, ${clampt(this.l) * 100}%${a === 1 ? ")" : `, ${a})`}`;
    }
  }));
  function clamph(value) {
    value = (value || 0) % 360;
    return value < 0 ? value + 360 : value;
  }
  function clampt(value) {
    return Math.max(0, Math.min(1, value || 0));
  }
  function hsl2rgb2(h, m1, m2) {
    return (h < 60 ? m1 + (m2 - m1) * h / 60 : h < 180 ? m2 : h < 240 ? m1 + (m2 - m1) * (240 - h) / 60 : m1) * 255;
  }

  // node_modules/d3-interpolate/src/basis.js
  function basis(t12, v0, v1, v2, v3) {
    var t2 = t12 * t12, t3 = t2 * t12;
    return ((1 - 3 * t12 + 3 * t2 - t3) * v0 + (4 - 6 * t2 + 3 * t3) * v1 + (1 + 3 * t12 + 3 * t2 - 3 * t3) * v2 + t3 * v3) / 6;
  }
  function basis_default(values) {
    var n = values.length - 1;
    return function(t) {
      var i = t <= 0 ? t = 0 : t >= 1 ? (t = 1, n - 1) : Math.floor(t * n), v1 = values[i], v2 = values[i + 1], v0 = i > 0 ? values[i - 1] : 2 * v1 - v2, v3 = i < n - 1 ? values[i + 2] : 2 * v2 - v1;
      return basis((t - i / n) * n, v0, v1, v2, v3);
    };
  }

  // node_modules/d3-interpolate/src/basisClosed.js
  function basisClosed_default(values) {
    var n = values.length;
    return function(t) {
      var i = Math.floor(((t %= 1) < 0 ? ++t : t) * n), v0 = values[(i + n - 1) % n], v1 = values[i % n], v2 = values[(i + 1) % n], v3 = values[(i + 2) % n];
      return basis((t - i / n) * n, v0, v1, v2, v3);
    };
  }

  // node_modules/d3-interpolate/src/constant.js
  var constant_default2 = (x) => () => x;

  // node_modules/d3-interpolate/src/color.js
  function linear(a, d) {
    return function(t) {
      return a + t * d;
    };
  }
  function exponential(a, b, y) {
    return a = Math.pow(a, y), b = Math.pow(b, y) - a, y = 1 / y, function(t) {
      return Math.pow(a + t * b, y);
    };
  }
  function gamma(y) {
    return (y = +y) === 1 ? nogamma : function(a, b) {
      return b - a ? exponential(a, b, y) : constant_default2(isNaN(a) ? b : a);
    };
  }
  function nogamma(a, b) {
    var d = b - a;
    return d ? linear(a, d) : constant_default2(isNaN(a) ? b : a);
  }

  // node_modules/d3-interpolate/src/rgb.js
  var rgb_default = function rgbGamma(y) {
    var color3 = gamma(y);
    function rgb2(start2, end) {
      var r = color3((start2 = rgb(start2)).r, (end = rgb(end)).r), g = color3(start2.g, end.g), b = color3(start2.b, end.b), opacity = nogamma(start2.opacity, end.opacity);
      return function(t) {
        start2.r = r(t);
        start2.g = g(t);
        start2.b = b(t);
        start2.opacity = opacity(t);
        return start2 + "";
      };
    }
    rgb2.gamma = rgbGamma;
    return rgb2;
  }(1);
  function rgbSpline(spline) {
    return function(colors2) {
      var n = colors2.length, r = new Array(n), g = new Array(n), b = new Array(n), i, color3;
      for (i = 0; i < n; ++i) {
        color3 = rgb(colors2[i]);
        r[i] = color3.r || 0;
        g[i] = color3.g || 0;
        b[i] = color3.b || 0;
      }
      r = spline(r);
      g = spline(g);
      b = spline(b);
      color3.opacity = 1;
      return function(t) {
        color3.r = r(t);
        color3.g = g(t);
        color3.b = b(t);
        return color3 + "";
      };
    };
  }
  var rgbBasis = rgbSpline(basis_default);
  var rgbBasisClosed = rgbSpline(basisClosed_default);

  // node_modules/d3-interpolate/src/number.js
  function number_default(a, b) {
    return a = +a, b = +b, function(t) {
      return a * (1 - t) + b * t;
    };
  }

  // node_modules/d3-interpolate/src/string.js
  var reA = /[-+]?(?:\d+\.?\d*|\.?\d+)(?:[eE][-+]?\d+)?/g;
  var reB = new RegExp(reA.source, "g");
  function zero(b) {
    return function() {
      return b;
    };
  }
  function one(b) {
    return function(t) {
      return b(t) + "";
    };
  }
  function string_default(a, b) {
    var bi = reA.lastIndex = reB.lastIndex = 0, am, bm, bs, i = -1, s = [], q = [];
    a = a + "", b = b + "";
    while ((am = reA.exec(a)) && (bm = reB.exec(b))) {
      if ((bs = bm.index) > bi) {
        bs = b.slice(bi, bs);
        if (s[i])
          s[i] += bs;
        else
          s[++i] = bs;
      }
      if ((am = am[0]) === (bm = bm[0])) {
        if (s[i])
          s[i] += bm;
        else
          s[++i] = bm;
      } else {
        s[++i] = null;
        q.push({ i, x: number_default(am, bm) });
      }
      bi = reB.lastIndex;
    }
    if (bi < b.length) {
      bs = b.slice(bi);
      if (s[i])
        s[i] += bs;
      else
        s[++i] = bs;
    }
    return s.length < 2 ? q[0] ? one(q[0].x) : zero(b) : (b = q.length, function(t) {
      for (var i2 = 0, o; i2 < b; ++i2)
        s[(o = q[i2]).i] = o.x(t);
      return s.join("");
    });
  }

  // node_modules/d3-interpolate/src/transform/decompose.js
  var degrees = 180 / Math.PI;
  var identity2 = {
    translateX: 0,
    translateY: 0,
    rotate: 0,
    skewX: 0,
    scaleX: 1,
    scaleY: 1
  };
  function decompose_default(a, b, c, d, e, f) {
    var scaleX, scaleY, skewX;
    if (scaleX = Math.sqrt(a * a + b * b))
      a /= scaleX, b /= scaleX;
    if (skewX = a * c + b * d)
      c -= a * skewX, d -= b * skewX;
    if (scaleY = Math.sqrt(c * c + d * d))
      c /= scaleY, d /= scaleY, skewX /= scaleY;
    if (a * d < b * c)
      a = -a, b = -b, skewX = -skewX, scaleX = -scaleX;
    return {
      translateX: e,
      translateY: f,
      rotate: Math.atan2(b, a) * degrees,
      skewX: Math.atan(skewX) * degrees,
      scaleX,
      scaleY
    };
  }

  // node_modules/d3-interpolate/src/transform/parse.js
  var svgNode;
  function parseCss(value) {
    const m = new (typeof DOMMatrix === "function" ? DOMMatrix : WebKitCSSMatrix)(value + "");
    return m.isIdentity ? identity2 : decompose_default(m.a, m.b, m.c, m.d, m.e, m.f);
  }
  function parseSvg(value) {
    if (value == null)
      return identity2;
    if (!svgNode)
      svgNode = document.createElementNS("http://www.w3.org/2000/svg", "g");
    svgNode.setAttribute("transform", value);
    if (!(value = svgNode.transform.baseVal.consolidate()))
      return identity2;
    value = value.matrix;
    return decompose_default(value.a, value.b, value.c, value.d, value.e, value.f);
  }

  // node_modules/d3-interpolate/src/transform/index.js
  function interpolateTransform(parse2, pxComma, pxParen, degParen) {
    function pop(s) {
      return s.length ? s.pop() + " " : "";
    }
    function translate2(xa, ya, xb, yb, s, q) {
      if (xa !== xb || ya !== yb) {
        var i = s.push("translate(", null, pxComma, null, pxParen);
        q.push({ i: i - 4, x: number_default(xa, xb) }, { i: i - 2, x: number_default(ya, yb) });
      } else if (xb || yb) {
        s.push("translate(" + xb + pxComma + yb + pxParen);
      }
    }
    function rotate2(a, b, s, q) {
      if (a !== b) {
        if (a - b > 180)
          b += 360;
        else if (b - a > 180)
          a += 360;
        q.push({ i: s.push(pop(s) + "rotate(", null, degParen) - 2, x: number_default(a, b) });
      } else if (b) {
        s.push(pop(s) + "rotate(" + b + degParen);
      }
    }
    function skewX(a, b, s, q) {
      if (a !== b) {
        q.push({ i: s.push(pop(s) + "skewX(", null, degParen) - 2, x: number_default(a, b) });
      } else if (b) {
        s.push(pop(s) + "skewX(" + b + degParen);
      }
    }
    function scale(xa, ya, xb, yb, s, q) {
      if (xa !== xb || ya !== yb) {
        var i = s.push(pop(s) + "scale(", null, ",", null, ")");
        q.push({ i: i - 4, x: number_default(xa, xb) }, { i: i - 2, x: number_default(ya, yb) });
      } else if (xb !== 1 || yb !== 1) {
        s.push(pop(s) + "scale(" + xb + "," + yb + ")");
      }
    }
    return function(a, b) {
      var s = [], q = [];
      a = parse2(a), b = parse2(b);
      translate2(a.translateX, a.translateY, b.translateX, b.translateY, s, q);
      rotate2(a.rotate, b.rotate, s, q);
      skewX(a.skewX, b.skewX, s, q);
      scale(a.scaleX, a.scaleY, b.scaleX, b.scaleY, s, q);
      a = b = null;
      return function(t) {
        var i = -1, n = q.length, o;
        while (++i < n)
          s[(o = q[i]).i] = o.x(t);
        return s.join("");
      };
    };
  }
  var interpolateTransformCss = interpolateTransform(parseCss, "px, ", "px)", "deg)");
  var interpolateTransformSvg = interpolateTransform(parseSvg, ", ", ")", ")");

  // node_modules/d3-timer/src/timer.js
  var frame = 0;
  var timeout = 0;
  var interval = 0;
  var pokeDelay = 1e3;
  var taskHead;
  var taskTail;
  var clockLast = 0;
  var clockNow = 0;
  var clockSkew = 0;
  var clock = typeof performance === "object" && performance.now ? performance : Date;
  var setFrame = typeof window === "object" && window.requestAnimationFrame ? window.requestAnimationFrame.bind(window) : function(f) {
    setTimeout(f, 17);
  };
  function now() {
    return clockNow || (setFrame(clearNow), clockNow = clock.now() + clockSkew);
  }
  function clearNow() {
    clockNow = 0;
  }
  function Timer() {
    this._call = this._time = this._next = null;
  }
  Timer.prototype = timer.prototype = {
    constructor: Timer,
    restart: function(callback2, delay, time) {
      if (typeof callback2 !== "function")
        throw new TypeError("callback is not a function");
      time = (time == null ? now() : +time) + (delay == null ? 0 : +delay);
      if (!this._next && taskTail !== this) {
        if (taskTail)
          taskTail._next = this;
        else
          taskHead = this;
        taskTail = this;
      }
      this._call = callback2;
      this._time = time;
      sleep();
    },
    stop: function() {
      if (this._call) {
        this._call = null;
        this._time = Infinity;
        sleep();
      }
    }
  };
  function timer(callback2, delay, time) {
    var t = new Timer();
    t.restart(callback2, delay, time);
    return t;
  }
  function timerFlush() {
    now();
    ++frame;
    var t = taskHead, e;
    while (t) {
      if ((e = clockNow - t._time) >= 0)
        t._call.call(void 0, e);
      t = t._next;
    }
    --frame;
  }
  function wake() {
    clockNow = (clockLast = clock.now()) + clockSkew;
    frame = timeout = 0;
    try {
      timerFlush();
    } finally {
      frame = 0;
      nap();
      clockNow = 0;
    }
  }
  function poke() {
    var now2 = clock.now(), delay = now2 - clockLast;
    if (delay > pokeDelay)
      clockSkew -= delay, clockLast = now2;
  }
  function nap() {
    var t02, t12 = taskHead, t2, time = Infinity;
    while (t12) {
      if (t12._call) {
        if (time > t12._time)
          time = t12._time;
        t02 = t12, t12 = t12._next;
      } else {
        t2 = t12._next, t12._next = null;
        t12 = t02 ? t02._next = t2 : taskHead = t2;
      }
    }
    taskTail = t02;
    sleep(time);
  }
  function sleep(time) {
    if (frame)
      return;
    if (timeout)
      timeout = clearTimeout(timeout);
    var delay = time - clockNow;
    if (delay > 24) {
      if (time < Infinity)
        timeout = setTimeout(wake, time - clock.now() - clockSkew);
      if (interval)
        interval = clearInterval(interval);
    } else {
      if (!interval)
        clockLast = clock.now(), interval = setInterval(poke, pokeDelay);
      frame = 1, setFrame(wake);
    }
  }

  // node_modules/d3-timer/src/timeout.js
  function timeout_default(callback2, delay, time) {
    var t = new Timer();
    delay = delay == null ? 0 : +delay;
    t.restart((elapsed) => {
      t.stop();
      callback2(elapsed + delay);
    }, delay, time);
    return t;
  }

  // node_modules/d3-transition/src/transition/schedule.js
  var emptyOn = dispatch_default("start", "end", "cancel", "interrupt");
  var emptyTween = [];
  var CREATED = 0;
  var SCHEDULED = 1;
  var STARTING = 2;
  var STARTED = 3;
  var RUNNING = 4;
  var ENDING = 5;
  var ENDED = 6;
  function schedule_default(node, name, id2, index3, group2, timing) {
    var schedules = node.__transition;
    if (!schedules)
      node.__transition = {};
    else if (id2 in schedules)
      return;
    create(node, id2, {
      name,
      index: index3,
      group: group2,
      on: emptyOn,
      tween: emptyTween,
      time: timing.time,
      delay: timing.delay,
      duration: timing.duration,
      ease: timing.ease,
      timer: null,
      state: CREATED
    });
  }
  function init(node, id2) {
    var schedule = get2(node, id2);
    if (schedule.state > CREATED)
      throw new Error("too late; already scheduled");
    return schedule;
  }
  function set3(node, id2) {
    var schedule = get2(node, id2);
    if (schedule.state > STARTED)
      throw new Error("too late; already running");
    return schedule;
  }
  function get2(node, id2) {
    var schedule = node.__transition;
    if (!schedule || !(schedule = schedule[id2]))
      throw new Error("transition not found");
    return schedule;
  }
  function create(node, id2, self) {
    var schedules = node.__transition, tween;
    schedules[id2] = self;
    self.timer = timer(schedule, 0, self.time);
    function schedule(elapsed) {
      self.state = SCHEDULED;
      self.timer.restart(start2, self.delay, self.time);
      if (self.delay <= elapsed)
        start2(elapsed - self.delay);
    }
    function start2(elapsed) {
      var i, j, n, o;
      if (self.state !== SCHEDULED)
        return stop();
      for (i in schedules) {
        o = schedules[i];
        if (o.name !== self.name)
          continue;
        if (o.state === STARTED)
          return timeout_default(start2);
        if (o.state === RUNNING) {
          o.state = ENDED;
          o.timer.stop();
          o.on.call("interrupt", node, node.__data__, o.index, o.group);
          delete schedules[i];
        } else if (+i < id2) {
          o.state = ENDED;
          o.timer.stop();
          o.on.call("cancel", node, node.__data__, o.index, o.group);
          delete schedules[i];
        }
      }
      timeout_default(function() {
        if (self.state === STARTED) {
          self.state = RUNNING;
          self.timer.restart(tick, self.delay, self.time);
          tick(elapsed);
        }
      });
      self.state = STARTING;
      self.on.call("start", node, node.__data__, self.index, self.group);
      if (self.state !== STARTING)
        return;
      self.state = STARTED;
      tween = new Array(n = self.tween.length);
      for (i = 0, j = -1; i < n; ++i) {
        if (o = self.tween[i].value.call(node, node.__data__, self.index, self.group)) {
          tween[++j] = o;
        }
      }
      tween.length = j + 1;
    }
    function tick(elapsed) {
      var t = elapsed < self.duration ? self.ease.call(null, elapsed / self.duration) : (self.timer.restart(stop), self.state = ENDING, 1), i = -1, n = tween.length;
      while (++i < n) {
        tween[i].call(node, t);
      }
      if (self.state === ENDING) {
        self.on.call("end", node, node.__data__, self.index, self.group);
        stop();
      }
    }
    function stop() {
      self.state = ENDED;
      self.timer.stop();
      delete schedules[id2];
      for (var i in schedules)
        return;
      delete node.__transition;
    }
  }

  // node_modules/d3-transition/src/interrupt.js
  function interrupt_default(node, name) {
    var schedules = node.__transition, schedule, active, empty2 = true, i;
    if (!schedules)
      return;
    name = name == null ? null : name + "";
    for (i in schedules) {
      if ((schedule = schedules[i]).name !== name) {
        empty2 = false;
        continue;
      }
      active = schedule.state > STARTING && schedule.state < ENDING;
      schedule.state = ENDED;
      schedule.timer.stop();
      schedule.on.call(active ? "interrupt" : "cancel", node, node.__data__, schedule.index, schedule.group);
      delete schedules[i];
    }
    if (empty2)
      delete node.__transition;
  }

  // node_modules/d3-transition/src/selection/interrupt.js
  function interrupt_default2(name) {
    return this.each(function() {
      interrupt_default(this, name);
    });
  }

  // node_modules/d3-transition/src/transition/tween.js
  function tweenRemove(id2, name) {
    var tween0, tween1;
    return function() {
      var schedule = set3(this, id2), tween = schedule.tween;
      if (tween !== tween0) {
        tween1 = tween0 = tween;
        for (var i = 0, n = tween1.length; i < n; ++i) {
          if (tween1[i].name === name) {
            tween1 = tween1.slice();
            tween1.splice(i, 1);
            break;
          }
        }
      }
      schedule.tween = tween1;
    };
  }
  function tweenFunction(id2, name, value) {
    var tween0, tween1;
    if (typeof value !== "function")
      throw new Error();
    return function() {
      var schedule = set3(this, id2), tween = schedule.tween;
      if (tween !== tween0) {
        tween1 = (tween0 = tween).slice();
        for (var t = { name, value }, i = 0, n = tween1.length; i < n; ++i) {
          if (tween1[i].name === name) {
            tween1[i] = t;
            break;
          }
        }
        if (i === n)
          tween1.push(t);
      }
      schedule.tween = tween1;
    };
  }
  function tween_default(name, value) {
    var id2 = this._id;
    name += "";
    if (arguments.length < 2) {
      var tween = get2(this.node(), id2).tween;
      for (var i = 0, n = tween.length, t; i < n; ++i) {
        if ((t = tween[i]).name === name) {
          return t.value;
        }
      }
      return null;
    }
    return this.each((value == null ? tweenRemove : tweenFunction)(id2, name, value));
  }
  function tweenValue(transition2, name, value) {
    var id2 = transition2._id;
    transition2.each(function() {
      var schedule = set3(this, id2);
      (schedule.value || (schedule.value = {}))[name] = value.apply(this, arguments);
    });
    return function(node) {
      return get2(node, id2).value[name];
    };
  }

  // node_modules/d3-transition/src/transition/interpolate.js
  function interpolate_default(a, b) {
    var c;
    return (typeof b === "number" ? number_default : b instanceof color2 ? rgb_default : (c = color2(b)) ? (b = c, rgb_default) : string_default)(a, b);
  }

  // node_modules/d3-transition/src/transition/attr.js
  function attrRemove2(name) {
    return function() {
      this.removeAttribute(name);
    };
  }
  function attrRemoveNS2(fullname) {
    return function() {
      this.removeAttributeNS(fullname.space, fullname.local);
    };
  }
  function attrConstant2(name, interpolate3, value1) {
    var string00, string1 = value1 + "", interpolate0;
    return function() {
      var string0 = this.getAttribute(name);
      return string0 === string1 ? null : string0 === string00 ? interpolate0 : interpolate0 = interpolate3(string00 = string0, value1);
    };
  }
  function attrConstantNS2(fullname, interpolate3, value1) {
    var string00, string1 = value1 + "", interpolate0;
    return function() {
      var string0 = this.getAttributeNS(fullname.space, fullname.local);
      return string0 === string1 ? null : string0 === string00 ? interpolate0 : interpolate0 = interpolate3(string00 = string0, value1);
    };
  }
  function attrFunction2(name, interpolate3, value) {
    var string00, string10, interpolate0;
    return function() {
      var string0, value1 = value(this), string1;
      if (value1 == null)
        return void this.removeAttribute(name);
      string0 = this.getAttribute(name);
      string1 = value1 + "";
      return string0 === string1 ? null : string0 === string00 && string1 === string10 ? interpolate0 : (string10 = string1, interpolate0 = interpolate3(string00 = string0, value1));
    };
  }
  function attrFunctionNS2(fullname, interpolate3, value) {
    var string00, string10, interpolate0;
    return function() {
      var string0, value1 = value(this), string1;
      if (value1 == null)
        return void this.removeAttributeNS(fullname.space, fullname.local);
      string0 = this.getAttributeNS(fullname.space, fullname.local);
      string1 = value1 + "";
      return string0 === string1 ? null : string0 === string00 && string1 === string10 ? interpolate0 : (string10 = string1, interpolate0 = interpolate3(string00 = string0, value1));
    };
  }
  function attr_default2(name, value) {
    var fullname = namespace_default(name), i = fullname === "transform" ? interpolateTransformSvg : interpolate_default;
    return this.attrTween(name, typeof value === "function" ? (fullname.local ? attrFunctionNS2 : attrFunction2)(fullname, i, tweenValue(this, "attr." + name, value)) : value == null ? (fullname.local ? attrRemoveNS2 : attrRemove2)(fullname) : (fullname.local ? attrConstantNS2 : attrConstant2)(fullname, i, value));
  }

  // node_modules/d3-transition/src/transition/attrTween.js
  function attrInterpolate(name, i) {
    return function(t) {
      this.setAttribute(name, i.call(this, t));
    };
  }
  function attrInterpolateNS(fullname, i) {
    return function(t) {
      this.setAttributeNS(fullname.space, fullname.local, i.call(this, t));
    };
  }
  function attrTweenNS(fullname, value) {
    var t02, i0;
    function tween() {
      var i = value.apply(this, arguments);
      if (i !== i0)
        t02 = (i0 = i) && attrInterpolateNS(fullname, i);
      return t02;
    }
    tween._value = value;
    return tween;
  }
  function attrTween(name, value) {
    var t02, i0;
    function tween() {
      var i = value.apply(this, arguments);
      if (i !== i0)
        t02 = (i0 = i) && attrInterpolate(name, i);
      return t02;
    }
    tween._value = value;
    return tween;
  }
  function attrTween_default(name, value) {
    var key = "attr." + name;
    if (arguments.length < 2)
      return (key = this.tween(key)) && key._value;
    if (value == null)
      return this.tween(key, null);
    if (typeof value !== "function")
      throw new Error();
    var fullname = namespace_default(name);
    return this.tween(key, (fullname.local ? attrTweenNS : attrTween)(fullname, value));
  }

  // node_modules/d3-transition/src/transition/delay.js
  function delayFunction(id2, value) {
    return function() {
      init(this, id2).delay = +value.apply(this, arguments);
    };
  }
  function delayConstant(id2, value) {
    return value = +value, function() {
      init(this, id2).delay = value;
    };
  }
  function delay_default(value) {
    var id2 = this._id;
    return arguments.length ? this.each((typeof value === "function" ? delayFunction : delayConstant)(id2, value)) : get2(this.node(), id2).delay;
  }

  // node_modules/d3-transition/src/transition/duration.js
  function durationFunction(id2, value) {
    return function() {
      set3(this, id2).duration = +value.apply(this, arguments);
    };
  }
  function durationConstant(id2, value) {
    return value = +value, function() {
      set3(this, id2).duration = value;
    };
  }
  function duration_default(value) {
    var id2 = this._id;
    return arguments.length ? this.each((typeof value === "function" ? durationFunction : durationConstant)(id2, value)) : get2(this.node(), id2).duration;
  }

  // node_modules/d3-transition/src/transition/ease.js
  function easeConstant(id2, value) {
    if (typeof value !== "function")
      throw new Error();
    return function() {
      set3(this, id2).ease = value;
    };
  }
  function ease_default(value) {
    var id2 = this._id;
    return arguments.length ? this.each(easeConstant(id2, value)) : get2(this.node(), id2).ease;
  }

  // node_modules/d3-transition/src/transition/easeVarying.js
  function easeVarying(id2, value) {
    return function() {
      var v = value.apply(this, arguments);
      if (typeof v !== "function")
        throw new Error();
      set3(this, id2).ease = v;
    };
  }
  function easeVarying_default(value) {
    if (typeof value !== "function")
      throw new Error();
    return this.each(easeVarying(this._id, value));
  }

  // node_modules/d3-transition/src/transition/filter.js
  function filter_default2(match) {
    if (typeof match !== "function")
      match = matcher_default(match);
    for (var groups2 = this._groups, m = groups2.length, subgroups = new Array(m), j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, subgroup = subgroups[j] = [], node, i = 0; i < n; ++i) {
        if ((node = group2[i]) && match.call(node, node.__data__, i, group2)) {
          subgroup.push(node);
        }
      }
    }
    return new Transition(subgroups, this._parents, this._name, this._id);
  }

  // node_modules/d3-transition/src/transition/merge.js
  function merge_default2(transition2) {
    if (transition2._id !== this._id)
      throw new Error();
    for (var groups0 = this._groups, groups1 = transition2._groups, m0 = groups0.length, m1 = groups1.length, m = Math.min(m0, m1), merges = new Array(m0), j = 0; j < m; ++j) {
      for (var group0 = groups0[j], group1 = groups1[j], n = group0.length, merge2 = merges[j] = new Array(n), node, i = 0; i < n; ++i) {
        if (node = group0[i] || group1[i]) {
          merge2[i] = node;
        }
      }
    }
    for (; j < m0; ++j) {
      merges[j] = groups0[j];
    }
    return new Transition(merges, this._parents, this._name, this._id);
  }

  // node_modules/d3-transition/src/transition/on.js
  function start(name) {
    return (name + "").trim().split(/^|\s+/).every(function(t) {
      var i = t.indexOf(".");
      if (i >= 0)
        t = t.slice(0, i);
      return !t || t === "start";
    });
  }
  function onFunction(id2, name, listener) {
    var on0, on1, sit = start(name) ? init : set3;
    return function() {
      var schedule = sit(this, id2), on = schedule.on;
      if (on !== on0)
        (on1 = (on0 = on).copy()).on(name, listener);
      schedule.on = on1;
    };
  }
  function on_default2(name, listener) {
    var id2 = this._id;
    return arguments.length < 2 ? get2(this.node(), id2).on.on(name) : this.each(onFunction(id2, name, listener));
  }

  // node_modules/d3-transition/src/transition/remove.js
  function removeFunction(id2) {
    return function() {
      var parent = this.parentNode;
      for (var i in this.__transition)
        if (+i !== id2)
          return;
      if (parent)
        parent.removeChild(this);
    };
  }
  function remove_default2() {
    return this.on("end.remove", removeFunction(this._id));
  }

  // node_modules/d3-transition/src/transition/select.js
  function select_default2(select) {
    var name = this._name, id2 = this._id;
    if (typeof select !== "function")
      select = selector_default(select);
    for (var groups2 = this._groups, m = groups2.length, subgroups = new Array(m), j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, subgroup = subgroups[j] = new Array(n), node, subnode, i = 0; i < n; ++i) {
        if ((node = group2[i]) && (subnode = select.call(node, node.__data__, i, group2))) {
          if ("__data__" in node)
            subnode.__data__ = node.__data__;
          subgroup[i] = subnode;
          schedule_default(subgroup[i], name, id2, i, subgroup, get2(node, id2));
        }
      }
    }
    return new Transition(subgroups, this._parents, name, id2);
  }

  // node_modules/d3-transition/src/transition/selectAll.js
  function selectAll_default2(select) {
    var name = this._name, id2 = this._id;
    if (typeof select !== "function")
      select = selectorAll_default(select);
    for (var groups2 = this._groups, m = groups2.length, subgroups = [], parents = [], j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, node, i = 0; i < n; ++i) {
        if (node = group2[i]) {
          for (var children2 = select.call(node, node.__data__, i, group2), child, inherit2 = get2(node, id2), k = 0, l = children2.length; k < l; ++k) {
            if (child = children2[k]) {
              schedule_default(child, name, id2, k, children2, inherit2);
            }
          }
          subgroups.push(children2);
          parents.push(node);
        }
      }
    }
    return new Transition(subgroups, parents, name, id2);
  }

  // node_modules/d3-transition/src/transition/selection.js
  var Selection2 = selection_default.prototype.constructor;
  function selection_default2() {
    return new Selection2(this._groups, this._parents);
  }

  // node_modules/d3-transition/src/transition/style.js
  function styleNull(name, interpolate3) {
    var string00, string10, interpolate0;
    return function() {
      var string0 = styleValue(this, name), string1 = (this.style.removeProperty(name), styleValue(this, name));
      return string0 === string1 ? null : string0 === string00 && string1 === string10 ? interpolate0 : interpolate0 = interpolate3(string00 = string0, string10 = string1);
    };
  }
  function styleRemove2(name) {
    return function() {
      this.style.removeProperty(name);
    };
  }
  function styleConstant2(name, interpolate3, value1) {
    var string00, string1 = value1 + "", interpolate0;
    return function() {
      var string0 = styleValue(this, name);
      return string0 === string1 ? null : string0 === string00 ? interpolate0 : interpolate0 = interpolate3(string00 = string0, value1);
    };
  }
  function styleFunction2(name, interpolate3, value) {
    var string00, string10, interpolate0;
    return function() {
      var string0 = styleValue(this, name), value1 = value(this), string1 = value1 + "";
      if (value1 == null)
        string1 = value1 = (this.style.removeProperty(name), styleValue(this, name));
      return string0 === string1 ? null : string0 === string00 && string1 === string10 ? interpolate0 : (string10 = string1, interpolate0 = interpolate3(string00 = string0, value1));
    };
  }
  function styleMaybeRemove(id2, name) {
    var on0, on1, listener0, key = "style." + name, event = "end." + key, remove2;
    return function() {
      var schedule = set3(this, id2), on = schedule.on, listener = schedule.value[key] == null ? remove2 || (remove2 = styleRemove2(name)) : void 0;
      if (on !== on0 || listener0 !== listener)
        (on1 = (on0 = on).copy()).on(event, listener0 = listener);
      schedule.on = on1;
    };
  }
  function style_default2(name, value, priority) {
    var i = (name += "") === "transform" ? interpolateTransformCss : interpolate_default;
    return value == null ? this.styleTween(name, styleNull(name, i)).on("end.style." + name, styleRemove2(name)) : typeof value === "function" ? this.styleTween(name, styleFunction2(name, i, tweenValue(this, "style." + name, value))).each(styleMaybeRemove(this._id, name)) : this.styleTween(name, styleConstant2(name, i, value), priority).on("end.style." + name, null);
  }

  // node_modules/d3-transition/src/transition/styleTween.js
  function styleInterpolate(name, i, priority) {
    return function(t) {
      this.style.setProperty(name, i.call(this, t), priority);
    };
  }
  function styleTween(name, value, priority) {
    var t, i0;
    function tween() {
      var i = value.apply(this, arguments);
      if (i !== i0)
        t = (i0 = i) && styleInterpolate(name, i, priority);
      return t;
    }
    tween._value = value;
    return tween;
  }
  function styleTween_default(name, value, priority) {
    var key = "style." + (name += "");
    if (arguments.length < 2)
      return (key = this.tween(key)) && key._value;
    if (value == null)
      return this.tween(key, null);
    if (typeof value !== "function")
      throw new Error();
    return this.tween(key, styleTween(name, value, priority == null ? "" : priority));
  }

  // node_modules/d3-transition/src/transition/text.js
  function textConstant2(value) {
    return function() {
      this.textContent = value;
    };
  }
  function textFunction2(value) {
    return function() {
      var value1 = value(this);
      this.textContent = value1 == null ? "" : value1;
    };
  }
  function text_default2(value) {
    return this.tween("text", typeof value === "function" ? textFunction2(tweenValue(this, "text", value)) : textConstant2(value == null ? "" : value + ""));
  }

  // node_modules/d3-transition/src/transition/textTween.js
  function textInterpolate(i) {
    return function(t) {
      this.textContent = i.call(this, t);
    };
  }
  function textTween(value) {
    var t02, i0;
    function tween() {
      var i = value.apply(this, arguments);
      if (i !== i0)
        t02 = (i0 = i) && textInterpolate(i);
      return t02;
    }
    tween._value = value;
    return tween;
  }
  function textTween_default(value) {
    var key = "text";
    if (arguments.length < 1)
      return (key = this.tween(key)) && key._value;
    if (value == null)
      return this.tween(key, null);
    if (typeof value !== "function")
      throw new Error();
    return this.tween(key, textTween(value));
  }

  // node_modules/d3-transition/src/transition/transition.js
  function transition_default() {
    var name = this._name, id0 = this._id, id1 = newId();
    for (var groups2 = this._groups, m = groups2.length, j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, node, i = 0; i < n; ++i) {
        if (node = group2[i]) {
          var inherit2 = get2(node, id0);
          schedule_default(node, name, id1, i, group2, {
            time: inherit2.time + inherit2.delay + inherit2.duration,
            delay: 0,
            duration: inherit2.duration,
            ease: inherit2.ease
          });
        }
      }
    }
    return new Transition(groups2, this._parents, name, id1);
  }

  // node_modules/d3-transition/src/transition/end.js
  function end_default() {
    var on0, on1, that = this, id2 = that._id, size = that.size();
    return new Promise(function(resolve2, reject) {
      var cancel = { value: reject }, end = { value: function() {
        if (--size === 0)
          resolve2();
      } };
      that.each(function() {
        var schedule = set3(this, id2), on = schedule.on;
        if (on !== on0) {
          on1 = (on0 = on).copy();
          on1._.cancel.push(cancel);
          on1._.interrupt.push(cancel);
          on1._.end.push(end);
        }
        schedule.on = on1;
      });
      if (size === 0)
        resolve2();
    });
  }

  // node_modules/d3-transition/src/transition/index.js
  var id = 0;
  function Transition(groups2, parents, name, id2) {
    this._groups = groups2;
    this._parents = parents;
    this._name = name;
    this._id = id2;
  }
  function transition(name) {
    return selection_default().transition(name);
  }
  function newId() {
    return ++id;
  }
  var selection_prototype = selection_default.prototype;
  Transition.prototype = transition.prototype = {
    constructor: Transition,
    select: select_default2,
    selectAll: selectAll_default2,
    selectChild: selection_prototype.selectChild,
    selectChildren: selection_prototype.selectChildren,
    filter: filter_default2,
    merge: merge_default2,
    selection: selection_default2,
    transition: transition_default,
    call: selection_prototype.call,
    nodes: selection_prototype.nodes,
    node: selection_prototype.node,
    size: selection_prototype.size,
    empty: selection_prototype.empty,
    each: selection_prototype.each,
    on: on_default2,
    attr: attr_default2,
    attrTween: attrTween_default,
    style: style_default2,
    styleTween: styleTween_default,
    text: text_default2,
    textTween: textTween_default,
    remove: remove_default2,
    tween: tween_default,
    delay: delay_default,
    duration: duration_default,
    ease: ease_default,
    easeVarying: easeVarying_default,
    end: end_default,
    [Symbol.iterator]: selection_prototype[Symbol.iterator]
  };

  // node_modules/d3-ease/src/cubic.js
  function cubicInOut(t) {
    return ((t *= 2) <= 1 ? t * t * t : (t -= 2) * t * t + 2) / 2;
  }

  // node_modules/d3-transition/src/selection/transition.js
  var defaultTiming = {
    time: null,
    delay: 0,
    duration: 250,
    ease: cubicInOut
  };
  function inherit(node, id2) {
    var timing;
    while (!(timing = node.__transition) || !(timing = timing[id2])) {
      if (!(node = node.parentNode)) {
        throw new Error(`transition ${id2} not found`);
      }
    }
    return timing;
  }
  function transition_default2(name) {
    var id2, timing;
    if (name instanceof Transition) {
      id2 = name._id, name = name._name;
    } else {
      id2 = newId(), (timing = defaultTiming).time = now(), name = name == null ? null : name + "";
    }
    for (var groups2 = this._groups, m = groups2.length, j = 0; j < m; ++j) {
      for (var group2 = groups2[j], n = group2.length, node, i = 0; i < n; ++i) {
        if (node = group2[i]) {
          schedule_default(node, name, id2, i, group2, timing || inherit(node, id2));
        }
      }
    }
    return new Transition(groups2, this._parents, name, id2);
  }

  // node_modules/d3-transition/src/selection/index.js
  selection_default.prototype.interrupt = interrupt_default2;
  selection_default.prototype.transition = transition_default2;

  // node_modules/d3-brush/src/brush.js
  var { abs, max: max2, min: min2 } = Math;
  function number1(e) {
    return [+e[0], +e[1]];
  }
  function number2(e) {
    return [number1(e[0]), number1(e[1])];
  }
  var X = {
    name: "x",
    handles: ["w", "e"].map(type),
    input: function(x, e) {
      return x == null ? null : [[+x[0], e[0][1]], [+x[1], e[1][1]]];
    },
    output: function(xy) {
      return xy && [xy[0][0], xy[1][0]];
    }
  };
  var Y = {
    name: "y",
    handles: ["n", "s"].map(type),
    input: function(y, e) {
      return y == null ? null : [[e[0][0], +y[0]], [e[1][0], +y[1]]];
    },
    output: function(xy) {
      return xy && [xy[0][1], xy[1][1]];
    }
  };
  var XY = {
    name: "xy",
    handles: ["n", "w", "e", "s", "nw", "ne", "sw", "se"].map(type),
    input: function(xy) {
      return xy == null ? null : number2(xy);
    },
    output: function(xy) {
      return xy;
    }
  };
  function type(t) {
    return { type: t };
  }

  // node_modules/d3-format/src/formatDecimal.js
  function formatDecimal_default(x) {
    return Math.abs(x = Math.round(x)) >= 1e21 ? x.toLocaleString("en").replace(/,/g, "") : x.toString(10);
  }
  function formatDecimalParts(x, p) {
    if ((i = (x = p ? x.toExponential(p - 1) : x.toExponential()).indexOf("e")) < 0)
      return null;
    var i, coefficient = x.slice(0, i);
    return [
      coefficient.length > 1 ? coefficient[0] + coefficient.slice(2) : coefficient,
      +x.slice(i + 1)
    ];
  }

  // node_modules/d3-format/src/exponent.js
  function exponent_default(x) {
    return x = formatDecimalParts(Math.abs(x)), x ? x[1] : NaN;
  }

  // node_modules/d3-format/src/formatGroup.js
  function formatGroup_default(grouping, thousands) {
    return function(value, width) {
      var i = value.length, t = [], j = 0, g = grouping[0], length = 0;
      while (i > 0 && g > 0) {
        if (length + g + 1 > width)
          g = Math.max(1, width - length);
        t.push(value.substring(i -= g, i + g));
        if ((length += g + 1) > width)
          break;
        g = grouping[j = (j + 1) % grouping.length];
      }
      return t.reverse().join(thousands);
    };
  }

  // node_modules/d3-format/src/formatNumerals.js
  function formatNumerals_default(numerals) {
    return function(value) {
      return value.replace(/[0-9]/g, function(i) {
        return numerals[+i];
      });
    };
  }

  // node_modules/d3-format/src/formatSpecifier.js
  var re = /^(?:(.)?([<>=^]))?([+\-( ])?([$#])?(0)?(\d+)?(,)?(\.\d+)?(~)?([a-z%])?$/i;
  function formatSpecifier(specifier) {
    if (!(match = re.exec(specifier)))
      throw new Error("invalid format: " + specifier);
    var match;
    return new FormatSpecifier({
      fill: match[1],
      align: match[2],
      sign: match[3],
      symbol: match[4],
      zero: match[5],
      width: match[6],
      comma: match[7],
      precision: match[8] && match[8].slice(1),
      trim: match[9],
      type: match[10]
    });
  }
  formatSpecifier.prototype = FormatSpecifier.prototype;
  function FormatSpecifier(specifier) {
    this.fill = specifier.fill === void 0 ? " " : specifier.fill + "";
    this.align = specifier.align === void 0 ? ">" : specifier.align + "";
    this.sign = specifier.sign === void 0 ? "-" : specifier.sign + "";
    this.symbol = specifier.symbol === void 0 ? "" : specifier.symbol + "";
    this.zero = !!specifier.zero;
    this.width = specifier.width === void 0 ? void 0 : +specifier.width;
    this.comma = !!specifier.comma;
    this.precision = specifier.precision === void 0 ? void 0 : +specifier.precision;
    this.trim = !!specifier.trim;
    this.type = specifier.type === void 0 ? "" : specifier.type + "";
  }
  FormatSpecifier.prototype.toString = function() {
    return this.fill + this.align + this.sign + this.symbol + (this.zero ? "0" : "") + (this.width === void 0 ? "" : Math.max(1, this.width | 0)) + (this.comma ? "," : "") + (this.precision === void 0 ? "" : "." + Math.max(0, this.precision | 0)) + (this.trim ? "~" : "") + this.type;
  };

  // node_modules/d3-format/src/formatTrim.js
  function formatTrim_default(s) {
    out:
      for (var n = s.length, i = 1, i0 = -1, i1; i < n; ++i) {
        switch (s[i]) {
          case ".":
            i0 = i1 = i;
            break;
          case "0":
            if (i0 === 0)
              i0 = i;
            i1 = i;
            break;
          default:
            if (!+s[i])
              break out;
            if (i0 > 0)
              i0 = 0;
            break;
        }
      }
    return i0 > 0 ? s.slice(0, i0) + s.slice(i1 + 1) : s;
  }

  // node_modules/d3-format/src/formatPrefixAuto.js
  var prefixExponent;
  function formatPrefixAuto_default(x, p) {
    var d = formatDecimalParts(x, p);
    if (!d)
      return x + "";
    var coefficient = d[0], exponent = d[1], i = exponent - (prefixExponent = Math.max(-8, Math.min(8, Math.floor(exponent / 3))) * 3) + 1, n = coefficient.length;
    return i === n ? coefficient : i > n ? coefficient + new Array(i - n + 1).join("0") : i > 0 ? coefficient.slice(0, i) + "." + coefficient.slice(i) : "0." + new Array(1 - i).join("0") + formatDecimalParts(x, Math.max(0, p + i - 1))[0];
  }

  // node_modules/d3-format/src/formatRounded.js
  function formatRounded_default(x, p) {
    var d = formatDecimalParts(x, p);
    if (!d)
      return x + "";
    var coefficient = d[0], exponent = d[1];
    return exponent < 0 ? "0." + new Array(-exponent).join("0") + coefficient : coefficient.length > exponent + 1 ? coefficient.slice(0, exponent + 1) + "." + coefficient.slice(exponent + 1) : coefficient + new Array(exponent - coefficient.length + 2).join("0");
  }

  // node_modules/d3-format/src/formatTypes.js
  var formatTypes_default = {
    "%": (x, p) => (x * 100).toFixed(p),
    "b": (x) => Math.round(x).toString(2),
    "c": (x) => x + "",
    "d": formatDecimal_default,
    "e": (x, p) => x.toExponential(p),
    "f": (x, p) => x.toFixed(p),
    "g": (x, p) => x.toPrecision(p),
    "o": (x) => Math.round(x).toString(8),
    "p": (x, p) => formatRounded_default(x * 100, p),
    "r": formatRounded_default,
    "s": formatPrefixAuto_default,
    "X": (x) => Math.round(x).toString(16).toUpperCase(),
    "x": (x) => Math.round(x).toString(16)
  };

  // node_modules/d3-format/src/identity.js
  function identity_default(x) {
    return x;
  }

  // node_modules/d3-format/src/locale.js
  var map3 = Array.prototype.map;
  var prefixes = ["y", "z", "a", "f", "p", "n", "\xB5", "m", "", "k", "M", "G", "T", "P", "E", "Z", "Y"];
  function locale_default(locale3) {
    var group2 = locale3.grouping === void 0 || locale3.thousands === void 0 ? identity_default : formatGroup_default(map3.call(locale3.grouping, Number), locale3.thousands + ""), currencyPrefix = locale3.currency === void 0 ? "" : locale3.currency[0] + "", currencySuffix = locale3.currency === void 0 ? "" : locale3.currency[1] + "", decimal = locale3.decimal === void 0 ? "." : locale3.decimal + "", numerals = locale3.numerals === void 0 ? identity_default : formatNumerals_default(map3.call(locale3.numerals, String)), percent = locale3.percent === void 0 ? "%" : locale3.percent + "", minus = locale3.minus === void 0 ? "\u2212" : locale3.minus + "", nan = locale3.nan === void 0 ? "NaN" : locale3.nan + "";
    function newFormat(specifier) {
      specifier = formatSpecifier(specifier);
      var fill2 = specifier.fill, align = specifier.align, sign2 = specifier.sign, symbol = specifier.symbol, zero2 = specifier.zero, width = specifier.width, comma = specifier.comma, precision = specifier.precision, trim = specifier.trim, type2 = specifier.type;
      if (type2 === "n")
        comma = true, type2 = "g";
      else if (!formatTypes_default[type2])
        precision === void 0 && (precision = 12), trim = true, type2 = "g";
      if (zero2 || fill2 === "0" && align === "=")
        zero2 = true, fill2 = "0", align = "=";
      var prefix = symbol === "$" ? currencyPrefix : symbol === "#" && /[boxX]/.test(type2) ? "0" + type2.toLowerCase() : "", suffix = symbol === "$" ? currencySuffix : /[%p]/.test(type2) ? percent : "";
      var formatType = formatTypes_default[type2], maybeSuffix = /[defgprs%]/.test(type2);
      precision = precision === void 0 ? 6 : /[gprs]/.test(type2) ? Math.max(1, Math.min(21, precision)) : Math.max(0, Math.min(20, precision));
      function format2(value) {
        var valuePrefix = prefix, valueSuffix = suffix, i, n, c;
        if (type2 === "c") {
          valueSuffix = formatType(value) + valueSuffix;
          value = "";
        } else {
          value = +value;
          var valueNegative = value < 0 || 1 / value < 0;
          value = isNaN(value) ? nan : formatType(Math.abs(value), precision);
          if (trim)
            value = formatTrim_default(value);
          if (valueNegative && +value === 0 && sign2 !== "+")
            valueNegative = false;
          valuePrefix = (valueNegative ? sign2 === "(" ? sign2 : minus : sign2 === "-" || sign2 === "(" ? "" : sign2) + valuePrefix;
          valueSuffix = (type2 === "s" ? prefixes[8 + prefixExponent / 3] : "") + valueSuffix + (valueNegative && sign2 === "(" ? ")" : "");
          if (maybeSuffix) {
            i = -1, n = value.length;
            while (++i < n) {
              if (c = value.charCodeAt(i), 48 > c || c > 57) {
                valueSuffix = (c === 46 ? decimal + value.slice(i + 1) : value.slice(i)) + valueSuffix;
                value = value.slice(0, i);
                break;
              }
            }
          }
        }
        if (comma && !zero2)
          value = group2(value, Infinity);
        var length = valuePrefix.length + value.length + valueSuffix.length, padding = length < width ? new Array(width - length + 1).join(fill2) : "";
        if (comma && zero2)
          value = group2(padding + value, padding.length ? width - valueSuffix.length : Infinity), padding = "";
        switch (align) {
          case "<":
            value = valuePrefix + value + valueSuffix + padding;
            break;
          case "=":
            value = valuePrefix + padding + value + valueSuffix;
            break;
          case "^":
            value = padding.slice(0, length = padding.length >> 1) + valuePrefix + value + valueSuffix + padding.slice(length);
            break;
          default:
            value = padding + valuePrefix + value + valueSuffix;
            break;
        }
        return numerals(value);
      }
      format2.toString = function() {
        return specifier + "";
      };
      return format2;
    }
    function formatPrefix2(specifier, value) {
      var f = newFormat((specifier = formatSpecifier(specifier), specifier.type = "f", specifier)), e = Math.max(-8, Math.min(8, Math.floor(exponent_default(value) / 3))) * 3, k = Math.pow(10, -e), prefix = prefixes[8 + e / 3];
      return function(value2) {
        return f(k * value2) + prefix;
      };
    }
    return {
      format: newFormat,
      formatPrefix: formatPrefix2
    };
  }

  // node_modules/d3-format/src/defaultLocale.js
  var locale;
  var format;
  var formatPrefix;
  defaultLocale({
    thousands: ",",
    grouping: [3],
    currency: ["$", ""]
  });
  function defaultLocale(definition) {
    locale = locale_default(definition);
    format = locale.format;
    formatPrefix = locale.formatPrefix;
    return locale;
  }

  // node_modules/d3-time/src/interval.js
  var t0 = new Date();
  var t1 = new Date();
  function newInterval(floori, offseti, count, field) {
    function interval2(date) {
      return floori(date = arguments.length === 0 ? new Date() : new Date(+date)), date;
    }
    interval2.floor = function(date) {
      return floori(date = new Date(+date)), date;
    };
    interval2.ceil = function(date) {
      return floori(date = new Date(date - 1)), offseti(date, 1), floori(date), date;
    };
    interval2.round = function(date) {
      var d0 = interval2(date), d1 = interval2.ceil(date);
      return date - d0 < d1 - date ? d0 : d1;
    };
    interval2.offset = function(date, step) {
      return offseti(date = new Date(+date), step == null ? 1 : Math.floor(step)), date;
    };
    interval2.range = function(start2, stop, step) {
      var range = [], previous;
      start2 = interval2.ceil(start2);
      step = step == null ? 1 : Math.floor(step);
      if (!(start2 < stop) || !(step > 0))
        return range;
      do
        range.push(previous = new Date(+start2)), offseti(start2, step), floori(start2);
      while (previous < start2 && start2 < stop);
      return range;
    };
    interval2.filter = function(test) {
      return newInterval(function(date) {
        if (date >= date)
          while (floori(date), !test(date))
            date.setTime(date - 1);
      }, function(date, step) {
        if (date >= date) {
          if (step < 0)
            while (++step <= 0) {
              while (offseti(date, -1), !test(date)) {
              }
            }
          else
            while (--step >= 0) {
              while (offseti(date, 1), !test(date)) {
              }
            }
        }
      });
    };
    if (count) {
      interval2.count = function(start2, end) {
        t0.setTime(+start2), t1.setTime(+end);
        floori(t0), floori(t1);
        return Math.floor(count(t0, t1));
      };
      interval2.every = function(step) {
        step = Math.floor(step);
        return !isFinite(step) || !(step > 0) ? null : !(step > 1) ? interval2 : interval2.filter(field ? function(d) {
          return field(d) % step === 0;
        } : function(d) {
          return interval2.count(0, d) % step === 0;
        });
      };
    }
    return interval2;
  }

  // node_modules/d3-time/src/duration.js
  var durationSecond = 1e3;
  var durationMinute = durationSecond * 60;
  var durationHour = durationMinute * 60;
  var durationDay = durationHour * 24;
  var durationWeek = durationDay * 7;
  var durationMonth = durationDay * 30;
  var durationYear = durationDay * 365;

  // node_modules/d3-time/src/day.js
  var day = newInterval(
    (date) => date.setHours(0, 0, 0, 0),
    (date, step) => date.setDate(date.getDate() + step),
    (start2, end) => (end - start2 - (end.getTimezoneOffset() - start2.getTimezoneOffset()) * durationMinute) / durationDay,
    (date) => date.getDate() - 1
  );
  var day_default = day;
  var days = day.range;

  // node_modules/d3-time/src/week.js
  function weekday(i) {
    return newInterval(function(date) {
      date.setDate(date.getDate() - (date.getDay() + 7 - i) % 7);
      date.setHours(0, 0, 0, 0);
    }, function(date, step) {
      date.setDate(date.getDate() + step * 7);
    }, function(start2, end) {
      return (end - start2 - (end.getTimezoneOffset() - start2.getTimezoneOffset()) * durationMinute) / durationWeek;
    });
  }
  var sunday = weekday(0);
  var monday = weekday(1);
  var tuesday = weekday(2);
  var wednesday = weekday(3);
  var thursday = weekday(4);
  var friday = weekday(5);
  var saturday = weekday(6);
  var sundays = sunday.range;
  var mondays = monday.range;
  var tuesdays = tuesday.range;
  var wednesdays = wednesday.range;
  var thursdays = thursday.range;
  var fridays = friday.range;
  var saturdays = saturday.range;

  // node_modules/d3-time/src/year.js
  var year = newInterval(function(date) {
    date.setMonth(0, 1);
    date.setHours(0, 0, 0, 0);
  }, function(date, step) {
    date.setFullYear(date.getFullYear() + step);
  }, function(start2, end) {
    return end.getFullYear() - start2.getFullYear();
  }, function(date) {
    return date.getFullYear();
  });
  year.every = function(k) {
    return !isFinite(k = Math.floor(k)) || !(k > 0) ? null : newInterval(function(date) {
      date.setFullYear(Math.floor(date.getFullYear() / k) * k);
      date.setMonth(0, 1);
      date.setHours(0, 0, 0, 0);
    }, function(date, step) {
      date.setFullYear(date.getFullYear() + step * k);
    });
  };
  var year_default = year;
  var years = year.range;

  // node_modules/d3-time/src/utcDay.js
  var utcDay = newInterval(function(date) {
    date.setUTCHours(0, 0, 0, 0);
  }, function(date, step) {
    date.setUTCDate(date.getUTCDate() + step);
  }, function(start2, end) {
    return (end - start2) / durationDay;
  }, function(date) {
    return date.getUTCDate() - 1;
  });
  var utcDay_default = utcDay;
  var utcDays = utcDay.range;

  // node_modules/d3-time/src/utcWeek.js
  function utcWeekday(i) {
    return newInterval(function(date) {
      date.setUTCDate(date.getUTCDate() - (date.getUTCDay() + 7 - i) % 7);
      date.setUTCHours(0, 0, 0, 0);
    }, function(date, step) {
      date.setUTCDate(date.getUTCDate() + step * 7);
    }, function(start2, end) {
      return (end - start2) / durationWeek;
    });
  }
  var utcSunday = utcWeekday(0);
  var utcMonday = utcWeekday(1);
  var utcTuesday = utcWeekday(2);
  var utcWednesday = utcWeekday(3);
  var utcThursday = utcWeekday(4);
  var utcFriday = utcWeekday(5);
  var utcSaturday = utcWeekday(6);
  var utcSundays = utcSunday.range;
  var utcMondays = utcMonday.range;
  var utcTuesdays = utcTuesday.range;
  var utcWednesdays = utcWednesday.range;
  var utcThursdays = utcThursday.range;
  var utcFridays = utcFriday.range;
  var utcSaturdays = utcSaturday.range;

  // node_modules/d3-time/src/utcYear.js
  var utcYear = newInterval(function(date) {
    date.setUTCMonth(0, 1);
    date.setUTCHours(0, 0, 0, 0);
  }, function(date, step) {
    date.setUTCFullYear(date.getUTCFullYear() + step);
  }, function(start2, end) {
    return end.getUTCFullYear() - start2.getUTCFullYear();
  }, function(date) {
    return date.getUTCFullYear();
  });
  utcYear.every = function(k) {
    return !isFinite(k = Math.floor(k)) || !(k > 0) ? null : newInterval(function(date) {
      date.setUTCFullYear(Math.floor(date.getUTCFullYear() / k) * k);
      date.setUTCMonth(0, 1);
      date.setUTCHours(0, 0, 0, 0);
    }, function(date, step) {
      date.setUTCFullYear(date.getUTCFullYear() + step * k);
    });
  };
  var utcYear_default = utcYear;
  var utcYears = utcYear.range;

  // node_modules/d3-time-format/src/locale.js
  function localDate(d) {
    if (0 <= d.y && d.y < 100) {
      var date = new Date(-1, d.m, d.d, d.H, d.M, d.S, d.L);
      date.setFullYear(d.y);
      return date;
    }
    return new Date(d.y, d.m, d.d, d.H, d.M, d.S, d.L);
  }
  function utcDate(d) {
    if (0 <= d.y && d.y < 100) {
      var date = new Date(Date.UTC(-1, d.m, d.d, d.H, d.M, d.S, d.L));
      date.setUTCFullYear(d.y);
      return date;
    }
    return new Date(Date.UTC(d.y, d.m, d.d, d.H, d.M, d.S, d.L));
  }
  function newDate(y, m, d) {
    return { y, m, d, H: 0, M: 0, S: 0, L: 0 };
  }
  function formatLocale(locale3) {
    var locale_dateTime = locale3.dateTime, locale_date = locale3.date, locale_time = locale3.time, locale_periods = locale3.periods, locale_weekdays = locale3.days, locale_shortWeekdays = locale3.shortDays, locale_months = locale3.months, locale_shortMonths = locale3.shortMonths;
    var periodRe = formatRe(locale_periods), periodLookup = formatLookup(locale_periods), weekdayRe = formatRe(locale_weekdays), weekdayLookup = formatLookup(locale_weekdays), shortWeekdayRe = formatRe(locale_shortWeekdays), shortWeekdayLookup = formatLookup(locale_shortWeekdays), monthRe = formatRe(locale_months), monthLookup = formatLookup(locale_months), shortMonthRe = formatRe(locale_shortMonths), shortMonthLookup = formatLookup(locale_shortMonths);
    var formats = {
      "a": formatShortWeekday,
      "A": formatWeekday,
      "b": formatShortMonth,
      "B": formatMonth,
      "c": null,
      "d": formatDayOfMonth,
      "e": formatDayOfMonth,
      "f": formatMicroseconds,
      "g": formatYearISO,
      "G": formatFullYearISO,
      "H": formatHour24,
      "I": formatHour12,
      "j": formatDayOfYear,
      "L": formatMilliseconds,
      "m": formatMonthNumber,
      "M": formatMinutes,
      "p": formatPeriod,
      "q": formatQuarter,
      "Q": formatUnixTimestamp,
      "s": formatUnixTimestampSeconds,
      "S": formatSeconds,
      "u": formatWeekdayNumberMonday,
      "U": formatWeekNumberSunday,
      "V": formatWeekNumberISO,
      "w": formatWeekdayNumberSunday,
      "W": formatWeekNumberMonday,
      "x": null,
      "X": null,
      "y": formatYear,
      "Y": formatFullYear,
      "Z": formatZone,
      "%": formatLiteralPercent
    };
    var utcFormats = {
      "a": formatUTCShortWeekday,
      "A": formatUTCWeekday,
      "b": formatUTCShortMonth,
      "B": formatUTCMonth,
      "c": null,
      "d": formatUTCDayOfMonth,
      "e": formatUTCDayOfMonth,
      "f": formatUTCMicroseconds,
      "g": formatUTCYearISO,
      "G": formatUTCFullYearISO,
      "H": formatUTCHour24,
      "I": formatUTCHour12,
      "j": formatUTCDayOfYear,
      "L": formatUTCMilliseconds,
      "m": formatUTCMonthNumber,
      "M": formatUTCMinutes,
      "p": formatUTCPeriod,
      "q": formatUTCQuarter,
      "Q": formatUnixTimestamp,
      "s": formatUnixTimestampSeconds,
      "S": formatUTCSeconds,
      "u": formatUTCWeekdayNumberMonday,
      "U": formatUTCWeekNumberSunday,
      "V": formatUTCWeekNumberISO,
      "w": formatUTCWeekdayNumberSunday,
      "W": formatUTCWeekNumberMonday,
      "x": null,
      "X": null,
      "y": formatUTCYear,
      "Y": formatUTCFullYear,
      "Z": formatUTCZone,
      "%": formatLiteralPercent
    };
    var parses = {
      "a": parseShortWeekday,
      "A": parseWeekday,
      "b": parseShortMonth,
      "B": parseMonth,
      "c": parseLocaleDateTime,
      "d": parseDayOfMonth,
      "e": parseDayOfMonth,
      "f": parseMicroseconds,
      "g": parseYear,
      "G": parseFullYear,
      "H": parseHour24,
      "I": parseHour24,
      "j": parseDayOfYear,
      "L": parseMilliseconds,
      "m": parseMonthNumber,
      "M": parseMinutes,
      "p": parsePeriod,
      "q": parseQuarter,
      "Q": parseUnixTimestamp,
      "s": parseUnixTimestampSeconds,
      "S": parseSeconds,
      "u": parseWeekdayNumberMonday,
      "U": parseWeekNumberSunday,
      "V": parseWeekNumberISO,
      "w": parseWeekdayNumberSunday,
      "W": parseWeekNumberMonday,
      "x": parseLocaleDate,
      "X": parseLocaleTime,
      "y": parseYear,
      "Y": parseFullYear,
      "Z": parseZone,
      "%": parseLiteralPercent
    };
    formats.x = newFormat(locale_date, formats);
    formats.X = newFormat(locale_time, formats);
    formats.c = newFormat(locale_dateTime, formats);
    utcFormats.x = newFormat(locale_date, utcFormats);
    utcFormats.X = newFormat(locale_time, utcFormats);
    utcFormats.c = newFormat(locale_dateTime, utcFormats);
    function newFormat(specifier, formats2) {
      return function(date) {
        var string = [], i = -1, j = 0, n = specifier.length, c, pad2, format2;
        if (!(date instanceof Date))
          date = new Date(+date);
        while (++i < n) {
          if (specifier.charCodeAt(i) === 37) {
            string.push(specifier.slice(j, i));
            if ((pad2 = pads[c = specifier.charAt(++i)]) != null)
              c = specifier.charAt(++i);
            else
              pad2 = c === "e" ? " " : "0";
            if (format2 = formats2[c])
              c = format2(date, pad2);
            string.push(c);
            j = i + 1;
          }
        }
        string.push(specifier.slice(j, i));
        return string.join("");
      };
    }
    function newParse(specifier, Z) {
      return function(string) {
        var d = newDate(1900, void 0, 1), i = parseSpecifier(d, specifier, string += "", 0), week, day2;
        if (i != string.length)
          return null;
        if ("Q" in d)
          return new Date(d.Q);
        if ("s" in d)
          return new Date(d.s * 1e3 + ("L" in d ? d.L : 0));
        if (Z && !("Z" in d))
          d.Z = 0;
        if ("p" in d)
          d.H = d.H % 12 + d.p * 12;
        if (d.m === void 0)
          d.m = "q" in d ? d.q : 0;
        if ("V" in d) {
          if (d.V < 1 || d.V > 53)
            return null;
          if (!("w" in d))
            d.w = 1;
          if ("Z" in d) {
            week = utcDate(newDate(d.y, 0, 1)), day2 = week.getUTCDay();
            week = day2 > 4 || day2 === 0 ? utcMonday.ceil(week) : utcMonday(week);
            week = utcDay_default.offset(week, (d.V - 1) * 7);
            d.y = week.getUTCFullYear();
            d.m = week.getUTCMonth();
            d.d = week.getUTCDate() + (d.w + 6) % 7;
          } else {
            week = localDate(newDate(d.y, 0, 1)), day2 = week.getDay();
            week = day2 > 4 || day2 === 0 ? monday.ceil(week) : monday(week);
            week = day_default.offset(week, (d.V - 1) * 7);
            d.y = week.getFullYear();
            d.m = week.getMonth();
            d.d = week.getDate() + (d.w + 6) % 7;
          }
        } else if ("W" in d || "U" in d) {
          if (!("w" in d))
            d.w = "u" in d ? d.u % 7 : "W" in d ? 1 : 0;
          day2 = "Z" in d ? utcDate(newDate(d.y, 0, 1)).getUTCDay() : localDate(newDate(d.y, 0, 1)).getDay();
          d.m = 0;
          d.d = "W" in d ? (d.w + 6) % 7 + d.W * 7 - (day2 + 5) % 7 : d.w + d.U * 7 - (day2 + 6) % 7;
        }
        if ("Z" in d) {
          d.H += d.Z / 100 | 0;
          d.M += d.Z % 100;
          return utcDate(d);
        }
        return localDate(d);
      };
    }
    function parseSpecifier(d, specifier, string, j) {
      var i = 0, n = specifier.length, m = string.length, c, parse2;
      while (i < n) {
        if (j >= m)
          return -1;
        c = specifier.charCodeAt(i++);
        if (c === 37) {
          c = specifier.charAt(i++);
          parse2 = parses[c in pads ? specifier.charAt(i++) : c];
          if (!parse2 || (j = parse2(d, string, j)) < 0)
            return -1;
        } else if (c != string.charCodeAt(j++)) {
          return -1;
        }
      }
      return j;
    }
    function parsePeriod(d, string, i) {
      var n = periodRe.exec(string.slice(i));
      return n ? (d.p = periodLookup.get(n[0].toLowerCase()), i + n[0].length) : -1;
    }
    function parseShortWeekday(d, string, i) {
      var n = shortWeekdayRe.exec(string.slice(i));
      return n ? (d.w = shortWeekdayLookup.get(n[0].toLowerCase()), i + n[0].length) : -1;
    }
    function parseWeekday(d, string, i) {
      var n = weekdayRe.exec(string.slice(i));
      return n ? (d.w = weekdayLookup.get(n[0].toLowerCase()), i + n[0].length) : -1;
    }
    function parseShortMonth(d, string, i) {
      var n = shortMonthRe.exec(string.slice(i));
      return n ? (d.m = shortMonthLookup.get(n[0].toLowerCase()), i + n[0].length) : -1;
    }
    function parseMonth(d, string, i) {
      var n = monthRe.exec(string.slice(i));
      return n ? (d.m = monthLookup.get(n[0].toLowerCase()), i + n[0].length) : -1;
    }
    function parseLocaleDateTime(d, string, i) {
      return parseSpecifier(d, locale_dateTime, string, i);
    }
    function parseLocaleDate(d, string, i) {
      return parseSpecifier(d, locale_date, string, i);
    }
    function parseLocaleTime(d, string, i) {
      return parseSpecifier(d, locale_time, string, i);
    }
    function formatShortWeekday(d) {
      return locale_shortWeekdays[d.getDay()];
    }
    function formatWeekday(d) {
      return locale_weekdays[d.getDay()];
    }
    function formatShortMonth(d) {
      return locale_shortMonths[d.getMonth()];
    }
    function formatMonth(d) {
      return locale_months[d.getMonth()];
    }
    function formatPeriod(d) {
      return locale_periods[+(d.getHours() >= 12)];
    }
    function formatQuarter(d) {
      return 1 + ~~(d.getMonth() / 3);
    }
    function formatUTCShortWeekday(d) {
      return locale_shortWeekdays[d.getUTCDay()];
    }
    function formatUTCWeekday(d) {
      return locale_weekdays[d.getUTCDay()];
    }
    function formatUTCShortMonth(d) {
      return locale_shortMonths[d.getUTCMonth()];
    }
    function formatUTCMonth(d) {
      return locale_months[d.getUTCMonth()];
    }
    function formatUTCPeriod(d) {
      return locale_periods[+(d.getUTCHours() >= 12)];
    }
    function formatUTCQuarter(d) {
      return 1 + ~~(d.getUTCMonth() / 3);
    }
    return {
      format: function(specifier) {
        var f = newFormat(specifier += "", formats);
        f.toString = function() {
          return specifier;
        };
        return f;
      },
      parse: function(specifier) {
        var p = newParse(specifier += "", false);
        p.toString = function() {
          return specifier;
        };
        return p;
      },
      utcFormat: function(specifier) {
        var f = newFormat(specifier += "", utcFormats);
        f.toString = function() {
          return specifier;
        };
        return f;
      },
      utcParse: function(specifier) {
        var p = newParse(specifier += "", true);
        p.toString = function() {
          return specifier;
        };
        return p;
      }
    };
  }
  var pads = { "-": "", "_": " ", "0": "0" };
  var numberRe = /^\s*\d+/;
  var percentRe = /^%/;
  var requoteRe = /[\\^$*+?|[\]().{}]/g;
  function pad(value, fill2, width) {
    var sign2 = value < 0 ? "-" : "", string = (sign2 ? -value : value) + "", length = string.length;
    return sign2 + (length < width ? new Array(width - length + 1).join(fill2) + string : string);
  }
  function requote(s) {
    return s.replace(requoteRe, "\\$&");
  }
  function formatRe(names2) {
    return new RegExp("^(?:" + names2.map(requote).join("|") + ")", "i");
  }
  function formatLookup(names2) {
    return new Map(names2.map((name, i) => [name.toLowerCase(), i]));
  }
  function parseWeekdayNumberSunday(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 1));
    return n ? (d.w = +n[0], i + n[0].length) : -1;
  }
  function parseWeekdayNumberMonday(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 1));
    return n ? (d.u = +n[0], i + n[0].length) : -1;
  }
  function parseWeekNumberSunday(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.U = +n[0], i + n[0].length) : -1;
  }
  function parseWeekNumberISO(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.V = +n[0], i + n[0].length) : -1;
  }
  function parseWeekNumberMonday(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.W = +n[0], i + n[0].length) : -1;
  }
  function parseFullYear(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 4));
    return n ? (d.y = +n[0], i + n[0].length) : -1;
  }
  function parseYear(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.y = +n[0] + (+n[0] > 68 ? 1900 : 2e3), i + n[0].length) : -1;
  }
  function parseZone(d, string, i) {
    var n = /^(Z)|([+-]\d\d)(?::?(\d\d))?/.exec(string.slice(i, i + 6));
    return n ? (d.Z = n[1] ? 0 : -(n[2] + (n[3] || "00")), i + n[0].length) : -1;
  }
  function parseQuarter(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 1));
    return n ? (d.q = n[0] * 3 - 3, i + n[0].length) : -1;
  }
  function parseMonthNumber(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.m = n[0] - 1, i + n[0].length) : -1;
  }
  function parseDayOfMonth(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.d = +n[0], i + n[0].length) : -1;
  }
  function parseDayOfYear(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 3));
    return n ? (d.m = 0, d.d = +n[0], i + n[0].length) : -1;
  }
  function parseHour24(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.H = +n[0], i + n[0].length) : -1;
  }
  function parseMinutes(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.M = +n[0], i + n[0].length) : -1;
  }
  function parseSeconds(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 2));
    return n ? (d.S = +n[0], i + n[0].length) : -1;
  }
  function parseMilliseconds(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 3));
    return n ? (d.L = +n[0], i + n[0].length) : -1;
  }
  function parseMicroseconds(d, string, i) {
    var n = numberRe.exec(string.slice(i, i + 6));
    return n ? (d.L = Math.floor(n[0] / 1e3), i + n[0].length) : -1;
  }
  function parseLiteralPercent(d, string, i) {
    var n = percentRe.exec(string.slice(i, i + 1));
    return n ? i + n[0].length : -1;
  }
  function parseUnixTimestamp(d, string, i) {
    var n = numberRe.exec(string.slice(i));
    return n ? (d.Q = +n[0], i + n[0].length) : -1;
  }
  function parseUnixTimestampSeconds(d, string, i) {
    var n = numberRe.exec(string.slice(i));
    return n ? (d.s = +n[0], i + n[0].length) : -1;
  }
  function formatDayOfMonth(d, p) {
    return pad(d.getDate(), p, 2);
  }
  function formatHour24(d, p) {
    return pad(d.getHours(), p, 2);
  }
  function formatHour12(d, p) {
    return pad(d.getHours() % 12 || 12, p, 2);
  }
  function formatDayOfYear(d, p) {
    return pad(1 + day_default.count(year_default(d), d), p, 3);
  }
  function formatMilliseconds(d, p) {
    return pad(d.getMilliseconds(), p, 3);
  }
  function formatMicroseconds(d, p) {
    return formatMilliseconds(d, p) + "000";
  }
  function formatMonthNumber(d, p) {
    return pad(d.getMonth() + 1, p, 2);
  }
  function formatMinutes(d, p) {
    return pad(d.getMinutes(), p, 2);
  }
  function formatSeconds(d, p) {
    return pad(d.getSeconds(), p, 2);
  }
  function formatWeekdayNumberMonday(d) {
    var day2 = d.getDay();
    return day2 === 0 ? 7 : day2;
  }
  function formatWeekNumberSunday(d, p) {
    return pad(sunday.count(year_default(d) - 1, d), p, 2);
  }
  function dISO(d) {
    var day2 = d.getDay();
    return day2 >= 4 || day2 === 0 ? thursday(d) : thursday.ceil(d);
  }
  function formatWeekNumberISO(d, p) {
    d = dISO(d);
    return pad(thursday.count(year_default(d), d) + (year_default(d).getDay() === 4), p, 2);
  }
  function formatWeekdayNumberSunday(d) {
    return d.getDay();
  }
  function formatWeekNumberMonday(d, p) {
    return pad(monday.count(year_default(d) - 1, d), p, 2);
  }
  function formatYear(d, p) {
    return pad(d.getFullYear() % 100, p, 2);
  }
  function formatYearISO(d, p) {
    d = dISO(d);
    return pad(d.getFullYear() % 100, p, 2);
  }
  function formatFullYear(d, p) {
    return pad(d.getFullYear() % 1e4, p, 4);
  }
  function formatFullYearISO(d, p) {
    var day2 = d.getDay();
    d = day2 >= 4 || day2 === 0 ? thursday(d) : thursday.ceil(d);
    return pad(d.getFullYear() % 1e4, p, 4);
  }
  function formatZone(d) {
    var z = d.getTimezoneOffset();
    return (z > 0 ? "-" : (z *= -1, "+")) + pad(z / 60 | 0, "0", 2) + pad(z % 60, "0", 2);
  }
  function formatUTCDayOfMonth(d, p) {
    return pad(d.getUTCDate(), p, 2);
  }
  function formatUTCHour24(d, p) {
    return pad(d.getUTCHours(), p, 2);
  }
  function formatUTCHour12(d, p) {
    return pad(d.getUTCHours() % 12 || 12, p, 2);
  }
  function formatUTCDayOfYear(d, p) {
    return pad(1 + utcDay_default.count(utcYear_default(d), d), p, 3);
  }
  function formatUTCMilliseconds(d, p) {
    return pad(d.getUTCMilliseconds(), p, 3);
  }
  function formatUTCMicroseconds(d, p) {
    return formatUTCMilliseconds(d, p) + "000";
  }
  function formatUTCMonthNumber(d, p) {
    return pad(d.getUTCMonth() + 1, p, 2);
  }
  function formatUTCMinutes(d, p) {
    return pad(d.getUTCMinutes(), p, 2);
  }
  function formatUTCSeconds(d, p) {
    return pad(d.getUTCSeconds(), p, 2);
  }
  function formatUTCWeekdayNumberMonday(d) {
    var dow = d.getUTCDay();
    return dow === 0 ? 7 : dow;
  }
  function formatUTCWeekNumberSunday(d, p) {
    return pad(utcSunday.count(utcYear_default(d) - 1, d), p, 2);
  }
  function UTCdISO(d) {
    var day2 = d.getUTCDay();
    return day2 >= 4 || day2 === 0 ? utcThursday(d) : utcThursday.ceil(d);
  }
  function formatUTCWeekNumberISO(d, p) {
    d = UTCdISO(d);
    return pad(utcThursday.count(utcYear_default(d), d) + (utcYear_default(d).getUTCDay() === 4), p, 2);
  }
  function formatUTCWeekdayNumberSunday(d) {
    return d.getUTCDay();
  }
  function formatUTCWeekNumberMonday(d, p) {
    return pad(utcMonday.count(utcYear_default(d) - 1, d), p, 2);
  }
  function formatUTCYear(d, p) {
    return pad(d.getUTCFullYear() % 100, p, 2);
  }
  function formatUTCYearISO(d, p) {
    d = UTCdISO(d);
    return pad(d.getUTCFullYear() % 100, p, 2);
  }
  function formatUTCFullYear(d, p) {
    return pad(d.getUTCFullYear() % 1e4, p, 4);
  }
  function formatUTCFullYearISO(d, p) {
    var day2 = d.getUTCDay();
    d = day2 >= 4 || day2 === 0 ? utcThursday(d) : utcThursday.ceil(d);
    return pad(d.getUTCFullYear() % 1e4, p, 4);
  }
  function formatUTCZone() {
    return "+0000";
  }
  function formatLiteralPercent() {
    return "%";
  }
  function formatUnixTimestamp(d) {
    return +d;
  }
  function formatUnixTimestampSeconds(d) {
    return Math.floor(+d / 1e3);
  }

  // node_modules/d3-time-format/src/defaultLocale.js
  var locale2;
  var timeFormat;
  var timeParse;
  var utcFormat;
  var utcParse;
  defaultLocale2({
    dateTime: "%x, %X",
    date: "%-m/%-d/%Y",
    time: "%-I:%M:%S %p",
    periods: ["AM", "PM"],
    days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    shortDays: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
    shortMonths: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  });
  function defaultLocale2(definition) {
    locale2 = formatLocale(definition);
    timeFormat = locale2.format;
    timeParse = locale2.parse;
    utcFormat = locale2.utcFormat;
    utcParse = locale2.utcParse;
    return locale2;
  }

  // node_modules/d3-zoom/src/transform.js
  function Transform(k, x, y) {
    this.k = k;
    this.x = x;
    this.y = y;
  }
  Transform.prototype = {
    constructor: Transform,
    scale: function(k) {
      return k === 1 ? this : new Transform(this.k * k, this.x, this.y);
    },
    translate: function(x, y) {
      return x === 0 & y === 0 ? this : new Transform(this.k, this.x + this.k * x, this.y + this.k * y);
    },
    apply: function(point) {
      return [point[0] * this.k + this.x, point[1] * this.k + this.y];
    },
    applyX: function(x) {
      return x * this.k + this.x;
    },
    applyY: function(y) {
      return y * this.k + this.y;
    },
    invert: function(location) {
      return [(location[0] - this.x) / this.k, (location[1] - this.y) / this.k];
    },
    invertX: function(x) {
      return (x - this.x) / this.k;
    },
    invertY: function(y) {
      return (y - this.y) / this.k;
    },
    rescaleX: function(x) {
      return x.copy().domain(x.range().map(this.invertX, this).map(x.invert, x));
    },
    rescaleY: function(y) {
      return y.copy().domain(y.range().map(this.invertY, this).map(y.invert, y));
    },
    toString: function() {
      return "translate(" + this.x + "," + this.y + ") scale(" + this.k + ")";
    }
  };
  var identity3 = new Transform(1, 0, 0);
  transform.prototype = Transform.prototype;
  function transform(node) {
    while (!node.__zoom)
      if (!(node = node.parentNode))
        return identity3;
    return node.__zoom;
  }

  // src/util/colorScheme.js
  var colorScheme = [
    {
      color: "#52C41A",
      order: 0,
      description: "Within Thresholds",
      flag: [0]
    },
    {
      color: "#FADB14",
      order: 1,
      description: "At Risk",
      flag: [-1, 1]
    },
    {
      color: "#FF4D4F",
      order: 2,
      description: "Flagged",
      flag: [-2, 2]
    }
  ];
  colorScheme.forEach((color3) => {
    color3.rgba = color2(color3.color);
  });
  var colorScheme_default = colorScheme;

  // src/util/coalesce.js
  function coalesce(customSetting, defaultSetting) {
    if ([null, void 0].includes(customSetting)) {
      return defaultSetting;
    }
    if (typeof defaultSetting === "string" && customSetting === "") {
      return defaultSetting;
    }
    if (Array.isArray(defaultSetting) && !Array.isArray(customSetting)) {
      customSetting = [customSetting];
    }
    if (Array.isArray(defaultSetting) && Array.isArray(customSetting) && customSetting[0] === "") {
      return defaultSetting;
    }
    return customSetting;
  }

  // src/util/configure.js
  function configure2(defaults3, _config_, customSettings = null) {
    const config = { ..._config_ };
    for (const key in defaults3) {
      config[key] = coalesce(config[key], defaults3[key]);
    }
    if (customSettings !== null) {
      for (const key in customSettings) {
        config[key] = customSettings[key]();
      }
    }
    return config;
  }

  // src/util/checkSelectedGroupIDs.js
  function checkSelectedGroupIDs(selectedGroupIDs, _data_) {
    if (["", null, void 0].includes(selectedGroupIDs) || Array.isArray(selectedGroupIDs) && selectedGroupIDs.length === 0)
      return [];
    if (!Array.isArray(selectedGroupIDs))
      selectedGroupIDs = [selectedGroupIDs];
    if (Array.isArray(selectedGroupIDs)) {
      const actualGroupIDs = [...new Set(_data_.map((d) => d.groupid))];
      for (const selectedGroupID of selectedGroupIDs) {
        if (actualGroupIDs.includes(selectedGroupID) === false)
          selectedGroupIDs = selectedGroupIDs.filter(
            (groupID) => groupID !== selectedGroupID
          );
      }
    }
    return selectedGroupIDs;
  }

  // src/util/mapThresholdsToFlags.js
  function mapThresholdsToFlags(_thresholds_) {
    const thresholds2 = _thresholds_.map((threshold) => +threshold).sort(ascending);
    const negativeThresholds = thresholds2.filter((threshold) => threshold < 0).sort(descending);
    const negativeFlags = negativeThresholds.map((threshold, i) => {
      return {
        threshold,
        flag: -(i + 1)
      };
    });
    const positiveThresholds = thresholds2.filter((threshold) => threshold > 0).sort(ascending);
    const positiveFlags = positiveThresholds.map((threshold, i) => {
      return {
        threshold,
        flag: i + 1
      };
    });
    const zeroFlag = thresholds2.filter((threshold) => threshold === 0).map((threshold) => {
      return {
        threshold,
        flag: 0
      };
    });
    const flags = [...negativeFlags, ...zeroFlag, ...positiveFlags].sort(
      (a, b) => a.flag - b.flag
    );
    return flags;
  }

  // src/util/checkThresholds.js
  function checkThresholds(_config_, _thresholds_) {
    let thresholds2 = _config_.thresholds;
    if (_config_.y === "metric" && !/^qtl/.test(_config_.workflowid))
      return null;
    if (Array.isArray(thresholds2) && thresholds2.length > 0 && thresholds2.every((threshold) => typeof threshold === "number"))
      return mapThresholdsToFlags(thresholds2);
    if (Array.isArray(thresholds2) && thresholds2.length > 0 && thresholds2.every(
      (threshold) => typeof threshold === "object" && threshold.hasOwnProperty("threshold") && threshold.hasOwnProperty("flag")
    ))
      return thresholds2;
    if (_thresholds_ === null || [null].includes(thresholds2) || Array.isArray(thresholds2) && (thresholds2.length === 0 || thresholds2.some((threshold) => typeof threshold !== "number")))
      return null;
    thresholds2 = _thresholds_.filter((d) => d.param === "vThreshold").map((d) => d.default);
    return mapThresholdsToFlags(
      thresholds2,
      thresholds2.some((threshold) => threshold < 0)
    );
  }

  // src/barChart/configure.js
  function configure3(_config_, _data_, _thresholds_) {
    const defaults3 = {};
    defaults3.type = "bar";
    defaults3.x = "groupid";
    defaults3.xType = "category";
    defaults3.y = "score";
    defaults3.yType = "linear";
    defaults3.color = "flag";
    defaults3.colorLabel = _config_[defaults3.color];
    defaults3.hoverCallback = (datum2) => {
    };
    defaults3.clickCallback = (datum2) => {
      console.log(datum2);
    };
    defaults3.maintainAspectRatio = false;
    const config = configure2(defaults3, _config_, {
      selectedGroupIDs: checkSelectedGroupIDs.bind(
        null,
        _config_.selectedGroupIDs,
        _data_
      ),
      thresholds: checkThresholds.bind(null, _config_, _thresholds_)
    });
    config.xLabel = coalesce(_config_.xLabel, config["group"]);
    config.yLabel = coalesce(_config_.yLabel, config[config.y]);
    return config;
  }

  // src/util/addCanvas/addCustomHoverEvent.js
  function addCustomHoverEvent(canvas, callback2) {
    const hoverEvent = new Event("hover-event");
    canvas.addEventListener(
      "hover-event",
      (event) => {
        const pointDatum = event.data;
        callback2(pointDatum);
        return pointDatum;
      },
      false
    );
    return hoverEvent;
  }

  // src/util/addCanvas/addCustomClickEvent.js
  function addCustomClickEvent(canvas, callback2) {
    const clickEvent = new Event("click-event");
    canvas.addEventListener(
      "click-event",
      (event) => {
        const pointDatum = event.data;
        callback2(pointDatum);
        return pointDatum;
      },
      false
    );
    return clickEvent;
  }

  // src/util/addCanvas.js
  function addCanvas(_element_, config) {
    let canvas;
    if (_element_.nodeName && _element_.nodeName.toLowerCase() === "canvas") {
      if (_element_.hasOwnProperty("chart"))
        _element_.chart.destroy();
      canvas = _element_;
    } else {
      const newCanvas = document.createElement("canvas");
      const oldCanvas = _element_.getElementsByTagName("canvas")[0];
      if (oldCanvas !== void 0) {
        if (oldCanvas.hasOwnProperty("chart"))
          oldCanvas.chart.destroy();
        oldCanvas.replaceWith(newCanvas);
      } else {
        _element_.appendChild(newCanvas);
      }
      canvas = newCanvas;
    }
    config.hoverEvent = addCustomHoverEvent(canvas, config.hoverCallback);
    config.clickEvent = addCustomClickEvent(canvas, config.clickCallback);
    return canvas;
  }

  // src/barChart/structureData/mutate.js
  function mutate(_data_, config) {
    const data = _data_.map((d) => {
      const datum2 = {
        ...d,
        x: d[config.x],
        y: +d[config.y],
        stratum: +d[config.color]
      };
      return datum2;
    }).sort((a, b) => b.y - a.y);
    return data;
  }

  // src/barChart/structureData/scriptableOptions/backgroundColor.js
  function backgroundColor(context, options) {
    const chart = context.chart;
    const config = chart.data.config;
    const dataset = context.dataset;
    const datum2 = dataset.data[context.dataIndex];
    if (dataset.type === "bar") {
      const threshold = colorScheme_default.find(
        (x) => x.flag.includes(datum2.stratum)
      );
      const color3 = threshold.rgba;
      color3.opacity = config.selectedGroupIDs.includes(datum2.groupid) | config.selectedGroupIDs.length === 0 ? 1 : 0.25;
      return color3 + "";
    }
  }

  // src/barChart/structureData/scriptableOptions.js
  function scriptableOptions() {
    return {
      backgroundColor
    };
  }

  // src/barChart/structureData.js
  function structureData(_data_, config) {
    const data = mutate(_data_, config);
    const datasets = [
      {
        type: "bar",
        data,
        label: "",
        ...scriptableOptions(),
        minBarLength: 2,
        grouped: false
      },
      ...colorScheme_default.map((color3) => ({
        type: "bar",
        label: color3.description,
        backgroundColor: color3.color
      }))
    ];
    return datasets;
  }

  // src/util/getElementDatum.js
  function getElementDatum(activeElements, chart) {
    const element = activeElements[0];
    const data = chart.data.datasets[element.datasetIndex].data;
    const datum2 = data[element.index];
    return datum2;
  }

  // src/util/onClick.js
  function onClick(event, activeElements, chart) {
    const config = chart.data.config;
    if (activeElements.length && chart.data.datasets[activeElements[0].datasetIndex].type === config.type) {
      const datum2 = getElementDatum(activeElements, chart);
      delete config.clickEvent.data;
      config.clickEvent.data = datum2;
      chart.canvas.dispatchEvent(config.clickEvent);
    }
  }

  // src/util/onHover.js
  function onHover(event, activeElements, chart) {
    const config = chart.data.config;
    if (activeElements.length && chart.data.datasets[activeElements[0].datasetIndex].type === config.type) {
      const datum2 = getElementDatum(activeElements, chart);
      config.hoverEvent.data = datum2;
      chart.canvas.dispatchEvent(config.hoverEvent);
      event.native.target.style.cursor = "pointer";
    } else {
      event.native.target.style.cursor = "default";
    }
  }

  // src/barChart/plugins/annotations.js
  function annotations(config) {
    let annotations5 = null;
    if (config.thresholds) {
      annotations5 = config.thresholds.sort((a, b) => Math.abs(a.threshold) - Math.abs(b.threshold)).map((x, i) => ({
        adjustScaleRange: false,
        borderColor: colorScheme_default.filter(
          (y) => y.flag.includes(+x.flag)
        )[0].color,
        borderDash: [2],
        borderWidth: 1,
        label: {
          backgroundColor: "white",
          color: colorScheme_default.filter(
            (y) => y.flag.includes(+x.flag)
          )[0].color,
          content: colorScheme_default.filter(
            (y) => y.flag.includes(+x.flag)
          )[0].description,
          display: true,
          font: {
            size: 12
          },
          padding: 2,
          position: Math.sign(+x.flag) === 1 ? "end" : "start",
          rotation: "auto",
          yValue: x.threshold,
          yAdjust: 0
        },
        type: "line",
        yMin: x.threshold,
        yMax: x.threshold
      }));
    }
    return annotations5;
  }

  // src/barChart/plugins/legend.js
  function legend(config) {
    return {
      display: !config.thresholds,
      labels: {
        boxHeight: 10,
        boxWidth: 10,
        filter: function(item, chart) {
          return item.text !== "";
        }
      },
      position: "top"
    };
  }

  // src/util/formatResultTooltipContent.js
  function formatResultTooltipContent(config, data) {
    const datum2 = data.dataset.data[data.dataIndex];
    let content;
    if (["bar", "line", "scatter"].includes(data.dataset.type) && config.dataType !== "discrete") {
      content = config.group === "Study" ? [
        `${config.yLabel}: ${format(".3f")(datum2.metric)}`,
        `Confidence Interval: (${format(".3f")(
          datum2.lowerCI
        )}, ${format(".3f")(datum2.upperCI)})`,
        `${config.numerator}: ${format(",")(datum2.numerator)}`,
        `${config.denominator}: ${format(",")(
          datum2.denominator
        )}`
      ] : [
        `KRI Score: ${format(".1f")(datum2.score)} (${config.score})`,
        `KRI Value: ${format(".3f")(datum2.metric)} (${config.metric})`,
        `${config.numerator}: ${format(",")(datum2.numerator)}`,
        `${config.denominator}: ${format(",")(
          datum2.denominator
        )}`
      ];
    } else if (["boxplot", "violin"].includes(data.dataset.type)) {
      const stats = ["mean", "min", "q1", "median", "q3", "max"].map(
        (stat) => `${stat.charAt(0).toUpperCase()}${stat.slice(1)}: ${format(
          ".1f"
        )(data.parsed[stat])}`
      );
      content = [...stats];
    } else if (config.dataType === "discrete") {
      content = data.dataset.purpose === "highlight" ? [
        `${datum2.n_flagged} flagged ${config.discreteUnit}${+datum2.n_flagged === 1 ? "" : "s"}`,
        `${datum2.n_at_risk} at risk ${config.discreteUnit}${+datum2.n_at_risk === 1 ? "" : "s"}`
      ] : data.dataset.purpose === "aggregate" && config.discreteUnit === "KRI" ? [
        `${format(".1f")(datum2.y)} Average ${config.yLabel}`,
        ...datum2.counts.map(
          (d) => `${d[config.y]} ${config.yLabel}: ${d.n}/${d.N} (${d.pct}%) ${config.group}s`
        )
      ] : data.dataset.purpose === "aggregate" && config.discreteUnit === "Site" ? `${format(".1f")(datum2.y)} ${config.yLabel}` : null;
    }
    return content;
  }

  // src/util/getTooltipAesthetics.js
  function getTooltipAesthetics() {
    return {
      backgroundColor: "rgba(255,255,255,.85)",
      bodyColor: "black",
      bodyFont: {
        family: "roboto",
        size: 12,
        weight: "bold"
      },
      borderColor: "black",
      borderWidth: 1,
      boxPadding: 5,
      boxWidth: 10,
      cornerRadius: 2,
      caretPadding: 4,
      padding: 10,
      titleColor: "black",
      titleMarginBottom: 5,
      titleFont: {
        family: "roboto",
        lineHeight: 1.5,
        size: 16,
        weight: "bold"
      },
      usePointStyle: true
    };
  }

  // src/barChart/plugins/tooltip.js
  function tooltip(config) {
    const tooltipAesthetics = getTooltipAesthetics();
    tooltipAesthetics.boxWidth = 10;
    return {
      callbacks: {
        label: formatResultTooltipContent.bind(null, config),
        labelPointStyle: () => ({ pointStyle: "rect" }),
        title: (data) => {
          if (data.length) {
            const datum2 = data[0].dataset.data[data[0].dataIndex];
            return `${config.group} ${datum2.groupid}`;
          }
        }
      },
      ...tooltipAesthetics
    };
  }

  // src/barChart/plugins/chartLabels.js
  function chartLabels(config) {
    return {
      align: (context) => config.y === "score" && Math.sign(context.dataset.data[context.dataIndex].y) === 1 || config.y === "metric" && Math.sign(context.dataset.data[context.dataIndex].y) === -1 ? "start" : "end",
      anchor: (context) => config.y === "score" && Math.sign(context.dataset.data[context.dataIndex].y) === 1 || config.y === "metric" && Math.sign(context.dataset.data[context.dataIndex].y) === -1 ? "start" : "end",
      color: "black",
      display: (context) => context.chart.getDatasetMeta(0).data[1].width >= context.chart.options.font.size - 3,
      formatter: (value, context) => context.chart.data.labels[context.dataIndex],
      rotation: -90
    };
  }

  // src/barChart/plugins.js
  function plugins2(config) {
    const plugins6 = {
      annotation: {
        annotations: annotations(config),
        clip: true
      },
      datalabels: chartLabels(config),
      legend: legend(config),
      tooltip: tooltip(config)
    };
    return plugins6;
  }

  // src/util/getDefaultScales.js
  function getDefaultScales() {
    const defaultScales = {
      x: {
        grid: {
          borderDash: [2],
          display: false,
          drawBorder: false
        },
        ticks: {
          display: true
        },
        title: {
          display: true,
          text: null
        },
        type: null
      },
      y: {
        grid: {
          borderDash: [2],
          display: true,
          drawBorder: false
        },
        ticks: {
          display: true
        },
        title: {
          display: true,
          text: null,
          padding: null
        },
        type: null
      }
    };
    return defaultScales;
  }

  // src/barChart/getScales.js
  function getScales(config, datasets) {
    const scales2 = getDefaultScales();
    scales2.x.ticks.display = false;
    scales2.x.title.text = config.xLabel;
    scales2.x.type = config.xType;
    scales2.y.title.text = config.yLabel;
    scales2.y.type = config.yType;
    scales2.y.offset = true;
    return scales2;
  }

  // node_modules/chart.js/auto/auto.mjs
  Chart.register(...registerables);
  var auto_default = Chart;

  // src/util/triggerTooltip.js
  function triggerTooltip(chart) {
    const tooltip5 = chart.tooltip;
    if (tooltip5.getActiveElements().length > 0) {
      tooltip5.setActiveElements([], { x: 0, y: 0 });
    }
    if (chart.data.config.selectedGroupIDs.length > 0) {
      const pointIndex = chart.data.datasets[0].data.findIndex(
        (d) => chart.data.config.selectedGroupIDs.includes(d.groupid)
      );
      tooltip5.setActiveElements([
        {
          datasetIndex: 0,
          index: pointIndex
        }
      ]);
    }
    chart.update();
  }

  // src/barChart/updateConfig.js
  function updateConfig(chart, _config_, _thresholds_, update = false) {
    const config = configure3(
      _config_,
      chart.data.datasets.find((dataset) => dataset.type === "bar").data,
      _thresholds_
    );
    chart.options.plugins = plugins2(config);
    chart.options.scales = getScales(config);
    chart.data.config = config;
    if (update)
      chart.update();
    triggerTooltip(chart);
    return config;
  }

  // src/barChart/updateData.js
  function updateData(chart, _data_, _config_, _thresholds_) {
    chart.data.config = updateConfig(chart, _config_, _thresholds_);
    chart.data.config.hoverEvent = addCustomHoverEvent(
      chart.canvas,
      chart.data.config.hoverCallback
    );
    chart.data.config.clickEvent = addCustomClickEvent(
      chart.canvas,
      chart.data.config.clickCallback
    );
    chart.data.datasets = structureData(_data_, chart.data.config);
    chart.update();
  }

  // src/barChart/updateOption.js
  function updateOption(chart, option, value) {
    const objPath = option.split(".");
    let obj = chart.options;
    for (let i = 0; i < objPath.length; i++) {
      if (i < objPath.length - 1)
        obj = obj[objPath[i]];
      else
        obj[objPath[i]] = value;
    }
    chart.update();
  }

  // src/barChart.js
  function barChart(_element_, _data_, _config_ = {}, _thresholds_ = null) {
    const config = configure3(_config_, _data_, _thresholds_);
    const canvas = addCanvas(_element_, config);
    const datasets = structureData(_data_, config);
    const options = {
      animation: false,
      clip: false,
      events: ["click", "mousemove", "mouseout"],
      interaction: {
        intersect: false,
        mode: "x"
      },
      layout: {
        padding: {
          top: config.y === "metric" ? max(datasets[0].data, (d) => d.groupid.length) * 8 : null
        }
      },
      maintainAspectRatio: config.maintainAspectRatio,
      onClick,
      onHover,
      plugins: plugins2(config),
      scales: getScales(config, datasets)
    };
    const chart = new auto_default(canvas, {
      data: {
        datasets,
        config,
        _thresholds_,
        _data_
      },
      metadata: "test",
      options,
      plugins: [plugin]
    });
    chart.helpers = {
      updateData,
      updateConfig,
      updateOption
    };
    canvas.chart = chart;
    triggerTooltip(chart);
    return chart;
  }

  // src/scatterPlot/configure.js
  function configure4(_config_, _data_) {
    const defaults3 = {};
    defaults3.type = "scatter";
    defaults3.x = "denominator";
    defaults3.xType = "logarithmic";
    defaults3.y = "numerator";
    defaults3.yType = "linear";
    defaults3.color = "flag";
    defaults3.colorScheme = colorScheme_default;
    defaults3.hoverCallback = (datum2) => {
    };
    defaults3.clickCallback = (datum2) => {
      console.log(datum2);
    };
    defaults3.displayTitle = false;
    defaults3.displayTrendLine = false;
    defaults3.maintainAspectRatio = false;
    const config = configure2(defaults3, _config_, {
      selectedGroupIDs: checkSelectedGroupIDs.bind(
        null,
        _config_.selectedGroupIDs,
        _data_
      )
    });
    config.xLabel = coalesce(_config_.xLabel, config[config.x]);
    config.yLabel = coalesce(_config_.yLabel, config[config.y]);
    return config;
  }

  // src/scatterPlot/structureData/mutate.js
  function mutate2(_data_, config) {
    const data = _data_.map((d) => {
      const datum2 = {
        ...d,
        x: +d[config.x],
        y: +d[config.y],
        stratum: Math.abs(+d[config.color])
      };
      return datum2;
    }).sort((a, b) => {
      const aSelected = config.selectedGroupIDs.indexOf(a.groupid) > -1;
      const bSelected = config.selectedGroupIDs.indexOf(b.groupid) > -1;
      const stratum = b.stratum - a.stratum;
      return aSelected ? 1 : bSelected ? -1 : stratum;
    });
    return data;
  }

  // src/scatterPlot/structureData/scriptableOptions/backgroundColor.js
  function backgroundColor2(context, options) {
    const chart = context.chart;
    const config = chart.data.config;
    const dataset = context.dataset;
    const datum2 = dataset.data[context.dataIndex];
    if (dataset.type === "scatter") {
      const color3 = config.colorScheme[datum2.stratum].rgba;
      color3.opacity = config.selectedGroupIDs.includes(datum2.groupid) | config.selectedGroupIDs.length === 0 ? 1 : 0.25;
      return color3 + "";
    }
  }

  // src/scatterPlot/structureData/scriptableOptions/borderColor.js
  function borderColor2(context, options) {
    const chart = context.chart;
    const config = chart.data.config;
    const dataset = context.dataset;
    const datum2 = dataset.data[context.dataIndex];
    if (dataset.type === "scatter") {
      return config.selectedGroupIDs.includes(datum2.groupid) ? "black" : "rgba(0, 0, 0, 0.1)";
    }
  }

  // src/scatterPlot/structureData/scriptableOptions/borderWidth.js
  function borderWidth(context, options) {
    const chart = context.chart;
    const config = chart.data.config;
    const dataset = context.dataset;
    const datum2 = dataset.data[context.dataIndex];
    if (dataset.type === "scatter") {
      return 1;
    }
  }

  // src/scatterPlot/structureData/scriptableOptions/radius.js
  function radius(context, options) {
    const chart = context.chart;
    const config = chart.data.config;
    const dataset = context.dataset;
    const datum2 = dataset.data[context.dataIndex];
    if (dataset.type === "scatter") {
      return config.selectedGroupIDs.includes(datum2.groupid) ? 5 : 3;
    }
  }

  // src/scatterPlot/structureData/scriptableOptions.js
  function scriptableOptions2() {
    return {
      backgroundColor: backgroundColor2,
      borderColor: borderColor2,
      borderWidth,
      radius
    };
  }

  // src/scatterPlot/structureData/rollupBounds.js
  function rollupBounds(_bounds_, config) {
    if (_bounds_ !== null) {
      const boundUps = rollups(
        _bounds_.sort((a, b) => a.threshold - b.threshold),
        (group2) => {
          return {
            type: "line",
            data: group2.map((d) => ({
              stratum: Math.abs(+d.threshold),
              threshold: d.threshold,
              x: +d.denominator,
              y: +d.numerator
            })),
            borderWidth: 1,
            hoverRadius: 0,
            pointRadius: 0
          };
        },
        (d) => d.threshold
      );
      const flags = mapThresholdsToFlags(boundUps.map((bound) => bound[0]));
      const bounds = boundUps.map((bound, i) => {
        const group2 = bound[1];
        group2.threshold = +bound[0];
        group2.flag = flags.find(
          (flag2) => flag2.threshold === group2.threshold
        );
        const flag = group2.flag.flag;
        group2.label = config.colorScheme.find(
          (color4) => color4.flag.includes(flag)
        ).description;
        const color3 = config.colorScheme[Math.abs(flag)].color;
        group2.borderColor = color3;
        const backgroundColor4 = color2(color3);
        backgroundColor4.opacity = 0.75;
        group2.backgroundColor = backgroundColor4 + "";
        group2.borderDash = [2];
        if (config.displayTrendLine === false && group2.threshold === 0) {
          group2.borderColor = "rgba(0,0,0,0)";
        }
        return group2;
      });
      rollup(
        bounds,
        (group2) => {
          group2.forEach((d, i) => {
            if (i > 0)
              d.label = "";
          });
        },
        (d) => Math.abs(d.flag.flag)
      );
      return bounds;
    }
  }

  // src/scatterPlot/structureData.js
  function structureData2(_data_, config, _bounds_) {
    const data = mutate2(_data_, config);
    const datasets = [
      {
        type: "scatter",
        data,
        label: "",
        ...scriptableOptions2()
      }
    ];
    const bounds = rollupBounds(_bounds_, config);
    if (bounds !== void 0)
      bounds.forEach((bound) => {
        datasets.push(bound);
      });
    return datasets;
  }

  // src/scatterPlot/plugins/legend.js
  function legend2(config) {
    const legendOrder = colorScheme_default.sort((a, b) => a.order - b.order).map((color3) => color3.description);
    return {
      display: true,
      labels: {
        boxHeight: 6,
        filter: function(legendItem, chartData) {
          return legendItem.text !== "";
        },
        sort: function(a, b, chartData) {
          return legendOrder.indexOf(a.text) - legendOrder.indexOf(b.text);
        },
        usePointStyle: true
      },
      onClick: () => null,
      position: "top"
    };
  }

  // src/scatterPlot/plugins/title.js
  function title(config) {
    return {
      display: config.displayTitle,
      text: `${config.metric} by ${config.group}`
    };
  }

  // src/scatterPlot/plugins/tooltip.js
  function tooltip2(config) {
    const tooltipAesthetics = getTooltipAesthetics();
    return {
      callbacks: {
        label: formatResultTooltipContent.bind(null, config),
        title: (data) => {
          if (data.length) {
            const groupIDs = data.map(
              (d, i) => d.dataset.data[d.dataIndex].groupid
            );
            return data.map(
              (d, i) => `${config.group} ${d.dataset.data[d.dataIndex].groupid}`
            ).join(", ");
          }
        }
      },
      custom: function(tooltipModel) {
        if (!tooltipModel.body || tooltipModel.body.length < 1) {
          tooltipModel.caretSize = 0;
          tooltipModel.xPadding = 0;
          tooltipModel.yPadding = 0;
          tooltipModel.cornerRadius = 0;
          tooltipModel.width = 0;
          tooltipModel.height = 0;
        }
      },
      filter: (data) => data.dataset.type !== "line",
      ...tooltipAesthetics
    };
  }

  // src/scatterPlot/plugins.js
  function plugins3(config) {
    const plugins6 = {
      legend: legend2(config),
      title: title(config),
      tooltip: tooltip2(config)
    };
    return plugins6;
  }

  // src/scatterPlot/getScales.js
  function getScales2(config) {
    const scales2 = getDefaultScales();
    scales2.x.grid.display = true;
    scales2.x.ticks = {
      callback: function(value, index3, context) {
        const tick = context[index3];
        return tick.major ? format(",d")(tick.value) : null;
      }
    };
    scales2.x.title.text = config.xType === "logarithmic" ? `${config.xLabel} (Log Scale)` : config.xLabel;
    scales2.x.type = config.xType;
    scales2.y.title.text = config.yLabel;
    scales2.y.type = config.yType;
    return scales2;
  }

  // src/scatterPlot/updateConfig.js
  function updateConfig2(chart, _config_, update = false) {
    const config = configure4(
      _config_,
      chart.data.datasets.find((dataset) => dataset.type === "scatter").data
    );
    chart.options.plugins = plugins3(config);
    chart.options.scales = getScales2(config);
    chart.data.config = config;
    if (update)
      chart.update();
    triggerTooltip(chart);
    return config;
  }

  // src/scatterPlot/updateData.js
  function updateData2(chart, _data_, _config_, _bounds_) {
    chart.data.config = updateConfig2(chart, _config_);
    chart.data.config.hoverEvent = addCustomHoverEvent(
      chart.canvas,
      chart.data.config.hoverCallback
    );
    chart.data.config.clickEvent = addCustomClickEvent(
      chart.canvas,
      chart.data.config.clickCallback
    );
    chart.data.datasets = structureData2(_data_, chart.data.config, _bounds_);
    chart.update();
    triggerTooltip(chart);
  }

  // src/scatterPlot/updateOption.js
  function updateOption2(chart, option, value) {
    const objPath = option.split(".");
    let obj = chart.options;
    for (let i = 0; i < objPath.length; i++) {
      if (i < objPath.length - 1)
        obj = obj[objPath[i]];
      else
        obj[objPath[i]] = value;
    }
    chart.update();
    triggerTooltip(chart);
  }

  // src/scatterPlot.js
  function scatterPlot(_element_ = "body", _data_ = [], _config_ = {}, _bounds_ = null) {
    const config = configure4(_config_, _data_);
    const canvas = addCanvas(_element_, config);
    const datasets = structureData2(_data_, config, _bounds_);
    const options = {
      animation: false,
      events: ["click", "mousemove", "mouseout"],
      interaction: {
        mode: "point"
      },
      maintainAspectRatio: config.maintainAspectRatio,
      onClick,
      onHover,
      plugins: plugins3(config),
      scales: getScales2(config)
    };
    const chart = new auto_default(canvas, {
      data: {
        datasets,
        config
      },
      options
    });
    canvas.chart = chart;
    chart.helpers = {
      updateData: updateData2,
      updateConfig: updateConfig2,
      updateOption: updateOption2
    };
    triggerTooltip(chart);
    return chart;
  }

  // src/sparkline/configure.js
  function configure5(_config_, _data_, _thresholds_) {
    const defaults3 = {};
    defaults3.type = "line";
    defaults3.x = "snapshot_date";
    defaults3.xType = "category";
    defaults3.y = "score";
    defaults3.yType = "linear";
    defaults3.color = "flag";
    defaults3.colorScheme = colorScheme_default;
    defaults3.hoverCallback = (datum2) => {
    };
    defaults3.clickCallback = (datum2) => {
      console.log(datum2);
    };
    defaults3.maintainAspectRatio = false;
    defaults3.nSnapshots = 5;
    defaults3.displayThresholds = false;
    const config = configure2(defaults3, _config_, {
      thresholds: checkThresholds.bind(null, _config_, _thresholds_)
    });
    config.annotation = ["metric", "score"].includes(config.y) ? "numerator" : config.y;
    config.dataType = ["metric", "score"].includes(config.y) ? "continuous" : "discrete";
    config.xLabel = coalesce(_config_.xLabel, "Snapshot Date");
    config.yLabel = coalesce(_config_.yLabel, config[config.y]);
    return config;
  }

  // src/sparkline/structureData/mutate.js
  function mutate3(_data_, config) {
    const data = _data_.map((d) => {
      const datum2 = {
        ...d,
        y: +d[config.y],
        stratum: Math.abs(+d[config.color])
      };
      return datum2;
    }).sort((a, b) => ascending(a.snapshot_date, b.snapshot_date));
    return data.slice(-config.nSnapshots);
  }

  // src/sparkline/structureData/scriptableOptions/borderColor.js
  function borderColor3(context, options) {
    const chart = context.chart;
    const config = chart.data.config;
    const dataset = context.dataset;
    const datum2 = dataset.data[context.dataIndex];
    if (dataset.type === "line") {
      return datum2 === dataset.data[dataset.data.length - 1] ? "black" : "rgba(0, 0, 0, 0.1)";
    }
  }

  // src/sparkline/structureData/scriptableOptions/radius.js
  function radius2(context, options) {
    const chart = context.chart;
    const config = chart.data.config;
    const dataset = context.dataset;
    const datum2 = dataset.data[context.dataIndex];
    if (dataset.type === "line") {
      return datum2 === dataset.data[dataset.data.length - 1] ? 4 : 3;
    }
  }

  // src/sparkline/structureData/scriptableOptions.js
  function scriptableOptions3() {
    return {
      borderColor: borderColor3,
      radius: radius2
    };
  }

  // src/sparkline/structureData.js
  function structureData3(_data_, config) {
    const data = mutate3(_data_, config);
    const labels = data.map((d) => d.snapshot_date);
    const pointBackgroundColor = !isNaN(data[0].stratum) ? data.map((d) => config.colorScheme[d.stratum].color) : data.map(
      (d, i) => i < data.length - 1 ? "rgba(0, 0, 0, 0.1)" : "rgba(0, 0, 0, 0.5)"
    );
    const datasets = [
      {
        type: "line",
        data: data.map((d, i) => {
          const datum2 = { ...d };
          datum2.x = i;
          datum2.y = +d[config.y];
          return datum2;
        }),
        pointBackgroundColor,
        ...scriptableOptions3()
      }
    ];
    datasets.labels = labels;
    return datasets;
  }

  // src/sparkline/plugins/annotation/thresholds.js
  function thresholds(config) {
    let thresholds2 = null;
    if (config.displayThresholds && config.thresholds) {
      thresholds2 = config.thresholds.map((threshold, i) => {
        const color3 = colorScheme_default.find(
          (color4) => color4.flag.includes(+threshold.flag)
        );
        color3.rgba.opacity = 0.5;
        const annotation2 = {
          drawTime: "beforeDatasetsDraw",
          type: "line",
          yMin: threshold.threshold,
          yMax: threshold.threshold,
          borderColor: color3.rgba + "",
          borderWidth: 1
        };
        return annotation2;
      });
    }
    return thresholds2;
  }

  // src/sparkline/plugins/annotation/value.js
  function annotations2(config, data) {
    const xMin = 0;
    const xMax = data.length - 1;
    const xValue = xMax + xMax / 50;
    const yMin = min(data, (d) => +d[config.y]);
    const yMax = max(data, (d) => +d[config.y]);
    const range = yMin === yMax ? yMin : yMax - yMin;
    const yValue = yMin === yMax ? yMin : yMin + range / 2;
    const format2 = data.every((d) => +d[config.y] % 1 === 0) ? `d` : config.y === "metric" ? `.3f` : `.1f`;
    const datum2 = data.slice(-1)[0];
    const content = [format(format2)(datum2.y)];
    const value = {
      content,
      font: {
        size: 14,
        family: "roboto",
        weight: 700
      },
      position: {
        x: "start",
        y: "center"
      },
      type: "label",
      xValue,
      yValue
    };
    return value;
  }

  // src/sparkline/plugins/annotation.js
  function annotations3(config, data) {
    const value = annotations2(config, data);
    const thresholds2 = thresholds(config);
    const annotations5 = {
      clip: false,
      annotations: [value]
    };
    if (thresholds2 !== null)
      thresholds2.forEach((threshold) => {
        annotations5.annotations.push(threshold);
      });
    return annotations5;
  }

  // src/sparkline/plugins/legend.js
  function legend3(config) {
    return {
      display: false
    };
  }

  // src/sparkline/plugins/tooltip.js
  function tooltip3(config) {
    const tooltipAesthetics = getTooltipAesthetics();
    tooltipAesthetics.padding = 4;
    tooltipAesthetics.caretSize = 0;
    return {
      callbacks: {
        label: function(data) {
          const fmt = config.y === "score" ? ".1f" : config.y === "metric" ? ".3f" : ",d";
          const date = timeFormat("'%y %b %d")(
            timeParse("%Y-%m-%d")(data.label)
          );
          return config.dataType === "continuous" ? `${date}: ${format(fmt)(data.parsed.y)}` : [
            `${date}: ${format(fmt)(data.raw.n_flagged)} flagged`,
            `${date}: ${format(fmt)(data.raw.n_at_risk)} at risk`
          ];
        },
        title: () => null,
        footer: () => null
      },
      displayColors: config.dataType === "continuous",
      ...tooltipAesthetics
    };
  }

  // src/sparkline/plugins.js
  function plugins4(config, _data_) {
    const plugins6 = {
      annotation: annotations3(config, _data_),
      legend: legend3(config),
      tooltip: tooltip3(config)
    };
    return plugins6;
  }

  // src/sparkline/getScales.js
  function getScales3(config, data) {
    const scales2 = getDefaultScales();
    scales2.x.display = false;
    scales2.x.type = config.xType;
    const yMin = min(data, (d) => d.y);
    const yMax = max(data, (d) => d.y);
    const range = yMin !== yMax ? yMax - yMin : yMin === yMax && yMin !== 0 ? yMin : 1;
    scales2.y.display = false;
    scales2.y.min = yMin - range * 0.35;
    scales2.y.max = yMax + range * 0.35;
    scales2.y.type = config.yType;
    return scales2;
  }

  // src/sparkline/updateConfig.js
  function updateConfig3(chart, _config_, update = false) {
    const config = configure5(_config_);
    chart.data.config = config;
    if (update)
      chart.update();
    return config;
  }

  // src/sparkline/updateData.js
  function updateData3(chart, _data_, _config_) {
    chart.data.config = updateConfig3(chart, _config_);
    chart.data.datasets = structureData3(_data_, chart.data.config);
    chart.data.config.hoverEvent = addCustomHoverEvent(
      chart.canvas,
      chart.data.config.hoverCallback
    );
    chart.data.config.clickEvent = addCustomClickEvent(
      chart.canvas,
      chart.data.config.clickCallback
    );
    chart.options.plugins = plugins4(
      chart.data.config,
      chart.data.datasets[0].data
    );
    chart.options.scales = getScales3(
      chart.data.config,
      chart.data.datasets[0].data
    );
    chart.update();
  }

  // src/sparkline.js
  function sparkline(_element_ = "body", _data_ = [], _config_ = {}, _thresholds_ = []) {
    const config = configure5(_config_, _data_, _thresholds_);
    const canvas = addCanvas(_element_, config);
    const datasets = structureData3(_data_, config);
    const options = {
      animation: false,
      events: ["click", "mousemove", "mouseout"],
      layout: {
        padding: {
          right: 50
        }
      },
      maintainAspectRatio: config.maintainAspectRatio,
      plugins: plugins4(config, datasets[0].data),
      scales: getScales3(config, datasets[0].data)
    };
    const chart = new auto_default(canvas, {
      data: {
        labels: datasets.labels,
        datasets,
        config
      },
      options
    });
    canvas.chart = chart;
    chart.helpers = {
      updateData: updateData3
    };
    return chart;
  }

  // src/timeSeries/configure.js
  function configure6(_config_, _data_, _thresholds_) {
    const defaults3 = {};
    defaults3.dataType = /flag|risk/.test(_config_.y) ? "discrete" : "continuous";
    if (defaults3.dataType === "discrete")
      defaults3.discreteUnit = Object.keys(_data_[0]).includes("groupid") ? "KRI" : "Site";
    else
      defaults3.discreteUnit = null;
    defaults3.type = defaults3.dataType === "discrete" ? "aggregate" : /^qtl/.test(_config_?.workflowid) ? "identity" : "boxplot";
    defaults3.x = "snapshot_date";
    defaults3.xType = "category";
    defaults3.y = "score";
    defaults3.yType = "linear";
    defaults3.colorScheme = colorScheme_default;
    defaults3.hoverCallback = (datum2) => {
    };
    defaults3.clickCallback = (datum2) => {
      console.log(datum2);
    };
    defaults3.group = "Site";
    defaults3.aggregateLabel = "Study";
    defaults3.maintainAspectRatio = false;
    const config = configure2(defaults3, _config_, {
      selectedGroupIDs: checkSelectedGroupIDs.bind(
        null,
        _config_.selectedGroupIDs,
        _data_
      ),
      thresholds: checkThresholds.bind(null, _config_, _thresholds_)
    });
    config.xLabel = coalesce(_config_.xLabel, "Snapshot Date");
    config.yLabel = coalesce(
      _config_.yLabel,
      config.dataType === "continuous" ? config[config.y] : /flag/.test(config.y) && /risk/.test(config.y) ? `At Risk or Flagged ${config.discreteUnit}s` : /flag/.test(config.y) ? `Flagged ${config.discreteUnit}s` : /risk/.test(config.y) ? `At Risk ${config.discreteUnit}s` : ""
    );
    return config;
  }

  // src/timeSeries/structureData/mutate.js
  function mutate4(_data_, config, _intervals_) {
    return _data_.map((d) => {
      const datum2 = { ...d };
      if ([void 0, null].includes(_intervals_) === false) {
        const intervals = _intervals_.filter(
          (interval2) => interval2.snapshot_date === datum2.snapshot_date
        );
        datum2.lowerCI = intervals.find(
          (interval2) => interval2.param === "LowCI"
        )?.value;
        datum2.upperCI = intervals.find(
          (interval2) => interval2.param === "UpCI"
        )?.value;
      }
      return datum2;
    }).sort((a, b) => ascending(a[config.x], b[config.x]));
  }

  // src/timeSeries/structureData/getLabels.js
  function getLabels(data, config) {
    const labels = [...new Set(data.map((d) => d[config.x]))];
    return labels;
  }

  // src/timeSeries/structureData/identityLine.js
  function identityLine(data, config, labels) {
    const aggregateData = rollup(
      data,
      (group2) => mean(group2, (d) => d[config.y]),
      (d) => d[config.x]
    );
    const color3 = "#666666";
    const backgroundColor4 = color2(color3);
    backgroundColor4.opacity = 1;
    const borderColor4 = color2(color3);
    borderColor4.opacity = 0.25;
    const dataset = {
      backgroundColor: (d) => {
        if (d.type === "dataset") {
          return backgroundColor4;
        } else {
          return config.colorScheme.find(
            (color4) => color4.flag.includes(+d.raw.flag)
          ).color;
        }
      },
      borderColor: borderColor4,
      data: [...aggregateData].map(([key, value], i) => {
        const x = labels[i];
        const y = value;
        return {
          ...data.find((d) => d[config.x] === x),
          x,
          y
        };
      }),
      label: "",
      pointStyle: "circle",
      purpose: "aggregate",
      radius: 2.5,
      type: "line"
    };
    return dataset;
  }

  // src/timeSeries/structureData/intervalLines.js
  function intervalLines(_intervals_, config, labels) {
    if (_intervals_ === null)
      return [null];
    const intervals = rollup(
      _intervals_.filter((d) => /ci/i.test(d.param)),
      (group2) => +group2[0].value,
      (d) => d.param,
      (d) => d.snapshot_date
    );
    const datasets = [...intervals].map(([key, value], i) => {
      return {
        borderColor: "#666",
        borderDash: [2],
        borderWidth: 1,
        data: [...value.values()],
        hoverRadius: 0,
        label: i === 0 ? "Confidence Interval" : "",
        pointStyle: "line",
        purpose: "aggregate",
        radius: 0,
        type: "line"
      };
    });
    return datasets;
  }

  // src/timeSeries/structureData/selectedGroupLine.js
  function selectedGroupLine(data, config, labels) {
    if (config.selectedGroupIDs.length === 0)
      return null;
    const lineData = data.filter((d) => config.selectedGroupIDs.includes(d.groupid)).map((d, i) => {
      const datum2 = { ...d };
      datum2.x = datum2[config.x];
      datum2.y = +datum2[config.y];
      return datum2;
    });
    const color3 = "black";
    const backgroundColor4 = color2(color3);
    backgroundColor4.opacity = 0.5;
    const borderColor4 = color2(color3);
    borderColor4.opacity = 0.25;
    const dataset = {
      data: lineData,
      backgroundColor: function(d) {
        const color4 = config.colorScheme.find(
          (color5) => color5.flag.includes(+d.raw?.flag)
        );
        if (color4 !== void 0)
          color4.rgba.opacity = 0.5;
        return color4 !== void 0 ? color4.rgba + "" : backgroundColor4;
      },
      borderColor: function(d) {
        const color4 = config.colorScheme.find(
          (color5) => color5.flag.includes(+d.raw?.flag)
        );
        if (color4 !== void 0)
          color4.rgba.opacity = 1;
        return color4 !== void 0 ? "black" : borderColor4;
      },
      label: "",
      pointStyle: "circle",
      purpose: "highlight",
      radius: 3,
      type: "line"
    };
    return dataset;
  }

  // src/timeSeries/structureData/atRisk.js
  function atRisk(data, config, labels) {
    const pointData = data.filter((d) => Math.abs(+d.flag) === 1).map((d) => {
      const datum2 = { ...d };
      datum2.x = datum2[config.x];
      datum2.y = +datum2[config.y];
      return datum2;
    });
    const color3 = config.colorScheme.find(
      (color4) => color4.flag.some((flag) => Math.abs(flag) === 1)
    );
    color3.rgba.opacity = 0.5;
    const dataset = {
      borderColor: color3.color,
      backgroundColor: color3.rgba + "",
      data: pointData,
      label: "",
      pointStyle: "circle",
      purpose: "scatter",
      radius: 2,
      type: "scatter"
    };
    return dataset;
  }

  // src/timeSeries/structureData/flagged.js
  function flagged(data, config, labels) {
    const pointData = data.filter((d) => Math.abs(+d.flag) > 1).map((d) => {
      const datum2 = { ...d };
      datum2.x = datum2[config.x];
      datum2.y = +datum2[config.y];
      return datum2;
    });
    const color3 = config.colorScheme.find(
      (color4) => color4.flag.some((flag) => Math.abs(flag) > 1)
    );
    color3.rgba.opacity = 0.5;
    const dataset = {
      borderColor: color3.color,
      backgroundColor: color3.rgba + "",
      data: pointData,
      label: "",
      pointStyle: "circle",
      purpose: "scatter",
      radius: 2,
      type: "scatter"
    };
    return dataset;
  }

  // src/timeSeries/structureData/distribution/boxplot.js
  function boxplot2(data, config) {
    const grouped = rollups(
      data,
      (group2) => group2.map((d) => +d[config.y]),
      (d) => d.snapshot_date
    );
    const color3 = config.colorScheme.find(
      (color4) => color4.flag.some((flag) => Math.abs(flag) === 0)
    );
    color3.rgba.opacity = 0.5;
    const dataset = {
      data: grouped.map((d) => d[1]),
      maxBarThickness: 7,
      maxWhiskerThickness: 0,
      meanRadius: /^n_/.test(config.y) ? 3 : 0,
      label: /flag|at.risk/.test(config.y) ? `Distribution` : `${config.group} Distribution`,
      outlierRadius: 0,
      pointStyle: "rect",
      purpose: "distribution",
      type: "boxplot"
    };
    return dataset;
  }

  // src/timeSeries/structureData/distribution/violin.js
  function violin(data, config) {
    const grouped = rollups(
      data,
      (group2) => group2.map((d) => +d[config.y]),
      (d) => d.snapshot_date
    );
    const color3 = config.colorScheme.find(
      (color4) => color4.flag.some((flag) => Math.abs(flag) === 0)
    );
    color3.rgba.opacity = 0.5;
    const dataset = {
      data: grouped.map((d) => d[1]),
      label: /flag|at.risk/.test(config.y) ? `Distribution` : `${config.group} Distribution`,
      purpose: "distribution",
      type: "violin"
    };
    return dataset;
  }

  // src/timeSeries/structureData/distribution.js
  function distribution(data, config, labels) {
    if (!["boxplot", "violin"].includes(config.type))
      return null;
    const dataset = config.type === "boxplot" ? boxplot2(data, config, labels) : config.type === "violin" ? violin(data, config, labels) : null;
    return dataset;
  }

  // src/timeSeries/structureData/aggregateLine.js
  function aggregateLine(data, config, labels) {
    const aggregateData = rollup(
      data,
      (group2) => mean(group2, (d) => d[config.y]),
      (d) => d[config.x]
    );
    const countsBySnapshot = rollup(
      data,
      (group2) => {
        const N = group2.length;
        return rollup(
          group2,
          (subgroup) => ({
            n: subgroup.length,
            N,
            pct: Math.round(subgroup.length / N * 100 * 10) / 10
          }),
          (d) => d[config.y]
        );
      },
      (d) => d[config.x]
    );
    const color3 = "#666666";
    const backgroundColor4 = color2(color3);
    backgroundColor4.opacity = 1;
    const borderColor4 = color2(color3);
    borderColor4.opacity = 0.25;
    const dataset = {
      backgroundColor: backgroundColor4,
      borderColor: borderColor4,
      data: [...aggregateData].map(([key, value], i) => {
        const x = labels[i];
        const y = value;
        const counts = [...countsBySnapshot.get(labels[i])];
        return {
          ...data.find((d) => d[config.x] === x),
          x,
          y,
          counts: counts.map(([key1, value1]) => {
            const countLookup = {
              ...value1
            };
            countLookup[config.y] = key1;
            return countLookup;
          }).sort((a, b) => a[config.y] - b[config.y])
        };
      }),
      label: "",
      pointStyle: "circle",
      purpose: "aggregate",
      radius: 2.5,
      type: "line"
    };
    return dataset;
  }

  // src/timeSeries/structureData.js
  function structureData4(_data_, config, _intervals_) {
    const data = mutate4(_data_, config, _intervals_);
    const labels = getLabels(data, config);
    let datasets = [];
    if (config.hasOwnProperty("workflowid") && config.dataType !== "discrete") {
      if (/^qtl/.test(config.workflowid)) {
        datasets = [
          identityLine(data, config, labels),
          ...intervalLines(_intervals_, config, labels),
          {
            type: "scatter",
            label: "Study Average",
            pointStyle: "line",
            pointStyleWidth: 24,
            boxWidth: 24,
            backgroundColor: "rgba(0,0,0,.5)",
            borderColor: "rgba(0,0,0,.25)",
            borderWidth: 3
          },
          ...colorScheme_default.map((color3) => ({
            type: "bar",
            label: color3.description,
            backgroundColor: color3.color,
            borderColor: color3.color
          }))
        ];
      } else {
        datasets = [
          selectedGroupLine(data, config, labels),
          {
            type: "scatter",
            label: config.selectedGroupIDs.length > 0 ? `${config.group} ${config.selectedGroupIDs[0]}` : "",
            pointStyle: "line",
            pointStyleWidth: 24,
            boxWidth: 24,
            backgroundColor: "rgba(0,0,0,.5)",
            borderColor: "rgba(0,0,0,.5)",
            borderWidth: 3
          },
          ...colorScheme_default.map((color3) => ({
            type: "bar",
            label: !(color3.description === "Within Thresholds" && config.selectedGroupIDs.length === 0) ? color3.description : "",
            backgroundColor: color3.color
          })),
          flagged(data, config, labels),
          atRisk(data, config, labels),
          distribution(data, config, labels)
        ];
      }
    } else if (config.dataType === "discrete") {
      datasets = [
        config.selectedGroupIDs.length > 0 ? {
          ...selectedGroupLine(data, config, labels),
          backgroundColor: "#1890FF",
          borderColor: (d) => {
            return d.raw !== void 0 ? "black" : "#1890FF";
          }
        } : null,
        {
          type: "scatter",
          label: config.selectedGroupIDs.length > 0 ? `${config.group} ${config.selectedGroupIDs[0]}` : "",
          pointStyle: "line",
          pointStyleWidth: 24,
          boxWidth: 24,
          backgroundColor: "#1890FF",
          borderColor: (d) => {
            return d.raw !== void 0 ? "black" : "#1890FF";
          },
          borderWidth: 3
        },
        aggregateLine(data, config, labels),
        {
          type: "scatter",
          label: `${config.aggregateLabel} Average`,
          pointStyle: "line",
          pointStyleWidth: 24,
          boxWidth: 24,
          backgroundColor: "rgba(0,0,0,.5)",
          borderColor: "rgba(0,0,0,.25)",
          borderWidth: 3
        }
      ];
    }
    const chartData = {
      labels,
      datasets: datasets.filter((dataset) => dataset !== null)
    };
    return chartData;
  }

  // src/timeSeries/plugins/annotations.js
  function annotations4(config) {
    let annotations5 = null;
    if (config.thresholds) {
      annotations5 = config.thresholds.map((x, i) => {
        const annotation2 = {
          adjustScaleRange: config.group === "Study",
          drawTime: "beforeDatasetsDraw",
          type: "line",
          yMin: x.threshold,
          yMax: x.threshold,
          borderColor: config.group === "Study" ? "#FD9432" : colorScheme_default.find((y) => y.flag.includes(+x.flag)).color,
          borderWidth: 1,
          borderDash: [2]
        };
        if (config.type === "identity") {
          annotation2.label = {
            rotation: "auto",
            position: Math.sign(+x.flag) >= 0 ? "end" : "start",
            color: config.group === "Study" ? "#FD9432" : colorScheme_default.find((y) => y.flag.includes(+x.flag)).color,
            backgroundColor: "white",
            content: `QTL: ${config.thresholds[0].threshold}`,
            display: true,
            font: {
              size: 12
            }
          };
        }
        return annotation2;
      });
    }
    return annotations5;
  }

  // src/timeSeries/plugins/legend.js
  function legend4(config) {
    const legendOrder = colorScheme_default.sort((a, b) => a.order - b.order).map((color3) => color3.description);
    legendOrder.unshift("Confidence Interval");
    legendOrder.unshift(`${config.aggregateLabel} Average`);
    legendOrder.unshift("Site Distribution");
    if (config.group === "Study")
      return {
        display: true,
        labels: {
          boxHeight: 7,
          filter: (legendItem, chartData) => {
            return legendItem.text !== "";
          },
          generateLabels: (chart) => chart.data.datasets.map((dataset, i) => {
            return {
              datasetIndex: i,
              fillStyle: dataset.backgroundColor,
              lineWidth: dataset.label !== "Study Average" ? 1 : 3,
              lineDash: dataset.borderDash,
              pointStyle: dataset.pointStyle,
              strokeStyle: dataset.borderColor,
              text: dataset.label
            };
          }),
          sort: function(a, b, chartData) {
            const order = legendOrder.indexOf(a.text) - legendOrder.indexOf(b.text);
            return /^Site (?!Distribution)/i.test(a.text) ? 1 : /^Site (?!Distribution)/i.test(b.text) ? -1 : order;
          },
          usePointStyle: true
        },
        onClick: () => null,
        position: "top"
      };
    else
      return {
        display: true,
        labels: {
          boxHeight: 7,
          lineWidth: 10,
          borderWidth: 10,
          filter: (legendItem, chartData) => {
            return legendItem.text !== "";
          },
          sort: function(a, b, chartData) {
            const order = legendOrder.indexOf(a.text) - legendOrder.indexOf(b.text);
            return /^Site (?!Distribution)/i.test(a.text) ? 1 : /^Site (?!Distribution)/i.test(b.text) ? -1 : order;
          },
          usePointStyle: true
        },
        onClick: () => null,
        position: "top"
      };
  }

  // src/timeSeries/plugins/tooltip.js
  function tooltip4(config) {
    const tooltipAesthetics = getTooltipAesthetics();
    return {
      callbacks: {
        label: formatResultTooltipContent.bind(null, config),
        labelPointStyle: (data) => {
          return {
            pointStyle: ["line", "scatter"].includes(data.dataset.type) ? "circle" : "rect"
          };
        },
        title: (data) => {
          if (data.length) {
            const datum2 = data[0].dataset.data[data[0].dataIndex];
            return ["boxplot", "violin"].includes(
              data[0].dataset.type
            ) === false && data[0].dataset.purpose !== "aggregate" ? `${config.group} ${datum2.groupid} on ${data[0].label}` : ["boxplot", "violin"].includes(data[0].dataset.type) ? `${config.group} Distribution on ${data[0].label}` : data[0].dataset.purpose === "aggregate" ? `${config.group} Summary on ${data[0].label}` : null;
          }
        }
      },
      displayColors: config.dataType !== "discrete",
      filter: (data) => {
        const datum2 = data.dataset.data[data.dataIndex];
        return typeof datum2 === "object" && !(config.selectedGroupIDs.includes(datum2.groupid) && data.dataset.type === "scatter");
      },
      ...tooltipAesthetics
    };
  }

  // src/timeSeries/plugins.js
  function plugins5(config) {
    return {
      annotation: {
        annotations: annotations4(config)
      },
      legend: legend4(config),
      tooltip: tooltip4(config)
    };
  }

  // src/timeSeries/getScales.js
  function getScales4(config) {
    const scales2 = getDefaultScales();
    scales2.x.title.text = config.xLabel;
    scales2.x.type = config.xType;
    scales2.y.title.text = config.yLabel;
    scales2.y.type = config.yType;
    return scales2;
  }

  // src/timeSeries/updateData.js
  function updateData4(chart, _data_, _config_, _parameters_ = null, _analysis_ = null) {
    const config = configure6(_config_, _data_, _parameters_);
    chart.data = {
      ...structureData4(_data_, config, _analysis_),
      config,
      _data_
    };
    chart.options.scales = getScales4(config);
    chart.options.plugins = plugins5(config);
    chart.update();
  }

  // src/timeSeries/updateSelectedGroupIDs.js
  function updateSelectedGroupIDs(selectedGroupIDs) {
    this.data.config.selectedGroupIDs = selectedGroupIDs;
    this.data.config = configure6(this.data.config, this.data._data_);
    this.data.datasets = structureData4(
      this.data._data_,
      this.data.config
    ).datasets;
    this.update();
  }

  // src/timeSeries.js
  function timeSeries(_element_, _data_, _config_ = {}, _thresholds_ = null, _intervals_ = null) {
    const config = configure6(_config_, _data_, _thresholds_);
    const canvas = addCanvas(_element_, config);
    const data = structureData4(_data_, config, _intervals_);
    const options = {
      animation: false,
      events: ["click", "mousemove", "mouseout"],
      maintainAspectRatio: config.maintainAspectRatio,
      onClick,
      onHover,
      plugins: plugins5(config),
      responsive: true,
      scales: getScales4(config, _data_)
    };
    const chart = new auto_default(canvas, {
      data: {
        ...data,
        config,
        _data_
      },
      options
    });
    chart.helpers = {
      updateData: updateData4.bind(chart),
      updateSelectedGroupIDs: updateSelectedGroupIDs.bind(chart)
    };
    canvas.chart = chart;
    return chart;
  }

  // src/main.js
  Chart.register(
    annotation,
    CategoryScale,
    LinearScale,
    BoxPlotController,
    BoxAndWiskers,
    ViolinController,
    Violin
  );
  var rbmViz = {
    barChart: barChart.bind({
      x: "groupid",
      y: "score",
      chartType: "bar",
      dataType: "continuous"
    }),
    barChartMetric: barChart.bind({
      x: "groupid",
      y: "metric",
      chartType: "bar",
      dataType: "continuous"
    }),
    barChartScore: barChart.bind({
      x: "groupid",
      y: "score",
      chartType: "bar",
      dataType: "continuous"
    }),
    scatterPlot: scatterPlot.bind({
      x: "denominator",
      y: "numerator",
      chartType: "scatter",
      dataType: "discrete"
    }),
    sparkline: sparkline.bind({
      x: "snapshot_date",
      y: "score",
      chartType: "line",
      dataType: "continuous"
    }),
    sparklineMetric: sparkline.bind({
      x: "snapshot_date",
      y: "metric",
      chartType: "line",
      dataType: "continuous"
    }),
    sparklineScore: sparkline.bind({
      x: "snapshot_date",
      y: "score",
      chartType: "line",
      dataType: "continuous"
    }),
    sparklineDiscrete: sparkline.bind({
      x: "snapshot_date",
      y: "n_at_risk_or_flagged",
      chartType: "line",
      dataType: "discrete"
    }),
    timeSeries: timeSeries.bind({
      x: "snapshot_date",
      y: "score",
      chartType: "boxplot",
      dataType: "continuous"
    }),
    timeSeriesScore: timeSeries.bind({
      x: "snapshot_date",
      y: "score",
      chartType: "boxplot",
      dataType: "continuous"
    }),
    timeSeriesDiscrete: timeSeries.bind({
      x: "snapshot_date",
      y: "n_at_risk_or_flagged",
      chartType: "line",
      dataType: "discrete"
    }),
    timeSeriesQTL: timeSeries.bind({
      x: "snapshot_date",
      y: "metric",
      chartType: "identity",
      dataType: "continuous"
    })
  };
  var main_default = rbmViz;
  return __toCommonJS(main_exports);
})();
/*!
 * @kurkle/color v0.2.1
 * https://github.com/kurkle/color#readme
 * (c) 2022 Jukka Kurkela
 * Released under the MIT License
 */
/*!
 * Chart.js v3.9.1
 * https://www.chartjs.org
 * (c) 2022 Chart.js Contributors
 * Released under the MIT License
 */
/*!
 * chartjs-plugin-datalabels v2.1.0
 * https://chartjs-plugin-datalabels.netlify.app
 * (c) 2017-2022 chartjs-plugin-datalabels contributors
 * Released under the MIT license
 */
/*!
* chartjs-plugin-annotation v2.0.1
* https://www.chartjs.org/chartjs-plugin-annotation/index
 * (c) 2022 chartjs-plugin-annotation Contributors
 * Released under the MIT License
 */
//# sourceMappingURL=index.js.map
