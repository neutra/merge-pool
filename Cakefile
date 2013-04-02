fs = require 'fs'
path = require 'path'
{spawn,exec} = require 'child_process'

launch = (cmd, args=[], callback) ->
  app = spawn cmd, args, {cwd: process.cwd()}
  app.stdout.pipe process.stdout
  app.stderr.pipe process.stderr
  app.on 'exit', (status) ->
    process.exit(1) if status != 0
    cb() if typeof cb is 'function'

clean = ->
  fs.unlinkSync path.join 'lib',file for file in fs.readdirSync 'lib'

task 'build', 'compile source', ->
  clean()
  exec "coffee -cm -o lib src", (err) ->
    return if err
    exec "coffee -c \"#{path.join 'test','test.coffee'}\"",(err) ->

task 'test', 'run test', ->
  launch 'node',[path.join __dirname,"test","test.js"],(err) ->
