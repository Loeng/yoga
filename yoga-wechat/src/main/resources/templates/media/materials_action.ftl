<script>
    function checkAll(elem) {
        $("input[name='material_id_checkbox']").prop("checked", $("#all_checked").prop('checked'));
    }
</script>
<div class="modal fade" id="group_set_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width:50%">
        <form class="form-horizontal" id="group_set_modal_form">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title">
                        设置分组
                    </h4>
                </div>
                <div class="modal-body" id="group_set_modal_body">
                <#list groups?if_exists as group>
                    <input type="radio" name="add_group_item" value="${group.id?if_exists?c}"
                           style="min-width: 200px; margin-left: 20px; margin-right: 10px">${group.name?if_exists}
                </#list>
                </div>
                <div class="modal-footer">
                    <a href="javascript:void(0)" class="btn btn-danger" data-dismiss="modal"><i
                            class="fa fa-fw fa-remove"></i></button>关闭</a>
                    <a href="javascript:void(0)" id="group_set_modal_submit" class="btn btn-info"><i
                            class="fa fa-fw  fa-save"></i>保存</a>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    function showGroup(id) {
        $("#filter_groupId").val(id);
        $("#filter_form").submit();
    }

    function setGroup(elem, mediaId) {
        $("#group_set_modal_submit").attr("onclick", "doSetGroup('" + mediaId + "')");
        $("#group_set_modal").modal("show");
        $("#group_set_modal_form")[0].reset();
    }

    function doSetGroup(mediaId) {
        var groupId = $("input[name='add_group_item']:checked").val();
        if (groupId == null) return;
        $.post("/api/wechat/material/group/set",
                {
                    groupId: groupId,
                    mediaIds: mediaId
                },
                function (data) {
                    if (data.code < 0) {
                        alertShow("warning", data.message, 3000);
                    } else {
                        window.location.reload();
                    }
                },
                "json"
        );
    }

    function batchAddGroup() {
        if ($("[name='material_id_checkbox']:checked").length < 1) {
            alertShow("warning", "请选择素材！", 1000);
            return;
        }
        $("#group_set_modal_submit").attr("onclick", "doBatchAddGroup()");
        $("#group_set_modal").modal("show");
        $("#group_set_modal_form")[0].reset();
    }

    function doBatchAddGroup() {
        var groupId = $("input[name='add_group_item']:checked").val();
        if (groupId == null) return;
        var ids = "";
        $("[name='material_id_checkbox']:checked").each(function () {
            ids += "," + $(this).val();
        });
        if (ids.length > 0) ids = ids.substr(1);
        $.post("/api/wechat/material/group/set",
                {
                    groupId: groupId,
                    mediaIds: ids
                },
                function (data) {
                    if (data.code < 0) {
                        alertShow("warning", data.message, 3000);
                    } else {
                        window.location.reload();
                    }
                },
                "json"
        );
    }
    $(".spinner").hide();
</script>

