Promise = require 'bluebird'

phone = require '../src'

call = phone 'localhost' 'tests'

call.then (connection) !->
  Promise.all [
    connection.with-queue 'test-2' ['key2']
    connection.with-queue 'test-3' ['key2']
    connection.with-queue 'test-4' ['key2']
  ] .spread (q2, q3, q4) ->
      q2.on 'message' (message) ->
        console.log 'q2', message.body, message.delay
      
      q3.on 'message' (message) ->
        console.log 'q3', message.body, message.delay
        set-timeout do
          -> message.reply { 'reply-test': ':D' }
          5000

      q4.first!then (message) ->
        console.log 'short-lived' message.body

      connection.dial 'key1' {  'test': 'upalele' }