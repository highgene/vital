var attachmentUrl_groupId = baseFilePath + 'file/?table=act_re_deployment&field=groupId';
$(function () {
    'use strict';
    $('#fileupload_groupId').fileupload({
        url: attachmentUrl_groupId,
        disableImageResize: /Android(?!.*Chrome)|Opera/
                .test(window.navigator.userAgent),
        maxFileSize: 52428800 == 52428800 ? 50000000 : 52428800,
        maxNumberOfFiles:5 == 5 ? 4 : 5,
        acceptFileTypes: /(\.|\/)(bpmn|bpmn20.xml)$/i
    });
    $('#fileupload_groupId').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );
});
function loading(field,value){
    $.ajax({
        url: baseFilePath + 'fileext/list/'+value,
        dataType: 'json',
        context: $('#fileupload_'+field)
    }).always(function () {
        $(this).removeClass('fileupload-processing');
    }).done(function (result) {
    	
        $(this).fileupload('option', 'done')
            .call(this, $.Event('done'), {result: result});
    });
}
function getAttachmentUrl(url , data){
	url = url.replace("/file/?table=","/fileext/?targetTable=");
	url = url.replace("&field=","&targetField=");
	var groupIdIndex = url.indexOf("groupId=");
	if(groupIdIndex > -1){
		url = url.substring(0,groupIdIndex-1);
	}
	url += "&groupId="+data;
	return url;
}
function initFile_groupId(field,value){
	$('#fileupload_'+field).addClass('fileupload-processing');
	$('#fileTbody').empty();
	if(value == null || value == undefined || value==''){
		$.get(baseFilePath + 'fileext/groupId/', function(data){
 	 		$('#'+field).val(data);
 	 		attachmentUrl_groupId = getAttachmentUrl(attachmentUrl_groupId, data);
 	 		$('#fileupload_groupId').fileupload({
      			 url: attachmentUrl_groupId
   			});
 	 		loading(field ,data);
		});
	}else{
		$('#'+field).val(value);
		attachmentUrl_groupId = getAttachmentUrl(attachmentUrl_groupId,value);
		$('#fileupload_groupId').fileupload({
      			 url: attachmentUrl_groupId
   		});
		loading(field ,value);
	}
}
function initFile(field,value){
	var fileMethod = "initFile_"+field+"(field,value)";
	eval(fileMethod);
}