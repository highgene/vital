ORYX.I18N.PropertyWindow.dateFormat = "d/m/y";

ORYX.I18N.View.East = "属性";
ORYX.I18N.View.West = "建模元素";

ORYX.I18N.Oryx.title	= "Signavio";
ORYX.I18N.Oryx.pleaseWait = "Signavio流程编辑器正在加载，请稍后";
ORYX.I18N.Edit.cutDesc = "将选定内容剪切到剪切板上";
ORYX.I18N.Edit.copyDesc = "将选定内容复制到剪切板上";
ORYX.I18N.Edit.pasteDesc = "将剪贴板粘贴到画布上";
ORYX.I18N.ERDFSupport.noCanvas = "该xml文档不包含画布节点";
ORYX.I18N.ERDFSupport.noSS = "Signavio流程编辑器画布节点没有包含模板集的定义";
ORYX.I18N.ERDFSupport.deprText = "不推荐导出ERDF，因为在后续的Signavio流程编辑器版本中不再支持。如果可能的话，可以导出模型到JSON，想要导出吗？";
ORYX.I18N.Save.pleaseWait = "保存中请稍等";

ORYX.I18N.Save.saveAs = "保存副本";
ORYX.I18N.Save.saveAsDesc = "保存副本";
ORYX.I18N.Save.saveAsTitle = "保存副本";
ORYX.I18N.Save.savedAs = "副本已保存";
ORYX.I18N.Save.savedDescription = "流程图被存储";
ORYX.I18N.Save.notAuthorized = "您目前尚未登录，请 在新窗口<a href='/p/login' target='_blank'>登录</a>才可以保存当前表"
ORYX.I18N.Save.transAborted = "保存请求需要很长时间，你可以使用更快的互联网连接。如果您使用无线局域网，请检查您的连接强度";
ORYX.I18N.Save.noRights = "你没有权限来存储模型。请检查<a href='/p/explorer' target='_blank'>Signavio Explorer</a>，是否你有权限要在目标目录写";
ORYX.I18N.Save.comFailed = "与Signavio服务器通信失败。请检查您的互联网连接。如果问题依然存在，请通过工具栏中的信封图标联系Signavio技术支持";
ORYX.I18N.Save.failed = "在试图保存你的表时出错了，请再试一次，如果问题依然存在，请通过工具栏中的信封图标联系Signavio技术支持";
ORYX.I18N.Save.exception = "在试图保存你的表时有异常，请再试一次，如果问题依然存在，请通过工具栏中的信封图标联系Signavio技术支持";
ORYX.I18N.Save.retrieveData = "请等待，数据正在检索";

/** New Language Properties: 10.6.09*/
if(!ORYX.I18N.ShapeMenuPlugin) ORYX.I18N.ShapeMenuPlugin = {};
ORYX.I18N.ShapeMenuPlugin.morphMsg = "转换形状";
ORYX.I18N.ShapeMenuPlugin.morphWarningTitleMsg = "转换形状";
ORYX.I18N.ShapeMenuPlugin.morphWarningMsg = "在转换元素时不包含子形状，你想转换吗？";

if (!Signavio) { var Signavio = {}; }
if (!Signavio.I18N) { Signavio.I18N = {} }
if (!Signavio.I18N.Editor) { Signavio.I18N.Editor = {} }

