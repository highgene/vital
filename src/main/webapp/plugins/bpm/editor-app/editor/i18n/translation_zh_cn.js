/**
 * @author nicolas.peters
 * 
 * Contains all strings for the default language (en-us).
 * Version 1 - 08/29/08
 */
if(!ORYX) var ORYX = {};

if(!ORYX.I18N) ORYX.I18N = {};

ORYX.I18N.Language = "en_us"; //Pattern <ISO language code>_<ISO country code> in lower case!

if(!ORYX.I18N.Oryx) ORYX.I18N.Oryx = {};

ORYX.I18N.Oryx.title		= "Oryx";
ORYX.I18N.Oryx.noBackendDefined	= "注意！后台没有定义。请求模型不能被加载。试图用保存插件加载配置。";
ORYX.I18N.Oryx.pleaseWait 	= "加载中，请稍候...";
ORYX.I18N.Oryx.notLoggedOn = "尚未登录";
ORYX.I18N.Oryx.editorOpenTimeout = "编辑可能没有开启。请检查一下，否有弹出窗口拦截器启用和禁用或允许该网站弹出窗口。我们不会在这个网站上展示任何广告。";

if(!ORYX.I18N.AddDocker) ORYX.I18N.AddDocker = {};

ORYX.I18N.AddDocker.group = "Docker";
ORYX.I18N.AddDocker.add = "添加Docker";
ORYX.I18N.AddDocker.addDesc = "通过点击，添加一个Docker到边缘";
ORYX.I18N.AddDocker.del = "删除Docker";
ORYX.I18N.AddDocker.delDesc = "删除一个Docker";

if(!ORYX.I18N.Arrangement) ORYX.I18N.Arrangement = {};

ORYX.I18N.Arrangement.groupZ = "Z-Order";
ORYX.I18N.Arrangement.btf = "置于顶层";
ORYX.I18N.Arrangement.btfDesc = "置于顶层";
ORYX.I18N.Arrangement.btb = "置于顶层";
ORYX.I18N.Arrangement.btbDesc = "置于底层";
ORYX.I18N.Arrangement.bf = "上移一层";
ORYX.I18N.Arrangement.bfDesc = "上移一层";
ORYX.I18N.Arrangement.bb = "下移一层";
ORYX.I18N.Arrangement.bbDesc = "下移一层";
ORYX.I18N.Arrangement.groupA = "对齐";
ORYX.I18N.Arrangement.ab = "底部对齐";
ORYX.I18N.Arrangement.abDesc = "底部";
ORYX.I18N.Arrangement.am = "上下居中";
ORYX.I18N.Arrangement.amDesc = "居中";
ORYX.I18N.Arrangement.at = "顶部对齐";
ORYX.I18N.Arrangement.atDesc = "顶部";
ORYX.I18N.Arrangement.al = "左对齐";
ORYX.I18N.Arrangement.alDesc = "左";
ORYX.I18N.Arrangement.ac = "左右居中";
ORYX.I18N.Arrangement.acDesc = "居中";
ORYX.I18N.Arrangement.ar = "右对齐";
ORYX.I18N.Arrangement.arDesc = "右";
ORYX.I18N.Arrangement.as = "均匀分布";
ORYX.I18N.Arrangement.asDesc = "相同尺寸";

if(!ORYX.I18N.Edit) ORYX.I18N.Edit = {};

ORYX.I18N.Edit.group = "编辑";
ORYX.I18N.Edit.cut = "剪切";
ORYX.I18N.Edit.cutDesc = "剪切选定内容到Oryx剪切板上";
ORYX.I18N.Edit.copy = "复制";
ORYX.I18N.Edit.copyDesc = "复制选定内容到Oryx剪切板上";
ORYX.I18N.Edit.paste = "粘贴";
ORYX.I18N.Edit.pasteDesc = "将Oryx剪切板粘贴到画布上";
ORYX.I18N.Edit.del = "删除";
ORYX.I18N.Edit.delDesc = "删除所有选定的形状";

if(!ORYX.I18N.EPCSupport) ORYX.I18N.EPCSupport = {};

