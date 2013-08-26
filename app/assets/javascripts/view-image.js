
function toggle_image_size(id,type,actual_width,max_width){
  $("#floatImg_"+id).prop('width',(type==1)? actual_width:max_width)
  $("#leftImgToggle_"+id).removeProp('onclick').unbind('click').click(function(){
    toggle_image_size(id,(type==1)? 2:1,actual_width,max_width)
    return false
  }).text((type==1)? '缩小':'原图大小')
}

function view_image(id,url,actual_width,max_width){
  var $floatImg = $('#floatImgDiv')
  if($('#floatImgDiv img#floatImg_'+id).length>0){
    $floatImg.show()
  }else {
    if($floatImg.length==0){
      $('body').append('<div id="floatImgDiv" style="display:none;"></div>')
        $floatImg =  $('#floatImgDiv')
        if($floatImg.draggable)$floatImg.draggable()
      } else{
        $floatImg.empty()
      }
      var onclick=' onclick="toggle_image_size('+id+',1,'+actual_width+','+max_width+'); return false;"'
      var html=''
      if(actual_width > max_width) {
        html+='<div style="float:left;"><a href="#" id="leftImgToggle_'+id+'"'+onclick+'>原图大小</a></div>'
      }
      html+='<div style="float:right;"><a href="#" onclick="$(&quot;#floatImgDiv&quot;).hide(); return false;">关闭</a></div>'
      html+='<div style="clear:both;">'
      html+='<img id="floatImg_'+id+'" src="'+url+'"'
      if(actual_width > max_width){
        html+=' width="'+max_width+'"'
      }
      html+=' />'
      html+='</div>'
      $floatImg.html(html)
      $floatImg.show()
  }
}