<div class="modal fade" id="material_upload_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width:50%">
        <form class="form-horizontal" id="material_upload_modal_form">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title">
                        上传素材
                    </h4>
                </div>
                <div class="modal-body" id="tags_list_model_body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">格式限制</label>
                    <#if (param.type!"") == 'image'>
                        <div class="col-sm-8 control-label"
                             style="text-align: left">小于2MB，bmp/png/jpeg/jpg/gif格式的文件
                        </div>
                    <#elseif (param.type!"") == 'voice'>
                        <div class="col-sm-8 control-label"
                             style="text-align: left">小于2MB，播放长度不超过60s，mp3/wma/wav/amr格式的文件
                        </div>
                    <#elseif (param.type!"") == 'video'>
                        <div class="col-sm-8 control-label" style="text-align: left">小于10MB，mp4格式的文件</div>
                    </#if>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3  control-label">分组</label>
                        <div class="col-md-8">
                            <select id="add_groupId" class="form-control" name="groupId"
                                    style="min-width: 120px">
                                <option value="0" selected>不指定</option>
                            <#list groups?if_exists as group>
                                <option value="${group.id?if_exists?c}">${group.name?if_exists}</option>
                            </#list>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3  control-label">素材名称</label>
                        <div class="col-md-8">
                            <input type="text" class="form-control" id="add_name">
                        </div>
                    </div>
                <#if (param.type!"") == 'video'>
                    <div class="form-group">
                        <label class="col-sm-3  control-label">视频标题</label>
                        <div class="col-md-8">
                            <input type="text" class="form-control" id="add_title">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3  control-label">视频简介</label>
                        <div class="col-md-8">
                            <textarea type="text" class="form-control" id="add_intro"></textarea>
                        </div>
                    </div>
                </#if>
                    <div class="form-group">
                        <label for="myUploader" class="col-md-3">上传文件</label>
                        <div class="col-md-8">
                            <div id="myUploader" class="uploader">
                                <div class="file-list" style="height: 200px; overflow:auto;"
                                     data-drag-placeholder="请拖拽文件到此处"></div>
                                <div class="uploader-actions">
                                    <div class="uploader-status pull-right text-muted"></div>
                                    <button type="button" class="btn btn-link uploader-btn-browse"><i
                                            class="icon icon-plus"></i> 选择文件
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <a href="javascript:void(0)" class="btn btn-danger" data-dismiss="modal"><i
                            class="fa fa-fw fa-remove"></i></button>关闭</a>
                    <a href="javascript:void(0)" id="group_set_modal_submit" class="btn btn-info"
                       onclick="addMaterial();"><i
                            class="fa fa-fw  fa-save"></i>保存</a>
                </div>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $('#myUploader').uploader({
            autoUpload: true,            // 当选择文件后立即自动进行上传操作
            url: '${uploadPath?if_exists}',     // 文件上传提交地址
            lang: 'zh_cn',
            filters: {
            mime_types:
            <#if (param.type!"") == 'image'>
                    [{title: '图片文件', extensions: 'bmp,png,jpeg,jpg,gif'}],
                max_file_size: '2mb',
            <#elseif (param.type!"") == 'voice'>
                [{title: '音频文件', extensions: 'mp3,wma,wav,amr'}],
                max_file_size: '2mb',
            <#elseif (param.type!"") == 'video'>
                [{title: '视频文件', extensions: 'mp4'}],
                max_file_size: '10mb',
            </#if>
                prevent_duplicates: true
            },
            multi_selection: true,
            file_data_name: 'file',
            chunk_size: 0,
            deleteActionOnDone: function (file, doRemoveFile) {
                return true;
            },
            responseHandler: function (responseObject, file) {
                file.data = responseObject.response;
            }
        });
    });
    function doAdd() {
        $("#material_upload_modal").modal("show");
    }

    function addMaterial() {
        var uploader = $('#myUploader').data('zui.uploader');
        var plupload = uploader.plupload;
        var files = plupload.files;
        var title = "";
        var intro = "";
    <#if (param.type!"") == 'video'>
        title = $("#add_title").val();
        intro = $("#add_intro").val();
    </#if>
        var medias = [];
        if (files.length < 1) {
            alertShow("warning", "请选择文件上传！", 3000);
            return;
        }
        for (var i = 0; i < files.length; i++) {
            if (files[i].status != 5) {
                alertShow("warning", "部分文件尚未完成上传或者上传失败！", 3000);
                return;
            }
            medias.push(JSON.parse(files[i].data));
        }
        var groupId = $("#add_groupId").val();
        var name = $("#add_name").val();
        var json = {};
        json["accountId"] = ${param.accountId?if_exists?c};
        json["type"] = '${param.type?if_exists}';
        json["groupId"] = groupId;
        json["files"] = medias;
        json["name"] = name;
        json["title"] = title;
        json["introduction"] = intro;
        $.ajax({
            url: '/api/wechat/material/add',
            type: 'post',
            traditional: true,
            data: JSON.stringify(json),
            dataType: 'json',
            contentType: 'application/json',
            success: function (data) {
                if (data.code < 0) {
                    alertShow("warning", data.message, 3000);
                    return;
                } else {
                    window.location.reload();
                }
            },
            error: function (data) {
                alertShow("warning", data.message, 3000);
            }
        });
    }
</script>

