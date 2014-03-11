React = require 'react'
DOM = React.DOM

tagNames = """
  a abbr address area article aside audio b base bdi bdo big blockquote body br
  button canvas caption cite code col colgroup data datalist dd del details dfn
  div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6
  head header hr html i iframe img input ins kbd keygen label legend li link main
  map mark menu menuitem meta meter nav noscript object ol optgroup option output
  p param pre progress q rp rt ruby s samp script section select small source
  span strong style sub summary sup table tbody td textarea tfoot th thead time
  title tr track u ul var video wbr circle g line path polyline rect svg
""".split(/\s+/)

isReactComponent = (object) ->
  if not object or not object.type or not object.type.prototype
    return false
  prototype = object.type.prototype
  ('function' is typeof prototype.mountComponentIntoNode) and
  ('function' is typeof prototype.receiveComponent)

isAttrs = (value) ->
  'object' is typeof value and not isReactComponent(value) and not Array.isArray value

ReactKupPrototype =
  text: (text) ->
    this.push text
  push: (child) ->
    this.childrenStack[this.childrenStack.length - 1].push child
  children: (content) ->
    if isReactComponent content
      [content]
    else if typeof content is 'function'
      this.childrenStack.push []
      content()
      children = this.childrenStack.pop()
      children
    else if Array.isArray content
      [].concat content.map this.children.bind this
    else if content?
      [content]
    else
      []
  component: (tagNameOrConstructor, attrsOrContent, optionalContent) ->
    attrs = if isAttrs attrsOrContent then attrsOrContent else {}

    content =
      if optionalContent? then optionalContent
      else if not isAttrs attrsOrContent then attrsOrContent

    children = this.children content

    component =
      switch typeof tagNameOrConstructor
        when 'string'
          DOM[tagNameOrConstructor] attrs, children...
        when 'function'
          new tagNameOrConstructor attrs, children...
        else
          throw new Error 'first argument to component must be a string or function'

     this.push component

for tagName in tagNames
  do (tagName) ->
      ReactKupPrototype[tagName] = (attrs, content) ->
        this.component tagName, attrs, content

newReactKup = ->
  reactKup = Object.create ReactKupPrototype
  reactKup.childrenStack = []
  reactKup.childrenStack.push []
  return reactKup

module.exports = (cb) ->
  k = newReactKup()

  if cb?
    cb k
    childrenStackTop = k.childrenStack[k.childrenStack.length - 1]
    return childrenStackTop[0]
  else
    return k
