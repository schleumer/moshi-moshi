phone = require '../src'

call = phone 'localhost' 'tests'

call.then (connection) ->
  connection.with-queue 'test-1', ['key1']
    .then (queue) ->
      queue.on 'message' (message) ->
        console.log message.body
        connection.dial 'key2', { 'test': '2' }
      
      Promise.all [
        connection.ask 'key2-1', { 'test': '1' }
        connection.ask 'key2-2', { 'test': '1' }
        connection.ask 'key2-3', { 'test': '1' }
        connection.ask 'key2-4', { 'test': '1' }
        connection.ask 'key2-5', { 'test': '1' }
        connection.ask 'key2-6', { 'test': '1' }
        connection.ask 'key2-7', { 'test': '1' }
        connection.ask 'key2-8', { 'test': '1' }
        connection.ask 'key2-9', { 'test': '1' }
        connection.ask 'key2-10', { 'test': '1' }
        connection.ask 'key2-11', { 'test': '1' }
        connection.ask 'key2-12', { 'test': '1' }
        connection.ask 'key2-13', { 'test': '1' }
        connection.ask 'key2-14', { 'test': '1' }
        connection.ask 'key2-15', { 'test': '1' }
        connection.ask 'key2-16', { 'test': '1' }
        connection.ask 'key2-17', { 'test': '1' }
        connection.ask 'key2-18', { 'test': '1' }
      ]
      .then (.map (.body)) 
      .then (all) ->
        console.log all
      .catch (err) -> console.log 'uh-oh'