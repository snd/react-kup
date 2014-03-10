react = require 'react'
DOM = react.DOM

reactKup = require '../src/react-kup'

removeReactAttributes = (string) ->
  string.replace(/\ data-react[^=]*="[^"]*"/g, '')

componentToString = (component) ->
  html = react.renderComponentToString component
  removeReactAttributes html

removeLayout = (string) ->
  string.replace(/\n\s*/g, '')

componentMatchesMarkup = (component, markup) ->
  componentToString(component) is removeLayout(markup)

module.exports =

  'single div': (test) ->
    component = reactKup (k) ->
      k.div "Hello world"

    test.ok componentMatchesMarkup component, """
      <div>Hello world</div>
    """

    test.done()

  'nested': (test) ->
    component = reactKup (k) ->
      k.div {className: 'wrapper'}, ->
        k.h1 {id: 'heading'}, "Heading"
        k.p ->
          k.text "hello"
          k.br()
          k.text "world"
        k.h2 "Heading"

    test.ok componentMatchesMarkup component, """
      <div class="wrapper">
        <h1 id="heading">Heading</h1>
        <p>
          <span>hello</span>
          <br>
          <span>world</span>
        </p>
        <h2>Heading</h2>
      </div>
    """

    test.done()

  'react example': (test) ->
    HelloMessage = react.createClass
      render: ->
        that = this
        reactKup (k) ->
          k.div "Hello #{that.props.name}"

    component = new HelloMessage
      name: 'John'

    test.ok componentMatchesMarkup component, """
      <div>Hello John</div>
    """

    test.done()
