# react-kup

[![NPM Package](https://img.shields.io/npm/v/react-kup.svg?style=flat)](https://www.npmjs.org/package/react-kup)
[![Build Status](https://travis-ci.org/snd/react-kup.svg?branch=master)](https://travis-ci.org/snd/react-kup/branches)
[![Sauce Test Status](https://saucelabs.com/buildstatus/reactkup)](https://saucelabs.com/u/reactkup)
[![coverage-92%](http://img.shields.io/badge/coverage-92%-brightgreen.svg?style=flat)](https://rawgit.com/snd/react-kup/master/coverage/lcov-report/lib/react-kup.js.html)
[![Dependencies](https://david-dm.org/snd/react-kup.svg)](https://david-dm.org/snd/react-kup)

**[react](http://facebook.github.io/react/)-[kup](https://github.com/snd/kup) is a simple, nonintrusive alternative to [JSX](https://facebook.github.io/react/docs/jsx-in-depth.html) for [coffeescript](http://coffeescript.org/)**

**[the newest version 0.4 introduces breaking changes !](CHANGELOG.md#04)**  
[see the changelog](CHANGELOG.md#04)

[![Sauce Test Status](https://saucelabs.com/browser-matrix/reactkup.svg)](https://saucelabs.com/u/reactkup)

```coffeescript
TodoItem = React.createClass
  render: ->
    # when called with a callback `reactKup` 
    # calls the callback with `k` and
    # returns result of all calls on `k`
    reactKup (k) =>
      if that.props.item.isDone
        k.li {

TodoList = React.createClass
  render: ->
    # when called without a callback `reactKup` returns a builder `k`
    k = reactKup()

    if @props.isHello
      k.div "Hello #{that.props.name}"
    else
      k.div "Goodbye #{that.props.name}"

    k.ul ->
      for i in [1...5]
        k.li i

    k.build

    # return result explicitely
    return k.result()

```

[see the full examples below](#examples)

**easy:** use all javascript/coffeescript features naturally
when building a react component's virtual-DOM.
as opposed to

flexible
https://github.com/kalasjocke/react-coffee-elements

**lightweight:** single file ([lib/react-kup.js](lib/react-kup.js)) with just under 100 lines.

**nonintrusive:** [no mixins.]( [no compilation.](https://github.com/jsdf/coffee-react-transform) [no `this` magic.](https://github.com/mvc-works/coffee-react-dom)
integration with react.

**portable:** works with CommonJS (NodeJS), AMD or without any module system.

**stable:** [extensive tests.](test/) and used in production.

it uses the same concept as [**kup**](https://github.com/snd/kup) (kup is an html builder for nodejs)
but builds up nested react elements instead of html strings.

- works
- no additional build step required
- no mixin. though you could build one yourself.

```
npm install react-kup
```

has all the methods of `React.DOM`

### CommonJS (NodeJS)

``` js
var reactKup = require('react-kup');
```

### AMD

``` js
define('my-module', ['react-kup'], function(reactKup) {
  // ...
});
```

### browser

when no module system is present including [lib/react-kup.js](lib/react-kup.js)
sets the global `reactKup`:

```html
<script src="react.js" type="text/javascript"></script>
<script src="react-kup.js" type="text/javascript"></script>
```

*its best to fetch react with [bower](http://bower.io/), [react-kup with npm](https://www.npmjs.org/package/react-kup) and then use
a build system like [gulp](http://gulpjs.com/) to bring everything together*

## example

```coffeescript
reactKup = require('react-kup')

HelloMessage = React.createClass
  render: ->
    that = this
    reactKup (k) ->
      k.div "Hello #{that.props.name}"

component = new HelloMessage({name: 'John'})

React.renderComponentToString component
# => <div>Hello John</div>
```

### `example.coffee` (assumed to be compiled to `example.js`)

```coffeescript
HelloMessage = React.createClass
  render: ->
    that = this
    reactKup (k) ->
      k.div "Hello #{that.props.name}"

init = ->
  mountNode = document.getElementById('my-app')
  component = new HelloMessage({name: 'John'})

  React.renderComponent component, mountNode
```

```coffeescript
HelloMessage = React.createClass
  render: ->
    that = this
    k = reactKup()
    k.div "Hello #{that.props.name}"
    # throws
    k.div k
    k.element()
    k.peek()

init = ->
  mountNode = document.getElementById('my-app')
  component = new HelloMessage({name: 'John'})

  React.renderComponent component, mountNode
```

## changelog

### 0.4.0

- `.component` method renamed to `.build`
- the `.text` method now uses `React.DOM.text` which gets wrapped in a `span` tag.
- added AMD support
- removed deprecation warnings for react 0.12.2
- react-kup now comes with a version of react (0.12.0) caused confusion
- supports both react-classes and react-elements as arguments to `.build`
- supports react elements as content

## contribution

**TL;DR: bugfixes, issues and discussion are always welcome.
ask me before implementing new features.**

i will happily merge pull requests that fix bugs with reasonable code.

i will only merge pull requests that modify/add functionality
if the changes align with my goals for this package
and only if the changes are well written, documented and tested.

**communicate:** write an issue to start a discussion
before writing code that may or may not get merged.

## [license: MIT](LICENSE)