ORYX.I18N.EPCSupport.group = "EPC";
ORYX.I18N.EPCSupport.exp = "导出EPC";
ORYX.I18N.EPCSupport.expDesc = "导出表到EPML";
ORYX.I18N.EPCSupport.imp = "导入EPC";
ORYX.I18N.EPCSupport.impDesc = "导入一个EPML文件";
ORYX.I18N.EPCSupport.progressExp = "导出模型";
ORYX.I18N.EPCSupport.selectFile = "选择一个EMPL文件(.empl)导入";
ORYX.I18N.EPCSupport.file = "文件";
ORYX.I18N.EPCSupport.impPanel = "导入EPML文件";
ORYX.I18N.EPCSupport.impBtn = "导入";
ORYX.I18N.EPCSupport.close = "关闭";
ORYX.I18N.EPCSupport.error = "关闭";
ORYX.I18N.EPCSupport.progressImp = "导入中...";

if(!ORYX.I18N.ERDFSupport) ORYX.I18N.ERDFSupport = {};

ORYX.I18N.ERDFSupport.exp = "导出ERDF";
ORYX.I18N.ERDFSupport.expDesc = "导出ERDF";
ORYX.I18N.ERDFSupport.imp = "从ERDF导入";
ORYX.I18N.ERDFSupport.impDesc = "从ERDF导入";
ORYX.I18N.ERDFSupport.impFailed = "导入ERDF请求失败";
ORYX.I18N.ERDFSupport.impFailed2 = "导入时发生错误，<br/>请检查错误信息： <br/><br/>";
ORYX.I18N.ERDFSupport.error = "错误";
ORYX.I18N.ERDFSupport.noCanvas = "xml文件没有包含Oryx画布节点";
ORYX.I18N.ERDFSupport.noSS = "Oryx画布节点不包含模板集的定义";
ORYX.I18N.ERDFSupport.wrongSS = "给定的模板集不适合当前编辑器！";
ORYX.I18N.ERDFSupport.selectFile = "在ERDF选择一个ERDF（.XML）文件或类型导入！";
ORYX.I18N.ERDFSupport.file = "文件";
ORYX.I18N.ERDFSupport.impERDF = "导入ERDF";
ORYX.I18N.ERDFSupport.impBtn = "导入";
ORYX.I18N.ERDFSupport.impProgress = "导入中";
ORYX.I18N.ERDFSupport.close = "关闭";
ORYX.I18N.ERDFSupport.deprTitle = "确定导出ERDF?";
ORYX.I18N.ERDFSupport.deprText = "不推荐导出ERDF，因为在后续的 Oryx编辑器版本中不再支持。如果可能的话，可以导出模型到JSON，想要导出吗";

if(!ORYX.I18N.jPDLSupport) ORYX.I18N.jPDLSupport = {};

ORYX.I18N.jPDLSupport.group = "ExecBPMN";
ORYX.I18N.jPDLSupport.exp = "导出到jPDL";
ORYX.I18N.jPDLSupport.expDesc = "导出到jPDL";
ORYX.I18N.jPDLSupport.imp = "从jPDL导入";
ORYX.I18N.jPDLSupport.impDesc = "导入jPDL文件";
ORYX.I18N.jPDLSupport.impFailedReq = "导入jPDL请求失败";
ORYX.I18N.jPDLSupport.impFailedJson = "jPDL转换失败";
ORYX.I18N.jPDLSupport.impFailedJsonAbort = "导入失败";
ORYX.I18N.jPDLSupport.loadSseQuestionTitle = "JBPM模板集的扩展需要加载"; 
ORYX.I18N.jPDLSupport.loadSseQuestionBody = "为了导入jPDL，模板集的扩展已经被加载，确定要继续吗？";
ORYX.I18N.jPDLSupport.expFailedReq = "模型导出请求失败";
ORYX.I18N.jPDLSupport.expFailedXml = "导出到jPDL失败.导出报告：";
ORYX.I18N.jPDLSupport.error = "错误";
ORYX.I18N.jPDLSupport.selectFile = "在jPDL中选择一个jPDL（.xml)文件导入";
ORYX.I18N.jPDLSupport.file = "文件";
ORYX.I18N.jPDLSupport.impJPDL = "导入jPDL";
ORYX.I18N.jPDLSupport.impBtn = "导入";
ORYX.I18N.jPDLSupport.impProgress = "导入中";
ORYX.I18N.jPDLSupport.close = "关闭";

if(!ORYX.I18N.Save) ORYX.I18N.Save = {};

