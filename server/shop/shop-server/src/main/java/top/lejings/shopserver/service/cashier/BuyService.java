package top.lejings.shopserver.service.cashier;

import top.lejings.shopcommon.result.Result;
import top.lejings.shoppojo.VO.CommodityVO;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.service.cashier
 * @Author: LeJingS
 * @CreateTime: 2025-06-08  17:13
 * @Description: TODO
 */
public interface BuyService {
    Result<CommodityVO> getCommodityByBarCode(String barcode);
}
