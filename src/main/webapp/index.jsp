<%--
  Created by IntelliJ IDEA.
  User: dudu
  Date: 2022/3/2
  Time: 16:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    pageContext.setAttribute("APP_PATH",request.getContextPath());
%>
<html>
<head>
    <title>员工列表</title>


    <!--
        web路径
        不以/开始的相对路径，找资源，以当前资源路径为基准，经常容易出问题
        以/开始的相对路径，找资源，以服务器路径为基准(http://localhost:8080);需要加上项目名
        http://localhost/crud
    -->
    <!--引入jquery-->
    <script src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
    <!--引入样式-->
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>

<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!--部门提交部门id即可-->
                            <select class="form-control" name="dId" >

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
            </div>
        </div>
    </div>
</div>
    <!-- 员工添加的模态框 -->
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">员工添加</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <!--部门提交部门id即可-->
                                <select class="form-control" name="dId" id="dept_add_select">

                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                </div>
            </div>
        </div>
    </div>
<!--搭建显示页面-->
<div class="container">
    <!--标题-->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!--按钮-->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <!--显示表格数据-->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" id="check_all"/>
                        </th>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>

                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <!--显示分页信息-->
    <div class="row">
        <div class="col-md-6" id="page_info_area">

        </div>
        <!--分页条-->
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>
<script type="text/javascript">
    var totalRecord,currentPage;
    //页面加载完成之后，直接发送ajax请求，要到分页数据
    $(function () {
        //去首页
        to_page(1)
        });
    function to_page(pn) {
        //解决每一次页面翻页，checkall的checkbox依旧勾选的状态
        $("#check_all").prop("checked",false);
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn=" + pn,
            type:"get",
            success:function (result) {
                // console.log(result)
                //1、解析并显示员工信息
                build_emps_table(result);
                //2、解析并显示分页信息
                build_page_info(result);
                //3、解析并显示分页条数据
                build_page_nav(result);
            }

        });
    }
        function build_emps_table(result) {
            //清空table表格
            $("#emps_table tbody").empty();
            var emps = result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);
                /*
                *  <button class="btn btn-primary btn-sm">
                        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                         编辑
                   </button>
                **/
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                                .append("编辑");
                //为修改按钮添加自定义属性
                editBtn.attr("eidt-id",item.empId);
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                                .append("删除");
                //为删除按钮添加自定义属性
                delBtn.attr("del-id",item.empId);
                var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

                //append方法执行完成之后还是返回原来的元素
                $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");

            })
        }
        function build_page_info(result) {
            //清空记录信息
            $("#page_info_area").empty();
            $("#page_info_area").append("当前页码是："+ result.extend.pageInfo.pageNum +"页，总共" +
                result.extend.pageInfo.pages+"页，总共"+ result.extend.pageInfo.total+"条记录")
            totalRecord = result.extend.pageInfo.total;
            currentPage = result.extend.pageInfo.pageNum;
        }
        function build_page_nav(result) {
            $("#page_nav_area").empty();
            //page_nav_area
            var ul = $("<ul></ul>").addClass("pagination");
            var first_pageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"))
            if (result.extend.pageInfo.hasPreviousPage == false){
                first_pageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else{
                //首页和前一页的点击事件
                first_pageLi.click(function () {
                    to_page(1);
                });
                prePageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum - 1);
                });
            }

            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"))
            var last_pageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
            if (result.extend.pageInfo.hasNextPage == false){
                nextPageLi.addClass("disabled");
                last_pageLi.addClass("disabled");
            }else{
                nextPageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum + 1);
                });
                last_pageLi.click(function () {
                    to_page(result.extend.pageInfo.pages);
                });
            }

            //添加首页和前一页
            ul.append(first_pageLi).append(prePageLi);
            //遍历添加1,2,3,4,5的页码显示
            $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {

                var numLi = $("<li></li>").append($("<a></a>").append(item));
                if (result.extend.pageInfo.pageNum == item){
                    numLi.addClass("active");
                }
                numLi.click(function () {
                    to_page(item)
                })
                ul.append(numLi)
            });
            //把下一页和末页加到ul中
            ul.append(nextPageLi).append(last_pageLi);
            var navEle = $("<nav></nav>").append(ul);
            navEle.appendTo("#page_nav_area")
        }
        //清空表单样式及内容
        function reset_form(ele){
            $(ele)[0].reset();
            //清空样式
            $(ele).find("*").removeClass("has-success has-error");
            $(ele).find(".help-block").text("");
        }
        //点击新增按钮弹出模态框
        $("#emp_add_modal_btn").click(function () {
            //清除表单的数据
            reset_form("#empAddModal form")

            //发送ajax请求，查出部门信息，显示在下拉列表中
            getDepts("#empAddModal select");
            //弹出模态框
            $("#empAddModal").modal({
                backdrop:"static"
            });
        });
        //查出所有的部门信息并显示在下拉列表
        function getDepts(ele) {
            //清空之前下拉列表的值
            $(ele).empty();
            $.ajax({
                url: "${APP_PATH}/depts",
                type:"get",
                success:function (result) {
                    //"extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]
                    // console.log(result)
                    //显示部门信息在下拉列表中
                    // $("#dept_add_select")
                    //$("#empAddModal select")
                    $.each(result.extend.depts,function () {
                        var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                        optionEle.appendTo(ele);
                    });

                }
            });
        }
        function validate_add_form(){
            var empName = $("#empName_add_input").val();
            var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
            // alert(regName.test(empName));
            if (!regName.test(empName)){
                // alert("用户名可以是2-5位中文字符或者6-16位英文字符和数字的组合");
                show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文字符或者6-16位英文字符和数字的组合");
                // $("#empName_add_input").parent().addClass("has-error");
                // $("#empName_add_input").next("span").text("用户名可以是2-5位中文字符或者6-16位英文字符和数字的组合");
                return false;
            }else{
                show_validate_msg("#empName_add_input","success","");

            }
            //验证邮箱是否正确
            var email = $("#email_add_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!regEmail.test(email)){
                // alert("邮箱格式不正确！")
                show_validate_msg("#email_add_input","error","邮箱格式不正确！");

                return false;
            }else {
                show_validate_msg("#email_add_input","success","");

            }
            return true;

        }

        //显示校验结果信息
        function show_validate_msg(ele,status,msg){
            //清除当前元素的校验状态
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if ("success" == status){
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            }else if ("error" == status){
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        //数据库重复名字校验
        $("#empName_add_input").change(function () {
            //发送ajax请求用户名是否可用
            var empName = this.value;
            $.ajax({
                url:"${APP_PATH}/checkuser",
                type:"Post",
                data:"empName="+empName,
                success:function (result) {
                    if (result.code == 100){
                        show_validate_msg("#empName_add_input","success","用户名可用");
                        $("#emp_save_btn").attr("ajax-va","success");
                    }else{
                        show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                        $("#emp_save_btn").attr("ajax-va","error");
                    }
                }
            })
        })

        $("#emp_save_btn").click(function () {
            //1、模态框填写的数据提交给服务器
            //2、先对提交服务器的数据进行校验
            // if (!validate_add_form()){
            //     return false;
            // };
            //判断之前的ajax用户名校验是否成功

            if ($(this).attr("ajax-va") == "error"){
                return false;
            }
            //3、发送ajax请求保存员工信息
            $.ajax({
                url:"${APP_PATH}/emp",
                type:"POST",
                data:$("#empAddModal form").serialize(),
                success:function (result) {
                    // alert(result.msg);
                    //员工保存成功
                    //1、关闭模态框
                    if(result.code == 100){
                        $("#empAddModal").modal('hide')
                        //2、来到最后一页，显示最后一页的数据，就是刚刚添加的数据
                        to_page(totalRecord);
                    }else{
                        // console.log(result)
                        // alert(result.extend.errorFields.email);
                        // alert(result.extend.errorFields.empName);
                        //那个字段出现错误信息显示那个字段
                        if(undefined != result.extend.errorFields.email){
                            show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                        }
                        if (undefined != result.extend.errorFields.empName){
                            show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                        }
                    }

                }
            })
        });
        //1、我们是创建按钮之前就绑定了单击事件，所以绑定不上
        // $(".edit").click(function () {
        //
        // })
        //2、可以在创建按钮的时候绑定，绑定单击live()
        //jquery新版没有live，使用on代替
        $(document).on("click",".edit_btn",function () {
            // alert("edit")
            //0、查出员工信息，显示员工信息
            //1、查出部门信息，显示部门列表
            getEmp($(this).attr("eidt-id"));
            //2、把员工id传递给模态框的更新按钮
            $("#emp_update_btn").attr("edit-id",$(this).attr("eidt-id"));
            getDepts("#empUpdateModal select");
            $("#empUpdateModal").modal({
                backdrop: "static"
            });
        });
        function getEmp(id) {
            $.ajax({
                url:"${APP_PATH}/emp/" + id,
                type:"get",
                success:function (result) {
                    // console.log(result);
                    var empData = result.extend.emp;
                    $("#empName_update_static").text(empData.empName);
                    $("#email_update_input").val(empData.email);
                    $("#empUpdateModal input[name=gender]").val([empData.gender]);
                    $("#empUpdateModal select").val([empData.dId]);

                }
            });
        }
        //点击更新，更新员工信息
        $("#emp_update_btn").click(function () {
            //验证邮箱是否合法
            //验证邮箱是否正确
            var email = $("#email_update_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!regEmail.test(email)){
                // alert("邮箱格式不正确！")
                show_validate_msg("#email_update_input","error","邮箱格式不正确！");

                return false;
            }else {
                show_validate_msg("#email_update_input","success","");

            }
            //发送ajax请求更新员工数据
            $.ajax({
               url:"${APP_PATH}/emp/" + $(this).attr("edit-id"),
                type:"PUT",
                data:$("#empUpdateModal form").serialize(),
                success:function (result) {
                    // alert(result.msg);
                    //1、关闭模态框
                    $("#empUpdateModal").modal("hide");
                    //2、回到本页面
                    to_page(currentPage);
                }
            });
        });
        $(document).on("click",".delete_btn",function () {
            //1、弹出是否确认删除按钮
            var empName = $(this).parents("tr").find("td:eq(2)").text();
            var empId = $(this).attr("del-id");
            // alert($(this).parents("tr").find("td:eq(1)").text());
            if (confirm("确认删除【" + empName + "】吗？")){
                $.ajax({
                    url:"${APP_PATH}/emp/" + empId,
                    type:"DELETE",
                    success:function (result) {
                        console.log(result.msg);
                        to_page(currentPage);
                    }
                });
            }
        });
        //完成全选、全不选
        $("#check_all").click(function () {
            //attr获取checked的值是undefine
            //我们这些dom原生的属性；attr是自定义属性的获取
            //prop修改和读取dom原生的属性的值
            // alert($(this).prop("checked"));
            $(".check_item").prop("checked",$(this).prop("checked"));


        });
        //check_item
        $(document).on("click",".check_item",function () {
            var flag = $(".check_item:checked").length == $(".check_item").length;
            $("#check_all").prop("checked",flag);
        });
        //点击全部删除就批量删除
        $("#emp_delete_all_btn").click(function () {
            var empNames = "  ";
            var del_idstr = "";
            $.each($(".check_item:checked"),function () {
                empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
                del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
            });
            //去除员工姓名多余的，
            empNames = empNames.substring(0,empNames.length -1);
            //去除员工id多余的-
            del_idstr = del_idstr.substring(0,del_idstr.length -1);
            if (confirm("是否删除【" + empNames + "】吗？")){
                $.ajax({
                    url:"${APP_PATH}/emp/" + del_idstr,
                    type:"DELETE",
                    success:function (result) {
                        alert(result.msg);
                        //在哪一页删除就回到那一页
                        to_page(currentPage);
                    }

                })
            }
        })
</script>
</body>
</html>
