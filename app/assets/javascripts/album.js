$(document).ready(function() {

//////////////////////// работа со слайдером ////////////////////////

    //функция, которая вычисляет высоту экрана
    function HW(){
        //сама высота экрана
        var height_window = $(window).height();
        //высота изображения, которую надо установить
        var final_height = height_window - 50;
        return final_height;
    }
    //функция, которая устанавливает стрелки для листания посередине
    function middle(num, func){
        var final_height = func();
        var middle = final_height/num;
        $(".slider").css("margin-top", middle + "px");
    }
    //функция, которая подстраивает изображение по высоте под экран
    function img_good(func){
        var final_height = func();
        $(".imgin img").css("height", final_height + "px");
    }

    //при клике на маленькую фотку показываем оригинал
    $('body').on('click', '.thumb' ,function() {
        //id изображения, по которому кликнули
        var id = $(this).attr("id");
        //закидываем его в слайдер, как активный элемент
        $( $(".item#"+id)).addClass('active');

        //устанавливаем стрелки для листания посередине
        middle(2, HW);

        //подстраиваем изображение по высоте под экран
        img_good(HW);

        //показываем слайдер
        $(".pop_up").css("display", "block");
        $(".hidden_foto").css("display", "block");
        $("#album_fotos").css("display", "none");

        //высота активного элемента с фотографией
        var top_active = $(".active").offset().top;
        var final_top = top_active - 30;
        //крутим окно к активному элементу
        $("body").animate({scrollTop: final_top+"px"}, 1000);

    });

    //закрываем оригинал
    $('.close_slider').on('click' ,function() {
        $(".pop_up").css("display", "none");
        $(".hidden_foto").css("display", "none");
        $( $('.item')).removeClass('active');
        $("#album_fotos").css("display", "block");
    });

//////////////////////// работа со слайдером ////////////////////////


    //проверка check_box на состояние
    $(":checkbox").change(function(){
        var length = $(".table-striped input:checkbox:checked").length;
        if(length > 0){
            $(".hidden_tr").css("display", "block");
        }
        else{
            $(".hidden_tr").css("display", "none");
        }
    });



    //формируем ЧПУ
    // $(".new_album").on('click',function() {
    //
    //     var album_name = $("input#album_album_name").val();
    //
    //     String.prototype.replaceArray = function(find, replace) {
    //         var replaceString = this;
    //         var regex;
    //         for (var i = 0; i < find.length; i++) {
    //             regex = new RegExp(find[i], "g");
    //             replaceString = replaceString.replace(regex, replace[i]);
    //         }
    //         return replaceString;
    //     };
    //
    //     var textarea = $(this).val();
    //     var rus = ['А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ё', 'Ж', 'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ', 'Ы', 'Ь', 'Э', 'Ю', 'Я', 'а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я', ' '];
    //     var lat = ['A', 'B', 'V', 'G', 'D', 'E', 'E', 'Gh', 'Z', 'I', 'Y', 'K', 'L', 'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'F', 'H', 'C', 'Ch', 'Sh', 'Sch', 'Y', 'Y', 'Y', 'E', 'Yu', 'Ya', 'a', 'b', 'v', 'g', 'd', 'e', 'e', 'gh', 'z', 'i', 'y', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f', 'h', 'c', 'ch', 'sh', 'sch', 'y', 'y', 'y', 'e', 'yu', 'ya', '_'];
    //     album_name = album_name.replaceArray(rus, lat);
    //     $("input#album_cpu_album_name").val(album_name);
    // });


});