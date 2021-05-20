<?xml version='1.0'?>

<!--
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved.
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other
trademarks are the property of their respective owners.

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE "AS IS," WITH
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED,  AND IDIOM
TECHNOLOGIES, INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. IDIOM TECHNOLOGIES, INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO  OR ARISING
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF IDIOM
TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

Idiom Technologies, Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives. In no event shall Idiom Technologies, Inc.'s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project.
See the accompanying LICENSE file for applicable license.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format" 
  xmlns:fn="www.w3.org/2005/xpath-functions"
  xmlns:opentopic="http://www.idiominc.com/opentopic" exclude-result-prefixes="opentopic" version="2.0">

  <xsl:template match="*[contains(@class, ' map/topicmeta ')]">
    <fo:block-container xsl:use-attribute-sets="__frontmatter__owner__container">
      <xsl:apply-templates/>
    </fo:block-container>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/author ')]">
    <fo:block xsl:use-attribute-sets="author">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/publisher ')]">
    <fo:block xsl:use-attribute-sets="publisher">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/copyright ')]">
    <fo:block xsl:use-attribute-sets="copyright">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/copyryear ')]">
    <fo:inline xsl:use-attribute-sets="copyryear">
      <xsl:value-of select="@year"/>
      <xsl:text> </xsl:text>
    </fo:inline>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/copyrholder ')]">
    <fo:inline xsl:use-attribute-sets="copyrholder">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <xsl:variable name="map" select="//opentopic:map"/>

  <xsl:template name="createFrontMatter">
    <xsl:if test="$generate-front-cover">
      <fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="page-sequence.cover">
        <xsl:call-template name="insertFrontMatterStaticContents"/>
        <fo:flow flow-name="xsl-region-body">
          <fo:block-container xsl:use-attribute-sets="__frontmatter">

            <!-- REIN MEDICAL set Company background image -->

            <!--                <fo:block background-image="Customization/OpenTopic/common/artwork/note.png" background-repeat="no-repeat" color="red">
                  Dieser Block hat ein Hintergrundbild! - Dieser Block hat ein Hintergrundbild! - Dieser Block hat ein 
                  Hintergrundbild! - Dieser Block hat ein Hintergrundbild! - Dieser Block hat ein Hintergrundbild!
                </fo:block>-->

            <fo:block-container absolute-position="absolute" top="-2cm" left="-2cm" width="28cm" height="39.7cm" background-image="Customization/OpenTopic/common/artwork/ManualCoverPageA4-02.svg">
              <fo:block/>
            </fo:block-container>

            <!-- REIN MEDICAL ENDE -->

            <xsl:call-template name="createFrontCoverContents"/>
          </fo:block-container>
        </fo:flow>
      </fo:page-sequence>
    </xsl:if>
  </xsl:template>

  <xsl:template name="createFrontCoverContents">
    <!-- set the title block -->
    <fo:block-container xsl:use-attribute-sets="__rm__frontmatter__title_box_frame">
      <fo:block-container xsl:use-attribute-sets="__rm__frontmatter__title__box">
        <fo:block xsl:use-attribute-sets="__frontmatter__title">
          <xsl:choose>
            <xsl:when test="$map/*[contains(@class, ' topic/title ')][1]">
              <xsl:apply-templates select="$map/*[contains(@class, ' topic/title ')][1]"/>
            </xsl:when>
            <xsl:when test="$map//*[contains(@class, ' bookmap/mainbooktitle ')][1]">
              <xsl:apply-templates select="$map//*[contains(@class, ' bookmap/mainbooktitle ')][1]"/>
            </xsl:when>
            <xsl:when test="//*[contains(@class, ' map/map ')]/@title">
              <xsl:value-of select="//*[contains(@class, ' map/map ')]/@title"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/descendant::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
        
          <!--Rein Medical Edit Start-->
          <!--list model numbers and product revision no (if available and greater than 0)-->
          <!--first of all we have to test if the value is a integer and not a string line V1.0.0-->
          
          <xsl:variable name="prodRevNo" select="string(//data[./@id[contains(., '_Produktrevision')]]/ph[1])"/>
          <!--potenzielle Leerzeichen aus prodRevNo-String rausrechnen-->
          <xsl:variable name="cleanProdRevNo" select="translate($prodRevNo, ' &#x9;&#xa;', '')"/>
          
          <xsl:if test="string-length($cleanProdRevNo)= 1">
              
              <xsl:choose>
                  
                  <!--if revision is "0" print model numbers only veraltet-->
                  <xsl:when test="$cleanProdRevNo = '0'">
                      <fo:block xsl:use-attribute-sets="__rm__ArtNr"><xsl:value-of select="//data[./@id[contains(., '_ArtNr')]]/ph"/>
                      </fo:block>
                  </xsl:when>
                  
                  <!--if revision is "1" print model numbers only-->
                  <xsl:when test="translate($cleanProdRevNo, ' ', '') = '1'">
                      <fo:block xsl:use-attribute-sets="__rm__ArtNr"><xsl:value-of select="//data[./@id[contains(., '_ArtNr')]]/ph"/>
                      </fo:block>   
                  </xsl:when>
                  
                  <!--all other situations print model numbers followed by revision as "MK x" statement-->
                  <xsl:otherwise>
                      <fo:block xsl:use-attribute-sets="__rm__ArtNr"><xsl:value-of select="//data[./@id[contains(., '_ArtNr')]]/ph"/>; (MK <xsl:value-of select="$cleanProdRevNo"/>)
                      </fo:block>
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:if>
          
          <!--Falls keine Revision verfügbar oder länger als ein Zeichen-->
          <xsl:if test="not(string-length($cleanProdRevNo)= 1)">
              <xsl:choose>
                  <!--if revision is not available print model numbers only-->
                  <xsl:when test="not(//data[./@id[contains(., '_Produktrevision')]]/ph)">
                      <fo:block xsl:use-attribute-sets="__rm__ArtNr"><xsl:value-of select="//data[./@id[contains(., '_ArtNr')]]/ph"/>
                      </fo:block>
                  </xsl:when>
                  
                  <!--Version Prefix 'V' if contains version separator '.' --> 
                  <xsl:when test="contains($cleanProdRevNo, '.')">
                      <fo:block xsl:use-attribute-sets="__rm__ArtNr"><xsl:value-of select="//data[./@id[contains(., '_ArtNr')]]/ph"/>; (V <xsl:value-of select="$cleanProdRevNo"/>)
                      </fo:block>
                  </xsl:when>
                  
                  <!--all other situations print model numbers followed by revision as "MK x" statement-->
                  <xsl:otherwise>
                      <fo:block xsl:use-attribute-sets="__rm__ArtNr"><xsl:value-of select="//data[./@id[contains(., '_ArtNr')]]/ph"/>; (MK <xsl:value-of select="$cleanProdRevNo"/>)
                      </fo:block>
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:if>
          <!--Rein Medical Edit End-->
        
        
      </fo:block-container></fo:block-container>
    <!-- set the subtitle -->
    <xsl:apply-templates select="$map//*[contains(@class, ' bookmap/booktitlealt ')]"/>
    <fo:block xsl:use-attribute-sets="__frontmatter__owner">
      <xsl:apply-templates select="$map//*[contains(@class, ' bookmap/bookmeta ')]"/>
    </fo:block>
    <!--Rein Medical Edit: Modellnummern unter Titel-->
    <!--<fo:block-container xsl:use-attribute-sets="__rm__ArtNr" >
      <fo:block><xsl:value-of select="//data[./@id[contains(.,'_ArtNr')]]/ph"/>
      </fo:block>
    </fo:block-container>-->
    <!--Rein Medical Edit: ENDE-->
    <!--Rein Medical Edit: Auto Sprachkennzeichnung-->
    <!--<fo:block-container xsl:use-attribute-sets="__rm__frontmatter__language" >
      <xsl:choose>
        <xsl:when test="contains(@xml:lang, 'en-gb')">
          <fo:block>
            [EN]  
          </fo:block>
        </xsl:when>
        
        <xsl:when test="contains(@xml:lang, 'de-de')">
          <fo:block>
            [DE]  
          </fo:block>
        </xsl:when>
        
        <xsl:when test="contains(@xml:lang, 'es-es')">
          <fo:block>
            [ES]
          </fo:block>
        </xsl:when>
        
        <xsl:when test="contains(@xml:lang, 'fr-fr')">
          <fo:block>
            [FR]
          </fo:block>
        </xsl:when>
        
        <xsl:when test="contains(@xml:lang, 'it-it')">
          <fo:block>
            [IT]
          </fo:block>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:message>REIN MEDICAL INFO: There is no language stamp defined for this language in front-matter.xsl </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block-container>-->--> <!--Rein Medical Edit: ENDE-->
    <!--Rein Medical Edit: Auto Revisionsdatum-->
    <!--<fo:block-container xsl:use-attribute-sets="__rm__revision__date" >
     
    <fo:block>DocRev: <xsl:value-of select="format-date(current-date(),'[Y]-[M]-[D]')"/>
    </fo:block> 
    </fo:block-container>-->
    <!--<fo:block-container xsl:use-attribute-sets="__rm__HandbArtNr" >
      
      <fo:block><xsl:value-of select="//data[./@id[contains(.,'HandbArtNr')]]/ph/text()"/>
      </fo:block> 
    </fo:block-container>-->
    <fo:block-container xsl:use-attribute-sets="__rm__Title_Credits">
     <!-- <xsl:variable name="rm_HandbArtNr" select=".//data[./@id[contains(., 'HandbArtNr')]]//text())"/>-->
      <fo:block><xsl:value-of select="string-join(.//data[./@id[contains(., 'DokArtNr')]]//text(), '')"/>
        <xsl:choose>
          <xsl:when test="contains(@xml:lang, 'en-gb')"> [EN] </xsl:when>
          <xsl:when test="contains(@xml:lang, 'de-de')"> [DE] </xsl:when>
          <xsl:when test="contains(@xml:lang, 'es-es')"> [ES] </xsl:when>
          <xsl:when test="contains(@xml:lang, 'fr-fr')"> [FR] </xsl:when>
          <xsl:when test="contains(@xml:lang, 'it-it')"> [IT] </xsl:when>
          <xsl:when test="contains(@xml:lang, 'ja-jp')"> [JA] </xsl:when>
          <xsl:when test="contains(@xml:lang, 'zh-cn')"> [ZH] </xsl:when>
          <xsl:otherwise>
            <xsl:message>REIN MEDICAL INFO: There is no language stamp defined for this language in front-matter.xsl </xsl:message>
          </xsl:otherwise>
        </xsl:choose> , Revision: <xsl:value-of select="format-date(current-date(), '[Y]-[M]-[D]')"/>
      </fo:block>
    </fo:block-container>
    <!--Rein Medical Edit: ENDE-->
  </xsl:template>

  <xsl:template name="createBackCover">
    <xsl:if test="$generate-back-cover">
      <fo:page-sequence master-reference="back-cover" xsl:use-attribute-sets="back-cover">
        <xsl:call-template name="insertBackCoverStaticContents"/>
        <fo:flow flow-name="xsl-region-body">
          <fo:block-container xsl:use-attribute-sets="__back-cover">
            <xsl:call-template name="createBackCoverContents"/>
          </fo:block-container>
        </fo:flow>
      </fo:page-sequence>
    </xsl:if>
  </xsl:template>

  <xsl:template name="createBackCoverContents">
    <fo:block/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' bookmap/bookmeta ')]" priority="1">
    <fo:block-container xsl:use-attribute-sets="__frontmatter__owner__container">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' bookmap/booktitlealt ')]" priority="2">
    <fo:block xsl:use-attribute-sets="__frontmatter__subtitle">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' bookmap/booktitle ')]" priority="2">
    <fo:block xsl:use-attribute-sets="__frontmatter__booklibrary">
      <xsl:apply-templates select="*[contains(@class, ' bookmap/booklibrary ')]"/>
    </fo:block>
    <fo:block xsl:use-attribute-sets="__frontmatter__mainbooktitle">
      <xsl:apply-templates select="*[contains(@class, ' bookmap/mainbooktitle ')]"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' xnal-d/namedetails ')]">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' xnal-d/addressdetails ')]">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' xnal-d/contactnumbers ')]">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' bookmap/bookowner ')]">
    <fo:block xsl:use-attribute-sets="author">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' bookmap/summary ')]">
    <fo:block xsl:use-attribute-sets="bookmap.summary">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
