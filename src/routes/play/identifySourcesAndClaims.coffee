module.exports = (app, done) ->

 app.get '/play/identifySourcesAndClaims', (req, res, next) ->
  res.render 'play/identifySourcesAndClaims'

 done()
