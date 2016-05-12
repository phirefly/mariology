var ActivityCardController;

ActivityCardController = (function(){
  
  function ActivityCardController(el, opts){
    this._setup(el,opts);
    return this;
  }

  ActivityCardController.prototype._setup = function(el,opts){
    $.extend(this,opts)
    this.$el = typeof el === "string" ? $(el) : el;
    this._events();
  }

  ActivityCardController.prototype._events = function(){
    var self = this;
    this.$el.on("activity-card:update", function(){
      var proposal_id = $("#proposal_id").attr("data-proposal-id");
      $.ajax({url: "/activity-feed/" + proposal_id + "/update_feed"})
        .done(function(html){
          self.update(html, {focus: false});
        });
    });
  }

  ActivityCardController.prototype.update = function(html, opts){
    opts = opts || {focus: true};
    this.$el.html(html);
    if (opts.focus){
      this.$el.find("textarea:first").focus();
    }
    this.$el.find("#add_a_comment").attr('disabled', true);
    this.$el.find("textarea:first").on('input',function(){
      $("#add_a_comment").attr('disabled', false);
    });
  }


  return ActivityCardController;

}());
window.ActivityCardController = ActivityCardController;
