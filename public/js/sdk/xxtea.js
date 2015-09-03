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
            var txt="<p>" + data + "</p>";
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
            var txt="<p>" + data + "</p>";
            $(".result").append(txt);
        });
    });

    var str_md5 = $('#str_md5').text();
    var key_md5 = $('#key_md5').text();
    $(".md5-encrypt-button").click(function(){        
        $.post("/sdk/md5/encrypt",
        {
            str: str_md5,
            key: key_md5
        },
        function(data, status){
            // alert("Data: " + data + "\nStatus: " + status);
            var txt="<p>" + data + "</p>";
            $(".result-md5").append(txt);
        });
    });
});