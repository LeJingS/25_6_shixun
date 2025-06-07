package top.lejings.shopserver.controller.common;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import lombok.extern.slf4j.Slf4j;
import top.lejings.shopcommon.result.Result;
import top.lejings.shoppojo.DTO.EmployeeLoginDTO;
import top.lejings.shoppojo.VO.EmployeeLoginVO;
import top.lejings.shopserver.service.CommonService;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.controller.common
 * @Author: LeJingS
 * @CreateTime: 2025-06-07  15:06
 * @Description: 通用接口员工方面
 */

@RestController
@RequestMapping("/emp")
@Slf4j
@Api(tags = "通用接口员工方面")
public class EmployeeController {

    @Autowired
    private CommonService commonService;

    /**
     * @Description: 登录
     */
    @PostMapping("/login")
    @ApiOperation(value = "登录")
    public Result<EmployeeLoginVO> login(@RequestBody EmployeeLoginDTO employeeLoginDTO){
        log.info("员工登录",  employeeLoginDTO);
        return Result.success(commonService.login(employeeLoginDTO));
    }

}
