module.exports =
  config:
    host:
      type: "string"
      default: "hastebin.com"
      description: "Hastebin Host"
    port:
      type: "integer"
      default: 80
      description: "Hastebin Port"
    use_https:
      type: "boolean"
      default: false
      description: "Use HTTPS to communicate with hastebin"
    copy_to_clipboard:
      type: "boolean"
      default: false
      description: "Copy the URL of the created hastebin to the clipboard"
    open_in_browser:
      type: "boolean"
      default: true
      description: "Open the new hastebin in the webbrowser"
