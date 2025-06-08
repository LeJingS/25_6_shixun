package top.lejings.shopserver.mapper.cashier;

import org.apache.ibatis.annotations.Mapper;
import top.lejings.shoppojo.VO.CommodityVO;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.mapper.cashier
 * @Author: LeJingS
 * @CreateTime: 2025-06-08  17:19
 * @Description: TODO
 */
@Mapper
public interface BuyMapper {
    CommodityVO getCommodityByBarCode(String barcode);
}
