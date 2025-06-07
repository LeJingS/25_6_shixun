package top.lejings.shopcommon.exception;

/**
 * 账号不存在异常
 */
public class AccountNotFoundException extends BaseException {

    public AccountNotFoundException() {
    }

    public AccountNotFoundException(String msg) {
        super(msg);
    }

}
