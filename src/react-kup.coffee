react = require 'react'
DOM = react.DOM

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

ReactKupPrototype =
  text: (text) ->
    this.push text
  push: (component) ->
    this.contentStack[this.contentStack.length - 1].push component
  component: (tagNameOrConstructor, attrsOrContent, optionalContent) ->
    attrs = if typeof attrsOrContent isnt 'object' then {} else attrsOrContent

    content = if typeof attrsOrContent isnt 'object' then attrsOrContent else optionalContent

    contents =
      if typeof content is 'function'
        this.contentStack.push []
        content()
        this.contentStack.pop()
      else if content?
        [content]
      else
        []

    component =
      switch typeof tagNameOrConstructor
        when 'string'
          DOM[tagNameOrConstructor] attrs, contents...
        when 'function'
          new tagNameOrConstructor attrs, contents...
        else
          throw new Error 'first argument to component must be a string or function'

     this.push component

for tagName in tagNames
  do (tagName) ->
      ReactKupPrototype[tagName] = (attrs, content) ->
        this.component tagName, attrs, content

newReactKup = ->
  reactKup = Object.create ReactKupPrototype
  reactKup.contentStack = []
  reactKup.contentStack.push []
  return reactKup

module.exports = (cb) ->
  k = newReactKup()

  if cb?
    cb k
    contentStackTop = k.contentStack[k.contentStack.length - 1]
    return contentStackTop[0]
  else
    return k
