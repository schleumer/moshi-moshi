require! {
  \bluebird : Q
  \amqp
  './queue' : { Queue }
}

export class Connection
  (@host, @exchange-name, @options) ->
    throw new Error 'host must be declared' if not @host
    throw new Error 'exchange-name must be declared' if not @exchange-name
    @connection = amqp.create-connection host: @host
  connect: ->
    new Q (resolve, reject) ~>
      do
        # i realy hate those `on ready` stuffs
        <~ @connection.on 'ready'
        @exchange = @connection.exchange @exchange-name, {}

        <~ @exchange.on 'open'
        resolve @
      do
        error <~ @connection.on 'error'
        reject error 
  with-queue: (queue-name, routing-keys = ['#'], queue-options = {}) ->
    new Q (resolve, reject) ~>
      queue <~ @connection.queue queue-name, queue-options
      resolve new Queue queue, routing-keys, queue-options

  hang: ->
    new Q (resolve, reject) ~>
      # i hope if this one fails it throws an error
      resolve @connection.disconnect!