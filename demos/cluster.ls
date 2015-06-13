require! \cluster

Promise = require 'bluebird'

phone = require '../src'

if cluster.is-master
  for i in [1 to 5]
    cluster.fork { X : i }
else
  phone 'localhost' 'tests'
    .then (c) ->
      c.with-queue "test-2-#{process.env['X']}", ["key2-#{process.env['X']}"]
        .then (q) ->
          q.on 'message' (message) ->
            console.log "received one message on test-2-#{process.env['X']} with #{message.delivery-info.reply-to}"
            try
              message.reply [process.env['X'], new Date!get-time!]
            catch ex
              console.log ex
          console.log "key2-#{process.env['X']}@test-2-#{process.env['X']} ready"