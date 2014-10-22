module.exports = ( ->
  getTemplate = (varName="__fixtures__") ->
    """
    window.#{varName} = window.#{varName} || {};
    window.#{varName}["%s"] = %s;
    """

  createCsonFixturesPreprocessor = (basePath, config={}) ->
    util = require "util"
    CSON = require "cson"

    stripPrefix = ///^#{config.stripPrefix || ""}///
    prependPrefix = config.prependPrefix || ""

    (content, file, done) ->
      fixtureName = file.originalPath
          .replace "#{basePath}/", ""
          .replace /\.cson$/, ""

      # Set the template
      template = getTemplate config.variableName

      # Update the fixture name
      fixtureName = prependPrefix + fixtureName.replace stripPrefix, ""

      file.path = file.path.replace /\.cson$/, ".js"

      content = JSON.stringify CSON.parseSync content

      done util.format(template, fixtureName, content)

  createCsonFixturesPreprocessor.$inject = [
    "config.basePath",
    "config.csonFixturesPreprocessor"
  ]

  createCsonFixturesPreprocessor
)()
