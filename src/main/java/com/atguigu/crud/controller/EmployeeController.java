package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import sun.security.krb5.internal.PAData;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author chensidi
 * @create 2022-03-02 16:15
 * 处理员工的crud请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 单个批量二合一
     * 批量删除 1-2-3
     * 单个删除：1
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids") String ids){
        if (ids.contains("-")){
            //批量删除
            List<Integer> del_list = new ArrayList<Integer>();

            String[] str_ids = ids.split("-");
            for (String string : str_ids){
                del_list.add(Integer.parseInt(string));
            }
            employeeService.delteBatch(del_list);
        }else {
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return Msg.success();
    }

    /**
     * 修改ajax的type请求方式为PUT
     * 出现的问题：
     * 请求体中有数据；
     * 但是employee对象封装不上
     * 导致sql语句
     * update tbl_emp where empId = 1014
     * 原因：
     *  tomcat：
     *      1、将请求体中的数据封装成一个map
     *      2、request.getParameter("empName")就会从这个map中取值
     *      3、speingMVC封装的POJO对象时
     *                  会把POJO每个属性的值调用request.getParameter("email")获取得到
     *
     * Ajax发送put请求引发的血案
     *          put请求，请求体中的数据，request.getparameter("empName")获取不到
     *          tomcattomcat一看不是post不会封装请求体的数据为map，只有post形式的请求才会封装请求体数据
     *          apache源码Request.java---paraseParameter()(3100行)
     * 解决方案：
     *我们要能支持直接发送PUT请求之类的请求还要封装请求体中的数据
     * 1、配置HttpPutFormContentFilter的过滤器
     * 2、它的作用：将请求体中的数据解析包装成一个map
     * 3、request重新被包装，request.getParameter()被重写，就会从自己封装的map取数据
     * 员工更新方法
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee, HttpServletRequest request){
        System.out.println("请求体中的数据：" + request.getParameter("gender"));
        System.out.println("将要更新员工的数据：" + employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 根据id查询员工
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    /**\
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping("checkuser")
    public Msg checkuser(@RequestParam("empName") String empName){
        //先判断用户名是否合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)){
            return Msg.fail().add("va_msg","用户名可以是2-5位中文字符");
        }
        boolean b = employeeService.checkUser(empName);
        if (b){
            return Msg.success();
        }else{
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if (result.hasErrors()){
            //校验失败返回错误信息
            Map<String,Object> map = new HashMap<String, Object>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors){
                System.out.println("错误的字段：" + error.getField());
                System.out.println("错误信息：" + error.getDefaultMessage());
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }

    }


    @ResponseBody
    @RequestMapping("emps")
    public Msg getEmpsWithJSon(@RequestParam(value = "pn",defaultValue = "1") int pn){
        //这不是一个分页查询
        //引入pageHelper分页插件
        //查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //stratPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps =  employeeService.getAll();
        //使用pageInfo包装查询之后的结果，只需要将pageInfo交给页面就好了
        //封装了详细的分页信息,包括有我们查询出来的数据,navigatePages导航栏的个数
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",pageInfo);
    }
    /**
     * 查询员工数据（分页查询）
     * @return
     */
//    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") int pn
    ,Model model){
        //这不是一个分页查询
        //引入pageHelper分页插件
        //查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //stratPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps =  employeeService.getAll();
        //使用pageInfo包装查询之后的结果，只需要将pageInfo交给页面就好了
        //封装了详细的分页信息,包括有我们查询出来的数据,navigatePages导航栏的个数
        PageInfo pageInfo = new PageInfo(emps,5);
        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }
}
