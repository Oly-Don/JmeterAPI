<?xml version="1.0"?>
<xsl:stylesheet  version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:msfunction="http://www.mycompany.org/ns/function" exclude-result-prefixes="msxsl msfunction">

<!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at
 
       http://www.apache.org/licenses/LICENSE-2.0
 
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->

<!-- 
	Stylesheet for processing 2.1 output format test result files 
	To uses this directly in a browser, add the following to the JTL file as line 2:
	<?xml-stylesheet type="text/xsl" href="../extras/jmeter-results-detail-report_21.xsl"?>
	and you can then view the JTL in a browser
-->
	<msxsl:script implements-prefix="msfunction" language="javascript">
<![CDATA[    
function clock(){
    var time = new Date();
    var year = time.getFullYear();
    var month = time.getMonth() + 1;
    var day = time.getDate();
    var hours = time.getHours();
    var min = time.getMinutes();
    var sec = time.getSeconds();
    var mydate= year + "/" + month + "/" + day + " " + hours + ":" + min + ":" + sec ;
	document.getElementById("mydata")
	
}
]]>
</msxsl:script>
<xsl:output method="html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

<!-- Defined parameters (overrideable)   <td bgcolor="#ff00ff">  -->
<xsl:param    name="showData" select="'n'"/>
<xsl:param    name="titleReport" select="'测试报告（南北项目组）'"/>
<xsl:param    name="dateReport" select="'date not defined'"/>

<xsl:template match="testResults">
	<html >
	
		<head>
			<title><h2><xsl:value-of select="$titleReport" /></h2></title>
			<style type="text/css">
				body {
					font:normal 95% verdana,arial,helvetica;
					color:#000000;
				}
				table tr td, table tr th {
					font-size: 95%;
				}
				table.details tr th{
				    color: #ffffff;
					font-weight: bold;
					text-align:center;
					background:#2674a6;
					white-space: nowrap;
				}
				table.details tr td{
					background:#eeeee0;
					white-space: nowrap;
				}
				h1 {
					margin: 0px 0px 5px; font: 165% verdana,arial,helvetica
				}
				h2 {
					margin-top: 1em; margin-bottom: 0.5em; font: bold 125% verdana,arial,helvetica
				}
				h3 {
					margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica
				}
				.Failure {
					font-weight:bold; color:red;
				}
				
	
				img
				{
				  border-width: 0px;
				}
				
				.expand_link
				{
				   position=absolute;
				   right: 0px;
				   width: 27px;
				   top: 1px;
				   height: 27px;
				}
				
				.page_details
				{
				   display: none;
				}
                                
                                .page_details_expanded
                                {
                                    display: block;
                                    display/* hide this definition from  IE5/6 */: table-row;
                                }


			</style>
			<script language="JavaScript">
			<![CDATA[

				function clock(){
					var time = new Date();
					var year = time.getFullYear();
					var month = time.getMonth() + 1;
					var day = time.getDate();
					var hours = time.getHours();
					var min = time.getMinutes();
					var sec = time.getSeconds();
					var mydate= year + "/" + month + "/" + day + " " + hours + ":" + min + ":" + sec ;
					document.getElementById("mydata").value = mydate;
					$("#txt").attr("value",mydate);
					alert(mydate);
				}
                           function expand(details_id)
			   {
			      
			      document.getElementById(details_id).className = "page_details_expanded";
			   }
			   
			   function collapse(details_id)
			   {
			      
			      document.getElementById(details_id).className = "page_details";
			   }
			   
			   function change(details_id)
			   {
			      if(document.getElementById(details_id+"_image").src.match("expand"))
			      {
			         document.getElementById(details_id+"_image").src = "collapse.png";
			         expand(details_id);
			      }
			      else
			      {
			         document.getElementById(details_id+"_image").src = "expand.png";
			         collapse(details_id);
			      } 
                           }
				
			]]></script>
		</head>
		<body >
			<xsl:call-template name="pageHeader" />
			<!--<label>报告日期:</label>
			<input type="text" id="mydata" value=" XXXX/XX/XX XX:XX:XX " /> -->
		    <xsl:call-template name="myresult" />	
			<xsl:call-template name="summary" />
			<hr size="1" width="95%" align="center" />
			<xsl:call-template name="pagelist" />
			<hr size="1" width="95%" align="center" />
			
			<xsl:call-template name="detail" />

		</body>
	
	</html>
</xsl:template>

<xsl:template name="pageHeader">
	<h2><xsl:value-of select="$titleReport" /></h2>
	<!--<table width="100%">
		<tr>
			<td align="right">设计：JMETER API 自动化</td>
		</tr>
	</table>-->
	<hr size="1" />
</xsl:template>

<xsl:template name="myresult">

<xsl:variable name="allFailCount" select="count(/testResults/*[attribute::s='false'])" />

<xsl:if test="$allFailCount = '0'">
 <h2>测试结果:success</h2>
</xsl:if>
<xsl:if test="$allFailCount &gt; '0'">
  <h2  bgcolor="#ff00ff">巡检结果:failed</h2>
  <h2  bgcolor="#ff00ff">失败个数:<xsl:value-of select="count(/testResults/*[attribute::s='false'])"/></h2>

</xsl:if>					
  

</xsl:template>


