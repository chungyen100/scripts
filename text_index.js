if ( typeof(tests) != "object" ) {
    tests = [];
}

// Character set used for the English language; note that only two digits are used to keep the frequency of numbers down
possible = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01";

// Some parameters to define the "dictionary"
// The dictionary is just a long random string. By picking fixed-sized substrings from it, we have our "words"
// dictSize: number of characters in the "dictionary", number of words is dictSize - wordLength
// wordLength: length of the "words"; all words are the same length currently but it can be changed
// wordDistance: distance between "words" in a multi-word phrase
dictSize = 4800;
wordLength = 5;
wordDistance = 100;

// dictionary="xyzABCDE";
// Populate the dictionary with random characters
dictionary = "";
for (var i = 0; i<dictSize; i++) 
    dictionary += possible.charAt(Math.floor(Math.random()*possible.length));

function generatePhrase(pos, numTerms) {
    buf="";
    for (var i=0; i<numTerms; i++) {
	var p = (pos + i*wordDistance) % (dictSize - wordLength);
	buf= buf.concat(dictionary.substring(p, p+wordLength), " ");
	// Adding a stop word for every 3 fake words; can be modified to increase or lower the frequency
	if ( i%3==1) buf=buf.concat("the ");
    }
    return buf;
}


// Single-word search
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<200; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    oplist.push({op: "find", query: {$text: {$search: "generatePhrase(c,1)" }},});
}

tests.push( { name: "Text.FindSingle",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
            collection.drop();
	    collection.createIndex({x: "text"});
	    for (var i = 0; i < 4800; i++) {
		collection.insert({x: generatePhrase(i, 7)});
            }
        },
	    ops: oplist
	    });

// Single-word search, case-sensitive
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<200; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    oplist.push({op: "find", query: {$text: {$search: "generatePhrase(c,1)", $caseSensivite: true }},});
}

tests.push( { name: "Text.FindSingle",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
            collection.drop();
	    collection.createIndex({x: "text"});
	    for (var i = 0; i < 4800; i++) {
		collection.insert({x: generatePhrase(i, 7)});
            }
        },
	    ops: oplist
	    });



// Three-word search (or)
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<200; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    oplist.push({op: "find", query: {$text: {$search: "generatePhrase(c,3)" }},});
}

tests.push( { name: "Text.FindSingle",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
            collection.drop();
	    collection.createIndex({x: "text"});
	    for (var i = 0; i < 4800; i++) {
		collection.insert({x: generatePhrase(i, 7)});
            }
        },
	    ops: oplist
	    });

// Three-word search, case-sensitive
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<200; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    oplist.push({op: "find", query: {$text: {$search: "generatePhrase(c,3)", $caseSensivite: true }},});
}

tests.push( { name: "Text.FindSingle",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
            collection.drop();
	    collection.createIndex({x: "text"});
	    for (var i = 0; i < 4800; i++) {
		collection.insert({x: generatePhrase(i, 7)});
            }
        },
	    ops: oplist
	    });

// Three-word phrase-search 
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<200; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    oplist.push({op: "find", query: {$text: {$search: "\"generatePhrase(c,3)\"" }},});
}

tests.push( { name: "Text.FindSingle",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
            collection.drop();
	    collection.createIndex({x: "text"});
	    for (var i = 0; i < 4800; i++) {
		collection.insert({x: generatePhrase(i, 7)});
            }
        },
	    ops: oplist
	    });

// Three-word search, case-sensitive
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<200; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    oplist.push({op: "find", query: {$text: {$search: "\"generatePhrase(c,3)\"", $caseSensivite: true }},});
}

tests.push( { name: "Text.FindSingle",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
            collection.drop();
	    collection.createIndex({x: "text"});
	    for (var i = 0; i < 4800; i++) {
		collection.insert({x: generatePhrase(i, 7)});
            }
        },
	    ops: oplist
	    });



