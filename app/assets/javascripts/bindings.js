Bashly = {
    common: {
        init: function() {
            // application-wide code
            faye = new Faye.Client('http://localhost:9292/faye');
        }
    }, 
    posts: {
        init: function() {
            // posts controller-wide code
            $(document).ready(function(){
                
                $.each($("figure.kudo"), function(index, element){
                    var postID = $(element).data("id");
                    if($.cookie(""+postID) == "kodoed"){
                        $(element).addClass("complete");   
                    }else{
                        $(element).kudoable()
                    }
                });
                $("figure.kudo").on("kudo:added", function(event){
                    var element = $(this);
                    var postID = element.data('id');
                    var url = element.data('url');
                    $.ajax({
                        dataType: 'json',
                        method: 'POST',
                        url: url,
                        data: {
                            post_id: postID
                        }
                    }).done(function(data){
                        $.cookie(data.kudo.post_id, 'kodoed');
                    });                   
                });
                $(".search-bashly").on("click", function(){
                    $(".search-input").css("visibility", "visible").css("width", "200px");
                });
                $(".search-input").on("focusout", function(){
                    $(this).css("width", "0px").css("visibility", "hidden");  
                });
            });
        },
        new: function() {
            //Enable widearea for post content
            wideArea();
        },
        show: function() {
            $(".create-post").on("click", function(e){
                e.preventDefault();
                var url = $(this).parents("form").attr("action");
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: url,
                    data: {
                        comment: {
                            author: $(".comment-author").val(),
                            content: $(".comment-content").val()
                        }
                    }
                }).done(function(data){
                    if(data.success){ 
                        $(".comment-author").val("");
                        $(".comment-content").val("");
                    }else{
                        if($.trim($(".comment-author").val()).length == 0){
                            $(".comment-author").addClass("error");
                        }
                        if($.trim($(".comment-content").val()).length == 0){
                            $(".comment-content").addClass("error");
                        }
                    }
                });
            });
            var channel = "/comments/"+$(".post").data("id");
            faye.subscribe(channel, function(data) {
                $(".comments-index").prepend(data.partial);
            });
        }
    }

};

BUtil = {
    exec: function( controller, action ) {
        var ns = Bashly,
            action = _.isUndefined(action) ? "init" : action;

        if ( controller !== "" && ns[controller] && _.isFunction(ns[controller][action]) ) {
            ns[controller][action]();
        }
    },

    init: function() {
        var body = $("body"),
            controller = body.data("controller"),
            action = body.data("action");

        BUtil.exec( "common" );
        BUtil.exec( controller );
        BUtil.exec( controller, action );
    }
};

$(document).ready( BUtil.init );