// Generated by LiveScript 1.4.0
var EventEmitter, Message, Promise, Queue, out$ = typeof exports != 'undefined' && exports || this;
EventEmitter = require('events').EventEmitter;
Message = require('./message').Message;
Promise = require('bluebird');
out$.Queue = Queue = (function(superclass){
  var prototype = extend$((import$(Queue, superclass).displayName = 'Queue', Queue), superclass).prototype, constructor = Queue;
  function Queue(rawQueue, connection, routingKeys, queueOptions){
    var this$ = this;
    this.rawQueue = rawQueue;
    this.connection = connection;
    this.routingKeys = routingKeys;
    this.queueOptions = queueOptions;
    this.queueOptions = import$({
      autoAck: true,
      prefetchCount: 1
    }, this.queueOptions);
    this.rawOptions = {
      ack: !this.queueOptions.autoAck,
      prefetchCount: this.queueOptions.prefetchCount
    };
    this.routingKeys.forEach(function(key){
      this$.rawQueue.bind(this$.connection.exchange, key);
      return this$.rawQueue.subscribe(this$.rawOptions, function(message, headers, deliveryInfo, messageObject){
        return this$.emit('message', new Message(this$.connection, message, headers, deliveryInfo, messageObject, !this$.queueOptions.autoAck));
      });
    });
  }
  prototype.destroy = function(){
    var this$ = this;
    return new Promise(function(resolve, _){
      return resolve(this$.rawQueue.destroy());
    });
  };
  prototype.first = function(timeout){
    var this$ = this;
    timeout == null && (timeout = 2000);
    return new Promise(function(resolve, reject){
      return this$.once('message', function(message){
        console.log(message.deliveryInfo.routingKey);
        resolve(message);
        return this$.destroy();
      });
    }).cancellable().timeout(timeout)['catch'](function(err){
      this$.destroy();
      throw new Error("queue " + this$.rawQueue.name + " destroyed due " + err);
    });
  };
  return Queue;
}(EventEmitter));
function extend$(sub, sup){
  function fun(){} fun.prototype = (sub.superclass = sup).prototype;
  (sub.prototype = new fun).constructor = sub;
  if (typeof sup.extended == 'function') sup.extended(sub);
  return sub;
}
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}