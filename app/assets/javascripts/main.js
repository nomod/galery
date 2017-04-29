$(document).ready(function() {

    //текущий урл
    var current_url = window.location.href;
    var current_arr = current_url.split('/');
    var current_last_url = current_arr[current_arr.length-1];

    if(current_last_url == '') {
        var mass_foto = $(".main_foto_in");
        for(var i = 0; i < mass_foto.length; i++){
            var rand_rotate = Math.floor(Math.random() * (25 - (-25))) + (-25);
            $(mass_foto[i]).css("transform", "rotate("+rand_rotate+"deg)");
        }
    }

});