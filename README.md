# README desu

## THIS IS A EXTREME EXPERIMENTAL MODULE SO PLEASE DON'T USE IT

## no code yet

Each created queue has one response queue, which receive messages from the exchange with some especial routing key,
it's like [LeanKit-Labs/wascally](https://github.com/LeanKit-Labs/wascally)
but using [postwait/node-amqp](https://github.com/postwait/node-amqp)
and made by a totally amateur programmer :bowtie:

And yes, it's a unexpected behaviour of an message queue service. But who cares?


# Brainstorm

```
var phone = require('moshi-moshi');

// receiver
phone('exchange', /*...amqp connection info*/)
  .then(function(connection) {
    connection
      .withQueue('the-queue', ['notice' /* routing keys */], /* queue options */) // return event emitter, is that wrong? Yes. Maybe a Stream could be cooler.
      .on('message', function(message) {
        message.reply('SENPAI NOTICED ME'); // auto acknowledge of `message`
      })
      .on('yaddayaddayadda', function(yaddayaddayadda) {
        yaddayaddayadda.yaddayaddayadda();
      });
  })
  .catch(function(error) {
    console.error("HOLY C##P");
  });

// sender
phone('exchange', /*...amqp connection info*/)
  .then(function(connection) {
    connection
      .askFor('notice')
      .timeout(1000) // timeout from bluebird
      .then(function(reply) {
        console.log(reply.body);
      })
      .catch(function(error) {
        console.error("uh-oh");
      });
  })
  .catch(function(error) {
    console.error("HOLY C##P");
  });


```


## i


## liek


## headerz
