module.exports = ( ->
  getTemplate = (varName="__fixtures__") ->
    """
    window.#{varName} = window.#{varName} || {};
    window.#{varName}["%s"] = %s;
    """

  createCsonFixturesPreprocessor = (basePath, config={}) ->
    util = require "util"
    CSON = require "cson-safe"

    stripPrefix = ///^#{config.stripPrefix or ""}///
    stripExtension = ///.#{config.extension or "cson"}$///
    prependPrefix = config.prependPrefix or ""

    (content, file, done) ->
      fixtureName = file.originalPath
          .replace "#{basePath}/", ""
          .replace stripExtension, ""

      # Set the template
      template = getTemplate config.variableName

      # Update the fixture name
      fixtureName = prependPrefix + fixtureName.replace stripPrefix, ""

      file.path = file.path.replace stripExtension, ".js"

      content = JSON.stringify CSON.parse content

      done util.format(template, fixtureName, content)

  createCsonFixturesPreprocessor.$inject = [
    "config.basePath",
    "config.csonFixturesPreprocessor"
  ]

  createCsonFixturesPreprocessor
)()
