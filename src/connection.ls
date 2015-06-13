require! {
  \bluebird : Promise
  \amqp
  './queue' : { Queue }
  './utils' : { uuid }
}

export class Connection
  # connection constructor, you know what a constructor do, don't you?
  # REMEMBER:
  # each connection with exchange cost 1 channel
  # each queue cost 1 channel
  # channels = n-queues + 1
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
          <| new Queue queue, @, routing-keys, queue-options
      catch
        reject e

  dial: (routing-key, message, publish-options = {}, will-reply = no) ->
    new Promise (resolve, reject) ~>
      publish-options.headers ?= {}
      publish-options.headers.\x-timestamp ?= new Date!get-time!
      if will-reply
        temp-name = (x) -> "temp-#{x}-for-reply-#{uuid!}"
        temp-route = temp-name \route
        temp-queue = temp-name \queue
        publish-options.headers.\Reply-To ?= temp-route
        # YEAH YEAH IT'S QUITE WRONG, SORRY
        resolve do
          # to avoid delay, i will wait till queue creation to publish a message
          @with-queue temp-queue, [temp-route]
            .then (queue) ~>
              @exchange.publish routing-key, message, publish-options
              queue.first!
      else
        result <~ @exchange.publish routing-key, message, publish-options
        # i don't know what is going on here nor what the
        # callback does, but i'll keep it.
        resolve result

  ask: (routing-key, message, publish-options = {}, will-reply = yes) ->
    @dial routing-key, message, publish-options, will-reply

  hang: ->
    new Promise (resolve, reject) ~>
      # i hope if this one fails it throws an error
      resolve @connection.disconnect!