{CompositeDisposable} = require 'atom'
shell = require 'shell'
http = require 'http'
https = require 'https'
url = require 'url'
settings = require './settings'

module.exports = AtomHastebin =
  subscriptions: null,
  config: settings.config

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command
    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-hastebin:upload': => @upload()

    @transport = @get_transport()

  deactivate: ->
    @subscriptions.dispose()

  get_config: ->
    return atom.config.get "atom-hastebin"

  get_data: ->
    editor = atom.workspace.getActivePane().getActiveEditor()
    data = editor.getText()
    return data

  get_transport: ->
    if @get_config().use_https is true
      return require 'https'
    else
      return require 'http'

  get_protocol: (config) ->
    return if config.use_https then "https" else "http"


  finalize: (config, resp, uri) ->
    if config.copy_to_clipboard is true
      atom.clipboard.write uri+"/"+resp.key
    if config.open_in_browser is true
      shell.openExternal uri+"/"+resp.key


  api_request: (config, data) ->
    options =
      hostname: url.parse(config.host).hostname
      port: config.port
      path: '/documents'
      method: 'POST'
      headers:
        'Content-Type': 'application/json; charset=utf-8'
        'Content-Length': data.length


    resp = ""
    req = @transport.request options, (res) =>
      res.setEncoding "utf8"

      res.on "data", (chunk) ->
        resp += chunk

      res.on "end", =>
        uri = @get_protocol(config) + "://" + req._headers.host
        console.log uri
        @finalize(config, JSON.parse(resp), uri)

    req.write data
    req.end()

  upload: ->
    config = @get_config()
    data = @get_data()
    @api_request(config, data)
