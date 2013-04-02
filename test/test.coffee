async = require 'async'
assert = require 'assert'

mp = require '../lib/merge_pool'

exports.test = (test) ->
	outputs = null
	echo = (input,cb) ->
		console.log "accept input: #{input}"
		op = -> 
			console.log "echo #{input+100}"
			cb null, input+100
		setTimeout op, 500
	wait = (ms) -> (cb) -> 
		console.log "wait #{ms}ms"
		setTimeout cb,ms
	push = (key,args...) -> (cb) ->
		for item in args
			console.log "push #{item} -> #{key}"
			mp.run key, echo, item, (err,result) ->
				assert.equal err,null
				assert.ok result?
				console.log "#{item} -> #{key} return #{result}"
				outputs[key].push result
		do cb
	reset = (cb) -> 
		console.log "reset"
		outputs = A: [], B: []
		do cb
	check = (expect) -> (cb) ->
		console.log "check"
		assert.deepEqual outputs, expect
		do cb
	async.series [
		reset
		check A:[], B:[]
		push 'A', 1, 3, 5
		push 'B', 2, 4
		push 'A', 7
		check A:[], B:[]
		wait 1000
		check A:[101,101,101,101], B:[102,102]

		reset
		check A:[], B:[]
		push 'A', 9
		push 'B', 6, 8, 10
		push 'A', 11, 13
		check A:[], B:[]
		wait 1000
		check A:[109,109,109], B:[106,106,106]
	],(err) ->
		assert.equal err, null
		test.done()

if require.main is module
	test = done: -> console.log "test done"
	exports.test test
