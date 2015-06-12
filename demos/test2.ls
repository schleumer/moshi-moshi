Promise = require 'bluebird'

phone = require './src'

call = phone 'localhost' 'tests'

call.then (connection) !->
  Promise.all [
    connection.with-queue 'test-2', ['key2']
    connection.with-queue 'test-3', ['key2']
  ] .spread (q2, q3) ->
      q2.on 'message' (message) ->
        console.log 'q2' message
      q3.on 'message' (message) ->
        console.log 'q3' message
      connection.dial 'key1', { 'lel': 'roflmao2' }

set-timeout (->), 1000