ORYX.I18N.Save.group = "文件";
ORYX.I18N.Save.save = "保存";
ORYX.I18N.Save.saveDesc = "保存";
ORYX.I18N.Save.saveAs = "另存为";
ORYX.I18N.Save.saveAsDesc = "另存为";
ORYX.I18N.Save.unsavedData = "有未保存数据，请在离开前保存以免丢失";
ORYX.I18N.Save.newProcess = "新程序";
ORYX.I18N.Save.saveAsTitle = "另存为";
ORYX.I18N.Save.saveBtn = "保存";
ORYX.I18N.Save.close = "关闭";
ORYX.I18N.Save.savedAs = "另存为";
ORYX.I18N.Save.saved = "已保存!";
ORYX.I18N.Save.failed = "保存失败";
ORYX.I18N.Save.noRights = "你没有权限保存";
ORYX.I18N.Save.saving = "保存中";
ORYX.I18N.Save.saveAsHint = "过程表已存储：";

if(!ORYX.I18N.File) ORYX.I18N.File = {};

ORYX.I18N.File.group = "文件";
ORYX.I18N.File.print = "打印";
ORYX.I18N.File.printDesc = "打印当前模型";
ORYX.I18N.File.pdf = "导出为PDF";
ORYX.I18N.File.pdfDesc = "导出为PDF";
ORYX.I18N.File.info = "信息";
ORYX.I18N.File.infoDesc = "信息";
ORYX.I18N.File.genPDF = "生成PDF";
ORYX.I18N.File.genPDFFailed = "生成PDF失败";
ORYX.I18N.File.printTitle = "打印";
ORYX.I18N.File.printMsg = "打印功能出现问题，我们建议PDF导出方式来打印表，你确定要继续打印吗？";

if(!ORYX.I18N.Grouping) ORYX.I18N.Grouping = {};

ORYX.I18N.Grouping.grouping = "组合中";
ORYX.I18N.Grouping.group = "组合";
ORYX.I18N.Grouping.groupDesc = "所有已选的形状组合";
ORYX.I18N.Grouping.ungroup = "取消组合";
ORYX.I18N.Grouping.ungroupDesc = "取消已选形状组合";

if(!ORYX.I18N.Loading) ORYX.I18N.Loading = {};

ORYX.I18N.Loading.waiting ="请等待...";

if(!ORYX.I18N.PropertyWindow) ORYX.I18N.PropertyWindow = {};

ORYX.I18N.PropertyWindow.name = "名字";
ORYX.I18N.PropertyWindow.value = "值";
ORYX.I18N.PropertyWindow.selected = "已选";
ORYX.I18N.PropertyWindow.clickIcon = "点击图标";
ORYX.I18N.PropertyWindow.add = "添加";
ORYX.I18N.PropertyWindow.rem = "移除";
ORYX.I18N.PropertyWindow.complex = "复杂类型编辑器";
ORYX.I18N.PropertyWindow.text = "文本编辑器";
ORYX.I18N.PropertyWindow.ok = "Ok";
ORYX.I18N.PropertyWindow.cancel = "取消";
ORYX.I18N.PropertyWindow.dateFormat = "m/d/y";

if(!ORYX.I18N.ShapeMenuPlugin) ORYX.I18N.ShapeMenuPlugin = {};

ORYX.I18N.ShapeMenuPlugin.drag = "拖动";
ORYX.I18N.ShapeMenuPlugin.clickDrag = "点击或者拖动";
ORYX.I18N.ShapeMenuPlugin.morphMsg = "改变形态";

if(!ORYX.I18N.SyntaxChecker) ORYX.I18N.SyntaxChecker = {};

ORYX.I18N.SyntaxChecker.group = "验证";
ORYX.I18N.SyntaxChecker.name = "语法检查器";
ORYX.I18N.SyntaxChecker.desc = "检查语法";
ORYX.I18N.SyntaxChecker.noErrors = "无语法错误";
ORYX.I18N.SyntaxChecker.invalid = "服务器无应答";
ORYX.I18N.SyntaxChecker.checkingMessage = "检查中";

if(!ORYX.I18N.FormHandler) ORYX.I18N.FormHandler = {};

ORYX.I18N.FormHandler.group = "表单处理";
ORYX.I18N.FormHandler.name = "创建";
ORYX.I18N.FormHandler.desc = "处理中检验";

if(!ORYX.I18N.Deployer) ORYX.I18N.Deployer = {};

ORYX.I18N.Deployer.group = "部署";
ORYX.I18N.Deployer.name = "部署器";
ORYX.I18N.Deployer.desc = "部署引擎";

