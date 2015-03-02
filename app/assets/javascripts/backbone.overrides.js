// Backbone.RelationalModel + Backbone.DeepModel
Backbone.DeepRelationalModel = Backbone.DeepModel.extend(Backbone.RelationalModel);

// Backbone.PageableCollection extended
Backbone.PageableCollection = Backbone.PageableCollection.extend({

  /**
     @property {"server"|"client"|"infinite"} [mode="server"] The mode of
     operations for this collection. `"server"` paginates on the server-side,
     `"client"` paginates on the client-side and `"infinite"` paginates on the
     server-side for APIs that do not support `totalRecords`.
  */
  mode: "infinite",

  /**
     Any `state` or `queryParam` you override in a subclass will be merged with
     the defaults in `Backbone.PageableCollection` 's prototype.
   */
  state: {
    /**
       The first page index. Set to 0 if your server API uses 0-based indices.
       You should only override this value during extension, initialization or
       reset by the server after fetching. This value should be read only at
       other times.
     */
    pageSize: 10,
  },

  /**
     A translation map to convert Backbone.PageableCollection state attributes
     to the query parameters accepted by your server API.

     You can override the default state by extending this class or specifying
     them in `options.queryParams` object hash to the constructor.

     @property {Object} queryParams
     @property {string} [queryParams.currentPage="page"]
     @property {string} [queryParams.pageSize="per_page"]
     @property {string} [queryParams.totalPages="total_pages"]
     @property {string} [queryParams.totalRecords="total_entries"]
     @property {string} [queryParams.sortKey="sort_by"]
     @property {string} [queryParams.order="order"]
     @property {string} [queryParams.directions={"-1": "asc", "1": "desc"}] A
     map for translating a Backbone.PageableCollection#state.order constant to
     the ones your server API accepts.
  */
  queryParams: {
    pageSize: "limit",
    currentPage: "page",
    totalPages: "total_pages",
    totalRecords: "total_entries",
    sortKey: "sort_by",
    order: "order",
    directions: {
      "-1": "asc",
      "1": "desc"
    }
  },

  /** OVERRIDE METHODS **/

  /**
     Parse server response for server pagination state updates. Not applicable
     under infinite mode.

     This default implementation first checks whether the response has any
     state object as documented in #parse. If it exists, a state object is
     returned by mapping the server state keys to this pageable collection
     instance's query parameter keys using `queryParams`.

     It is __NOT__ neccessary to return a full state object complete with all
     the mappings defined in #queryParams. Any state object resulted is merged
     with a copy of the current pageable collection state and checked for
     sanity before actually updating. Most of the time, simply providing a new
     `totalRecords` value is enough to trigger a full pagination state
     recalculation.

         parseState: function (resp, queryParams, state, options) {
           return {totalRecords: resp.total_entries};
         }

     If you want to use header fields use:

         parseState: function (resp, queryParams, state, options) {
             return {totalRecords: options.xhr.getResponseHeader("X-total")};
         }

     This method __MUST__ return a new state object instead of directly
     modifying the #state object. The behavior of directly modifying #state is
     undefined.

     @param {Object} resp The deserialized response data from the server.
     @param {Object} queryParams A copy of #queryParams.
     @param {Object} state A copy of #state.
     @param {Object} [options] The options passed through from
     `parse`. (backbone >= 0.9.10 only)

     @return {Object} A new (partial) state object.
   */
  parseState: function (resp, queryParams, state, options) {
    if (!(resp && resp.paging)) return null;

    var newState = _.clone(state);
    var serverState = resp.paging;

    _.each(_.pairs(_.omit(queryParams, "directions")), function (kvp) {
      var k = kvp[0], v = kvp[1];
      var serverVal = serverState[v];
      if (!_.isUndefined(serverVal) && !_.isNull(serverVal)) newState[k] = serverState[v];
    });

    if (serverState.order) {
      newState.order = _.invert(queryParams.directions)[serverState.order] * 1;
    }
    return newState;
  },

  /**
     Return results object of response.
   */
  parseRecords: function (resp, options) {
    return resp && resp.results;
  },

  /**
     Return navigating object of response.
   */
  parseLinks: function (resp, xhr) {
    return resp && resp.paging && resp.paging.navigating;
  },
});
