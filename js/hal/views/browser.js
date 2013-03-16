HAL.Views.Browser = Backbone.View.extend({
  initialize: function(opts) {
    var self = this;
    this.vent = opts.vent;
    this.explorerView = new HAL.Views.Explorer({ vent: this.vent });
    this.inspectorView = new HAL.Views.Inspector({ vent: this.vent });
  },

  className: 'hal-browser row-fluid',

  render: function() {
    this.inspectorView.render();
    this.explorerView.render();

    this.$el.empty();
    this.$el.append(this.explorerView.el);
    this.$el.append(this.inspectorView.el);
  },
});