if(!ORYX.I18N.Tester) ORYX.I18N.Tester = {};

ORYX.I18N.Tester.group = "测试";
ORYX.I18N.Tester.name = "测试过程";
ORYX.I18N.Tester.desc = "打开测试组件来测试过程定义";

if(!ORYX.I18N.Undo) ORYX.I18N.Undo = {};

ORYX.I18N.Undo.group = "撤销";
ORYX.I18N.Undo.undo = "撤销";
ORYX.I18N.Undo.undoDesc = "撤消前次操作";
ORYX.I18N.Undo.redo = "恢复";
ORYX.I18N.Undo.redoDesc = "恢复上次撤消的动作";

if(!ORYX.I18N.View) ORYX.I18N.View = {};

ORYX.I18N.View.group = "缩小或放大";
ORYX.I18N.View.zoomIn = "放大";
ORYX.I18N.View.zoomInDesc = "放大至模型";
ORYX.I18N.View.zoomOut = "缩小";
ORYX.I18N.View.zoomOutDesc = "缩小至模型";
ORYX.I18N.View.zoomStandard = "正常缩放";
ORYX.I18N.View.zoomStandardDesc = "缩放至正常标准";
ORYX.I18N.View.zoomFitToModel = "适度缩放至模型";
ORYX.I18N.View.zoomFitToModelDesc = "适度缩放至模型大小";

if(!ORYX.I18N.XFormsSerialization) ORYX.I18N.XFormsSerialization = {};

ORYX.I18N.XFormsSerialization.group = "XForms序列化";
ORYX.I18N.XFormsSerialization.exportXForms = "XForms导出";
ORYX.I18N.XFormsSerialization.exportXFormsDesc = "导出XForms + XHTML标记";
ORYX.I18N.XFormsSerialization.importXForms = "XForms导入";
ORYX.I18N.XFormsSerialization.importXFormsDesc = "导入XForms+XHTML标记";
ORYX.I18N.XFormsSerialization.noClientXFormsSupport = "不支持XForms";
ORYX.I18N.XFormsSerialization.noClientXFormsSupportDesc = "你的浏览器不支持xForms，请下载Mozilla xForms插件";
ORYX.I18N.XFormsSerialization.ok = "Ok";
ORYX.I18N.XFormsSerialization.selectFile = "在XForms+XHTML标记中选择一个XHTML(.xhtml)文件导入!";
ORYX.I18N.XFormsSerialization.selectCss = "请添加CSS或URL文件";
ORYX.I18N.XFormsSerialization.file = "文件";
ORYX.I18N.XFormsSerialization.impFailed = "文件导入请求失败";
ORYX.I18N.XFormsSerialization.impTitle = "导入XForms+XHTML文件";
ORYX.I18N.XFormsSerialization.expTitle = "导出XForms+XHTML文件";
ORYX.I18N.XFormsSerialization.impButton = "导入";
ORYX.I18N.XFormsSerialization.impProgress = "导入中";
ORYX.I18N.XFormsSerialization.close = "关闭";

/** New Language Properties: 08.12.2008 */

ORYX.I18N.PropertyWindow.title = "属性";

if(!ORYX.I18N.ShapeRepository) ORYX.I18N.ShapeRepository = {};
ORYX.I18N.ShapeRepository.title = "形状库";

ORYX.I18N.Save.dialogDesciption = "请输入名称、说明和注释";
ORYX.I18N.Save.dialogLabelTitle = "标题";
ORYX.I18N.Save.dialogLabelDesc = "说明";
ORYX.I18N.Save.dialogLabelType = "类型";
ORYX.I18N.Save.dialogLabelComment = "修改批注";

if(!ORYX.I18N.Perspective) ORYX.I18N.Perspective = {};
ORYX.I18N.Perspective.no = "无透镜"
ORYX.I18N.Perspective.noTip = "卸载当前透镜"

/** New Language Properties: 21.04.2009 */
ORYX.I18N.JSONSupport = {
    imp: {
        name: "从JSON中导入",
        desc: "从JSON中导入一个模型",
        group: "导出",
        selectFile: "在JSON中选择一个JSON(.json)文件或类型导入!",
        file: "文件",
        btnImp: "导入",
        btnClose: "关闭",
        progress: "导入中",
        syntaxError: "语法错误"
    },
    exp: {
        name: "导出只JSON",
        desc: "导出当前模型只JSONJSON",
        group: "导出"
    }
};

