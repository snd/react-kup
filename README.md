# react-kup

[![NPM Package](https://img.shields.io/npm/v/react-kup.svg?style=flat)](https://www.npmjs.org/package/react-kup)
[![Build Status](https://travis-ci.org/snd/react-kup.svg?branch=master)](https://travis-ci.org/snd/react-kup/branches)
[![Sauce Test Status](https://saucelabs.com/buildstatus/reactkup)](https://saucelabs.com/u/reactkup)
[![coverage-92%](http://img.shields.io/badge/coverage-92%-brightgreen.svg?style=flat)](https://rawgit.com/snd/react-kup/master/coverage/lcov-report/lib/react-kup.js.html)
[![Dependencies](https://david-dm.org/snd/react-kup.svg)](https://david-dm.org/snd/react-kup)

**[react](http://facebook.github.io/react/)-[kup](https://github.com/snd/kup) is a simple, nonintrusive alternative to [JSX](https://facebook.github.io/react/docs/jsx-in-depth.html) for [coffeescript](http://coffeescript.org/)**

**[the newest version 0.5 introduces breaking changes !](CHANGELOG.md#05)**  
[see the changelog](CHANGELOG.md#05)

- use all coffeescript features naturally when building a react component's virtual-DOM
- supports Node.js, [AMD](http://requirejs.org/docs/whyamd.html) and browsers
- [tiny with just under 100 lines of simple, readable, maintainable code in a single file](src/react-kup.coffee)
- [huge test suite](test) with [92% test coverage](https://rawgit.com/snd/react-kup/master/coverage/lcov-report/lib/react-kup.js.html)
- tests pass in all relevant browsers  
  [![Sauce Test Status](https://saucelabs.com/browser-matrix/reactkup.svg)](https://saucelabs.com/u/reactkup)
- used in production
- npm package: `npm install react-kup`
- bower package: `bower install react-kup`
- no additional build step required
- no mixin required. though you could easily build one if you prefer.
- it uses the same concept as [**kup**](https://github.com/snd/kup) (kup is an html builder for nodejs)
  but builds up nested react elements instead of html strings.

```
npm install react-kup
```

```
bower install react-kup
```

``` javascript
> var reactKup = require('react-kup');
```

[lib/react-kup.js](lib/react-kup.js) supports [AMD](http://requirejs.org/docs/whyamd.html).  
when used in the browser and [AMD](http://requirejs.org/docs/whyamd.html) is not available it sets the global variable `reactKup`.

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

has all the methods of `React.DOM`

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

### [contributing](contributing.md)

**bugfixes, issues and discussion are always welcome.  
kindly [ask](https://github.com/snd/url-pattern/issues/new) before implementing new features.**

i will happily merge pull requests that fix bugs with reasonable code.

i will only merge pull requests that modify/add functionality
if the changes align with my goals for this package,
are well written, documented and tested.

**communicate !**  
[write an issue](https://github.com/snd/url-pattern/issues/new) to start a discussion before writing code that may or may not get merged.

[This project adheres to the Contributor Covenant 1.2](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to kruemaxi@gmail.com.

## [license: MIT](LICENSE)
