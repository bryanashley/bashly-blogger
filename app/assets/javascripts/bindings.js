Bashly = {
    common: {
        init: function() {
            // application-wide code
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
            });
        },
        new: function() {
            //Enable widearea for post content
            wideArea();
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