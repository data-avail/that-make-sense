connect = require 'connect'
views = require 'connect-views'
marked = require 'marked'
fs = require "fs"

body = fs.readFileSync("views/shared/_layout.htm", "utf8")

views.engines.marked = ->

  contentType: 'text/html'
  render: (str, callback) ->
    try
      out = marked str
      out = body.replace("{content}", out)
    catch err
      return callback err
    callback null, out

views.engines.extensions['.md'] = views.engines.marked


app =
  connect()
  .use((req, res, next) ->
      if (req.url == "/")
        req.url = "/posts/_index.md"
      console.log req.url
      next()
    )
  .use(connect.static("assets"))
  .use(views())
  .listen(process.env.PORT || 8080)
