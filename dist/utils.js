// Generated by LiveScript 1.4.0
var uuid, out$ = typeof exports != 'undefined' && exports || this;
out$.uuid = uuid = function(){
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c){
    var r, v;
    r = Math.random() * 16 | 0;
    v = c === 'x'
      ? r
      : r & 3 | 8;
    return v.toString(16);
  });
};