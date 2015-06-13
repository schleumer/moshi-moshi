require! {
  \bluebird : Promise
}

export class Message
  # TODO: process message body the right way, because raw-message
  # could be a file, image, etc. it's not only JSON. It could be
  # a buffer when content-type is application/octet-stream
  # XXX: if you send a string you receive Buffer, because 
  # strings has no content-type, nuff said.
  (@connection, @raw-message, @headers, @delivery-info, @message-object, @can-ack = no) ->
    # DIRTY:
    if @headers?.\x-timestamp
      # in microseconds
      @delay = new Date!get-time! - @headers.\x-timestamp
    else
      @delay = 0
    @body = @raw-message
    # for the lazy
    @routing-key = @delivery-info.routing-key

  # TODO: MAKE THIS HARD AND COMPLEX
  reply: (body) ->
    resolve, reject <~ new Promise!
    if @delivery-info.reply-to
      console.log 'Replying to ' + @delivery-info.reply-to
      @connection.dial @delivery-info.reply-to, body
    else
      reject new Error("No Reply-To header found")

  ack: (ack-previous = no) -> 
    if @can-ack
      @message-object.acknowledge ack-previous