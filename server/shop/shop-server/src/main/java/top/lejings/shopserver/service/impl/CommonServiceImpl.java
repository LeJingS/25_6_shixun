package top.lejings.shopserver.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import top.lejings.shopcommon.constant.JwtClaimsConstant;
import top.lejings.shopcommon.constant.MessageConstant;
import top.lejings.shopcommon.constant.StatusConstant;
import top.lejings.shopcommon.exception.AccountLockedException;
import top.lejings.shopcommon.exception.AccountNotFoundException;
import top.lejings.shopcommon.exception.PasswordErrorException;
import top.lejings.shopcommon.properties.JwtProperties;
import top.lejings.shopcommon.utils.JwtUtil;
import top.lejings.shoppojo.DTO.EmployeeLoginDTO;
import top.lejings.shoppojo.VO.EmployeeLoginVO;
import top.lejings.shopserver.mapper.CommonMapper;
import top.lejings.shopserver.service.CommonService;

import java.util.HashMap;
import java.util.Map;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.controller.service.impl
 * @Author: LeJingS
 * @CreateTime: 2025-06-07  16:11
 * @Description:
 */
@Service
@Slf4j
public class CommonServiceImpl implements CommonService {

    @Autowired
    private CommonMapper  commonMapper;
    @Autowired
    private JwtProperties jwtProperties;

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
        // 登录成功，生成jwt令牌
        Map<String, Object> claims = new HashMap<>();
        // 将用户ID放入JWT的声明中，用于后续身份识别
        claims.put(JwtClaimsConstant.EMP_ID, employeeLoginVO.getUserId());
        
        // 使用配置的密钥、过期时间和用户声明生成JWT令牌
        String token = JwtUtil.createJWT(
                jwtProperties.getSecretKey(),  // JWT签名所用的密钥
                jwtProperties.getTtl(),        // 令牌有效时间（毫秒）
                claims);                            // 用户相关信息的声明
        
        // 将生成的token设置到返回对象中，以便客户端保存和使用
        employeeLoginVO.setToken(token);
        return employeeLoginVO;
    }
}
