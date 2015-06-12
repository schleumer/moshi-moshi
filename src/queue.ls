require! {
  'events' : { EventEmitter }
  './message' : { Message }
}

export class Queue extends EventEmitter
  (@raw-queue, @exchange, @routing-keys, @queue-options) ->
    @queue-options = {
      auto-ack: true,
      prefetch-count: 1
    } <<< @queue-options
    @raw-options = {
      ack: not @queue-options.auto-ack # auto-ack = true, ack = false
      prefetchCount: @queue-options.prefetch-count # it's okay to be undefined
    }
    @routing-keys.for-each (key) ~>
      @raw-queue.bind @exchange, key
      @raw-queue.subscribe do
        @raw-options
        (message, headers, delivery-info, message-object) ~>
          @emit 'message' new Message do
            message
            headers
            delivery-info
            message-object
            not @queue-options.auto-ack
  destroy: ->
    resolve, _ <~ new Promise!
    resolve @raw-queue.destroy!
