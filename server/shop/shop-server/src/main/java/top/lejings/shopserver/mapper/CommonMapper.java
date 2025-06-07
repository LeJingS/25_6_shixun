package top.lejings.shopserver.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import top.lejings.shoppojo.VO.EmployeeLoginVO;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.mapper
 * @Author: LeJingS
 * @CreateTime: 2025-06-07  16:24
 * @Description: 通用查询
 */
@Mapper
public interface CommonMapper {
    EmployeeLoginVO getByUsername(String username);
}
