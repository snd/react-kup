# react-kup

[![NPM Package](https://img.shields.io/npm/v/react-kup.svg?style=flat)](https://www.npmjs.org/package/react-kup)
[![Build Status](https://travis-ci.org/snd/react-kup.svg?branch=master)](https://travis-ci.org/snd/react-kup/branches)
[![Sauce Test Status](https://saucelabs.com/buildstatus/reactkup)](https://saucelabs.com/u/reactkup)
[![codecov.io](http://codecov.io/github/snd/react-kup/coverage.svg?branch=master)](http://codecov.io/github/snd/react-kup?branch=master)
[![Dependencies](https://david-dm.org/snd/react-kup.svg)](https://david-dm.org/snd/react-kup)

**[react](http://facebook.github.io/react/)-[kup](https://github.com/snd/kup) is a simple, nonintrusive alternative to [JSX](https://facebook.github.io/react/docs/jsx-in-depth.html) for [coffeescript](http://coffeescript.org/)**

**[the newest version 0.5 introduces breaking changes !](CHANGELOG.md#05)**  
[see the changelog](CHANGELOG.md#05)

- use all coffeescript features naturally when building a react component's virtual-DOM in `render`
- [tiny single file with just under 100 lines of simple, readable, maintainable code in a single file](src/react-kup.coffee)
- [huge test suite](test/react-kup.coffee)
  passing [![Build Status](https://travis-ci.org/snd/react-kup.svg?branch=master)](https://travis-ci.org/snd/react-kup/branches)
  with [![codecov.io](http://codecov.io/github/snd/react-kup/coverage.svg?branch=master)](http://codecov.io/github/snd/react-kup?branch=master)
  code coverage
- continously tested in Node.js (0.12, **4.0**), io.js (2, 3) and all relevant browsers:
  [![Sauce Test Status](https://saucelabs.com/browser-matrix/reactkup.svg)](https://saucelabs.com/u/reactkup)
- supports CommonJS, [AMD](http://requirejs.org/docs/whyamd.html) and browser globals
- used in production
- npm package: `npm install react-kup`
- bower package: `bower install react-kup`
- no additional build step required
- no react mixin
- same concept as [**kup**](https://github.com/snd/kup) (kup is an html builder for nodejs)
  but builds up nested react elements instead of html strings.
- supports all tags supported by react

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
```

[look at the tests for additional examples](test/react-kup.coffee)

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
