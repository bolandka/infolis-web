BodyParser = require 'body-parser'
Vim2Html   = require 'vim2html'

log = require('../log')(module)

module.exports = (app, done) ->

	app.swagger '/api/syntax-highlight',
		post:
			tags: ['advanced']
			summary: "Post text and receive syntax highlighted text"
			consumes: ['application/json']
			produces: ['text/html']
			parameters: [
				name: 'hl'
				in: "body"
				description: "Text to highlight"
				schema:
					type: 'object'
					properties:
						text:
							type: 'string'
						mimetype:
							type: 'string'
			]
			responses:
				200:
					description: 'Successfully highlighted'

	mimetype2syntax =
		'application/json':             'json'
		'application/ld+json':          'json'
		'application/n3+json':          'json'
		'application/rdf+json':         'json'
		'application/rdf-triples+json': 'json'
		'application/rdf-triples':      'turtleson'
		'application/x-turtle':         'turtleson'
		'text/rdf+n3':                  'turtleson'
		'application/trig':             'turtleson'
		'text/turtle':                  'turtleson'
		'application/nquads':           'turtleson'
		'application/n-triples':        'turtleson'
		'application/rdf+xml':          'xml'
		'text/xml':                     'xml'
		'text/html':                    'html'

	app.post '/api/syntax-highlight', BodyParser.text(), (req, res, next) ->
		res.header 'Content-Type', 'text/html'
		mimetype = req.body.mimetype
		if not mimetype or mimetype is ''
			mimetype = 'application/json'
		syntax = mimetype2syntax[mimetype] or 'json'
		log.debug "highlighting format #{mimetype} as #{syntax}"
		opts = {
			syntax: syntax
			colorscheme: 'chrysoprase'
			number_lines: 0
			use_css: 0
			pre_only: 1
		}
		Vim2Html.highlightString req.body.text, opts, (err, highlighted) ->
			# console.log highlighted
			if err
				return next err
			res.send highlighted

	done()
