# react-kup

[![Build Status](https://travis-ci.org/snd/react-kup.png)](https://travis-ci.org/snd/react-kup)

**react-kup is a simple, non-intrusive alternative to jsx for coffeescript**

[it's like **kup**but constructs react dom components instead of html strings](https://github.com/snd/kup)

### install

```
npm install react-kup
```

**or**

put this line in the dependencies section of your `package.json`:

```
"react-kup": "0.1.0"
```

then run:

```
npm install
```

### example

```coffeescript
reactKup = require 'react-kup'

HelloMessage = React.createClass
  render: ->
    that = this
    reactKup (k) ->
      k.div "Hello #{that.props.name}"

mountNode = document.getElementById('example')
component = new HelloMessage({name: 'John'})

React.renderComponent component, mountNode
```

[see tests for more examples](test/react-kup.coffee)

### license: MIT
