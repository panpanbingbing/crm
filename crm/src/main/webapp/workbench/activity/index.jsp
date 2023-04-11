<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>

<head>
<base href="<%=baseUrl%>">
<meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


    <script type="text/javascript">

        $(function () {


            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });


            $("#addBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/getUserList.do",
                    data: {},
                    type: "get",
                    dataType: "json",
                    success: function (response) {
                        var html = ""
                        // var html = "<option></option>"
                        $.each(response, function (index, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>"
                        })
                        $("#create-marketActivityOwner").html(html)

                        var value = "${sessionScope.user.id}"

                        $("#create-marketActivityOwner").val(value)

                        $("#createActivityModal").modal("show")
                    }
                })

            })

            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/saveActivity.do",
                    data: {

                        "owner": $.trim($("#create-marketActivityOwner").val()),
                        "name": $.trim($("#create-marketActivityName").val()),
                        "startDate": $.trim($("#create-startTime").val()),
                        "endDate": $.trim($("#create-endTime").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-describe").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            //添加成功刷新市场活动列表
                            pageList(1, 3);
                            // $("#ActivityAddForm")[0].reset();
                            //关闭模态窗口
                            $("#createActivityModal").modal("hide");

                        } else {
                            alert("市场活动添加失败")
                            // $("#createActivityModal").modal("hide");
                        }
                    }
                })

            })


            //界面加载完毕刷新activityList
            pageList(1, 3);


            //点击查询刷新activityList
            $("#searchBtn").click(function () {
                $("#hidden-name").val($.trim($("#search-name").val()))
                $("#hidden-owner").val($.trim($("#search-owner").val()))
                $("#hidden-startTime").val($.trim($("#search-startTime").val()))
                $("#hidden-endTime").val($.trim($("#search-endTime").val()))
                pageList(1, 3);
            })


            //全选复选框
            $("#qx").click(function () {

                $("input[name=xz]").prop("checked", this.checked)
            })


            //单选复选框
            $("#activityBody").on("click", "input[name=xz]", function () {
                $("#qx").prop("checked", $("input[name=xz]").length === $("input[name=xz]:checked").length)
            })


            // 删除市场活动
            $("#deleteBtn").click(function () {
                // var $xz = $("input[name=xz]:checked");
                var $xz = $("input[name=xz]:checked")

                if ($xz.length !== 0) {
                    if (confirm("确定删除所选记录吗？")) {
                        var param = ""
                        for (var i = 0; i < $xz.length; i++) {
                            param += "id=" + $($xz[i]).val();
                            //如果不是最后一个元素，需要在后面追加一个&符
                            if (i < $xz.length - 1) {
                                param += "&";
                            }
                        }
                        $.ajax({
                            //"/workbench/activity/deleteActivity.do"
                            url: "workbench/activity/deleteActivity.do",
                            data: param,
                            type: "post",
                            dataType: "json",
                            success: function (response) {
                                if (response.success) {
                                    // pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                                    pageList(1, 3);
                                } else {
                                    alert("市场活动删除失败！！！")
                                }
                            }
                        })
                    }
                } else {
                    alert("请选择需要删除的记录");
                }
            })





        });





        function pageList(pageNo, pageSize) {

            // $("#qx").prop("checked",false)
            $("#qx").prop("checked", false);

            $("#search-name").val($.trim($("#hidden-name").val()))
            $("#search-owner").val($.trim($("#hidden-owner").val()))
            $("#search-startTime").val($.trim($("#hidden-startTime").val()))
            $("#search-endTime").val($.trim($("#hidden-endTime").val()))


            $.ajax({
                url: "workbench/activity/pageList.do",

                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startTime").val()),
                    "endDate": $.trim($("#search-endTime").val())

                },
                type: "get",
                dataType: "json",
                success: function (response) {
                    /*
                        data
                            我们需要的：市场活动信息列表
                            [{市场活动1},{2},{3}] List<Activity> aList
                            一会分页插件需要的：查询出来的总记录数
                            {"total":100} int total

                            {"total":100,"dataList":[{市场活动1},{2},{3}]}
                     */

                    var html = "";
                    //每一个n就是每一个市场活动对象
                    $.each(response.dataList, function (i, n) {

                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.jsp?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '</tr>';
                    })
                    $("#activityBody").html(html);


                    var totalPages = response.total % pageSize === 0 ? response.total / pageSize : parseInt(response.total / pageSize) + 1;

                    //数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: response.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        //该回调函数时在，点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });


                }
            })
        }


        // function pageList(pageNo,pageSize) {
        //
        //     //将全选的复选框的√干掉
        //     $("#qx").prop("checked",false);
        //
        //     //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
        //     $("#search-name").val($.trim($("#hidden-name").val()));
        //     $("#search-owner").val($.trim($("#hidden-owner").val()));
        //     $("#search-startDate").val($.trim($("#hidden-startDate").val()));
        //     $("#search-endDate").val($.trim($("#hidden-endDate").val()));
        //
        //     $.ajax({
        //         url: "workbench/activity/pageList.do",
        //
        //                 data: {
        //                     "pageNo": pageNo,
        //                     "pageSize": pageSize,
        //                     "name": $.trim($("#search-name").val()),
        //                     "owner": $.trim($("#search-owner").val()),
        //                     "startDate": $.trim($("#search-startTime").val()),
        //                     "endDate": $.trim($("#search-endTime").val())
        //         // url : "workbench/activity/pageList.do",
        //         // data : {
        //         //
        //         //     "pageNo" : pageNo,
        //         //     "pageSize" : pageSize,
        //         //     "name" : $.trim($("#search-name").val()),
        //         //     "owner" : $.trim($("#search-owner").val()),
        //         //     "startDate" : $.trim($("#search-startDate").val()),
        //         //     "endDate" : $.trim($("#search-endDate").val())
        //
        //         },
        //         type : "get",
        //         dataType : "json",
        //         success : function (data) {
        //
        //             /*
        //
        //                 data
        //
        //                     我们需要的：市场活动信息列表
        //                     [{市场活动1},{2},{3}] List<Activity> aList
        //                     一会分页插件需要的：查询出来的总记录数
        //                     {"total":100} int total
        //
        //                     {"total":100,"dataList":[{市场活动1},{2},{3}]}
        //
        //              */
        //
        //             var html = "";
        //
        //             //每一个n就是每一个市场活动对象
        //             $.each(data.dataList,function (i,n) {
        //
        //                 html += '<tr class="active">';
        //                 html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
        //                 html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
        //                 html += '<td>'+n.owner+'</td>';
        //                 html += '<td>'+n.startDate+'</td>';
        //                 html += '<td>'+n.endDate+'</td>';
        //                 html += '</tr>';
        //
        //             })
        //
        //             $("#activityBody").html(html);
        //
        //             //计算总页数
        //             var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
        //
        //             //数据处理完毕后，结合分页查询，对前端展现分页信息
        //             $("#activityPage").bs_pagination({
        //                 currentPage: pageNo, // 页码
        //                 rowsPerPage: pageSize, // 每页显示的记录条数
        //                 maxRowsPerPage: 20, // 每页最多显示的记录条数
        //                 totalPages: totalPages, // 总页数
        //                 totalRows: data.total, // 总记录条数
        //
        //                 visiblePageLinks: 3, // 显示几个卡片
        //
        //                 showGoToPage: true,
        //                 showRowsPerPage: true,
        //                 showRowsInfo: true,
        //                 showRowsDefaultInfo: true,
        //
        //                 //该回调函数时在，点击分页组件的时候触发的
        //                 onChangePage : function(event, data){
        //                     pageList(data.currentPage , data.rowsPerPage);
        //                 }
        //             });
        //
        //
        //         }
        //
        //     })
        //
        // }

    </script>
