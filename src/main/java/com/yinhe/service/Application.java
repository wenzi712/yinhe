package com.yinhe.service;

import com.yinhe.config.Parameter;
import com.yinhe.helper.RSAHelper;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;

public class Application implements ApplicationListener<ContextRefreshedEvent> {
    @Override
    public void onApplicationEvent(ContextRefreshedEvent contextRefreshedEvent) {
        try {
            Parameter.PRIVATE_KEY = RSAHelper.StringToPrivateKey("MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDlHBLid7hWL97Bg0FLb8f0chdu7fAdZyDsl1r0mNxfK5hXIfCkzcGggnDePY235RYaId6PtK9njQpkgP0gl9U9ZivFZ19QOPtO3BZQEaJKKGYFOpB/Md6liWSNtoYNejDQPwP/lwAVH2X8KFkjXB/LRYS4fCWY0+Hl3H+YN5fw6bX65BlBHEQGJyvu7RIdfFGPSpDYyizT1lnlTOs2WwqFvkVANW9B0fY5e1aRgeIo+TSsRefXCpsNUxaIpCaT/B4AKJDNSZpUyX1PV9aAJ92SXma1IDF9JLX6WLAYX07z5NZdxTdePktM55q3zcGDibSj0m8GqUAF9RHH7FobgeevAgMBAAECggEARTRZr/ahw8bp7mILUxIMwBXGZkeRBBCmrVB6tO+HgWfVuFwUKHPOTQGZvkexix6zsmkQpS/a29iKjxk3XKUAUG+QQSycacsMfiGUy9LHxsa1KlcqVoFl03LQ4M2FaITEQeMG/ilKaRb241f8tOWa5Pe2w1McuDEoRxp3oC8KwkYDpz99+PkX1ezc1FhyVGpgNIdw5j1UuYK+P+vWwt/mPZNwtsy561Sa/E3KmWXqxjkV/NmMv1tyC6W5C3EvZsACh8o2q9tEAAhfRNKHUjJtTWWmYtdggKCkk03o/wKMay7Pealo1tNH4DZD6C/dHzPlfqcIgD+qZZinQ0FNITWGYQKBgQD+wLuaTuzr6nLeiUdy+DdBE8S4ZF+dRndeegLzb/fWnw/H5d6YRxd60uxmx91Q5Whiwn13Phj/pI8eoDK9+pQqj6C5UFxp5cHqv04FIG4zkNm1WEtUDkhBtEeIknMNLNf/ohQDWSsjMFZT7Sx3JFvUGWUe9fPyUBplO/XQGv+M7QKBgQDmOzQrqJavfSZt+Ec8YuuEDmHTGuYMSFJP2xjX+qZUrWW7I3AFldOx9iTow2CLG0WNtg+zKL57Zs2Hb+OI4Mw79tuOk7aeT++8MByyU/XhqsjfZNOUjHx74NsLHN62Mau2ML2IpKcqjKIwntHYiAfmZ5uEN0t8ge6T+i/zpiiPiwKBgQDMOkBrjVhcLMDX7F/uKFVLg4iSdk08rXAmulPBSwL5+NxS2dJga6XEHnHMV+/x2WecvOSOgqbR0t+1oqHrMYY0tJ4Z0fW0I7AY/DKU45HVHwuZWOZSxXxhyCAMubMoXcnvssSuhn6RoD+k2p9qCCjh2VX6wxxFJrhybeY7Zll2ZQKBgFsev20wEkNuUtFfXEJIHFJtpsX4dWgTD5DPdCu25jHJVuQUCHgNbnWWp9D/0qv7pTGLBvevfoQ0kc+ytukrn2l0MD1jtPk/RfDDUfg6RqyD/XB85Uh7uaEFw2vIh1Swn/dBnyH/mLG8a0y27vK2E/paszBG+jdS7Wvfry7Namw1AoGBANsbiNJrsmBHzSkaQ2S2hizYTgrrbzbruwcNZmFqkgL9ignFG8ni1wTzVdIOqaZ5++4gMX7XYd0kLCdYj0tgY/Lpx5RGm1DAlq2QAIB62GLInqHkzNdl6wK2yuxDSWg9qfmdbq7XZurVKoiZhsR2oskiwGUy1+eKi06VnNFl1cOm");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
