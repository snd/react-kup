React = require 'react/addons'

reactKup = require('../src/react-kup')

removeReactAttributes = (string) ->
  string.replace(/\ data-react[^=]*="[^"]*"/g, '')

elementToString = (element) ->
  html = React.renderToString element
  removeReactAttributes html

removeLayout = (string) ->
  string.replace(/\n\s*/g, '')

elementProducesMarkup = (element, markup) ->
  actual = elementToString(element)
  expected = removeLayout(markup)

  # console.log 'actual   =', actual
  # console.log 'expected =', expected

  actual is expected

module.exports =

  'build':

    'tag': (test) ->
      element = reactKup (k) ->
        k.build 'div'
      test.ok elementProducesMarkup element, """
        <div></div>
      """
      test.done()

    'tag + attrs': (test) ->
      element = reactKup (k) ->
        k.build 'div', {className: 'test'}
      test.ok elementProducesMarkup element, """
        <div class="test"></div>
      """
      test.done()

    'tag + attrs': (test) ->
      element = reactKup (k) ->
        k.build 'div', {className: 'test'}
      test.ok elementProducesMarkup element, """
        <div class="test"></div>
      """
      test.done()

    'tag + attrs + text': (test) ->
      element = reactKup (k) ->
        k.build 'div', {className: 'test'}, 'this is a test'
      test.ok elementProducesMarkup element, """
        <div class="test">this is a test</div>
      """
      test.done()

    'tag + attrs + function': (test) ->
      element = reactKup (k) ->
        k.build 'div', {className: 'test'}, ->
          k.build 'a', 'hey there'
      test.ok elementProducesMarkup element, """
        <div class="test"><a>hey there</a></div>
      """
      test.done()

    'tag + attrs + element': (test) ->
      div = reactKup (k) ->
        k.div 'hey there'
      element = reactKup (k) ->
        k.build 'div', {className: 'test'}, div
      test.ok elementProducesMarkup element, """
        <div class="test"><div>hey there</div></div>
      """
      test.done()

    'tagName + attrs + mixed contents': (test) ->
      element = reactKup (k) ->
        k.build 'div', {className: 'test'},
          ->
            k.build 'div', 'hey'
          'this is a test'
          reactKup (l) ->
            l.build 'a', 'there'
      test.ok elementProducesMarkup element, """
        <div class="test">
          <div>hey</div>
          <span>this is a test</span>
          <a>there</a>
        </div>
      """
      test.done()

    'existing element': (test) ->
      div = reactKup (k) ->
        k.div 'hey there'

      element = reactKup (k) ->
        k.build div
      test.ok elementProducesMarkup element, """
        <div>hey there</div>
      """
      test.done()

    'existing element with wrapper': (test) ->
      div = reactKup (k) ->
        k.div 'hey there'

      element = reactKup (k) ->
        k.p ->
          k.build div
      test.ok elementProducesMarkup element, """
        <p><div>hey there</div></p>
      """
      test.done()

  'alternative API': (test) ->
    k = reactKup()
    k.build 'div', {className: 'test'}
    test.ok elementProducesMarkup k.element(), """
      <div class="test"></div>
    """
    test.done()

  'fail':

    'only one tag allowed on toplevel': (test) ->
      reactKup (k) ->
        k.p 'test'
        try
          k.p 'fail'
        catch e
          test.equal e.message, 'only one tag allowed on toplevel but you are trying to add a second one'
          test.done()

    'when build is given react element additional arguments are forbidden': (test) ->
      div = reactKup (k) ->
        k.div()

      reactKup (k) ->
        try
          k.build div, {className: 'foo'}
        catch e
          test.equal e.message, 'first argument to .build() is already a react element. in this case additional arguments are not allowed.'
          test.done()

  'empty':

    'returns null': (test) ->
      test.equal null, reactKup (k) ->
        test.done()

    'produces noscript tag': (test) ->
      Class = React.createClass
        render: ->
          reactKup (k) ->
      element = React.createElement Class
      test.ok elementProducesMarkup element, """
        <noscript></noscript>
      """
      test.done()

  'inner text content':

    'one is not wrapped in span': (test) ->
      Class = React.createClass
        render: ->
          reactKup (k) ->
            k.div 'inner text'
      element = React.createElement Class
      test.ok elementProducesMarkup element, """
        <div>inner text</div>
      """
      test.done()

    'more than one is wrapped in span': (test) ->
      Class = React.createClass
        render: ->
          reactKup (k) ->
            k.div 'inner text', 'another inner text'
      element = React.createElement Class
      test.ok elementProducesMarkup element, """
        <div>
          <span>inner text</span>
          <span>another inner text</span>
        </div>
      """
      test.done()

    'interspersed is wrapped in span': (test) ->
      Class = React.createClass
        render: ->
          reactKup (k) ->
            k.div(
              -> k.span 'text in span'
              'inner text'
              -> k.br()
              'another inner text'
            )
      element = React.createElement Class
      test.ok elementProducesMarkup element, """
        <div>
          <span>text in span</span>
          <span>inner text</span>
          <br>
          <span>another inner text</span>
        </div>
      """
      test.done()

  'single div': (test) ->
    element = reactKup (k) ->
      k.div "Hello world"

    test.ok elementProducesMarkup element, """
      <div>Hello world</div>
    """

    test.done()

  'nested': (test) ->
    element = reactKup (k) ->
      k.div {className: 'wrapper'}, ->
        k.h1 {id: 'heading'}, "Heading"
        k.p ->
          k.span "hello"
          k.br()
          k.span "world"
        k.h2 "Heading"

    test.ok elementProducesMarkup element, """
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
    element = reactKup (k) ->
      k.ul items.map createItem

    test.ok elementProducesMarkup element, """
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

    element = React.createElement HelloMessage,
      name: 'John'

    test.ok elementProducesMarkup element, """
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
            k.build TodoList,
              items: that.state.items
            k.form {
              onSubmit: that.handleSubmit
            }, ->
              k.input
                onChange: that.onChange
                value: that.state.text
              k.button "Add ##{that.state.items.length + 1}"

    element = React.createElement TodoApp

    test.ok elementProducesMarkup element, """
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

  'another complex react example': (test) ->

    ComponentPublicPageContent = React.createClass
      render: ->
        that = this

        reactKup (k) ->
          k.div ->
            k.h1 "#{that.props.page.title}"
            k.div
              className: "page-markdown"
              dangerouslySetInnerHTML:
                __html: "<b>unsafe</b>"

    ComponentPublicPage = React.createClass
      render: ->
        that = this
        reactKup (k) ->
          k.div className: "row", ->
            k.build ComponentPublicPageContent, {page: that.props.page}

    element = React.createElement ComponentPublicPage,
      page:
        title: 'faq'

    test.ok elementProducesMarkup element, """
      <div class="row">
        <div>
          <h1>faq</h1>
          <div class="page-markdown">
            <b>unsafe</b>
          </div>
        </div>
      </div>
    """

    test.done()
