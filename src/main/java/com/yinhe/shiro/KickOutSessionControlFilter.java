package com.yinhe.shiro;

import com.yinhe.model.Account;
import org.apache.shiro.cache.Cache;
import org.apache.shiro.cache.CacheManager;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.DefaultSessionKey;
import org.apache.shiro.session.mgt.SessionManager;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.apache.shiro.web.util.WebUtils;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.io.Serializable;
import java.util.Deque;
import java.util.LinkedList;

public class KickOutSessionControlFilter extends AccessControlFilter {
    private String url;                   //踢出后到的地址
    private boolean kickAfter = false;  //踢出之后登录的用户=false
    private int maxSession = 1;          //同一个帐号最大会话数
    private SessionManager sessionManager;
    private Cache<String, Deque<Serializable>> loggedInCache;

    public KickOutSessionControlFilter(CacheManager cacheManager) {
        loggedInCache = cacheManager.getCache("loggedInCache");
    }

    @Override
    protected boolean isAccessAllowed(ServletRequest servletRequest, ServletResponse servletResponse, Object o) throws Exception {
        return false;
    }

    @Override
    protected boolean onAccessDenied(ServletRequest servletRequest, ServletResponse servletResponse) throws Exception {
        Subject subject = getSubject(servletRequest, servletResponse);
        if (!subject.isAuthenticated() && !subject.isRemembered()) {
            return true;
        }

        Session session = subject.getSession();
        String username = ((Account) subject.getPrincipal()).getName();
        Serializable sessionId = session.getId();

        Deque<Serializable> LoggedInQueue = loggedInCache.get(username);
        if (LoggedInQueue == null || LoggedInQueue.isEmpty()) {
            LoggedInQueue = new LinkedList<>();
            loggedInCache.put(username, LoggedInQueue);
        }

        //如果队列里没有此Session且用户没有被踢出,放入队列
        if (!LoggedInQueue.contains(sessionId) && session.getAttribute("kickedOut") == null) {
            LoggedInQueue.push(sessionId);
        }

        //如果队列里的Session数超出最大会话数,踢出用户
        while (LoggedInQueue.size() > maxSession) {
            Serializable kickedOutSessionId;
            if (kickAfter) {
                kickedOutSessionId = LoggedInQueue.removeFirst();
            } else {
                kickedOutSessionId = LoggedInQueue.removeLast();
            }
            try {
                Session kickedOutSession = sessionManager.getSession(new DefaultSessionKey(kickedOutSessionId));
                if (kickedOutSession != null) {
                    kickedOutSession.setAttribute("kickedOut", true);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        //重定向到踢出后的地址
        if (session.getAttribute("kickedOut") != null) {
            try {
                subject.logout();
            } catch (Exception e) {
                e.printStackTrace();
            }
            saveRequest(servletRequest);
            WebUtils.issueRedirect(servletRequest, servletResponse, url);
            return false;
        }
        return true;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setKickAfter(boolean kickAfter) {
        this.kickAfter = kickAfter;
    }

    public void setMaxSession(int maxSession) {
        this.maxSession = maxSession;
    }

    public void setSessionManager(SessionManager sessionManager) {
        this.sessionManager = sessionManager;
    }
}
