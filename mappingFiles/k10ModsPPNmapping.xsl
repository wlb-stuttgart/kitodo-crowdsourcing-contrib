<?xml version="1.0" encoding="UTF-8" ?>
<!--
 *
 * (c) Kitodo. Key to digital objects e. V. <contact@kitodo.org>
 *
 * This file is part of the Kitodo project.
 *
 * It is licensed under GNU General Public License version 3 or later.
 *
 * For the full copyright and license information, please read the
 * GPL3-License.txt file that was distributed with this source code.
 *
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:kitodo="http://meta.kitodo.org/v1/"
                exclude-result-prefixes="mods xsi xs">

    <xsl:output method="xml" indent="yes" encoding="utf-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="mods:mods">
        <kitodo:kitodo>
            <xsl:for-each select="mods:recordInfo/mods:recordIdentifier[@source='DE-627']">
                <kitodo:metadata name="0100">
                    <xsl:value-of select="normalize-space()"/>
                </kitodo:metadata>
            </xsl:for-each>
        </kitodo:kitodo>
    </xsl:template>


    <!-- ### Ignore unmapped text ### -->
    <xsl:template match="text()"/>

    <!-- ### Ignore MODS schema location (as it is not required in the internal format) ### -->
    <xsl:template match="@xsi:schemaLocation"/>

    <!-- ### Ignore 'version' attribute of root element (as it is not required in the internal format) ### -->
    <xsl:template match="@version"/>

</xsl:stylesheet>
