<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/fwebUI/header.jsp"%>   
</head>
<body class="no-skin v_no_y">


	<form id="uploadForm">
		<p>
			指定文件groupId： <input type="text" id="groupId" name="groupId" value="1" />
		</p>
		<p>
			指定文件id： <input type="text" id="id" name="id" value="1" />
		</p>
		<p>
			是否创建压缩图： <input type="text" name="isGenerateCompressImage" value="true" />
		</p>
		<p>
			上传文件： <input type="file" name="file" />
		</p>
		<input type="button" value="上传" onclick="doUpload()" />
		<input type="button" id="button" value="listFile" onclick="listFile()"/>
	</form>
	<div id="fileList" style="width:500px;border:1px solid blue;min-height:300px;word-break:break-word;">
	</div>

	<script type="text/javascript">
		/*$.ajax({
		 type: "get",
		 contentType:"application/json;charset=UTF-8",
		 url:"http://localhost:8080/fileservice/fileext/groupFiles/585df9918f0742d7bf3aeb32b9cd56b6",
		 error: function(request) {
		 $.alert("error", "获取任务字典失败！");
		 },
		 success: function(data) {
		 console.log(data);
		 console.log(eval(data));
		 }
		 });*/
		function doUpload() {
			var formData = new FormData($("#uploadForm")[0]);
			$.ajax({
						url : 'http://192.168.1.181:8686/fileservice/fileservice/fileext',
						type : 'POST',
						data : formData,
						async : false,
						cache : false,
						contentType : false,
						processData : false,
						success : function(returndata) {
							console.log(returndata);
							alert(returndata);
						},
						error : function(returndata) {
							alert(returndata);
						}
					});
		}
		 function listFile(){
			 var id = $("#id").val();
			 var groupId = $("#groupId").val();
			 $.ajax({
				 url : 'http://192.168.1.181:8686/fileservice/fileext/list/'+groupId,
				 success : function(data) {
					$("#fileList").text(JSON.stringify(data));
				},
				error : function(data) {
					$("#fileList").text(JSON.stringify(data));
				}
			 });
		 }
	</script>
</body>
</html>