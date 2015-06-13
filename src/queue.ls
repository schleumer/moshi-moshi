require! {
  'events' : { EventEmitter }
  './message' : { Message }
  'bluebird' : Promise
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

  first: (timeout = 2000ms)->
    new Promise (resolve, reject) ~>
      @once 'message', (message) ~>
        console.log message.delivery-info.routingKey
        resolve message
        @destroy!
    .cancellable!
    .timeout timeout
    .catch (err) ~>
      @destroy!
      # pass the error ahead because i'm really bad to design flows
      throw new Error("queue #{@raw-queue.name} destroyed due #{err}")