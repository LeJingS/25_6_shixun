package top.lejings.shopserver.service;

import top.lejings.shoppojo.DTO.EmployeeLoginDTO;
import top.lejings.shoppojo.VO.EmployeeLoginVO;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.controller.service
 * @Author: LeJingS
 * @CreateTime: 2025-06-07  16:11
 * @Description:
 */
public interface CommonService {
    EmployeeLoginVO login(EmployeeLoginDTO employeeLoginDTO);
}
