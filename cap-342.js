var strings = ["abc", "123", "xyz", "Chung-yen Chang", "   ", "ljk", "xxxx", "ABCD", "xxxxyyyyzzz", "MNOPWXYZ", "emacs xyz"]

for (var i=0; i<3000; i++) { 
    db.foo.insert({a: Math.random().toString(36).substr(2, 5), b: strings[Math.floor(Math.random()*10)], c: Math.floor(Math.random()*100000), d: 10000+Math.floor(Math.random()*40000), e: { e1: Math.random().toString(36).substr(2, 7), e2: Math.random(), e3: strings[Math.floor(Math.random()*10)]}, f: Math.random(1000)}); 
}

db.foo.ensureIndex({a:1}); db.foo.ensureIndex({b:1}), db.foo.ensureIndex({c:1}); db.foo.ensureIndex({d:1}); db.foo.ensureIndex({f:1}); db.foo.ensureIndex({e:1}); db.foo.ensureIndex({a:1, "e.e1": 1}); db.foo.ensureIndex({c:1, "e.e2":1}); db.foo.ensureIndex({f:1, "e.e3":1}); db.foo.ensureIndex({b:1, d:1});
