test = require 'tape'
React = require 'react'
ReactDOMServer = require 'react-dom/server'

reactKup = require('../lib/react-kup')

removeReactAttributes = (string) ->
  string.replace(/\ data-react[^=]*="[^"]*"/g, '')

elementToString = (element) ->
  html = ReactDOMServer.renderToString element
  removeReactAttributes html

removeLayout = (string) ->
  string.replace(/\n\s*/g, '')

elementProducesMarkup = (element, markup) ->
  actual = elementToString(element)
  expected = removeLayout(markup)
  actual is expected

test 'single div', (t) ->
  element = reactKup (k) ->
    k.div "Hello world"

  t.ok elementProducesMarkup element, """
    <div>Hello world</div>
  """
  t.end()

test 'build', (t) ->

  t.test 'tag', (t) ->
    element = reactKup (k) ->
      k.build 'div'
    t.ok elementProducesMarkup element, """
      <div></div>
    """
    t.end()

  t.test 'tag + attrs', (t) ->
    element = reactKup (k) ->
      k.build 'div', {className: 't'}
    t.ok elementProducesMarkup element, """
      <div class="t"></div>
    """
    t.end()

  t.test 'tag + attrs', (t) ->
    element = reactKup (k) ->
      k.build 'div', {className: 't'}
    t.ok elementProducesMarkup element, """
      <div class="t"></div>
    """
    t.end()

  t.test 'tag + attrs + text', (t) ->
    element = reactKup (k) ->
      k.build 'div', {className: 't'}, 'this is a test'
    t.ok elementProducesMarkup element, """
      <div class="t">this is a test</div>
    """
    t.end()

  t.test 'tag + attrs + function', (t) ->
    element = reactKup (k) ->
      k.build 'div', {className: 't'}, ->
        k.build 'a', 'hey there'
    t.ok elementProducesMarkup element, """
      <div class="t"><a>hey there</a></div>
    """
    t.end()

  t.test 'tag + attrs + element', (t) ->
    div = reactKup (k) ->
      k.div 'hey there'
    element = reactKup (k) ->
      k.build 'div', {className: 't'}, div
    t.ok elementProducesMarkup element, """
      <div class="t"><div>hey there</div></div>
    """
    t.end()

  t.test 'tagName + attrs + mixed contents', (t) ->
    element = reactKup (k) ->
      k.build 'div', {className: 't'},
        ->
          k.build 'div', 'hey'
        'this is a t'
        reactKup (l) ->
          l.build 'a', 'there'
    t.ok elementProducesMarkup element, """
      <div class="t">
        <div>hey</div>
        <span>this is a t</span>
        <a>there</a>
      </div>
    """
    t.end()

  t.test 'existing element', (t) ->
    div = reactKup (k) ->
      k.div 'hey there'

    element = reactKup (k) ->
      k.build div
    t.ok elementProducesMarkup element, """
      <div>hey there</div>
    """
    t.end()

  t.test 'existing element with wrapper', (t) ->
    span = reactKup (k) ->
      k.span 'hey there'

    element = reactKup (k) ->
      k.p ->
        k.build span
    t.ok elementProducesMarkup element, """
      <p><span>hey there</span></p>
    """
    t.end()

test 'alternative API', (t) ->
  k = reactKup()
  k.build 'div', {className: 't'}
  t.ok elementProducesMarkup k.element(), """
    <div class="t"></div>
  """
  t.end()

test 'error', (t) ->

  t.test 'only one tag allowed on toplevel', (t) ->
    reactKup (k) ->
      k.p 't'
      try
        k.p 'fail'
      catch e
        t.equal e.message, 'only one tag allowed on toplevel but you are trying to add a second one'
        t.end()

  t.test 'when build is given react element additional arguments are forbidden', (t) ->
    div = reactKup (k) ->
      k.div()

    reactKup (k) ->
      try
        k.build div, {className: 'foo'}
      catch e
        t.equal e.message, 'first argument to .build() is already a react element. in this case additional arguments are not allowed.'
        t.end()

test 'empty', (t) ->

  t.test 'returns null', (t) ->
    t.equal null, reactKup (k) ->
      t.end()

  t.test 'produces noscript tag', (t) ->
    Class = React.createClass
      render: ->
        reactKup (k) ->
    element = React.createElement Class
    t.ok elementProducesMarkup element, """
      <noscript></noscript>
    """
    t.end()

test 'inner text content', (t) ->

  t.test 'one is not wrapped in span', (t) ->
    Class = React.createClass
      render: ->
        reactKup (k) ->
          k.div 'inner text'
    element = React.createElement Class
    t.ok elementProducesMarkup element, """
      <div>inner text</div>
    """
    t.end()

  t.test 'more than one is wrapped in span', (t) ->
    Class = React.createClass
      render: ->
        reactKup (k) ->
          k.div 'inner text', 'another inner text'
    element = React.createElement Class
    t.ok elementProducesMarkup element, """
      <div>
        <span>inner text</span>
        <span>another inner text</span>
      </div>
    """
    t.end()

  t.test 'interspersed is wrapped in span', (t) ->
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
    t.ok elementProducesMarkup element, """
      <div>
        <span>text in span</span>
        <span>inner text</span>
        <br/>
        <span>another inner text</span>
      </div>
    """
    t.end()

test 'nested', (t) ->
  element = reactKup (k) ->
    k.div {className: 'wrapper'}, ->
      k.h1 {id: 'heading'}, "Heading"
      k.p ->
        k.span "hello"
        k.br()
        k.span "world"
      k.h2 "Heading"

  t.ok elementProducesMarkup element, """
    <div class="wrapper">
      <h1 id="heading">Heading</h1>
      <p>
        <span>hello</span>
        <br/>
        <span>world</span>
      </p>
      <h2>Heading</h2>
    </div>
  """

  t.end()

test 'composition', (t) ->
  items = ['Buy Milk', 'Buy Sugar']
  createItem = (itemText) ->
    reactKup (k) ->
      k.li itemText
  element = reactKup (k) ->
    k.ul items.map createItem

  t.ok elementProducesMarkup element, """
    <ul>
      <li>Buy Milk</li>
      <li>Buy Sugar</li>
    </ul>
  """

  t.end()

test 'simple react example', (t) ->
  HelloMessage = React.createClass
    render: ->
      that = this
      reactKup (k) ->
        k.div "Hello #{that.props.name}"

  element = React.createElement HelloMessage,
    name: 'John'

  t.ok elementProducesMarkup element, """
    <div>Hello John</div>
  """

  t.end()

test 'complex react example', (t) ->
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

  t.ok elementProducesMarkup element, """
    <div>
      <h3>TODO</h3>
      <ul>
        <li>Buy Milk</li>
        <li>Buy Sugar</li>
      </ul>
      <form>
        <input value="Add #3"/>
        <button>Add #3</button>
      </form>
    </div>
  """

  t.end()

test 'another complex react example', (t) ->

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

  t.ok elementProducesMarkup element, """
    <div class="row">
      <div>
        <h1>faq</h1>
        <div class="page-markdown">
          <b>unsafe</b>
        </div>
      </div>
    </div>
  """

  t.end()
