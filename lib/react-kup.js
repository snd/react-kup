// Generated by CoffeeScript 1.9.0
var __slice = [].slice;

(function(root, factory) {
  if (('function' === typeof define) && (define.amd != null)) {
    return define(['react'], factory);
  } else if (typeof exports !== "undefined" && exports !== null) {
    return module.exports = factory(require('react'));
  } else {
    if (root.React == null) {
      throw new Error('react-kup needs react: make sure react.js is included before react-kup.js');
    }
    return root.reactKup = factory(root.React);
  }
})(this, function(React) {
  var ReactKup;
  ReactKup = function() {
    this.stack = [[]];
    return this;
  };
  ReactKup.prototype = {
    normalizeChildren: function(inputs) {
      var normalizeChildren, outputs, stack;
      stack = this.stack;
      normalizeChildren = this.normalizeChildren.bind(this);
      outputs = [];
      inputs.forEach(function(input) {
        if (React.isValidElement(input)) {
          return outputs.push(input);
        } else if ('function' === typeof input) {
          stack.unshift([]);
          input();
          return outputs = outputs.concat(stack.shift());
        } else if (Array.isArray(input)) {
          return outputs = outputs.concat(normalizeChildren(input));
        } else if (input) {
          return outputs.push(input);
        }
      });
      return outputs;
    },
    build: function() {
      var children, config, element, isCurrentLevelEmpty, isToplevel, isValidConfig, normalized, type;
      type = arguments[0], config = arguments[1], children = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      isToplevel = this.stack.length === 1;
      isCurrentLevelEmpty = this.stack[0].length === 0;
      if (isToplevel && !isCurrentLevelEmpty) {
        throw new Error('only one tag allowed on toplevel but you are trying to add a second one');
      }
      if (React.isValidElement(type)) {
        if ((config != null) || children.length !== 0) {
          throw new Error('first argument to .build() is already a react element. in this case additional arguments are not allowed.');
        }
        this.stack[0].push(type);
        return type;
      }
      isValidConfig = 'object' === typeof config && !React.isValidElement(config) && !Array.isArray(config);
      if (!isValidConfig) {
        children.unshift(config);
        config = {};
      }
      normalized = this.normalizeChildren(children);
      element = React.createElement.apply(React, [type, config].concat(__slice.call(normalized)));
      this.stack[0].push(element);
      return element;
    },
    element: function() {
      return this.stack[0][0] || null;
    }
  };
  Object.keys(React.DOM).forEach(function(tagName) {
    if (ReactKup.prototype[tagName] != null) {
      throw new Error("React.DOM." + tagName + " is shadowing existing method ReactKup.prototype." + tagName);
    }
    return ReactKup.prototype[tagName] = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return this.build.apply(this, [tagName].concat(__slice.call(args)));
    };
  });
  return function(callback) {
    var kup;
    kup = new ReactKup;
    if (callback != null) {
      callback(kup);
      return kup.element();
    } else {
      return kup;
    }
  };
});