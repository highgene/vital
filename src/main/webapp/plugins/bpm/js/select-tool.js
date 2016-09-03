	function selectUser(baseURL,selectId,defaultVal,role){
		$("#"+selectId).empty();
		if (typeof(role) == "undefined") {
			role = "";
		}
 	    $.ajax({
			url :  baseURL+'hr/userHelper?pageIndex=0&pageSize=1000&role='+role,
			type : "get",
			cache: true,
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				 $("#"+selectId).append("<option value=\"\" ></option>");
			     $(data).each(function(i,el){
			    	 var selected = "";
			    	 $(defaultVal).each(function(i,defaultVal_el){
			    		 if(el.id == defaultVal_el){
			    			 selected="selected=true";
			    		 }
			    	 });
			    	 $("#"+selectId).append("<option value='"+el.id+"' "+selected+">"+el.userName+"</option>");
			     });
			 	$('#'+selectId).chosen({allow_single_deselect:true,no_results_text: "没有找到!"}); 
			 	$(window)
				.off('resize.chosen')
				.on('resize.chosen', function() {
					$('.chosen-select').each(function() {
						 var $this = $(this);
						 $this.next().css({'width': '100%'});
					})
				}).trigger('resize.chosen');
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert('error')
			}
	 });
  }
	function selectMonth(baseURL,selectId,defaultVal,role){
		$("#"+selectId).empty();
		if (typeof(role) == "undefined") {
			role = "";
		}
		var data = [1,2,3,4,5,6,7,8,9,10,11,12];
 	     $("#"+selectId).append("<option value=\"\" ></option>");
			     $(data).each(function(i,el){
			    	 var selected = "";
			    	 $(defaultVal).each(function(i,defaultVal_el){
			    		 if(el == defaultVal_el){
			    			 selected="selected=true";
			    		 }
			    	 });
			    	 $("#"+selectId).append("<option value='"+el+"' "+selected+">"+el+"</option>");
			     });
			 	$('#'+selectId).chosen({allow_single_deselect:true,no_results_text: "没有找到!"}); 
			 	$(window)
				.off('resize.chosen')
				.on('resize.chosen', function() {
					$('.chosen-select').each(function() {
						 var $this = $(this);
						 $this.next().css({'width': '7%'});
					})
				}).trigger('resize.chosen');
  }
 
	