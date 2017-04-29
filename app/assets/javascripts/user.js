$(document).ready(function() {

    //текущий урл
    var url = window.location.href;
    var arr = url.split('/');
    var last_url = arr[arr.length-1];

    //если текущий урл это users
    if(last_url == "users"){

        //обрабатываем json ответ ajax формы снять/утвердить пользователя
        $("body").on("ajax:success", ".new_user", function (xhr, data) {
            //по id находим элемент
            var box = $("td#"+data.user.id+".list_public");
            //обновляем
            if(data.status == 'утверждено'){
                $(box).html(
                    "<td class='list_public' id='"+ data.user.id +"'>" +
                    "<p>Подтвержден</p>" +
                    "<form class='new_user' id='new_user' action='/users' accept-charset='UTF-8' data-remote='true' method='post'>"+
                    "<input name='utf8' type='hidden' value='✓'>"+
                    "<input value='"+ data.user.id +"' type='hidden' name='user[user_id]' id='"+ data.user.id +"'>" +
                    "<p><input type='submit' name='nopublic_btn' value='Снять' data-disable-with='Снять'></p>"+
                    "</form>"+
                    "</td>"
                );
            }
            else{
                $(box).html(
                    "<td class='list_public' id='"+ data.user.id +"'>" +
                    "<p>Не подтвержден</p>" +
                    "<form class='new_user' id='new_user' action='/users' accept-charset='UTF-8' data-remote='true' method='post'>"+
                    "<input name='utf8' type='hidden' value='✓'>"+
                    "<input value='"+ data.user.id +"' type='hidden' name='user[user_id]' id='"+ data.user.id +"'>" +
                    "<p><input type='submit' name='public_btn' value='Утвердить' data-disable-with='Утвердить'></p>"+
                    "</form>"+
                    "</td>"
                );
            }
        }).on("ajax:error", function (xhr, data) {
            //как то можно обработать ошибку
        });
    }

});
