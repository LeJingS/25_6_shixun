package top.lejings.shopcommon.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "shop.jwt")
@Data
public class JwtProperties {

    /**
     * 员工生成jwt令牌相关配置
     */
    private String secretKey;
    private long ttl;
    private String tokenName;
}
