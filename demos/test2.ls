Promise = require 'bluebird'

phone = require '../src'

call = phone 'localhost' 'tests'

call.then (connection) !->
  Promise.all [
    connection.with-queue 'test-2' ['key2']
    connection.with-queue 'test-3' ['key2']
  ] .spread (q2, q3) ->
      q2.on 'message' (message) ->
        console.log 'q2', message.body, message.delay
      q3.on 'message' (message) ->
        console.log 'q3', message.body, message.delay

      connection.listen-and-die 'test-4' ['key2'] .then (message) ->
        console.log 'short-lived' message.body

set-timeout (->), 1000