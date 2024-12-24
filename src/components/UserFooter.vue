<template>
  <footer class="app_footer">
    <!-- 联系我们 -->
    <div class="contact">
      <div class="container">
        <dl>
          <dt>客户服务</dt>
          <dd><i class="iconfont icon-kefu1"></i> 智能客服</dd>
          <dd><i class="iconfont icon-kefu2"></i> 在线客服</dd>
        </dl>
        <dl>
          <dt>关注我们</dt>
          <dd><i class="iconfont icon-weixin"></i> 公众号</dd>
          <dd><i class="iconfont icon-weibo"></i> 微博</dd>
        </dl>
        <dl>
          <dt>服务热线</dt>
          <dd class="hotline">800-0800-008 <small>周一至周日 8:00-18:00</small></dd>
        </dl>
        <dl>
          <dt>帮助中心</dt>
          <dd><i class="iconfont icon-qa"></i> 常见问题</dd>
          <dd><i class="iconfont icon-tousu"></i> 我要投诉</dd>
        </dl>
      </div>
    </div>
    <!-- 其它 -->
    <div class="extra">
      <div class="container">
        <div class="slogan">
          <a href="javascript:;">
            <i class="iconfont icon-SwapEase"></i>
            <span>闲置变现</span>
          </a>
          <a href="javascript:;">
            <i class="iconfont icon-CampusAid"></i>
            <span>校园互助</span>
          </a>
          <a href="javascript:;">
            <i class="iconfont icon-DealHunt"></i>
            <span>低价好物</span>
          </a>
        </div>
        <!-- 版权信息 -->
        <div class="copyright">
          <p>
            <a href="javascript:;">关于我们</a>
            <a href="javascript:;">帮助中心</a>
            <a href="javascript:;">售后服务</a>
            <a href="javascript:;">配送与验收</a>
            <a href="javascript:;">商务合作</a>
            <a href="javascript:;">搜索推荐</a>
            <a href="javascript:;">友情链接</a>
          </p>
          <p>CopyRight ©双鸭山海景房施工团</p>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped lang="scss">
.app_footer {
  overflow: hidden;
  background-color: #f5f5f5;
  // padding-top: 20px;

  .contact {
    background: #fff;

    .container {
      padding: 40px 0 30px 100px;
      display: flex;
    }

    dl {
      height: 100px;
      text-align: center;
      padding: 0 72px;
      color: #999;

      &:first-child {
        border-right: none;
        padding-left: 0;
      }

      &:last-child {
        border-right: none;
        padding-right: 0;
      }
    }

    dt {
      border-right: none;
      line-height: 1;
      font-size: 16px;
    }

    dd {
      margin: 20px 12px 0 0;
      float: left;
      width: 72px;
      height: 72px;
      padding-top: 0px;
      font-size: 12px;

      .iconfont {
        font-size: 26px;
        display: block;
        color: #666;
      }

      &:hover {
        .iconfont {
          color: $comColor;
        }
      }

      &:last-child {
        margin-right: 0;
      }
    }

    .hotline {
      padding-top: 7px;
      font-size: 18px;
      color: #666;
      width: auto;
      height: auto;
      border: none;

      small {
        display: block;
        font-size: 12px;
        color: #999;
      }
    }
  }

  .extra {
    background-color: #333;
  }

  .slogan {
    height: 100px;
    line-height: 58px;
    padding: 30px 100px;
    border-bottom: 1px solid #434343;
    display: flex;
    justify-content: space-between;

    a {
      height: 58px;
      line-height: 48px;
      color: #fff;
      font-size: 25px;

      i {
        font-size: 30px;
        vertical-align: middle;
        margin-right: 10px;
        font-weight: 100;
      }

      span {
        vertical-align: middle;
        text-shadow: 0 0 1px #333;
      }
    }
  }

  .copyright {
    height: 120px;
    padding-top: 40px;
    text-align: center;
    color: #999;
    font-size: 12px;

    p {
      line-height: 1;
      margin-bottom: 20px;
    }

    a {
      color: #999;
      line-height: 1;
      padding: 0 10px;
      border-right: 1px solid #999;

      &:last-child {
        border-right: none;
      }
    }
  }
}
</style>
