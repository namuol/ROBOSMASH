config = require './config'

fs = require 'fs'
ck = require 'coffeecup'
{exec} = require 'child_process'
build_dir = 'impact'

String::endsWith = (suffix) ->
  @indexOf(suffix, @length - suffix.length) isnt -1

handle_errors = (err, stdout, stderr) ->
  if err
    console.log stdout + stderr
    throw err

server = (cb) ->
  express = require("express")
  impact = require("impact-weltmeister")
  port = 8080
  root = __dirname + "/#{build_dir}/"
  app = express()
  app.configure ->
    app.use express.methodOverride()
    app.use express.bodyParser()
    app.use app.router

  impact.listen app,
    root: root

  app.use express.static(root)
  app.get '_pwd', (req,res) ->
    res.send __dirname
    
  app.listen port
  console.log "listening on port", port

  cb()

build_entity = (f, cb) ->
  return if not f.endsWith '.coffee'
  exec "coffee -c -o #{build_dir}/lib/game/entities src/entities/" + f, cb

build_html = (f, cb) ->
  return if not f.endsWith '.ccup'
  exec "coffeecup -o #{build_dir} #{f}", cb

build_main = (cb) ->
  exec "coffee -c -o #{build_dir}/lib/game/ src/main.coffee", cb

build_css = (cb) ->
  exec "stylus -o #{build_dir} src/style.styl"

task 'build', 'Create compiled HTML/CSS output', ->
  console.log 'build her a cake or something...'

  console.log 'building entities...'
  for f in fs.readdirSync 'src/entities'
    build_entity f, handle_errors

  console.log 'building main...'
  build_main handle_errors

  console.log 'building html...'
  for f in fs.readdirSync 'src'
    build_html __dirname + '/src/' + f, handle_errors

  console.log 'building css...'
  build_css handle_errors

task 'live', 'Start hosting the game & editor; automatically rebuild when source files change.', ->
  server ->
    fs.watch __dirname + '/src', (e, filename) ->
      if filename.endsWith '.ccup'
        console.log filename
        build_html __dirname+'/src/'+filename, (err) ->
          console.error err

    fs.watch __dirname + '/src/entities', (e, filename) ->
      build_entity filename, (err) ->
        console.error err

    fs.watch __dirname + '/src/style.styl', (e, filename) ->
      if filename.endsWith '.styl'
        console.log 'building css...'
        build_css ->

    fs.watch __dirname + '/src/main.coffee', (e, filename) ->
      console.log 'building main...'
      build_main ->

task 'edit', 'Run ImpactJS\'s editor, Weltmeister', ->
  cmd = config.browser_cmd.replace '[[url]]', config.weltmeister_url
  exec cmd, handle_errors

task 'run', 'Launch your browser.', ->
  cmd = config.browser_cmd.replace '[[url]]', config.run_url
  exec cmd, handle_errors

task 'bake', 'Build game.min.js', ->
  exec 'cd impact/tools;./bake.sh', (err, stdout, stderr) =>
    handle_errors arguments...
    console.log stdout
    console.log stderr

    exec 'rm -rf prod', =>
      handle_errors arguments...
      exec 'mkdir -p prod', =>
        handle_errors arguments...
        exec 'cp impact/*.html prod/.', =>
          handle_errors arguments...
          exec 'mv prod/index_production.html prod/index.html', handle_errors
          exec 'cp impact/style.css prod/.', handle_errors
          exec 'cp impact/game.min.js prod/.', handle_errors
          exec 'cp -r impact/media prod/.', =>
            handle_errors arguments...

            exec 'rm -rf prod/media/*.xcf prod/media/sounds/*.wav prod/media/music/*.wav prod/media/music/*.flac', handle_errors
