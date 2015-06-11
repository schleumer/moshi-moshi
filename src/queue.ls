require! {
  'events' : { EventEmitter }
}

export class Queue extends EventEmitter
  (@queue, @exchange, @routing-keys, @queue-options) ->
    console.log "queue #{@queue.name} created"
    @routing-keys.for-each (key) ~>
      @queue.bind @exchange, key
    @queue.subscribe (message, a, b, c, d) ~>
      @emit 'message', message