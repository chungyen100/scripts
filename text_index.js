if ( typeof(tests) != "object" ) {
    tests = [];
}

// Global variables for the text index tests
// dictSize: number of characters in the "dictionary", number of words is dictSize - wordLength
//           we also use this as the number of documents in a collection but that can be changed
// wordLength: length of the "words"; all words are the same length currently but it can be changed
// wordDistance: distance between "words" in a multi-word phrase
var language = "english"; 
const dictSize = 4800;
const wordLength = 5;
const wordDistance = 100;
const numTerm = 5;

// number of queries to use in query tests; idea is to spread the hits across the tree
const numQuery = 50;

// ============
// Some Helper functions that are used to create the dictionary and phrases of fake words for the text index
// ============
// The dictionary is just a long random string. By picking fixed-sized substrings from it, we have our "words"
var enPossible = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1";
var possible = enPossible;

var dictionary = "";
for (var i = 0; i<dictSize; i++) 
    dictionary += possible.charAt(Math.floor(Math.random()*possible.length));

function generatePhrase(pos, term) {
    buf="";
    for (var i=0; i<term; i++) {
        // Adding a stop word for every 3 fake words; can be modified to increase or lower the frequency                                                                    
        if ( i%3==1) {
            buf = buf.concat("the")
                }
        else {
            var p = (pos + i*wordDistance) % (dictSize - wordLength);
            buf = buf.concat(dictionary.substring(p, p+wordLength));
        }
        if (i<term) {
            buf = buf.concat(" ");
        }
    }
    return buf;
}

function generatePhraseLowerCase(pos, term) {
    var buf = generatePhrase(pos, term);
    return buf.toLowerCase();
}

// Populate the collection with phrases of fake words
function populateCollection(col, term, entry) {
    col.drop();
    col.createIndex( { x: "text"}, {default_language: language} );
    for (var i = 0; i < entry; i++) {
        col.insert({ x: generatePhrase(i, term) });
        col.insert({ x: generatePhraseLowerCase(i, term) });
    }
    col.getDB().getLastError();
}



// ============
// Generate all queries with lower case words so we can exercise the caseSensitive switch
// ============

// Single-word search
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<numQuery; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    oplist.push({op: "find", query: {$text: {$search: generatePhraseLowerCase(c,1), $caseSensitive: false }}});
}

tests.push( { name: "Text.FindSingle",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
	    populateCollection(collection, numTerm, dictSize);
	},
	    ops: oplist
	    });

// Single-word search, case-sensitive
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<numQuery; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    oplist.push({op: "find", query: {$text: {$search: generatePhraseLowerCase(c,1), $caseSensitive: true }}});
}

tests.push( { name: "Text.FindSingleCaseSensitive",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
	    populateCollection(collection, numTerm, dictSize);
	},
	    ops: oplist
	    });



// Three-word search (or)
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<numQuery; i++) {
    var p = "";
    for (var j=0; j<3; j++) {
        var c = Math.floor(Math.random()*(dictSize-wordLength));
        p = p.concat(generatePhraseLowerCase(c,1), " ");
    }
    oplist.push({op: "find", query: {$text: {$search: p, $caseSensitive: false }}});
}

tests.push( { name: "Text.FindThreeWords",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
            populateCollection(collection, numTerm, dictSize);
        },
            ops: oplist
            });

// Three-word search (or), case sensitive
// Create an oplist and use it to create the test case
oplist=[];
for (var i=0; i<numQuery; i++) {
    var p = "";
    for (var j=0; j<3; j++) {
        var c = Math.floor(Math.random()*(dictSize-wordLength));
        p = p.concat(generatePhraseLowerCase(c,1), " ");
    }
    oplist.push({op: "find", query: {$text: {$search: p, $caseSensitive: true }}});
}

tests.push( { name: "Text.FindThreeWords",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
            populateCollection(collection, numTerm, dictSize);
        },
            ops: oplist
            });


// Three-word phrase search
// Create an oplist and use it to create the test case
// Be careful with the escape character "\"
oplist=[];
for (var i=0; i<numQuery; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    var p = "\"";
    p = p.concat(generatePhraseLowerCase(c, numTerm), "\"");
    oplist.push({op: "find", query: {$text: {$search: p, $caseSensitive: false }}});
}

tests.push( { name: "Text.FindPhrase",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
	    populateCollection(collection, numTerm, dictSize);
        },
	    ops: oplist
	    });

// Three-word phrase search, case-sensitive
// Create an oplist and use it to create the test case
// Be careful with the escape character "\"
oplist=[];
for (var i=0; i<numQuery; i++) {
    var c = Math.floor(Math.random()*(dictSize-wordLength));
    var p = "\"";
    p = p.concat(generatePhraseLowerCase(c, numTerm), "\"");
    oplist.push({op: "find", query: {$text: {$search: p, $caseSensitive: true }}});
}

tests.push( { name: "Text.FindPhraseCaseSensitive",
            tags: ['query','daily','weekly','monthly'],
            pre: function(collection) {
	    populateCollection(collection, numTerm, dictSize);
        },
	    ops: oplist
	    });


