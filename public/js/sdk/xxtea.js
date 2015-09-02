$(document).ready( function() {        
    var str = $('#str').text();
    var key = $('#key').text();
    $(".encrypt-button").click(function(){        
        $.post("/sdk/xxtea/encrypt",
        {
            str: str,
            key: key
        },
        function(data, status){
            // alert("Data: " + data + "\nStatus: " + status);
            var txt="<span>" + data + "</span>";
            $(".result").append(txt);
        });
    });
    $(".decrypt-button").click(function(){        
        $.post("/sdk/xxtea/decrypt",
        {
            str: str,
            key: key
        },
        function(data, status){
            // alert("Data: " + data + "\nStatus: " + status);
            var txt="<span>" + data + "</span>";
            $(".result").append(txt);
        });
    });
});