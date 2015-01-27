
//var testToParse = db.raw.findOne({label: "cap-1442-oplog"}); 
var testToParse = db.raw.findOne({label: "cap-1442-single"}); 
var dbConfig = testToParse["singledb"];

// Printing the table header
var test = dbConfig[0];
var header = "Test_name   ";
for (var i=0; i<=Object.keys(test.results).length-3; i++) {
//   print(Object.keys(test.results)[i]);
   header = header + Object.keys(test.results)[i] + "   ";
}

print(header);

for (var i=0; i< dbConfig.length; i++) {
   var test=dbConfig[i];
   var mTval = 0;
   var line = test.name + "   ";
   singleThread = test.results[1].median;
   sT = "" + singleThread;
   sT = sT.substring(0, sT.indexOf(".")+2);
   for (j=0; j<=Object.keys(test.results).length-3; j++) {
     if (mTval < test.results[Object.keys(test.results)[j]].median) {
        mTval = test.results[Object.keys(test.results)[j]].median;
     }
     val = "" + test.results[Object.keys(test.results)[j]].median;
     val = val.substring(0, val.indexOf(".")+2);
     line = line + val + "   "; 
   }  
//   maxThreadCount = Object.keys(test.results)[Object.keys(test.results).length-3];
//   maxThread = test.results[maxThreadCount].median;
//   mT = "" + maxThread;
//   print(test.name, sT, maxThread, maxThread/singleThread); 
//   ratio = "" + maxThread/singleThread;
   ratio = "" + mTval/singleThread;
   ratio = ratio.substring(0, ratio.indexOf(".")+2);
   line = line + ratio;
   print(line); 
}

