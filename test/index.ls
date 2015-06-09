require! {
  '../src/index.ls' : phone
  '../src/connection.ls' : { Connection }
  '../src/queue.ls' : { Queue }
  \chai : { assert }: chai
  \chai-as-promised
}

# https://github.com/gkz/LiveScript/issues/211#issuecomment-33868831 :+1:
global.It = it
global.Spec = describe

chai.use chai-as-promised
chai.should!

Spec 'Connection' ->
  It 'call with wrong host should throw an exception' ->
    (phone 'address.that.doesnt.exists' 'tests')should.eventually.rejected-with Error
  
  It 'call without host should throw an exception' ->
    (phone 'tests')should.eventually.rejected-with Error
  
  It 'call without arguments should throw an exception' ->
    phone!should.eventually.rejected-with Error

  call = phone 'localhost' 'tests'
  It 'should open' ->
    call.should.eventually.instance-of Connection

  It 'should close' ->
    conn <~ call.then
    conn.hang!

Spec 'Queue' ->
  call = phone 'localhost' 'tests'
  It 'should be ok' ->
    call.then (connection) ->
      connection
        .with-queue 'test-queue', ['notice']
        .should.eventually.instance-of Queue
