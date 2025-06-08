package top.lejings.shopserver.controller.cashier;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import top.lejings.shopcommon.result.Result;
import top.lejings.shoppojo.VO.CommodityVO;
import top.lejings.shopserver.service.cashier.BuyService;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shopserver.controller.cashier
 * @Author: LeJingS
 * @CreateTime: 2025-06-08  16:22
 * @Description: 收银员收银相关
 */
@RestController
@RequestMapping("/buy")
@Slf4j
@Api(tags = "收银相关")
public class BuyController {

    @Autowired
    private BuyService buyService;


    //收银根据条码查找商品信息,barcode
    @GetMapping("/commodity/{barcode}")
    @ApiOperation(value = "根据条码查找商品信息")
    public Result<CommodityVO> getCommodityByBarCode(@PathVariable String barcode){
        // 前端返回条码，根据条码查询商品信息
        return buyService.getCommodityByBarCode(barcode);
    }


}
