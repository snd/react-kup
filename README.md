# react-kup

[![Build Status](https://travis-ci.org/snd/react-kup.png)](https://travis-ci.org/snd/react-kup)

**react-kup is a simple, non-intrusive alternative to jsx for coffeescript**

[it's like **kup** but constructs react dom components instead of html strings](https://github.com/snd/kup)

### install

```
npm install react-kup
```

**or**

put this line in the dependencies section of your `package.json`:

```
"react-kup": "0.2.0"
```

then run:

```
npm install
```

### example

```coffeescript
# react-kup doesn't come with react.
# require your favorite version ...
react = require 'react'
# ... and tell react kup to use it
reactKup = require('react-kup')(react)
# react-kup has been tested against react@0.10.0-rc1
# which is recommended

HelloMessage = React.createClass
  render: ->
    that = this
    reactKup (k) ->
      k.div "Hello #{that.props.name}"

mountNode = document.getElementById('example')
component = new HelloMessage({name: 'John'})

React.renderComponent component, mountNode
```

[see tests for many more examples](test/react-kup.coffee)

### license: MIT
