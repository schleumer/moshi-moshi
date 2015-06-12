export class Message
  (@raw-message) ->
    @body = @raw-message.data
