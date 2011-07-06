<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="propertyDefinition" type="org.jahia.services.content.nodetypes.ExtendedPropertyDefinition"--%>
<%--@elvariable id="type" type="org.jahia.services.content.nodetypes.ExtendedNodeType"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="selectorType" type="org.jahia.services.content.nodetypes.SelectorType"--%>
<template:addResources type="javascript" resources="jquery.min.js,jquery.jeditable.js"/>
<template:addResources type="javascript" resources="jquery.jeditable.ajaxupload.js"/>
<template:addResources type="javascript" resources="jquery.ajaxfileupload.js"/>
<template:addResources type="javascript" resources="jquery.defer.js"/>
<label for="file${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}">${jcr:labelInNodeType(propertyDefinition,renderContext.mainResourceLocale,type)}</label>
<input type="hidden" name="${propertyDefinition.name}" id="${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}"/>
<fmt:message key="label.select.file" var="fileLabel"/>
<c:url value="${url.files}" var="previewPath"/>
<c:set var="onSelect">function(uuid, path, title) {
            $('#${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}').val(uuid);
            $('#display${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}').html('<img src="${previewPath}'+path+'"/>');
            return false;
        }</c:set>
<c:set var="onClose">function(){$("#treepreview").empty().hide();}</c:set>
<c:set var="fancyboxOptions">{
            height:600,
    width:600
        }</c:set>
<c:if test="${propertyDefinition.selectorOptions.type == 'image'}">
<ui:fileSelector fieldId="${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}"
                 displayFieldId="file${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}" valueType="identifier"
        label="${fileLabel}"
        nodeTypes="nt:folder,jmix:image,jnt:virtualsite"
        selectableNodeTypes="jmix:image"
        onSelect="${onSelect}"
        onClose="${onClose}"
        fancyboxOptions="${fancyboxOptions}" treeviewOptions="{preview:true,previewPath:'${previewPath}'}"/>
</c:if>
<c:if test="${propertyDefinition.selectorOptions.type != 'image'}">
<ui:fileSelector fieldId="${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}"
                 displayFieldId="file${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}" valueType="identifier"
        label="${fileLabel}"
        onSelect="${onSelect}"
        onClose="${onClose}"
        fancyboxOptions="${fancyboxOptions}" treeviewOptions="{preview:true,previewPath:'${previewPath}'}"/>
</c:if>
<span><fmt:message key="label.or"/></span>
<div id="file${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}" jcr:id="${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}">
    <span><fmt:message key="add.file"/></span>
</div>
<div id="display${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}" jcr:id="${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}">
</div>
<template:addResources>
<script>
    $(document).ready(function() {
        $("#file${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}").editable('<c:url value="${url.base}${param['path'] == null ? renderContext.mainResource.node.path : param['path']}"><c:param name="jcrContributePost" value="true"/></c:url>', {
            type : 'ajaxupload',
            onblur : 'ignore',
            submit : 'OK',
            cancel : 'Cancel',
            submitdata : {'jcrContributePost':'true'},
            tooltip : 'Click to edit',
            callback : function (data, status,original) {
                var id = $(original).attr('jcr:id');
                $("#"+id).val(data.uuids[0]);
                $("#display${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}").html("<img src='"+data.urls[0]+"'/>");
                $("#file${scriptTypeName}${fn:replace(propertyDefinition.name,':','_')}").html('<span><fmt:message key="add.file"/></span>');
            }
        });
    });
</script>
</template:addResources>