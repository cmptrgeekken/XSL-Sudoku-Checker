<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="yes"/>
	<!-- Define newline for output. -->
	<xsl:param name="newline" select="'&#xA;'"/>
   <xsl:param name="puzzle" select="'puzzle.xml'"/>
   
	<xsl:key name="rows" match="c" use="count(preceding::r)"/>
	<xsl:key name="cols" match="c" use="count(preceding-sibling::c)"/>
	<xsl:key name="boxes" match="c" use="floor(count(preceding-sibling::c) div 3)+3*(floor(count(preceding::r) div 3))"/>

	<xsl:template match="sudoku">
		<!-- Check for duplicate entries in the rows -->
		<xsl:for-each select="//c[count(.| key('rows',count(preceding::r))[1]) = 1]">
			<xsl:for-each select="key('rows',count(preceding::r))">
				<xsl:sort select="."/>
            <xsl:if test="position() != ./text()">
               <xsl:text>duplicates in row </xsl:text>
               <xsl:value-of select="count(preceding::r)+1"/>
               <xsl:value-of select="$newline"/>
            </xsl:if>
			</xsl:for-each>
		</xsl:for-each>
		
		<!-- Check for duplicate entries in the columns -->
		<xsl:for-each select="//c[count(.| key('cols',count(preceding-sibling::c))[1]) = 1]">
			<xsl:for-each select="key('cols',count(preceding-sibling::c))">
				<xsl:sort select="."/>
            <xsl:if test="position() != ./text()">
               <xsl:text>duplicates in column </xsl:text>
               <xsl:value-of select="count(preceding-sibling::c)+1"/>
               <xsl:value-of select="$newline"/>
            </xsl:if>
			</xsl:for-each>
		</xsl:for-each>
      
      <!-- Check for duplicate entries in the boxes -->
		<xsl:for-each select="//c[count(.| key('boxes',floor(count(preceding-sibling::c) div 3)+3*(floor(count(preceding::r) div 3)))[1]) = 1]">
			<xsl:for-each select="key('boxes',floor(count(preceding-sibling::c) div 3)+3*(floor(count(preceding::r) div 3)))">
				<xsl:sort select="."/>
            <xsl:if test="position() != ./text()">
               <xsl:text>duplicates in box </xsl:text>
               <xsl:value-of select="floor(count(preceding-sibling::c) div 3)+3*(floor(count(preceding::r) div 3))+1"/>
               <xsl:value-of select="$newline"/>
            </xsl:if>
			</xsl:for-each>
		</xsl:for-each>
      
      <!-- Verify that the solution matches the original puzzle -->
      <xsl:if test="$puzzle">
         <xsl:for-each select="//r">
            <xsl:variable name="row" select="position()"/>
            <xsl:for-each select="c">
               <xsl:variable name="col" select="position()"/>
               <xsl:variable name="val" select="document($puzzle)//r[$row]/c[$col]/text()"/>
               <xsl:if test="$val and $val != text()">
                  <xsl:text>elements in row </xsl:text>
                  <xsl:value-of select="$row"/>
                  <xsl:text> column </xsl:text>
                  <xsl:value-of select="$col"/>
                  <xsl:text> differ: </xsl:text>
                  <xsl:value-of select="text()"/>
                  <xsl:text> vs. </xsl:text>
                  <xsl:value-of select="$val"/>
                  <xsl:value-of select="$newline"/>
               </xsl:if>               
            </xsl:for-each>
         </xsl:for-each>
      </xsl:if>
	</xsl:template>
	
</xsl:stylesheet>