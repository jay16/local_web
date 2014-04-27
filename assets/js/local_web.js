(function() {
  window.LocalWeb = {
    chk: function() {
      alert("yes");
    },
    refresh: function() {
      $.ajax({
        url: "/refresh",
        success: function(data) {
          window.location.reload();
        }
      });
    }
  };

}).call(this);
