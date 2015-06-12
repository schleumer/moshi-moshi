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

  ack: (ack-previous = no) -> 
    if @can-ack
      @message-object.acknowledge ack-previous