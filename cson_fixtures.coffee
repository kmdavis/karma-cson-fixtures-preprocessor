module.exports = ( ->
  util = require "util"

  getTemplate = (varName="__fixtures__") ->
    """
    window.#{varName} = window.#{varName} || {};
    window.#{varName}["%s"] = %s;
    """

  createCsonFixturesPreprocessor = (basePath, config={}) ->

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

      done util.format(template, fixtureName, content)

  createCsonFixturesPreprocessor.$inject = [
    "config.basePath",
    "config.csonFixturesPreprocessor"
  ]

  createCsonFixturesPreprocessor
)()
