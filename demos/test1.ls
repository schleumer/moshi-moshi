phone = require '../src'

Promise = require 'bluebird'

call = phone 'localhost' 'tests'

call.then (connection) ->
  connection.with-queue 'test-1', ['key1']
    .then (queue) ->
      queue.on 'message' (message) ->
        console.log message.body
        connection.dial 'key2', { 'test': '2' }

      # NEVER EVER DO THIS ASYNC, OKAY?
      # IT WORKS, FOR SURE
      # BUT MAY FAIL BECAUSE SOME MESSAGES
      # JUST DISAPPEAR INTO 
      # THE DARK HALLWAYS OF MQ CHANNELS
      # WHEN PROCESSED ASYNCHRONOUSLY.
      # IT'S ASYNCHRONOUSLY TOO ASYNCHRONOUS FOR NODE.
      # But when you wait answer just from 1 node
      # it works, it's just don't work when you ask lots of nodes
      # and wait ASYNCHRONOUSLY for the answers
      # you can use cluster.ls to test and see
      # Bluebird::map is ok
      # even on this way there's some-small-number-with-comma-for-credibility% of fail
      Promise.each [1 to 100] (i) ->
        Promise.map do
          [key: "key2-#{i}" value: 'test': i for i in [1 to 5]] # implicit witchcraft
          (item) ->
            connection.ask item.key, item.value
              .then (message) -> message.body
          concurrency: 1
        .then (all) ->
          console.log all
        #.delay(1000) # if you are running into a potato
      .catch (err) -> console.log err