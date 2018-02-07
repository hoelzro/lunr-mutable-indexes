/**
 * A convenience function for configuring and constructing
 * a new mutable lunr Index.
 *
 * A lunr.MutableBuilder instance is created and the pipeline setup
 * with a trimmer, stop word filter and stemmer.
 *
 * This mutable builder object is yielded to the configuration function
 * that is passed as a parameter, allowing the list of fields
 * and other builder parameters to be customised.
 *
 * All documents _must_ be added within the passed config function, but
 * you can always update the index later. ;)
 *
 * @example
 * var idx = lunrMutable(function () {
 *   this.field('title')
 *   this.field('body')
 *   this.ref('id')
 *
 *   documents.forEach(function (doc) {
 *     this.add(doc)
 *   }, this)
 * })
 *
 * index.add({
 *     "title": "new title",
 *     "body": "new body",
 *     "id": "2"
 * })
 *
 * index.remove({ id: "1" });
 *
 * index.update({
 *   "body": "change",
 *   "id": "2"
 * })
 */

var lunrMutable = function (config) {
  var builder = new MutableBuilder();

  builder.pipeline.add(
    lunr.trimmer,
    lunr.stopWordFilter,
    lunr.stemmer
  )

  builder.searchPipeline.add(
    lunr.stemmer
  )

  config.call(builder, builder)
  return builder.build()
}

lunrMutable.version = "@VERSION"

lunrMutable.Builder = MutableBuilder
lunrMutable.Index = MutableIndex