<xsl:template name="summary">
	<h2>报告概况</h2>
	<table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
		<tr valign="top">
			<th>功能模块总数</th>
			<th>失败数</th>
			<th>成功率</th>
			<!--<th>实际响应时间</th>-->
		</tr>
		<tr valign="top">
			<xsl:variable name="allCount" select="count(/testResults/*)" />
			<xsl:variable name="allFailureCount" select="count(/testResults/*[attribute::s='false'])" />
			<xsl:variable name="allSuccessCount" select="count(/testResults/*[attribute::s='true'])" />
			<xsl:variable name="allSuccessPercent" select="$allSuccessCount div $allCount" />
			<xsl:variable name="allTotalTime" select="sum(/testResults/*/@t)" />
			<xsl:variable name="allAverageTime" select="$allTotalTime div $allCount" />
			<xsl:variable name="allMinTime">
				<xsl:call-template name="min">
					<xsl:with-param name="nodes" select="/testResults/*/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="allMaxTime">
				<xsl:call-template name="max">
					<xsl:with-param name="nodes" select="/testResults/*/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$allFailureCount &gt; 0">Failure</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<td align="center">
				<xsl:value-of select="$allCount" />
			</td>
			<td align="center">
				<xsl:value-of select="$allFailureCount" />
			</td>
			<td align="center">
				<xsl:call-template name="display-percent">
					<xsl:with-param name="value" select="$allSuccessPercent" />
				</xsl:call-template>
			</td>
		<!--	<td align="center">
				<xsl:call-template name="display-time">
					<xsl:with-param name="value" select="$allAverageTime" />
				</xsl:call-template>
			</td>
			-->
	
		</tr>
	</table>
</xsl:template>

<xsl:template name="pagelist">
	<h2>详细情况</h2>
	<table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
		<tr valign="top">
			<th width="20%">功能模块</th>
			<th>检查次数</th>
			<th>失败数</th>
			<th>成功率</th>
			<th>实际响应时间</th>
			<th>对应URL</th>

		</tr>
		<xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb)]">
			<xsl:variable name="label" select="@lb" />
			<xsl:variable name="URL" select="java.net.URL" />
			<xsl:variable name="count" select="count(../*[@lb = current()/@lb])" />
			<xsl:variable name="failureCount" select="count(../*[@lb = current()/@lb][attribute::s='false'])" />
			<xsl:variable name="successCount" select="count(../*[@lb = current()/@lb][attribute::s='true'])" />
			<xsl:variable name="successPercent" select="$successCount div $count" />
			<xsl:variable name="totalTime" select="sum(../*[@lb = current()/@lb]/@t)" />
			<xsl:variable name="averageTime" select="$totalTime div $count" />
			<xsl:variable name="minTime">
				<xsl:call-template name="min">
					<xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="maxTime">
				<xsl:call-template name="max">
					<xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
				</xsl:call-template>
			</xsl:variable>
			
			
			<tr valign="top">
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<td>
				<xsl:if test="$failureCount > 0">
				  <a><xsl:attribute name="href">#<xsl:value-of select="$label" /></xsl:attribute>
				  <xsl:value-of select="$label" />
				  </a>
				</xsl:if>
				<xsl:if test="0 >= $failureCount">
				  <xsl:value-of select="$label" />
				</xsl:if>
				</td>
				<td align="center">
					<xsl:value-of select="$count" />
				</td>
				<td align="center">
					<xsl:value-of select="$failureCount" />
				</td>
				<td align="center">
					<xsl:call-template name="display-percent">
						<xsl:with-param name="value" select="$successPercent" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$averageTime" />
					</xsl:call-template>
				</td>
				<td align="left">
				 <a><xsl:attribute name="href"><xsl:value-of select="$URL"/></xsl:attribute>
				  <xsl:value-of select="$URL"/>
				  </a>
				
				</td>
			
			</tr>
			

		</xsl:for-each>
	</table>
</xsl:template>

<xsl:template name="detail">
	<xsl:variable name="allFailureCount" select="count(/testResults/*[attribute::s='false'])" />

	<xsl:if test="$allFailureCount > 0">
		<h2>Failure Detail</h2>

		<xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb)]">

			<xsl:variable name="failureCount" select="count(../*[@lb = current()/@lb][attribute::s='false'])" />

			<xsl:if test="$failureCount > 0">
				<h3><xsl:value-of select="@lb" /><a><xsl:attribute name="name"><xsl:value-of select="@lb" /></xsl:attribute></a></h3>

				<table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
				<tr valign="top">
					<th>响应</th>
					<th>失败详细信息</th>
					<xsl:if test="$showData = 'y'">
					   <th>响应数据</th>
					</xsl:if>
				</tr>
			
				<xsl:for-each select="/testResults/*[@lb = current()/@lb][attribute::s='false']">
					<tr>
						<td><xsl:value-of select="@rc | @rs" /> - <xsl:value-of select="@rm" /></td>
						<td><xsl:value-of select="assertionResult/failureMessage" /></td>
						<xsl:if test="$showData = 'y'">
							<td><xsl:value-of select="./binary" /></td>
						</xsl:if>
					</tr>
				</xsl:for-each>
				
				</table>
			</xsl:if>

		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template name="min">
	<xsl:param name="nodes" select="/.." />
	<xsl:choose>
		<xsl:when test="not($nodes)">NaN</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$nodes">
				<xsl:sort data-type="number" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="number(.)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="max">
	<xsl:param name="nodes" select="/.." />
	<xsl:choose>
		<xsl:when test="not($nodes)">NaN</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$nodes">
				<xsl:sort data-type="number" order="descending" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="number(.)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="display-percent">
	<xsl:param name="value" />
	<xsl:value-of select="format-number($value,'0.00%')" />
</xsl:template>

<xsl:template name="display-time">
	<xsl:param name="value" />
	<xsl:value-of select="format-number($value,'0 ms')" />
</xsl:template>
	

</xsl:stylesheet>
