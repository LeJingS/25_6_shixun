package top.lejings.shoppojo.VO;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @BelongsProject: shop
 * @BelongsPackage: top.lejings.shoppojo.VO
 * @Author: LeJingS
 * @CreateTime: 2025-06-08  16:55
 * @Description: TODO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(description = "单个商品信息")
public class CommodityVO {
    @ApiModelProperty("商品id")
    private Long productId;

    @ApiModelProperty("商品品牌id")
    private Long brandId;

    @ApiModelProperty("品牌名称")
    private String brandName;

    @ApiModelProperty("商品分类id")
    private Long categoryId;

    @ApiModelProperty("分类名称")
    private String categoryName;

    @ApiModelProperty("商品名称")
    private String name;

    @ApiModelProperty("商品价格")
    private Double price;

    @ApiModelProperty("商品计量单位")
    private String unit;

}
