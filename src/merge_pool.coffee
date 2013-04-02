util = require 'util'
async = require 'async'

_log = (text) -> 
	console.log "MergePool: #{text}"

class MergePool
	###
	Merge Pool

	merge multi requests, process one and response all the same requests
	###
	constructor: (opt={}) ->
		###
		constructor
		> @opt:
		>	debug: 
		###
		@pendings = {}
		@debug = !!opt.debug
		
	run: (key,exec,args...,callback) ->
		###
		run(key,exec,args...,callback)
		> @key: string()
		> @exec: (args...,callback) -> void()
		> @callback: (err,result) -> void()
		###

		# check params
		unless key?
			throw new Error 'MergePool.run: key can not must be null'
		unless 'string' is typeof key
			key = key.toString()
		unless 'function' is typeof exec
			throw new Error 'MergePool.run: exec must be a function'
		unless 'function' is typeof callback
			throw new Error 'MergePool.run: callback must be a function'

		# enqueue item
		item = {callback}
		queue = @pendings[key]
		if queue?
			queue.push item
			return
		queue = [item]
		@pendings[key] = queue

		done = (err,result) =>
			delete @pendings[key]
			Object.freeze err if err instanceof Object
			Object.freeze result if result instanceof Object
			queue.forEach (item) =>
				item.callback.call @,err,result
		
		# execute
		try
			exec.apply null,[args...,done]
		catch err
			process.nextTick ->	done err
		return

module.exports = MergePool