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

views.engines.html = ->

  contentType: 'text/html'
  render: (str, callback) ->
    str = body.replace("{content}", str)
    callback null, str

views.engines.extensions['.html'] = views.engines.html

app =
  connect()
  .use((req, res, next) ->
      if (req.url == "/")
        req.url = "/views/home/index.html"
      console.log req.url
      next()
    )
  .use(connect.static("assets"))
  .use(views())
  .listen(process.env.PORT || 8080)