/** New Language Properties: 09.05.2009 */
if(!ORYX.I18N.JSONImport) ORYX.I18N.JSONImport = {};

ORYX.I18N.JSONImport.title = "JSON导入";
ORYX.I18N.JSONImport.wrongSS = "输入文件的模板集与加载的模板集不匹配"

/** New Language Properties: 14.05.2009 */
if(!ORYX.I18N.RDFExport) ORYX.I18N.RDFExport = {};
ORYX.I18N.RDFExport.group = "导出";
ORYX.I18N.RDFExport.rdfExport = "导出至RDF";
ORYX.I18N.RDFExport.rdfExportDescription = "Exports current model to the XML serialization defined for the Resource Description Framework (RDF)";

/** New Language Properties: 15.05.2009*/
if(!ORYX.I18N.SyntaxChecker.BPMN) ORYX.I18N.SyntaxChecker.BPMN={};
ORYX.I18N.SyntaxChecker.BPMN_NO_SOURCE = "一个边必须有一个源";
ORYX.I18N.SyntaxChecker.BPMN_NO_TARGET = "一个边必须有一个目标";
ORYX.I18N.SyntaxChecker.BPMN_DIFFERENT_PROCESS = "源和目标节点必须在同一进程中";
ORYX.I18N.SyntaxChecker.BPMN_SAME_PROCESS = "源和目标节点必须在不同的池中";
ORYX.I18N.SyntaxChecker.BPMN_FLOWOBJECT_NOT_CONTAINED_IN_PROCESS = "一个进程必须有一个流对象";
ORYX.I18N.SyntaxChecker.BPMN_ENDEVENT_WITHOUT_INCOMING_CONTROL_FLOW = "一个结束事件必须有一个输入序列流";
ORYX.I18N.SyntaxChecker.BPMN_STARTEVENT_WITHOUT_OUTGOING_CONTROL_FLOW = "一个开始事件必须有一个输出序列流";
ORYX.I18N.SyntaxChecker.BPMN_STARTEVENT_WITH_INCOMING_CONTROL_FLOW = "开始事件不能有输入序列流.";
ORYX.I18N.SyntaxChecker.BPMN_ATTACHEDINTERMEDIATEEVENT_WITH_INCOMING_CONTROL_FLOW = "附加中间事件不能有输入序列流";
ORYX.I18N.SyntaxChecker.BPMN_ATTACHEDINTERMEDIATEEVENT_WITHOUT_OUTGOING_CONTROL_FLOW = "附加中间事件必须有一个确切的输出序列流";
ORYX.I18N.SyntaxChecker.BPMN_ENDEVENT_WITH_OUTGOING_CONTROL_FLOW = "结束事件不能有输出序列流";
ORYX.I18N.SyntaxChecker.BPMN_EVENTBASEDGATEWAY_BADCONTINUATION = "基于事件的网关必须后面不能跟网关或子进程";
ORYX.I18N.SyntaxChecker.BPMN_NODE_NOT_ALLOWED = "不允许节点类型";

if(!ORYX.I18N.SyntaxChecker.IBPMN) ORYX.I18N.SyntaxChecker.IBPMN={};
ORYX.I18N.SyntaxChecker.IBPMN_NO_ROLE_SET = "交互必须有一个发送器和一个接收器的角色集";
ORYX.I18N.SyntaxChecker.IBPMN_NO_INCOMING_SEQFLOW = "这个节点必须有输入序列流";
ORYX.I18N.SyntaxChecker.IBPMN_NO_OUTGOING_SEQFLOW = "这个节点必须有输出序列流";

if(!ORYX.I18N.SyntaxChecker.InteractionNet) ORYX.I18N.SyntaxChecker.InteractionNet={};
ORYX.I18N.SyntaxChecker.InteractionNet_SENDER_NOT_SET = "未设定发件人";
ORYX.I18N.SyntaxChecker.InteractionNet_RECEIVER_NOT_SET = "未设定接收人";
ORYX.I18N.SyntaxChecker.InteractionNet_MESSAGETYPE_NOT_SET = "未设置消息类型";
ORYX.I18N.SyntaxChecker.InteractionNet_ROLE_NOT_SET = "未设置角色";

