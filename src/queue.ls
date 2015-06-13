require! {
  'events' : { EventEmitter }
  './message' : { Message }
}

export class Queue extends EventEmitter
  (@raw-queue, @connection, @routing-keys, @queue-options) ->
    @queue-options = {
      auto-ack: true,
      prefetch-count: 1
    } <<< @queue-options
    @raw-options = {
      ack: not @queue-options.auto-ack # auto-ack = true, ack = false
      prefetchCount: @queue-options.prefetch-count # it's okay to be undefined
    }
    @routing-keys.for-each (key) ~>
      @raw-queue.bind @connection.exchange, key
      @raw-queue.subscribe do
        @raw-options
        (message, headers, delivery-info, message-object) ~>
          @emit \message new Message do
            @connection
            message
            headers
            delivery-info
            message-object
            not @queue-options.auto-ack
  
  destroy: ->
    resolve, _ <~ new Promise!
    resolve @raw-queue.destroy!

  first: ->
    resolve, reject <~ new Promise!
    @once 'message', (message) ~>
      resolve message
      @destroy!
