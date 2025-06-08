package top.lejings.shopserver.controller.common;

import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.controller.common
 * @Author: LeJingS
 * @CreateTime: 2025-06-08  16:07
 * @Description: 通用登录后所有员工都可以查询的一些信息
 */
@RestController
@RequestMapping("/get")
@Slf4j
@Api(tags = "通用接口员工查询信息")
public class GetSomeThingController {

    //  获取个人考勤信息、TODO 考虑登录自动添加本日考勤记录

    //  获取个人排班信息，分页查询，默认查询当日的排班信息

    //  获取上层管理发布的任务信息，分页查询，默认查询当日的

    //查询个人工资，分页查询，默认查询上月即最后一条

    //个人绩效考核，分页查询，默认查询上次即最后一条
}