if(!ORYX.I18N.SyntaxChecker.EPC) ORYX.I18N.SyntaxChecker.EPC={};
ORYX.I18N.SyntaxChecker.EPC_NO_SOURCE = "每个边必须有一个源";
ORYX.I18N.SyntaxChecker.EPC_NO_TARGET = "每个边必须有一个目标";
ORYX.I18N.SyntaxChecker.EPC_NOT_CONNECTED = "节点必须与边相连。";
ORYX.I18N.SyntaxChecker.EPC_NOT_CONNECTED_2 = "节点必须与多个边进行连接";
ORYX.I18N.SyntaxChecker.EPC_TOO_MANY_EDGES = "节点有太多的关联边";
ORYX.I18N.SyntaxChecker.EPC_NO_CORRECT_CONNECTOR = "节点是不正确的连接器";
ORYX.I18N.SyntaxChecker.EPC_MANY_STARTS = "必须只有一个启动事件";
ORYX.I18N.SyntaxChecker.EPC_FUNCTION_AFTER_OR = "分流OR/ XOR后不能有函数";
ORYX.I18N.SyntaxChecker.EPC_PI_AFTER_OR = "分流OR/ XOR后不能有过程接口";
ORYX.I18N.SyntaxChecker.EPC_FUNCTION_AFTER_FUNCTION =  "函数后不能有函数";
ORYX.I18N.SyntaxChecker.EPC_EVENT_AFTER_EVENT =  "时间后不能有时间";
ORYX.I18N.SyntaxChecker.EPC_PI_AFTER_FUNCTION =  "函数后不能有过程接口";
ORYX.I18N.SyntaxChecker.EPC_FUNCTION_AFTER_PI =  "一个过程接口后不能有函数";
ORYX.I18N.SyntaxChecker.EPC_SOURCE_EQUALS_TARGET = "边必须连接两个不同的节点"

if(!ORYX.I18N.SyntaxChecker.PetriNet) ORYX.I18N.SyntaxChecker.PetriNet={};
ORYX.I18N.SyntaxChecker.PetriNet_NOT_BIPARTITE = "The graph is not bipartite";
ORYX.I18N.SyntaxChecker.PetriNet_NO_LABEL = "标签不设置标记转型";
ORYX.I18N.SyntaxChecker.PetriNet_NO_ID = "没有ID的节点";
ORYX.I18N.SyntaxChecker.PetriNet_SAME_SOURCE_AND_TARGET = "双流关系具有相同的源和目标";
ORYX.I18N.SyntaxChecker.PetriNet_NODE_NOT_SET = "一个节点不能设置双流关系";

/** New Language Properties: 02.06.2009*/
ORYX.I18N.Edge = "边";
ORYX.I18N.Node = "节点";

/** New Language Properties: 03.06.2009*/
ORYX.I18N.SyntaxChecker.notice = "将鼠标移到一个红色的十字图标，查看错误信息";

/** New Language Properties: 05.06.2009*/
if(!ORYX.I18N.RESIZE) ORYX.I18N.RESIZE = {};
ORYX.I18N.RESIZE.tipGrow = "增加画布大小：";
ORYX.I18N.RESIZE.tipShrink = "减小画布大小：";
ORYX.I18N.RESIZE.N = "上";
ORYX.I18N.RESIZE.W = "左";
ORYX.I18N.RESIZE.S ="下";
ORYX.I18N.RESIZE.E ="右";

/** New Language Properties: 15.07.2009*/
if(!ORYX.I18N.Layouting) ORYX.I18N.Layouting ={};
ORYX.I18N.Layouting.doing = "布局中";

/** New Language Properties: 18.08.2009*/
ORYX.I18N.SyntaxChecker.MULT_ERRORS = "多个错误";

/** New Language Properties: 08.09.2009*/
if(!ORYX.I18N.PropertyWindow) ORYX.I18N.PropertyWindow = {};
ORYX.I18N.PropertyWindow.oftenUsed = "经常使用";
ORYX.I18N.PropertyWindow.moreProps = "更多属性";

/** New Language Properties 01.10.2009 */
if(!ORYX.I18N.SyntaxChecker.BPMN2) ORYX.I18N.SyntaxChecker.BPMN2 = {};

