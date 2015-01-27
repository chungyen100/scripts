var thread=100
var testTime=100

db.createCollection("cappedtest", {capped: true, size: 32768});

var ops = [{op: "insert", ns:"test.cappedtest", doc:{}}];

res = benchRun({ops:ops, seconds:testTime, writeCmd: true, parallel: thread});


