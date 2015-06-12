require! {
  \bluebird : Promise
  \amqp
  './queue' : { Queue }
}

export class Connection
  # connection constructor, you know what a constructor do, don't you?
  # @param {srting} host: host
  # @param {string} exchange-name: exchange-name
  # @param {object} options: connection options, default = {}
  # @param {object} exchange-options: exchange options, default = {}
  # @throws an error if there's no host
  # @throws an error if there's no exchange-name
  # @see https://github.com/postwait/node-amqp#connection-options-and-url for connection options
  # @see https://github.com/postwait/node-amqp#connectionexchangename-options-opencallback for exchange options
  # @todo cut down exchange from connection for more usability for those who don't use exchange
  # - thank you, captain obvious
  # - no problem
  (@host, @exchange-name, @options = {}, @exchange-options = {}) ->
    throw new Error 'host must be declared' if not @host
    throw new Error 'exchange-name must be declared' if not @exchange-name
    @connection = amqp.create-connection host: @host
  connect: ->
    new Promise (resolve, reject) ~>
      do
        # i realy hate those `on ready` stuffs
        <~ @connection.on 'ready'
        # yeah, exchange is mandatory
        @exchange = @connection.exchange @exchange-name, @exchange-options

        <~ @exchange.on 'open'
        resolve @
      do
        error <~ @connection.on 'error'
        reject error
  # listen to messages within a queue and routing key(s)
  with-queue: (queue-name, routing-keys = ['#'], queue-options = {}) ->
    new Promise (resolve, reject) ~>
      queue <~ @connection.queue queue-name, queue-options
      # if there's some error here, node-amqp will restart queue creation, 
      # and also will create a new channel on server, without destroying
      # the previously created
      try
        resolve 
          <| new Queue queue, @exchange, routing-keys, queue-options
      catch
        reject e

  # listen to a single message within queue and routing key(s) and destroy that queue
  # this may be useful for: ...
  listen-and-die: (queue-name, routing-keys = ['#'], queue-options = {}) ->
    new Promise (resolve, reject) ~>
      @with-queue queue-name, routing-keys, queue-options
        .then (queue) ~>
          queue.on 'message' (message) ~>
            resolve message
            queue.destroy!catch (err) ->
              console.log err
              console.log 'an error ocurred while destroying a queue'

  dial: (routing-key, message, publish-options) ->
    new Promise (resolve, reject) ~>
      result <~ @exchange.publish routing-key, message, publish-options
      console.log result
      resolve result

  hang: ->
    new Promise (resolve, reject) ~>
      # i hope if this one fails it throws an error
      resolve @connection.disconnect!