</head>

<body>

<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startTime">
<input type="hidden" id="hidden-endTime">


<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="ActivityAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startTime">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endTime">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span>
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <option>zhangsan12321</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input id="search-name" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="search-owner" class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startTime"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endTime">
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" id="deleteBtn" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除123
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--                <tr class="active">--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>2020-10-10</td>--%>
                <%--                    <td>2020-10-20</td>--%>
                <%--                </tr>--%>
                <%--                <tr class="active">--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>2020-10-10</td>--%>
                <%--                    <td>2020-10-20</td>--%>
                <%--                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <%--            <div>--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
            <%--            </div>--%>
            <%--            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
            <%--                <div class="btn-group">--%>
            <%--                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
            <%--                        10--%>
            <%--                        <span class="caret"></span>--%>
            <%--                    </button>--%>
            <%--                    <ul class="dropdown-menu" role="menu">--%>
            <%--                        <li><a href="#">20</a></li>--%>
            <%--                        <li><a href="#">30</a></li>--%>
            <%--                    </ul>--%>
            <%--                </div>--%>
            <%--                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
            <%--            </div>--%>
            <%--            <div style="position: relative;top: -88px; left: 285px;">--%>
            <%--                <nav>--%>
            <%--                    <ul class="pagination">--%>
            <%--                        <li class="disabled"><a href="#">首页</a></li>--%>
            <%--                        <li class="disabled"><a href="#">上一页</a></li>--%>
            <%--                        <li class="active"><a href="#">1</a></li>--%>
            <%--                        <li><a href="#">2</a></li>--%>
            <%--                        <li><a href="#">3</a></li>--%>
            <%--                        <li><a href="#">4</a></li>--%>
            <%--                        <li><a href="#">5</a></li>--%>
            <%--                        <li><a href="#">下一页</a></li>--%>
            <%--                        <li class="disabled"><a href="#">末页</a></li>--%>
            <%--                    </ul>--%>
            <%--                </nav>--%>
            <%--            </div>--%>
            <%--        </div>--%>
            <div id="activityPage"></div>

        </div>

    </div>

</body>

</html>