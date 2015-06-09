require! {
  \amqp
  \bluebird : Q
  './connection' : { Connection }
}

module.exports = (host, exchange-name, options) ->
  new Q (resolve, reject) ->
    resolve (new Connection host, exchange-name, options .connect!)