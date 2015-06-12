phone = require '../src'

call = phone 'localhost' 'tests'

call.then (connection) ->
  connection.with-queue 'test-1', ['key1']
    .then (queue) ->
      queue.on 'message' (message) ->
        console.log message.body
        connection.dial 'key2', { 'test': '2' }
      connection
        .dial 'key2', { 'test': '1' }
        #.then (message) ->
        #  console.log message.body