ORYX.I18N.SyntaxChecker.BPMN2_DATA_INPUT_WITH_INCOMING_DATA_ASSOCIATION = "数据输入不得有任何输入数据关联";
ORYX.I18N.SyntaxChecker.BPMN2_DATA_OUTPUT_WITH_OUTGOING_DATA_ASSOCIATION = "数据输出不得有任何输出数据关联";
ORYX.I18N.SyntaxChecker.BPMN2_EVENT_BASED_TARGET_WITH_TOO_MANY_INCOMING_SEQUENCE_FLOWS = "基于事件的网关目标可能只有一个输入序列流";

/** New Language Properties 02.10.2009 */
ORYX.I18N.SyntaxChecker.BPMN2_EVENT_BASED_WITH_TOO_LESS_OUTGOING_SEQUENCE_FLOWS = "基于事件的网关必须有两个或更多的输出序列流";
ORYX.I18N.SyntaxChecker.BPMN2_EVENT_BASED_EVENT_TARGET_CONTRADICTION = "如果在配置时使用消息中间件，就不得接受任务，反之亦然";
ORYX.I18N.SyntaxChecker.BPMN2_EVENT_BASED_WRONG_TRIGGER = "只有以下中间事件触发是有效的：消息，信号，定时器，条件和多重";
ORYX.I18N.SyntaxChecker.BPMN2_EVENT_BASED_WRONG_CONDITION_EXPRESSION = "事件网关的输出序列流不得有条件表达式";
ORYX.I18N.SyntaxChecker.BPMN2_EVENT_BASED_NOT_INSTANTIATING = "网关不符合实例化过程的条件，请使用启动事件或网关的实例化属性";

/** New Language Properties 05.10.2009 */
ORYX.I18N.SyntaxChecker.BPMN2_GATEWAYDIRECTION_MIXED_FAILURE = "网关必须同时具有多种输入和输出顺序流";
ORYX.I18N.SyntaxChecker.BPMN2_GATEWAYDIRECTION_CONVERGING_FAILURE = "网关必须有多个输入序列流，但大多数没有多个输出序列流";
ORYX.I18N.SyntaxChecker.BPMN2_GATEWAYDIRECTION_DIVERGING_FAILURE = "网关不能有多个输入序列流，但必须有多个输出序列流";
ORYX.I18N.SyntaxChecker.BPMN2_GATEWAY_WITH_NO_OUTGOING_SEQUENCE_FLOW = "一个网关至少有一个输出序列流";
ORYX.I18N.SyntaxChecker.BPMN2_RECEIVE_TASK_WITH_ATTACHED_EVENT = "事件网关配置中接收任务不能有任何附加的中间事件";
ORYX.I18N.SyntaxChecker.BPMN2_EVENT_SUBPROCESS_BAD_CONNECTION = "一个事件子进程不能有任何输入或输出的序列流";

/** New Language Properties 13.10.2009 */
ORYX.I18N.SyntaxChecker.BPMN_MESSAGE_FLOW_NOT_CONNECTED = "消息流至少有一侧被连接";

/** New Language Properties 24.11.2009 */
ORYX.I18N.SyntaxChecker.BPMN2_TOO_MANY_INITIATING_MESSAGES = "一个编排活动可能只有一个启动消息";
ORYX.I18N.SyntaxChecker.BPMN_MESSAGE_FLOW_NOT_ALLOWED = "这里不允许有消息流";

/** New Language Properties 27.11.2009 */
ORYX.I18N.SyntaxChecker.BPMN2_EVENT_BASED_WITH_TOO_LESS_INCOMING_SEQUENCE_FLOWS = "一种没有实例化的基于事件的网关至少有一个输入序列流";
ORYX.I18N.SyntaxChecker.BPMN2_TOO_FEW_INITIATING_PARTICIPANTS = "编排活动必须有一个发起者（白色）";
ORYX.I18N.SyntaxChecker.BPMN2_TOO_MANY_INITIATING_PARTICIPANTS = "编排活动不能有一个以上的发起者（白色）"

ORYX.I18N.SyntaxChecker.COMMUNICATION_AT_LEAST_TWO_PARTICIPANTS = "该通信至少连接两个参与者";
ORYX.I18N.SyntaxChecker.MESSAGEFLOW_START_MUST_BE_PARTICIPANT = "消息流源必须是一个参与者";
ORYX.I18N.SyntaxChecker.MESSAGEFLOW_END_MUST_BE_PARTICIPANT = "T消息流的目标必须是一个参与者";
ORYX.I18N.SyntaxChecker.CONV_LINK_CANNOT_CONNECT_CONV_NODES = "会话连接必须连接一个与参与者的通信或子会话节点";
