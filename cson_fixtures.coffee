getTemplate = (varName = "__fixtures__") ->
  """
  window.#{varName} = window.#{varName} || {};
  window.#{varName}["%s"] = %s;
  """

createCsonFixturesPreprocessor = (logger, basePath, config = {}) ->
  log = logger.create "preprocessor.cson_fixtures"
  util = require "util"
  CSON = require "cson-safe"

  stripPrefix = ///^#{config.stripPrefix or ""}///
  stripExtension = ///\.#{config.extension or "cson"}$///
  prependPrefix = config.prependPrefix or ""

  (content, file, done) ->
    log.debug """Processing "#{file.originalPath}"."""
    fixtureName = file.originalPath
      .replace( "#{basePath}/", "" )
      .replace stripExtension, ""

    # Set the template
    template = getTemplate config.variableName

    # Update the fixture name
    fixtureName = prependPrefix + fixtureName.replace stripPrefix, ""

    file.path = file.path.replace stripExtension, ".js"

    try
      content = JSON.stringify CSON.parse content
    catch error
      throw Error("in #{file.originalPath}\n#{error.toString()}")

    done util.format(template, fixtureName, content)

createCsonFixturesPreprocessor.$inject = [
  "logger"
  "config.basePath",
  "config.csonFixturesPreprocessor"
]

module.exports = createCsonFixturesPreprocessor
