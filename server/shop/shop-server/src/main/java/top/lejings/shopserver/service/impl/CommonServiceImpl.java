package top.lejings.shopserver.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import top.lejings.shopcommon.constant.MessageConstant;
import top.lejings.shopcommon.constant.StatusConstant;
import top.lejings.shopcommon.exception.AccountLockedException;
import top.lejings.shopcommon.exception.AccountNotFoundException;
import top.lejings.shopcommon.exception.PasswordErrorException;
import top.lejings.shoppojo.DTO.EmployeeLoginDTO;
import top.lejings.shoppojo.VO.EmployeeLoginVO;
import top.lejings.shopserver.mapper.CommonMapper;
import top.lejings.shopserver.service.CommonService;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.controller.service.impl
 * @Author: LeJingS
 * @CreateTime: 2025-06-07  16:11
 * @Description: TODO
 */
@Service
@Slf4j
public class CommonServiceImpl implements CommonService {

    @Autowired
    CommonMapper  commonMapper;

    @Override
    public EmployeeLoginVO login(EmployeeLoginDTO employeeLoginDTO) {
        log.info("登录验证密码",  employeeLoginDTO);
        String username = employeeLoginDTO.getUsername();
        String password = employeeLoginDTO.getPassword();
        EmployeeLoginVO employeeLoginVO = commonMapper.getByUsername(username);
        if(employeeLoginVO == null){
            //账号不存在异常
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }
        // 比对密码
        // 密码md5加密
        password = DigestUtils.md5DigestAsHex(password.getBytes());
        log.info("加密后密码为", password);

        if (!password.equals(employeeLoginVO.getPassword())) {
            //密码错误
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }

        if (employeeLoginVO.getStatus() == StatusConstant.DISABLE) {
            //账号被锁定
            throw new AccountLockedException(MessageConstant.ACCOUNT_LOCKED);
        }
        return employeeLoginVO;
    }
}
