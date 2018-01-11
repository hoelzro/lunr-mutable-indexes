# Lunr Mutable Indexes - Mutable indexes for lunr.js 2.1.x

With the release of [lunr.js 2.0](https://github.com/olivernn/lunr.js), lunr
removed the ability to update existing indexes with new data.  While the space
benefits of this change are nice, some users need the flexibility of updating
their indexes with new data.  That's what this library is for.

# Example

```js

var lunr = require('lunr');
var { MutableBuilder, MutableIndex } = require('lunr-mutable');

var builder = new MutableBuilder();

// Add default pipeline and searchPipeline components - sorry,
// no sugary builder function yet!
builder.pipeline.add(
  lunr.trimmer,
  lunr.stopWordFilter,
  expandQuery,
  lunr.stemmer
);

builder.searchPipeline.add(
  lunr.stemmer
);

// Define the fields of documents
builder.field('title');
builder.field('body');

builder.add({
    "title": "Twelfth-Night",
    "body": "If music be the food of love, play on: Give me excess of it…",
    "author": "William Shakespeare",
    "id": "1"
});

// Works just like lunr.js
var index = builder.build();

// But now you can add...
index.add({
    "title": "Merchant of Venice",
    "body": "You speak an infinite deal of nothing.",
    "author": "William Shakespeare",
    "id": "2"
});

// remove...
index.remove({ id: "1" });

// or update existing documents.
index.update({
    "body": "With mirth and laughter let old wrinkles come.",
    "id": "2"
});

// You can also serialize an index:
var serialized = JSON.stringify(index);

// ...and deserialize it later:
var sameIndex = MutableIndex.load(JSON.parse(serialized));
```
