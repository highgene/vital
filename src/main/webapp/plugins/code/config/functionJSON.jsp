<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>查看功能配置的JSON</title>
<%@ include file="../header.jsp"%>
<style>
.Canvas {
	font: 10pt Georgia;
	background-color: #ECECEC;
	color: #000000;
	border: solid 1px #CECECE;
	overflow:auto
}
.ObjectBrace {
	color: #00AA00;
	font-weight: bold;
}
.ArrayBrace {
	color: #0033FF;
	font-weight: bold;
}
.PropertyName {
	color: #CC0000;
	font-weight: bold;
}
.String {color: #007777;}
.Number {color: #AA00AA;}
.Boolean {color: #0000FF;}
.Function {
	color: #AA6633;
	text-decoration: italic;
}
.Null {color: #0000FF;}
.Comma {
	color: #000000;
	font-weight: bold;
}
PRE.CodeContainer {
	margin-top: 0px;
	margin-bottom: 0px;
}
</style>
</head>
<body stye="overflow:auto">
<div id="Canvas" class="Canvas"></div>
</body>
</html>
<script type="text/javascript">
	var basePath = '${Config.baseURL}';
	var funId = '${param.funId}';
	window.TAB = "  ";
	var json;
	$(document).ready(function() {
		$.ajax({
			url : basePath + "code/config/functionConfig/"+funId,
			type : 'get',
			cache : false,
			success : function(data) {
				json = JSON.stringify(data);
				Process();
			},
			error : function() {
			}
		});
		window.resizeTo(screen.availWidth,screen.availHeight);
	});
	
	function IsArray(obj) {
		return obj && typeof obj === 'object' && typeof obj.length === 'number'
				&& !(obj.propertyIsEnumerable('length'));
	}

	function Process() {
		var html = "";
		try {
			if (json == "")
				json = "\"\"";
			var obj = eval("[" + json + "]");
			html = ProcessObject(obj[0], 0, false, false, false);
			document.getElementById("Canvas").innerHTML = "<PRE class='CodeContainer'>"
					+ html + "</PRE>";
		} catch (e) {
			alert("JSON语法错误,不能格式化,错误信息:\n" + e.message);
			document.getElementById("Canvas").innerHTML = "";
		}
	}
	function ProcessObject(obj, indent, addComma, isArray, isPropertyContent) {
		var html = "";
		var comma = (addComma) ? "<span class='Comma'>,</span> " : "";
		var type = typeof obj;

		if (IsArray(obj)) {
			if (obj.length == 0) {
				html += GetRow(indent, "<span class='ArrayBrace'>[ ]</span>"
						+ comma, isPropertyContent);
			} else {
				html += GetRow(indent, "<span class='ArrayBrace'>[</span>",
						isPropertyContent);
				for (var i = 0; i < obj.length; i++) {
					html += ProcessObject(obj[i], indent + 1,
							i < (obj.length - 1), true, false);
				}
				html += GetRow(indent, "<span class='ArrayBrace'>]</span>"
						+ comma);
			}
		} else if (type == 'object' && obj == null) {
			html += FormatLiteral("null", "", comma, indent, isArray, "Null");
		} else if (type == 'object') {
			var numProps = 0;
			for ( var prop in obj)
				numProps++;
			if (numProps == 0) {
				html += GetRow(indent, "<span class='ObjectBrace'>{ }</span>"
						+ comma, isPropertyContent);
			} else {
				html += GetRow(indent, "<span class='ObjectBrace'>{</span>",
						isPropertyContent);
				var j = 0;
				for ( var prop in obj) {
					html += GetRow(indent + 1, "<span class='PropertyName'>"
							+ prop
							+ "</span>: "
							+ ProcessObject(obj[prop], indent + 1,
									++j < numProps, false, true));
				}
				html += GetRow(indent, "<span class='ObjectBrace'>}</span>"
						+ comma);
			}
		} else if (type == 'number') {
			html += FormatLiteral(obj, "", comma, indent, isArray, "Number");
		} else if (type == 'boolean') {
			html += FormatLiteral(obj, "", comma, indent, isArray, "Boolean");
		} else if (type == 'function') {
			obj = FormatFunction(indent, obj);
			html += FormatLiteral(obj, "", comma, indent, isArray, "Function");
		} else if (type == 'undefined') {
			html += FormatLiteral("undefined", "", comma, indent, isArray,
					"Null");
		} else {
			html += FormatLiteral(obj, "\"", comma, indent, isArray, "String");
		}
		return html;
	}
	function FormatLiteral(literal, quote, comma, indent, isArray, style) {
		if (typeof literal == 'string')
			literal = literal.split("<").join("&lt;").split(">").join("&gt;");
		var str = "<span class='" + style + "'>" + quote + literal + quote
				+ comma + "</span>";
		if (isArray)
			str = GetRow(indent, str);
		return str;
	}
	function FormatFunction(indent, obj) {
		var tabs = "";
		for (var i = 0; i < indent; i++)
			tabs += window.TAB;
		var funcStrArray = obj.toString().split("\n");
		var str = "";
		for (var i = 0; i < funcStrArray.length; i++) {
			str += ((i == 0) ? "" : tabs) + funcStrArray[i] + "\n";
		}
		return str;
	}
	function GetRow(indent, data, isPropertyContent) {
		var tabs = "";
		for (var i = 0; i < indent && !isPropertyContent; i++)
			tabs += window.TAB;
		if (data != null && data.length > 0
				&& data.charAt(data.length - 1) != "\n")
			data = data + "\n";
		return tabs + data;
	}

</script>