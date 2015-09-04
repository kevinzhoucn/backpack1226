var xxtea = function($){
  var cacheElements = {
    "str_xxtea" : $('#str').text(),
    "str_key" : $('#key').text(),
    "str_md5" : $('#str_md5').text(),
    "key_md5" : $('#key_md5').text()
  };
  return {
    init : function(){
        this.bindEvents();
    },
    bindEvents : function(){
        $(".encrypt-button").click(function(event){
            event.preventDefault();
            $.post("/sdk/xxtea/encrypt",
            {
                // str: cacheElements.str_xxtea,
                // key: cacheElements.str_key
                str: $('#str').val(),
                key: $('#key').val()
            },
            function(data, status){
                // alert("Data: " + data + "\nStatus: " + status);
                var txt="<p>" + data + "</p>";
                $(".result").append(txt);
            });
        });
        $(".decrypt-button").click(function(event){
            event.preventDefault();
            $.post("/sdk/xxtea/decrypt",
            {
                // str: cacheElements.str_xxtea,
                // key: cacheElements.str_key
                str: $('#str').val(),
                key: $('#key').val()
            },
            function(data, status){
                // alert("Data: " + data + "\nStatus: " + status);
                var txt="<p>" + data + "</p>";
                $(".result").append(txt);
            });
        });
        $(".md5-encrypt-button").click(function(event){
            event.preventDefault();
            $.post("/sdk/md5/encrypt",
            {
                // str: cacheElements.str_md5,
                // key: cacheElements.key_md5
                str: $('#str_md5').val(),
                key: $('#key_md5').val()
            },
            function(data, status){
                // alert("Data: " + data + "\nStatus: " + status);
                var txt="<p>" + data + "</p>";
                $(".result-md5").append(txt);
            });
        });    
    }
  }
}(jQuery);

$(document).ready( function() {
    xxtea.init();
});