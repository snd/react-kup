((root, factory) ->
  # AMD
  if ('function' is typeof define) and define.amd?
    define(['react'], factory)
  # CommonJS
  else if exports?
    module.exports = factory(require('react'))
  # browser globals
  else
    unless root.React?
      throw new Error(
        'react-kup needs react:
         make sure react.js is included before react-kup.js'
      )
    root.reactKup = factory(root.React)
)(this, (React) ->
  ReactKup = ->
    this.stack = [[]]
    return this

  ReactKup.prototype =
    normalizeChildren: (inputs) ->
      stack = this.stack
      normalizeChildren = this.normalizeChildren.bind this
      outputs = []
      inputs.forEach (input) ->
        if React.isValidElement input
          outputs.push input
        else if 'function' is typeof input
          # collect all that the `input` function will add on this stack level
          stack.unshift []
          input()
          outputs = outputs.concat stack.shift()
        else if Array.isArray input
          # recurse into arrays
          outputs = outputs.concat normalizeChildren input
        else if input
          outputs.push input
      return outputs

    build: (type, config, children...) ->
      isToplevel = this.stack.length is 1
      isCurrentLevelEmpty = this.stack[0].length is 0

      if isToplevel and not isCurrentLevelEmpty
        throw new Error(
          'only one tag allowed on toplevel
           but you are trying to add a second one'
        )

      if React.isValidElement type
        if config? or children.length isnt 0
          throw new Error(
            'first argument to .build() is already a react element.
             in this case additional arguments are not allowed.'
          )
        this.stack[0].push type
        return type

      isValidConfig = 'object' is typeof config and
        not React.isValidElement(config) and
        not Array.isArray(config)

      unless isValidConfig
        # treat config as first child
        children.unshift config
        config = {}

      normalized = this.normalizeChildren children
      element = React.createElement type, config, normalized...
      this.stack[0].push element
      return element

    element: ->
      this.stack[0][0] or null

  # add a method for every tag react supports to the builder

  Object.keys(React.DOM).forEach (tagName) ->
    if ReactKup.prototype[tagName]?
      throw new Error(
        "React.DOM.#{tagName} is shadowing
        existing method ReactKup.prototype.#{tagName}"
      )
    ReactKup.prototype[tagName] = (args...) ->
      this.build tagName, args...

  # export

  return (callback) ->
    kup = new ReactKup

    if callback?
      callback kup
      return kup.element()
    else
      return kup
)
