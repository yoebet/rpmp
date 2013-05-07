
function toggle_image_size(id,type,actual_width,max_width){
  $("#floatImg_"+id).prop('width',(type==1)? actual_width:max_width)
  $("#leftImgToggle_"+id).removeProp('onclick').unbind('click').click(function(){
    toggle_image_size(id,(type==1)? 2:1,actual_width,max_width)
    return false
  }).text((type==1)? '缩小':'原图大小')
}

function view_image(id,url,actual_width,max_width){
  var fid = $('#floatImgDiv')
  if($('#floatImgDiv img#floatImg_'+id).length>0){
    fid.show()
  }else {
    if(fid.length==0){
      $('body').append('<div id="floatImgDiv" style="display:none;"></div>')
        fid =  $('#floatImgDiv')
        if(fid.draggable)fid.draggable()
      } else{
        fid.empty()
      }
      var itonclick=' onclick="toggle_image_size('+id+',1,'+actual_width+','+max_width+'); return false;"'
      var html=''
      if(actual_width > max_width) {
        html+='<div style="float:left;"><a href="#" id="leftImgToggle_'+id+'"'+itonclick+'>原图大小</a></div>'
      }
      html+='<div style="float:right;"><a href="#" onclick="$(&quot;#floatImgDiv&quot;).hide(); return false;">关闭</a></div>'
      html+='<div style="clear:both;">'
      html+='<img id="floatImg_'+id+'" src="'+url+'"'
      if(actual_width > max_width){
        html+=' width="'+max_width+'"'
      }
      html+=' />'
      html+='</div>'
      fid.html(html)
      fid.show()
  }
}
