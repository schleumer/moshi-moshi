require! {
  \amqp
  \bluebird : Promise
  './connection' : { Connection }
}

module.exports = (host, exchange-name, options) ->
  new Promise (resolve, reject) ->
    resolve (new Connection host, exchange-name, options .connect!)