if (!Signavio.I18N.Editor.Linking) { Signavio.I18N.Editor.Linking = {} }
Signavio.I18N.Editor.Linking.CreateDiagram = "新建流程图";
Signavio.I18N.Editor.Linking.UseDiagram = "使用现有的流程图";
Signavio.I18N.Editor.Linking.UseLink = "使用连接";
Signavio.I18N.Editor.Linking.Close = "关闭";
Signavio.I18N.Editor.Linking.Cancel = "取消";
Signavio.I18N.Editor.Linking.UseName = "采用表名字";
Signavio.I18N.Editor.Linking.UseNameHint = "用链表名字替换模型元素（类型）的当前名字";
Signavio.I18N.Editor.Linking.CreateTitle = "建立链接";
Signavio.I18N.Editor.Linking.AlertSelectModel = "你需要选择一个模型";
Signavio.I18N.Editor.Linking.ButtonLink = "连接表";
Signavio.I18N.Editor.Linking.LinkNoAccess = "你无法访问这个表";
Signavio.I18N.Editor.Linking.LinkUnavailable = "表不可用";
Signavio.I18N.Editor.Linking.RemoveLink = "删除连接";
Signavio.I18N.Editor.Linking.EditLink = "编辑连接";
Signavio.I18N.Editor.Linking.OpenLink = "打开";
Signavio.I18N.Editor.Linking.BrokenLink = "连接中断!";
Signavio.I18N.Editor.Linking.PreviewTitle = "预览";

if(!Signavio.I18N.Glossary_Support) { Signavio.I18N.Glossary_Support = {}; }
Signavio.I18N.Glossary_Support.renameEmpty = "没有字典列表";
Signavio.I18N.Glossary_Support.renameLoading = "搜索中";

/** New Language Properties: 08.09.2009*/
if(!ORYX.I18N.PropertyWindow) ORYX.I18N.PropertyWindow = {};
ORYX.I18N.PropertyWindow.oftenUsed = "主要属性";
ORYX.I18N.PropertyWindow.moreProps = "更多属性";

ORYX.I18N.PropertyWindow.btnOpen = "打开";
ORYX.I18N.PropertyWindow.btnRemove = "移除";
ORYX.I18N.PropertyWindow.btnEdit = "编辑";
ORYX.I18N.PropertyWindow.btnUp = "上移";
ORYX.I18N.PropertyWindow.btnDown = "下移";
ORYX.I18N.PropertyWindow.createNew = "新建";

if(!ORYX.I18N.PropertyWindow) ORYX.I18N.PropertyWindow = {};
ORYX.I18N.PropertyWindow.oftenUsed = "主属性";
ORYX.I18N.PropertyWindow.moreProps = "更多属性";
ORYX.I18N.PropertyWindow.characteristicNr = "成本与资源分析";
ORYX.I18N.PropertyWindow.meta = "自定义属性";

if(!ORYX.I18N.PropertyWindow.Category){ORYX.I18N.PropertyWindow.Category = {}}
ORYX.I18N.PropertyWindow.Category.popular = "主属性";
ORYX.I18N.PropertyWindow.Category.characteristicnr = "成本与资源分析";
ORYX.I18N.PropertyWindow.Category.others = "更多属性";
ORYX.I18N.PropertyWindow.Category.meta = "自定义属性";

if(!ORYX.I18N.PropertyWindow.ListView) ORYX.I18N.PropertyWindow.ListView = {};
ORYX.I18N.PropertyWindow.ListView.title = "编辑：";
ORYX.I18N.PropertyWindow.ListView.dataViewLabel = "已存在的列表";
ORYX.I18N.PropertyWindow.ListView.dataViewEmptyText = "没有";
ORYX.I18N.PropertyWindow.ListView.addEntryLabel = "增加新列表";
ORYX.I18N.PropertyWindow.ListView.buttonAdd = "添加";
ORYX.I18N.PropertyWindow.ListView.save = "保存";
ORYX.I18N.PropertyWindow.ListView.cancel = "取消";

if(!Signavio.I18N.Buttons) Signavio.I18N.Buttons = {};
Signavio.I18N.Buttons.save		= "保存";
Signavio.I18N.Buttons.cancel 	= "取消";
Signavio.I18N.Buttons.remove	= "移除";

if(!Signavio.I18N.btn) {Signavio.I18N.btn = {};}
Signavio.I18N.btn.btnEdit = "编辑";
Signavio.I18N.btn.btnRemove = "移除";
Signavio.I18N.btn.moveUp = "上移";
Signavio.I18N.btn.moveDown = "下移";

if(!Signavio.I18N.field) {Signavio.I18N.field = {};}
Signavio.I18N.field.Url = "URL";
Signavio.I18N.field.UrlLabel = "标签";
