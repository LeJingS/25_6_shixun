package top.lejings.shopserver.service.impl.cashier;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import top.lejings.shopcommon.result.Result;
import top.lejings.shoppojo.VO.CommodityVO;
import top.lejings.shopserver.mapper.cashier.BuyMapper;
import top.lejings.shopserver.service.cashier.BuyService;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.service.impl.cashier
 * @Author: LeJingS
 * @CreateTime: 2025-06-08  17:13
 * @Description: TODO
 */
@Service
@Slf4j
public class BuyServiceImpl implements BuyService {

    @Autowired
    private BuyMapper buyMapper;
    @Override
    public Result<CommodityVO> getCommodityByBarCode(String barcode) {
        // 根据条码查询商品信息，判断是否有记录
        CommodityVO commodityVO = buyMapper.getCommodityByBarCode(barcode);
        if (commodityVO == null) {
            return Result.error("未找到对应的商品信息");
        }
        return Result.success(commodityVO);
    }
}
