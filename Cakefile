{exec} = require 'child_process'

task 'build', 'build src', ->
  exec "coffee -o lib -c src/venn.coffee"

task 'build-test', 'build tests', ->
  exec "coffee -o html -c test/venn-test.coffee"

task 'all', 'build all', ->
  invoke 'build'
  invoke 'build-test'
