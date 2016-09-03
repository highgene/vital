	function addPaperclip(gridData, baseURL, groupid){
		var groupid = groupid || "groupid";
		var groupIds = [];
		for(var i=0; i < gridData.data.length; i++){
			if(gridData.data[i][groupid]){
				groupIds.push(gridData.data[i][groupid]);
			}
		}
		if(groupIds.length){
			$.ajax({
				type: "get",
				contentType:"application/json;charset=UTF-8",
				url:baseURL + "/file/groupFiles/" + groupIds.join(","),
			    error: function(request) {
			    	$.alert("error", "获取附件信息失败！");
			    },
			    success: function(data) {
			    	for(var j=0; j<data.length; j++){
			    		if(data[j].size){
					    	$("#"+data[j].groupID).replaceWith("<i class='fa fa-paperclip' style='margin-right:5px;'></i>");
			    		}
			    	}
			    }
			});
		}
	}