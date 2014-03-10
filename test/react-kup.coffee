React = require 'react/addons'
DOM = React.DOM

reactKup = require '../src/react-kup'

removeReactAttributes = (string) ->
  string.replace(/\ data-react[^=]*="[^"]*"/g, '')

componentToString = (component) ->
  html = React.renderComponentToString component
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

  'composition': (test) ->
    items = ['Buy Milk', 'Buy Sugar']
    createItem = (itemText) ->
      reactKup (k) ->
        k.li itemText
    component = reactKup (k) ->
      k.ul items.map createItem

    test.ok componentMatchesMarkup component, """
      <ul>
        <li>Buy Milk</li>
        <li>Buy Sugar</li>
      </ul>
    """

    test.done()

  'simple react example': (test) ->
    HelloMessage = React.createClass
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

  'complex react example': (test) ->
    TodoList = React.createClass
      render: ->
        that = this
        createItem = (itemText) ->
          reactKup (k) ->
            k.li itemText
        reactKup (k) ->
          k.ul that.props.items.map createItem

    TodoApp = React.createClass
      getInitialState: ->
        items: ['Buy Milk', 'Buy Sugar']
        text: 'Add #3'
      onChange: (e) ->
        this.setState({text: e.target.value})
      handleSubmit: (e) ->
        e.preventDefault()
        nextItems = this.state.items.concat([this.state.text])
        nextText = ''
        this.setState({items: nextItems, text: nextText})
      render: ->
        that = this

        reactKup (k) ->
          k.div ->
            k.h3 'TODO'
            k.component TodoList,
              items: that.state.items
            k.form {
              onSubmit: that.handleSubmit
            }, ->
              k.input
                onChange: that.onChange
                value: that.state.text
              k.button "Add ##{that.state.items.length + 1}"

    component = new TodoApp

    test.ok componentMatchesMarkup component, """
      <div>
        <h3>TODO</h3>
        <ul>
          <li>Buy Milk</li>
          <li>Buy Sugar</li>
        </ul>
        <form>
          <input value="Add #3">
          <button>Add #3</button>
        </form>
      </div>
    """

    test.done()
