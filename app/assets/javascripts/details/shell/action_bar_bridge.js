var ActionBarBridge;
ActionBarBridge = (function() {

  function ActionBarBridge(config){
    config = config || {};
    this.config = {
      actionBar:      '#action-bar-wrapper',
      detailsSave:    '#request-details-card',
      notifications:  '#action-bar-status',
      modalCard:      '#modal-wrapper',
      updateView:     '#mode-parent',
    }
    this._overrideTestConfig(config);
    this._blastOff();
  }

  ActionBarBridge.prototype._blastOff = function(){
    var config = this.config;
    // Data
    this.detailsSave = new DetailsSave(config.detailsSave, config.detailsSaveAll);
    this.updateView = new UpdateView(config.updateView);

    // Views
    this.modals = new ModalController(config.modalCard);
    this.actionBar = new ActionBar(config.actionBar);
    this.notification = new Notifications(config.notifications);
    this._setupEvents();
  }

  ActionBarBridge.prototype._overrideTestConfig = function(config){
    var opt = this.config;
    $.each(opt, function(key, item){
      if(config[key]){
        opt[key] = config[key];
      }
    });
    this.config = opt;
  }

  ActionBarBridge.prototype._setupEvents = function(){
    this._setupActionBar();
    this._setupSaveModal();
    this._setupFormSubmitModal();
  }

  /* Action Bar */

  ActionBarBridge.prototype._setupActionBar = function(){
    var self = this;
    this.actionBar.el.on("action-bar-clicked:cancel", function(){
      self.detailsCancelled();
    });
    this.actionBar.el.on("action-bar-clicked:save", function(){
      self.notification.clearAll();
    });
    this.actionBar.el.on("action-bar-clicked:edit", function(){
      self.detailsMode('edit');
    });
  }

  ActionBarBridge.prototype.enableModalButtons = function(){
    this.modals.el.find('button').attr('disabled', false).css('opacity', 1);
  }

  ActionBarBridge.prototype.disableModalButtons = function(){
    this.modals.el.find('button').attr('disabled', 'disabled').css('opacity', 0.5);
  }

  ActionBarBridge.prototype.checktimeout = function(l){
    var self = this;
    window.setTimeout(function(){
      if(l.ladda( 'isLoading' )){
        l.ladda( 'stop' );
        self.enableModalButtons();
      }
    }, 7500);
  }

  ActionBarBridge.prototype._setupSaveModal = function(){
    var self = this;
    this.modals.el.on("save_confirm-modal:confirm", function(event, item){
      var l = $(item).ladda();
      l.ladda( 'start' );
      self.disableModalButtons();
      self.actionBar.el.trigger("action-bar-clicked:saving");
      self.detailsSave.el.trigger("details-form:save");
      self.checkTimeout(l);
    });
    this.modals.el.on("save_confirm-modal:cancel", function(event, item){
      self._closeModal();
    });
    this.modals.el.on("modal:cancel", function(){
      self.actionBar.stopLadda();
    });
  }

  ActionBarBridge.prototype._setupFormSubmitModal = function(){
    var self = this,
      events = "attachment_confirm-modal:confirm observer_confirm-modal:confirm";
    this.modals.el.on(events, function(event, item, sourceEl){
      self._submitAndClose(sourceEl);
    });
  }

  ActionBarBridge.prototype._submitAndClose = function(sourceEl){
    var self = this;
    $(sourceEl).parent().submit();
    self._closeModal();
  }

  ActionBarBridge.prototype._closeModal = function(){
    this.modals.el.trigger("modal:close");
    this.actionBar.stopLadda();
  }
  /* End Action Bar */


  return ActionBarBridge;

}());

window.ActionBarBridge = ActionBarBridge;