<div class="modal fade" id="material_preview_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width:60%;">
        <form class="form-horizontal" id="material_preview_modal_form">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title">
                        素材预览
                    </h4>
                </div>
                <div class="modal-body" id="material_preview_modal_body">
                <#if (param.type!"") == "image">
                    <img src="" id="image" alt="" style="display: block; position: relative; margin: auto">
                <#else>
                    <div id="news-page">
                        <div id="news-head">
                            <h2 id="news-title">标题</h2>
                            <span id="news-date-author">更新时间和作者</span>
                        </div>
                        <div id="news-body" style="">
                            <div style="text-align: center"><img src="" alt="" id="news-thumb"></div>
                            <div id="news-content"></div>
                        </div>
                    </div>
                </#if>
                </div>
                <div class="modal-footer">
                    <a href="javascript:void(0)" class="btn btn-danger" data-dismiss="modal"><i
                            class="fa fa-fw fa-remove"></i></button>关闭</a>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    function doPreview(elem, url) {
        if (url.length > 0) {
            $("#material_preview_modal").modal("show");
        <#if (param.type!"") == "image">
            $("#image").prop("src", url);
        <#else>
            var arr = url.split(",")
            $.post(
                    "/api/wechat/material/detail",
                    {
                        accountId: ${param.accountId?c},
                        id: arr[0]
                    },
                    function (data) {
                        if (data.code < 0) {
                            alertShow("danger", data.message, 3000);
                        } else {
                            $("#news-title").html(data.result.title);
                            $("#news-date-author").html("更新于" + arr[1] + "&nbsp;&nbsp;" + data.result.author);
                            $('#news-thumb').prop("src", data.result.thumbUrl);
                            $('#news-content').html(data.result.content);
                        }
                    }
            );
        </#if>
        }
    }

    function doBatchDelete() {
        if ($("[name='material_id_checkbox']:checked").length < 1) {
            alertShow("warning", "请选择素材！", 1000);
            return;
        }
        var arr = new Array();
        $("[name='material_id_checkbox']:checked").each(function () {
            console.log($(this).val())
            arr.push($(this).val())
        });
        $.post(
                "/api/wechat/material/batchDelete",
                {
                    accountId: ${param.accountId?c},
                    mediaIds: arr.join(',')
                },
                function (data) {
                    if (data.code < 0) {
                        alertShow("danger", data.message, 3000);
                    } else {
                        window.location.reload();
                    }
                }
        )

    }

    function doDelete(id) {
        warningModal("确定要删除该素材吗?", function () {
            $.post(
                    "/api/wechat/material/delete",
                    {
                        accountId: ${param.accountId?c},
                        id: id
                    },
                    function (data) {
                        if (data.code < 0) {
                            alertShow("danger", data.message, 3000);
                        } else {
                            window.location.reload();
                        }
                    }
            );
        });
    }

    function doRefresh() {
        $.get(
                "/api/wechat/material/refresh?accountId=${param.accountId?if_exists?c}&type=${param.type?if_exists}",
                function (data) {
                    if (data.code < 0) {
                        alertShow("danger", data.message, 3000);
                    } else {
                        alertShow("info", "提交刷新请求成功，请等待一段时候重新刷新页面！", 3000);
                    }
                }
        );
    }
</script>

<@operate.add "新增分组" "#groupAddButton" "addGroup">
<div class="modalForm" style="margin-top: 15px">
    <div class="form-group">
        <label class="col-sm-3  control-label">名称</label>
        <div class="col-sm-8">
            <input type="text" class="form-control" id="new_name">
        </div>
    </div>
</div>
<div class="modalForm" style="margin-top: 15px">
    <div class="form-group">
        <label class="col-sm-3  control-label">描述</label>
        <div class="col-sm-8">
            <input type="text" class="form-control" id="new_remark">
        </div>
    </div>
</div>
</@operate.add>
<script>
    function addGroup() {
        var name = $("#new_name").val();
        var remark = $("#new_remark").val();
        $.post(
                "/api/wechat/material/group/add",
                {
                    name: name,
                    remark: remark
                },
                function (data) {
                    if (data.code < 0) {
                        alertShow("danger", data.message, 3000);
                    } else {
                        window.location.reload();
                    }
                },
                "json"
        );
    }
</script>

<@operate.modal "编辑素材" "material_edit_modal" "saveEdit">
<div class="modalForm" style="margin-top: 15px">
    <div class="form-group">
        <label class="col-sm-2 control-label">素材名称</label>
        <div class="col-sm-9">
            <input type="text" class="form-control" placeholder="" id="edit_material_name" name="name">
        </div>
    </div>
</div>
<input type="hidden" id="edit_media_id" name="mediaId" value="">
</@operate.modal>
<script>
    function doMaterialEdit(name, mediaId) {
        $("#edit_material_name").val(name)
        $("#edit_media_id").val(mediaId);
        $("#material_edit_modal").modal("show");
    }

    function saveEdit() {
        var name = $("#edit_material_name").val();
        var mediaId = $("#edit_media_id").val();
        $.post(
                '/api/wechat/material/edit',
                {
                    name: name,
                    mediaId: mediaId
                },
                function (data) {
                    if (data.code < 0) {
                        alertShow('danger', data.message, 3000);
                    } else {
                        window.location.reload();
                    }
                }
        );
    }
</script>