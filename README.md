# react-kup

[![Build Status](https://travis-ci.org/snd/react-kup.png)](https://travis-ci.org/snd/react-kup)

**react-kup is a simple, non-intrusive alternative to [jsx](https://facebook.github.io/react/docs/jsx-in-depth.html) for coffeescript**

[it's like **kup** but constructs react dom components instead of html strings](https://github.com/snd/kup)

react-kup works in [node.js](#nodejs) and the [browser](#browser)

react-kup has been tested against `react@0.11.0` (recommended) and `react@0.10.0`

## browser

your development markup should look something like the following

```html
<html>
  <body>
    <div id="my-app"></div>
    <!-- react-kup doesn't come with react. include the newest react: -->
    <script type="text/javascript" src="http://fb.me/react-0.11.0.js"></script>
    <!-- take src/react-kup.js from this repository and include it -->
    <script type="text/javascript" src="react-kup.js"></script>
    <!-- example.js is assumed to be compiled from example.coffee below -->
    <script type="text/javascript" src="example.js"></script>
    <!-- call init from example.coffee below -->
    <script type="text/javascript">init();</script>
  </body>
</html>
```

[react-kup.js](src/react-kup.js) makes the global variable `newReactKup`
available

*its best to fetch react with [bower](http://bower.io/), [react-kup with npm](https://www.npmjs.org/package/react-kup) and then use
a build system like [gulp](http://gulpjs.com/) to bring everything together*

### `example.coffee` (assumed to be compiled to `example.js`)

```coffeescript
# react-kup doesn't come with react.
# tell react-kup to use the version of react we included above.
reactKup = newReactKup (React)

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

[see tests for more examples and advanced usage](test/react-kup.coffee)

## node.js

### install

```
npm install react-kup
```

**or**

put this line in the dependencies section of your `package.json`:

```
"react-kup": "0.3.0"
```

then run:

```
npm install
```

```coffeescript
# react-kup doesn't come with react.
# require your favorite version ...
React = require 'react'
# ... and tell react kup to use it
reactKup = require('react-kup')(React)

HelloMessage = React.createClass
  render: ->
    that = this
    reactKup (k) ->
      k.div "Hello #{that.props.name}"

component = new HelloMessage({name: 'John'})

React.renderComponentToString component
# => <div>Hello John</div>
```

[see tests for more examples and advanced usage](test/react-kup.coffee)

### license: MIT
