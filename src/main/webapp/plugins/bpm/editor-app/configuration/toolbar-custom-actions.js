/*
 * Activiti Modeler component part of the Activiti project
 * Copyright 2005-2014 Alfresco Software, Ltd. All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */
'use strict';
var CUSTOM_ACTIONS = {
	back :function(){
		window.location = getBasePath() + "view/bpm/bpm/config/definitionList";
	},
	exportModel : function(services){
		var modelMetaData = services.$scope.editor.getModelMetaData();
		window.location = 'bpm/model/export/'+modelMetaData.modelId+'/bpmn';
	},
	deployModel : function(services){
		var $scope = services.$scope;
		var modelMetaData = $scope.editor.getModelMetaData();
		$scope.status = {
	        loading: true
	    };
		services.$http({
			method: 'GET',
			url: "bpm/model/deploy/"+modelMetaData.modelId
		}).success(function(data, status, headers, config){
			$scope.status.loading = false;
	        //$scope.addAlert(data['msg'],'info');
	        //alert(data['msg']);
	        //console.log(data + "//" + status + "//"+headers + "//" + config);
			if(data['msg'].indexOf("成功")<0){
				jAlert(data['msg'],'提示');
			}else{
				jConfirm('部署成功，是否要进行任务配置？', '确定',function(res){
					if(res){
						location = getBasePath()+"view/bpm/bpm/config/taskList?id="+data['definitionId'];
					}
				});
			}
		}).error(function (data, status, headers, config) {
            $scope.error = {};
            console.log('Something went wrong when deploying the process model:' + JSON.stringify(data));
            $scope.status.loading = false;
        });
	},
	openModel : function(services){
		 jIframe(getBasePath() + 'view/bpm/bpm/config/model-list?version=' + Date.now(), '已保存模型列表','1024','500');
	}
};
for(var action in CUSTOM_ACTIONS){
	KISBPM.TOOLBAR.ACTIONS[action] = CUSTOM_ACTIONS[action];
}