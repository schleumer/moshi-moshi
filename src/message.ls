export class Message
  # TODO: process message body the right way, because raw-message
  # could be a file, image, etc. it's not only JSON. It could be
  # a buffer when content-type is application/octet-stream
  # XXX: if you send a string you receive Buffer, because 
  # strings has no content-type, nuff said.
  (@raw-message, @headers, @delivery-info, @message-object, @can-ack = no) ->
    @body = @raw-message

  ack: (ack-previous = no) -> 
    if @can-ack
      console.log 'hehe'
      @message-object.acknowledge ack-previous