<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/task-taglibs.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
	<title><s:text name="task.menu.completedMatters"/></title>
	<%@ include file="/common/task-meta.jsp"%>
	
	<script language="javascript" type="text/javascript" src="${imatrixCtx}/widgets/calendar/WdatePicker.js"></script>
	<script src="${resourcesCtx}/js/jquery.timers-1.2.js" type="text/javascript"></script>
	
	<script src="${taskCtx}/js/task.js" type="text/javascript"></script>
	
	<script type="text/javascript">
	$(document).ready(function() {
		activeTree("canceled_bussiness_content","cancel_task");
	});
	function markColor(code){
		$("#identifiersDiv").hide();
		if(validateReadioTaskIds()){
			var id="";
			if(tree.getSelectNode()){
				id=tree.getSelectNode().id;
				if(id=='cancel_task'){
					id="";
				}
			}
			$('#taskMark').attr('value', code.toUpperCase());
			var taskType = $("#taskType").val();
			ajaxSubmit("task_form", encodeURI("${taskCtx }/task/task-mark.htm?typeName="+id+'&taskType='+taskType), "pageTablelist");
		}
	}

	function validateReadioTaskIds(){
		var rds = jQuery("#taskCanceledTableId").getGridParam('selarrrow');
	    if(rds.length==0){
	    	alert(iMatrixMessage["selectInfo"]);
		    return false;
		}else{
			var taskIds = "";
			for(var i=0;i<rds.length;i++){
				taskIds+=rds[i]+",";
			}
			taskIds=taskIds.substring(0,taskIds.length-1);
			$("#task_ids").attr("value", taskIds);
		    return true;	
		}
	}
	function validateReadio(){
		var rds = jQuery("#taskCompletedTableId").getGridParam('selarrrow');
		for(var i=0;i<rds.length;i++){
			$("#task_id").attr("value", rds[i]);
			return true;
		}
		return false;
	}

	function taskList(){
		setPageState();
		$("#searchBtn").find("span").find("span").html(public_lang["Query"]);
		var typeName = $("#typeName").val();
		var taskType = $("#taskType").val();
		ajaxSubmit('searchForm', encodeURI('${taskCtx}/task/task-canceled-list.htm?typeName='+typeName+'&taskType='+taskType), 'pageTablelist' );
	}
	function changeTaskType(taskType){
		$("#typeName").attr("value","");
		$("#taskType").attr("value",taskType);
		ajaxSubmit('pageForm', '${taskCtx}/task/task-canceled-list.htm', 'pageTablelist_all',changeTaskTypeCallback);
	}

	function changeTaskTypeCallback(){
		activeTree("canceled_bussiness_content","cancel_task");
	}
	</script>
</head>
<body onclick="$('#sysTableDiv').hide();$('#styleList').hide();">
	<script type="text/javascript">
  		var thirdMenu = "task-thirdMenu3";
  	</script>
  	<%@ include file="/menus/header.jsp"%>
	<div class="ui-layout-west">
		<%@ include file="/menus/task-third-menu.jsp"%>
	</div>
	<div class="ui-layout-center">
	<div class="opt-body">
		<aa:zone name="product_task">
			<div class="opt-btn">
				<button class="btn" onclick="iMatrix.showSearchDIV(this);" id="searchBtn"><span><span><s:text name="formManager.search"></s:text></span></span></button>
				<button id="_task_button" class="btn" onclick="showIdentifiersDiv();"><span><span><s:text name="task.button.identifyAs"></s:text>.. </span></span></button>
				<div class="btndiv" id="_flowbtn" style="*top:-2px;">
					<button  class="ui-button ui-widget ui-state-default ui-button-text-only ui-corner-left" id="parentFlowBtn">
						<span class="ui-button-text"><s:text name="task.button.taskType"></s:text></span>
					</button>
					<button  title='<s:text name="task.button.more"></s:text>' class="ui-button ui-widget ui-state-default ui-button-icon-only ui-corner-right" id="select">
						<span class="ui-button-icon-primary ui-icon ui-icon-triangle-1-s"></span>
						<span class="ui-button-text"><s:text name="task.button.more"></s:text></span>
					</button>
				</div>
				<div id="flowbtn" class="flag" >
					<ul style="width: 100%">
						<s:iterator value="@com.norteksoft.task.base.enumeration.TaskType@values()" >
							<li><a href="#" onclick="changeTaskType('${code}');"><s:text name="%{name}"></s:text></a></li>
						</s:iterator>
					</ul>
				</div>
				<script type="text/javascript">
					initBtnGroup();
				</script>
			</div>
			
			<div id="flag" onmouseover='show_moveiIdentifiersDiv();' onmouseout='hideIdentifiersDiv();'>
			<ul >
			 <s:iterator value="@com.norteksoft.task.entity.TaskMark@values()" id="acolor">
			 <li onclick="markColor('<s:property value="#acolor"/>');">
			 <span><img style="border: none;" src="${taskCtx}/images/${name}.gif"/></span>
			 <a href="#"><s:text name="%{i18nName}"></s:text></a>
			 </li>
			 </s:iterator>
			</ul>
			</div>
			<input id="task_state" type="hidden" value="new"/>
					
			<form id="pageForm" name="pageForm" action="" method="post">
				<input name="taskType" value="${taskType }" type="hidden" id="taskType"/>
				<input name="typeName" value="${typeName }" type="hidden" id="typeName"/>
				<input name="taskCategory" value="cancel"  type="hidden" id="taskCategory"/>
			</form>
		   <aa:zone name="pageTablelist_all">
			<div id="opt-content">
			<form id="searchForm" name="searchForm" action="" method="post">
			</form>
			<aa:zone name="pageTablelist">
				<div style="display: none;">
					<form action="#" id="task_form">
						<input type="hidden" id="task_id" name="id"/>
						<input type="hidden" id="task_ids" name="ids"/>
						<input id="taskMark" name="taskMarks" type="hidden"/>
						<input name="taskCategory" value="cancel" type="hidden"/> 
						<input type="hidden" name="tasks.pageNo" value="${tasks.pageNo }">
					</form>
				</div>
				
				<span id="message" >
					<s:actionmessage theme="mytheme" />
				</span>
				<script type="text/javascript">
					setTimeout('$("#message").hide();',3000);
				</script>
				<form id="searchSubmit" name="searchSubmit" action="" method="post">
					<view:jqGrid url="${taskCtx}/task/task-canceled-list.htm?taskCategory=cancel&typeName=${typeName }&taskType=${taskType }" code="TASK_CANCELED_TASK" gridId="taskCanceledTableId" pageName="tasks"  submitForm="searchForm"></view:jqGrid>
				</form>
			</aa:zone>
			</div>
			</aa:zone>
		</aa:zone>	
		</div>
	</div>
</body>
<script type="text/javascript" src="${resourcesCtx}/widgets/colorbox/jquery.colorbox.js"></script>
<script src="${resourcesCtx}/widgets/timepicker/timepicker_<%=com.norteksoft.product.util.ContextUtils.getCurrentLanguage()%>.js" type="text/javascript"></script>
<script type="text/javascript" src="${resourcesCtx}/widgets/timepicker/timepicker-all-1.0.js"></script>
<script type="text/javascript" src="${resourcesCtx}/widgets/validation/validate-all-1.0.js"></script>
</html>
