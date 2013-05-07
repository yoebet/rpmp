$(document).on('ajax:success', 'a[data-remote],form[data-remote]', function(evt, data, status, xhr){
    var guessScript = /^\s*(\$|alert|var |function)/.test(data)
    if(guessScript) return false
    var $trigger=$(this)
    var then_toggle=$trigger.attr('data-toggle')
    $([['update','html'],['replace','replaceWith'],['append'],['prepend'],['before'],['after']]).each(function(i,e){
        var containerId=$trigger.attr('data-'+e[0])
        var mani=e[1]||e[0]
        if(containerId!=null){
            var $container=(containerId=='')? $trigger : $('#'+containerId)
            if(containerId=='rmain' && mani=='html' && history.pushState){
                if(!history.state){
                    $container.data('ori_html', $container.html())
                }
                history.pushState({phtml:data}, null, $trigger.attr('href')||'#')
            }
            if(then_toggle){
                $container.hide()
                $container[mani](data)
                $container.effect('slide',{direction:'up',mode:'show'},500)
                $trigger.unbind('click.rails').click(function(){
                    //$container.toggle()
                    $container.effect('slide',{direction:'up',mode: $container.is(":hidden")? 'show':'hide'},500)
                    return false
                })
            }else{
                $container[mani](data)
            }
            return false
        }
    })
})
$(window).bind('popstate',function(event){
    var $rmain=$('#rmain')
    if(history.state){
        $rmain.html(history.state.phtml)
    }else{
        var ori_html=$rmain.data('ori_html')
        if(ori_html){
            $rmain.html(ori_html)
        }
    }
})