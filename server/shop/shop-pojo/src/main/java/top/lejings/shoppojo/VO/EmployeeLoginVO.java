package top.lejings.shoppojo.VO;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(description = "员工登录返回的数据格式")
public class EmployeeLoginVO implements Serializable {

    @ApiModelProperty("主键值")
    private Long userId;

    @ApiModelProperty("用户名")
    private String username;

    @ApiModelProperty("密码")
    private String password;

    @ApiModelProperty("姓名")
    private String fullName;

    @ApiModelProperty("姓别")
    private String gender;

    @ApiModelProperty("职位")
    private String position;

    @ApiModelProperty("部门")
    private String departmentName;

    @ApiModelProperty("入职时间")
    private String hireDate;

    @ApiModelProperty("角色")
    private String roleName;

    @ApiModelProperty("账号状态")
    private Integer status;

    @ApiModelProperty("jwt令牌")
    private String token;

}
