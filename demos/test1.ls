phone = require './src'

call = phone 'localhost' 'tests'

call.then (connection) ->
  connection.with-queue 'test-1', ['key1']
    .then (queue) ->
      queue.on 'message' (message) ->
        console.log message
        connection.dial 'key2', { 'kek': 'hehehehe' }