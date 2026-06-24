<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:kitodo="http://meta.kitodo.org/v1/"
                exclude-result-prefixes="kitodo">
    <xsl:output method="xml"
                indent="yes"
                encoding="utf-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:template name="dmdSec" match="//kitodo:kitodo">

        <xsl:variable name="signatur" select="normalize-space(//kitodo:metadata[@name='Signatur'])"/>
        <!-- 0501_1: Unbewegtes Bild -->
        <xsl:variable name="p0501_1" select="normalize-space(//kitodo:metadata[@name='0501_1'])"/>
        <!-- 0501_2: Text vorhanden -->
        <xsl:variable name="p0501_2" select="normalize-space(//kitodo:metadata[@name='0501_2'][text()='true'])"/>
        <!-- 0502: Medientyp -->
        <xsl:variable name="p0502" select="normalize-space(//kitodo:metadata[@name='0502'])"/>
        <!-- 0503: Datenträgertyp -->
        <xsl:variable name="p0503" select="normalize-space(//kitodo:metadata[@name='0503'])"/>
        <!-- 0599_3: Rückseite bedruckt -->
        <xsl:variable name="p0599_3" select="normalize-space(//kitodo:metadata[@name='0599_3'][text()='true'])"/>

        <!-- 1100_1_1: Entstehungsdatum oder Beginn eines Entstehungszeitraums - Jahr -->
        <xsl:variable name="p1100_1_1" select="normalize-space(//kitodo:metadata[@name='1100_1_1'])"/>
        <!-- 1100_1_2: Entstehungsdatum oder Beginn eines Entstehungszeitraums - ca. -->
        <xsl:variable name="p1100_1_2" select="normalize-space(//kitodo:metadata[@name='1100_1_2'])"/>
        <!-- 1100_1_3: Entstehungsdatum oder Beginn eines Entstehungszeitraums - vor -->
        <xsl:variable name="p1100_1_3" select="normalize-space(//kitodo:metadata[@name='1100_1_3'])"/>
        <!-- 1100_1_4: Entstehungsdatum oder Beginn eines Entstehungszeitraums - nach -->
        <xsl:variable name="p1100_1_4" select="normalize-space(//kitodo:metadata[@name='1100_1_4'])"/>
        <!-- 1100_2: Ende eines Entstehungszeitraums - Jahr -->
        <xsl:variable name="p1100_2_1" select="normalize-space(//kitodo:metadata[@name='1100_2_1'])"/>
        <!-- 1101: Materialspezifische Codes -->
        <xsl:variable name="p1101" select="normalize-space(//kitodo:metadata[@name='1101'])"/>
        <!-- 1108: Copyrightjahr -->
        <xsl:variable name="p1108" select="normalize-space(//kitodo:metadata[@name='1108'])"/>
        <!-- 1109: Erscheinungsdatum Reproduktion -->
        <xsl:variable name="p1109" select="normalize-space(//kitodo:metadata[@name='1109'])"/>
        <!-- 1131: Inhalt -->
        <xsl:variable name="p1131" select="normalize-space(//kitodo:metadata[@name='1131'])"/>
        <!-- 1140: Veröffentlichungsart -->
        <xsl:variable name="p1140" select="normalize-space(//kitodo:metadata[@name='1140'])"/>
        <!-- 1500: Sprache (ohne "normalize-space", weil dieser Selektor eine Liste zurückgeben kann! (maxOccurs > 1 in Regelsatz!)) -->
        <xsl:variable name="p1500" select="//kitodo:metadata[@name='1500']"/>
        <!-- 1700: Erscheinungsland -->
        <xsl:variable name="p1700" select="normalize-space(//kitodo:metadata[@name='1700'])"/>

        <!-- 2050: URN -->
        <xsl:variable name="p2050" select="normalize-space(//kitodo:metadata[@name='2050'])"/>
        <!-- 2230: Nummer (allgemein) - maxOccurs='3' -->
        <xsl:variable name="p2230" select="kitodo:metadata[@name='2230']"/>
        <!-- 2230_1: Bestellnummer -->
        <xsl:variable name="p2230_1" select="normalize-space(kitodo:metadata[@name='2230_1'])"/>
        <!-- 2230_2: Lizenznummer -->
        <xsl:variable name="p2230_2" select="normalize-space(kitodo:metadata[@name='2230_2'])"/>
        <!-- 2230_3: Sonstige Nummer -->
        <xsl:variable name="p2230_3" select="normalize-space(kitodo:metadata[@name='2230_3'])"/>

        <!-- 3260: Abweichende Titelsucheinstiege -->
        <xsl:variable name="p3260" select="//kitodo:metadata[@name='3260']"/>

        <!-- 4000: Titel -->
        <!-- siehe unten -->
        <!-- 4002: Paralleltitel -->
        <xsl:variable name="p4002" select="//kitodo:metadata[@name='4002']"/>
        <!-- 4020: Ausgabevermerk-->
        <xsl:variable name="p4020" select="normalize-space(//kitodo:metadata[@name='4020'])"/>
        <!-- 4030: Erscheinungsort und Verlag -->
        <xsl:variable name="p4030" select="normalize-space(//kitodo:metadataGroup[@name='4030'])"/>
        <!-- 4048: Erscheinungsort und Verlag -->
        <xsl:variable name="p4048" select="normalize-space(//kitodo:metadata[@name='4048'])"/>


        <!-- 4060: Umfang -->
        <xsl:variable name="p4060" select="normalize-space(//kitodo:metadata[@name='4060'])"/>
        <!-- 4061: Farbe -->
        <xsl:variable name="p4061" select="normalize-space(//kitodo:metadata[@name='4061'])"/>
        <!-- 4062: Format -->
        <xsl:variable name="p4062" select="normalize-space(//kitodo:metadata[@name='4062'])"/>

        <!-- 4110: Gesamttitel der Reproduktion -->
        <xsl:variable name="p4110" select="normalize-space(//kitodo:metadata[@name='4110'])"/>
        <!-- 4120: Verknüpfung zum Gesamttitel der Reproduktion -->
        <xsl:variable name="p4120" select="normalize-space(//kitodo:metadata[@name='4120'])"/>

        <!-- 4207: Inhaltliche Zusammenfassung -->
        <xsl:variable name="p4207" select="normalize-space(//kitodo:metadata[@name='4207'])"/>
        <!-- 4212: Abweichender Titel -->
        <xsl:variable name="p4212" select="normalize-space(//kitodo:metadata[@name='4212'])"/>
        <!-- 4233: Last Copy -->
        <xsl:variable name="p4233" select="normalize-space(//kitodo:metadata[@name='4233'])"/>
        <!-- 4238: Reproduktionshinweis -->
        <xsl:variable name="p4238" select="normalize-space(//kitodo:metadata[@name='4238'])"/>

        <!-- 4801: Exemplarbezogener Kommentar -->
        <xsl:variable name="p4801" select="normalize-space(//kitodo:metadata[@name='4801'])"/>
        <!-- 4950: URL -->
        <xsl:variable name="p4950" select="normalize-space(//kitodo:metadata[@name='4950'])"/>

        <!-- TODO: 5580: Schlagworte -->

        <!-- 7100 Bibliothekssiegel und Fernleihcode -->
        <xsl:variable name="p7100" select="normalize-space(//kitodo:metadata[@name='7100'])"/>
        <!-- 7133 Zugriff Online-Ressource -->
        <xsl:variable name="p7133" select="normalize-space(//kitodo:metadata[@name='7133'])"/>

        <!-- 8012: Abrufzeichen -->
        <xsl:variable name="p8012" select="normalize-space(//kitodo:metadata[@name='8012'])"/>

        <!-- 9100: Provienzangabe -->
        <xsl:variable name="p9100" select="normalize-space(//kitodo:metadata[@name='9100'])"/>

        <collection xmlns="http://www.loc.gov/MARC21/slim"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <record>
                <!-- Derzeit statischer Leader für "Plakate"; ggf. in Zukunft anpassen -->
                <leader>00000ckm a2200000 c 4500</leader>
                <!-- Derzeit wird "Signatur" als ID verwendet -->
                <controlfield tag="001"><xsl:value-of select="$signatur"/></controlfield>
                <controlfield tag="003">DE-627</controlfield>
                <!-- TODO: Entscheidungen abwarten und dann später nachliefern -->
                <!-- controlfield tag="005">20241127215432.0</controlfield -->
                <!-- Derzeit statischer Wert für "Plakate"; ggf. in Zukunft anpassen -->
                <controlfield tag="007"><xsl:value-of select="$p1101"/></controlfield>
                <xsl:variable name="cf008template" select="'[6dateEnteredOnFile][1publicationStatus][4date1][3publicationPlace] |||||o     00| ||[3language][1modifiedRecord][1catalogingSource]'"/>
                <xsl:variable name="update_1_publicationStatus_Added" select="replace($cf008template, '\[1publicationStatus\]', 's')"/>
                <xsl:variable name="update_2_date_Added" select="replace($update_1_publicationStatus_Added, '\[4date1\]', $p1100_1_1)"/>
                <xsl:variable name="update_3_modifiedRecord_Added" select="replace($update_2_date_Added, '\[1modifiedRecord\]', ' ')"/>
                <xsl:variable name="update_4_catalogingSource_Added" select="replace($update_3_modifiedRecord_Added, '\[1catalogingSource\]', 'c')"/>
                <xsl:variable name="update_5_publicationPlace_Added" select="replace($update_4_catalogingSource_Added, '\[3publicationPlace\]', lower-case(substring-after($p1700, '-')))"/>
                <xsl:variable name="update_6_dateEnteredOnFile_Added" select="replace($update_5_publicationPlace_Added, '\[6dateEnteredOnFile\]', '||||||')"/>

                <!-- create controlfield 008 depending on existence of language (1500) with default value or not -->
                <xsl:choose>
                    <xsl:when test="count($p1500)=0">
                        <!-- if no language is included in metadata, set "und" for "undefined" instead -->
                        <controlfield tag="008"><xsl:value-of select="replace($update_6_dateEnteredOnFile_Added, '\[3language\]', 'und')"/></controlfield>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- if at least one language is included in metadata, add it to the controlfield value here -->
                        <controlfield tag="008"><xsl:value-of select="replace($update_6_dateEnteredOnFile_Added, '\[3language\]', $p1500[1])"/></controlfield>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- Example: -->
                <!--controlfield tag="008">140408s2013    gw |||||o     00| ||eng c</controlfield-->

                <!-- 28: Nummer (allgemein) -->
                <xsl:if test="$p2230">
                    <xsl:for-each select="$p2230">
                        <datafield tag="028" ind1="5" ind2="2">
                            <subfield code="a">Nummer: <xsl:value-of select="normalize-space(.)"/></subfield>
                        </datafield>
                    </xsl:for-each>
                </xsl:if>
                <!-- 028: Bestellnummer -->
                <xsl:if test="$p2230_1">
                    <datafield tag="028" ind1="5" ind2="2">
                        <subfield code="a">Bestellnummer: <xsl:value-of select="$p2230_1"/></subfield>
                    </datafield>
                </xsl:if>
                <!-- 028: Lizenznummer -->
                <xsl:if test="$p2230_2">
                    <datafield tag="028" ind1="5" ind2="2">
                        <subfield code="a">Lizenznummer: <xsl:value-of select="$p2230_2"/></subfield>
                    </datafield>
                </xsl:if>
                <!-- 028: Sonstige Nummer -->
                <xsl:if test="$p2230_3">
                    <datafield tag="028" ind1="5" ind2="2">
                        <subfield code="a">Sonstige Nummer: <xsl:value-of select="$p2230_3"/></subfield>
                    </datafield>
                </xsl:if>

                <!-- 041: Sprache -->
                <xsl:if test="$p1500">
                    <xsl:for-each select="$p1500">
                        <datafield tag="041" ind1=" " ind2=" ">
                            <subfield code="a"><xsl:value-of select="normalize-space(.)"/></subfield>
                        </datafield>
                    </xsl:for-each>
                </xsl:if>

                <!-- 044: Erscheinungsland -->
                <xsl:if test="$p1700">
                    <datafield tag="044" ind1=" " ind2=" ">
                        <subfield code="c"><xsl:value-of select="$p1700"/></subfield>
                    </datafield>
                </xsl:if>

                <!-- 245: Titel -->
                <!-- "4000" darf nur einmal vorkommen; "for-each" wird verwendet, um mit MetadataGroup und enthaltenen Elementen korrekt umzugehen -->
                <xsl:for-each select="//kitodo:metadataGroup[@name='4000']">
                    <datafield tag="245" ind1="0" ind2="0">
                        <xsl:variable name="haupttitel" select="normalize-space(kitodo:metadata[@name='4000_1'])"/>
                        <xsl:if test="$haupttitel">
                            <subfield code="a"><xsl:value-of select="$haupttitel"/></subfield>
                            <!--subfield code="p"><xsl:value-of select="$haupttitel"/></subfield-->
                        </xsl:if>
                        <xsl:variable name="titelzusatz" select="string-join((kitodo:metadata[@name='4000_2'])[normalize-space() != ''], ' : ')"/>
                        <xsl:variable name="titelinanderensprachen" select="string-join(($p4002)[normalize-space() != ''], ' = ')"/>
                        <xsl:if test="$titelzusatz">
                            <xsl:choose>
                                <xsl:when test="$titelinanderensprachen">
                                    <subfield code="b"><xsl:value-of select="$titelzusatz"/> = <xsl:value-of select="$titelinanderensprachen"/></subfield>
                                </xsl:when>
                                <xsl:otherwise>
                                    <subfield code="b"><xsl:value-of select="$titelzusatz"/></subfield>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <!-- Subfield 'p' Export zu K10+ nicht benötigt -->
                        <!--subfield code="p"><xsl:value-of select="$titelzusatz"/></subfield-->
                    </datafield>
                </xsl:for-each>

                <!-- 246: Abweichende Titelsucheinstiege / Paralleltitel -->
                <xsl:for-each select="$p4002">
                    <datafield tag="246" ind1="3" ind2="1">
                        <subfield code="a"><xsl:value-of select="normalize-space(.)"/></subfield>
                    </datafield>
                </xsl:for-each>

                <xsl:if test="$p3260">
                    <xsl:for-each select="$p3260">
                        <xsl:variable name="abweichender_titelzusatz" select="normalize-space(.)"/>
                        <xsl:if test="$abweichender_titelzusatz!=''">
                            <datafield tag="246" ind1="3" ind2="3">
                                <subfield code="a"><xsl:value-of select="$abweichender_titelzusatz"/></subfield>
                            </datafield>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>

                <xsl:if test="$p4212">
                    <datafield tag="246" ind1="1" ind2=" ">
                        <subfield code="i">Abweichender Titel</subfield>
                        <subfield code="a"><xsl:value-of select="$p4212"/></subfield>
                    </datafield>
                </xsl:if>

                <!-- 250: Ausgabevermerk -->
                <xsl:if test="$p4020">
                    <datafield tag="250" ind1=" " ind2=" ">
                        <subfield code="a"><xsl:value-of select="$p4020"/></subfield>
                    </datafield>
                </xsl:if>

                <!-- 264: Veröffentlichungsangabe -->
                <xsl:if test="$p1108 or $p1100_1_1 or $p4030">
                    <datafield tag="264" ind1=" " ind2="1">
                        <!-- Erscheinungsdatum Reproduktion -->
                        <xsl:if test="$p1108">
                            <subfield code="c">©<xsl:value-of select="substring-after($p1108, '$n')"/></subfield>
                        </xsl:if>
                        <!-- Erscheinungsort und Verlag -->
                        <xsl:for-each select="//kitodo:metadataGroup[@name='4030']">
                            <!-- Verlagsort -->
                            <xsl:variable name="verlagsorte" select="kitodo:metadata[@name='4030_1' and normalize-space(text())!='']"/>
                            <xsl:choose>
                                <xsl:when test="count($verlagsorte)>0">
                                    <xsl:for-each select="$verlagsorte">
                                        <subfield code="a"><xsl:value-of select="."/></subfield>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <subfield code="a">[Ort nicht ermittelbar]</subfield>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- Verlag -->
                            <xsl:variable name="verlage" select="kitodo:metadata[@name='4030_2' and normalize-space(text())!='']"/>
                            <xsl:choose>
                                <xsl:when test="count($verlage)>0">
                                    <!-- (aktuell darf "4030_2" nur einmal als Unterfeld von "4030" vorkommen; eine Schleife zu verwenden ist aber zukunftsicherer und stabiler -->
                                    <xsl:for-each select="$verlage">
                                        <subfield code="b"><xsl:value-of select="."/></subfield>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <subfield code="b">[Verlag nicht ermittelbar]</subfield>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        <!-- Entstehungszeitraum -->
                        <xsl:if test="$p1100_1_1">
                            <xsl:choose>
                                <!-- "[zwischen 1980 und 1985]" -->
                                <xsl:when test="$p1100_2_1">
                                    <subfield code="c"><xsl:value-of select="concat('[zwischen ', $p1100_1_1, ' und ', $p1100_2_1, ']')"/></subfield>
                                </xsl:when>
                                <!-- "[nach 1980]" -->
                                <xsl:when test="$p1100_1_4='true'">
                                    <subfield code="c"><xsl:value-of select="concat('[nach ', $p1100_1_1, ']')"/></subfield>
                                </xsl:when>
                                <!-- "[vor 1980]"-->
                                <xsl:when test="$p1100_1_3='true'">
                                    <subfield code="c"><xsl:value-of select="concat('[vor ', $p1100_1_1, ']')"/></subfield>
                                </xsl:when>
                                <!-- "[ca. 1980]"-->
                                <xsl:when test="$p1100_1_2='true'">
                                    <subfield code="c"><xsl:value-of select="concat('[ca. ', $p1100_1_1, ']')"/></subfield>
                                </xsl:when>
                                <!-- "1980"-->
                                <xsl:otherwise>
                                    <subfield code="c"><xsl:value-of select="$p1100_1_1"/></subfield>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </datafield>
                </xsl:if>

                <!-- 264: Herstellungsangabe - in Kampagne p001 nicht aktiv! -->
                <xsl:for-each select="//kitodo:metadataGroup[@name='4045']">
                    <datafield tag="264" ind1=" " ind2="1">
                        <!-- Herstellungsort -->
                        <xsl:variable name="herstellungsorte" select="kitodo:metadata[@name='4045_1' and normalize-space(text())!='']"/>
                        <xsl:choose>
                            <xsl:when test="count($herstellungsorte)>0">
                                <!-- (aktuell darf "4045_1" nur einmal als Unterfeld von "4045" vorkommen; eine Schleife zu verwenden ist aber zukunftsicherer und stabiler -->
                                <xsl:for-each select="$herstellungsorte">
                                    <subfield code="a"><xsl:value-of select="."/></subfield>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <subfield code="a">[Herstellungsort nicht ermittelbar]</subfield>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- Hersteller -->
                        <xsl:variable name="hersteller" select="kitodo:metadata[@name='4045_2' and normalize-space(text())!='']"/>
                        <xsl:choose>
                            <xsl:when test="count($hersteller)>0">
                                <!-- (aktuell darf "4045_2" nur einmal als Unterfeld von "4045" vorkommen; eine Schleife zu verwenden ist aber zukunftsicherer und stabiler -->
                                <xsl:for-each select="$hersteller">
                                    <subfield code="b"><xsl:value-of select="."/></subfield>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <subfield code="b">[Hersteller nicht ermittelbar]</subfield>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- TODO: Herstellungszeit/-zeitraum abbilden - Frage: aus welchem Pica-/Internformat-Feld ableiten? -->
                    </datafield>
                </xsl:for-each>

                <!-- 300: Umfang / Farbe / Format -->
                <xsl:if test="$p4060 or $p4061 or $p4062">
                    <datafield tag="300" ind1=" " ind2=" ">
                        <xsl:if test="$p4060">
                            <subfield code="a"><xsl:value-of select="$p4060"/> </subfield>
                        </xsl:if>
                        <xsl:if test="$p4061">
                            <xsl:choose>
                                <xsl:when test="$p4061='true'">
                                    <subfield code="b">farbig</subfield>
                                </xsl:when>
                                <xsl:otherwise>
                                    <subfield code="b">schwarz-weiß</subfield>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$p4062">
                            <subfield code="c"><xsl:value-of select="$p4062"/> </subfield>
                        </xsl:if>
                    </datafield>
                </xsl:if>

                <!-- 336: Inhaltstyp: Text vorhanden? -->
                <xsl:choose>
                    <xsl:when  test="$p0501_1">
                        <datafield tag="336" ind1=" " ind2=" ">
                            <subfield code="a"><xsl:value-of select="substring-before($p0501_1, '$b')"/></subfield>
                            <subfield code="b"><xsl:value-of select="substring-after($p0501_1, '$b')"/></subfield>
                            <subfield code="2">rdacontent</subfield>
                        </datafield>
                    </xsl:when>
                    <!-- Der folgende Fall ist für Plakate notwendig, die vor der letzten Aktualisierung des Regelsatzes
                         erstellt wurden und deswegen das Regelsatz-Feld "0501_1" mit dem statischen Inhalt
                         "unbewegtes Bild$bsti" noch nicht enthielten, beim MarcXML-Export aber trotzdem das
                         entsprechende Feld Marc-Feld "336" bekommen müssen (Bedingung kann entfernt bzw. "choose" in
                         ein einfaches "if" geändert werden, wenn keine Plakate mehr im System sind, die auf der alten
                         Version des Regelsatz basieren - stört aber auch nicht, wenn es drin bleibt)-->
                    <xsl:otherwise>
                        <datafield tag="336" ind1=" " ind2=" ">
                            <subfield code="a">unbewegtes Bild</subfield>
                            <subfield code="b">sti</subfield>
                            <subfield code="2">rdacontent</subfield>
                        </datafield>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="$p0501_2">
                    <datafield tag="336" ind1=" " ind2=" ">
                        <subfield code="a">Text</subfield>
                        <subfield code="b">txt</subfield>
                        <subfield code="2">rdacontent</subfield>
                    </datafield>
                </xsl:if>

                <!-- 337: Medientyp -->
                <xsl:if test="$p0502">
                    <datafield tag="337" ind1=" " ind2=" ">
                        <subfield code="a"><xsl:value-of select="substring-before($p0502, '$b')"/></subfield>
                        <subfield code="b"><xsl:value-of select="substring-after($p0502, '$b')"/></subfield>
                        <subfield code="2">rdamedia</subfield>
                    </datafield>
                </xsl:if>

                <!-- 338: Datenträgertyp -->
                <xsl:if test="$p0503">
                    <datafield tag="338" ind1=" " ind2=" ">
                        <subfield code="a"><xsl:value-of select="substring-before($p0503, '$b')"/></subfield>
                        <subfield code="b"><xsl:value-of select="substring-after($p0503, '$b')"/></subfield>
                        <subfield code="2">rdacarrier</subfield>
                    </datafield>
                </xsl:if>

                <!-- 361: Provienzangabe -->
                <xsl:if test="$p9100">
                    <datafield tag="361" ind1="1" ind2=" ">
                        <subfield code="a">Hill, Thomas</subfield>
                        <subfield code="o">Vorbesitz</subfield>
                        <subfield code="0">(DE-588)1309275327</subfield>
                        <subfield code="0">(DE-627)1869944577</subfield>
                        <xsl:if test="$signatur">
                            <subfield code="s"><xsl:value-of select="$signatur"/></subfield>
                        </xsl:if>
                        <xsl:for-each select="tokenize($p9100, '\$')">
                            <xsl:choose>
                                <xsl:when test="position()=1">
                                    <subfield code="5"><xsl:value-of select="normalize-space(.)"/></subfield>
                                </xsl:when>
                                <!-- Subfield 'y' Export zu K10+ nicht benötigt -->
                                <!--xsl:when test="starts-with(., '2')">
                                    <subfield code="y"><xsl:value-of select="substring(normalize-space(.), 2)"/></subfield>
                                </xsl:when-->
                                <xsl:when test="starts-with(., 'b')">
                                    <subfield code="f"><xsl:value-of select="substring(normalize-space(.), 2)"/></subfield>
                                </xsl:when>
                                <xsl:when test="starts-with(., 'k')">
                                    <subfield code="z"><xsl:value-of select="substring(normalize-space(.), 2)"/></subfield>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </datafield>
                </xsl:if>

                <!-- 500: interne Anmerkungen (aus 4201) werden nicht nach MarcXML für K10+ exportiert -->
                
                <!-- 520: Inhaltliche Zusammenfassung -->
                <xsl:if test="$p4207">
                    <datafield tag="520" ind1=" " ind2=" ">
                        <subfield code="a">Bildbeschreibung in Stichworten: <xsl:value-of select="$p4207"/></subfield>
                    </datafield>
                </xsl:if>

                <!-- 533: Ausgabevermerk der Reproduktion / Umfang der Reproduktion -->
                <!-- Marc-Feld 533 wird von Pica3-Feld 4238 samt Unterfeldern befüllt -->
                <xsl:if test="$p4110 or $p4238">
                    <datafield tag="533" ind1=" " ind2=" ">
                        <xsl:if test="$p4238">
                            <xsl:for-each select="tokenize($p4238, '\$')">
                                <xsl:if test="normalize-space(.)">
                                    <xsl:choose>
                                        <xsl:when test="position()=1">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">a</xsl:attribute>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:variable name="code" select="substring(., 1, 1)"/>
                                            <xsl:variable name="value" select="substring(., 2)"/>
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code"><xsl:value-of select="$code"/></xsl:attribute>
                                                <xsl:value-of select="$value"/>
                                            </xsl:element>
                                            <xsl:if test="$code='d'">
                                                <xsl:element name="subfield">
                                                    <xsl:attribute name="code">7</xsl:attribute>
                                                    <xsl:value-of select="$value"/>||||||||||</xsl:element>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="$p4110">
                            <subfield code="f"><xsl:value-of select="string-join(tokenize($p4110, '\$p')[normalize-space() != ''], '. ')"/></subfield>
                        </xsl:if>
                    </datafield>
                </xsl:if>
                
                <!-- 583: LastCopy / Auftraggeber Digitalisierung -->
                <xsl:if test="$p4233">
                    <datafield tag="583" ind1=" " ind2=" ">
                        <xsl:if test="$p4233">
                            <xsl:for-each select="tokenize($p4233, '\$')">
                                <xsl:if test="normalize-space(.)">
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code"><xsl:value-of select="substring(., 1, 1)"/></xsl:attribute>
                                        <xsl:value-of select="substring(., 2)"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                    </datafield>
                </xsl:if>

                <!-- 599: Selektionscode -->

                <!-- 648: Zeitschlagwort - Start -->
                <xsl:for-each select="kitodo:metadataGroup[@name='5520_1']">
                    <xsl:variable name="day" select="normalize-space(kitodo:metadata[@name='5520_1_1'])"/>
                    <xsl:variable name="month" select="normalize-space(kitodo:metadata[@name='5520_1_2'])"/>
                    <xsl:variable name="year" select="normalize-space(kitodo:metadata[@name='5520_1_3'])"/>
                    <!-- "Jahr" muss mindestens gegeben sein -->
                    <xsl:if test="$year!=''">
                        <datafield tag="648" ind1=" " ind2="4">
                            <xsl:choose>
                                <!-- e.g. 19.07.2008 -->
                                <xsl:when test="$day!='' and $month!=''">
                                    <subfield code="a"><xsl:value-of select="$day"/>.<xsl:value-of select="$month"/>.<xsl:value-of select="$year"/></subfield>
                                </xsl:when>
                                <!-- e.g. 07.2008 -->
                                <xsl:when test="$month!=''">
                                    <subfield code="a"><xsl:value-of select="$month"/>.<xsl:value-of select="$year"/></subfield>
                                </xsl:when>
                                <!-- e.g. 2008 -->
                                <xsl:otherwise>
                                    <subfield code="a"><xsl:value-of select="$year"/></subfield>
                                </xsl:otherwise>
                            </xsl:choose>
                            <subfield code="2">gnd</subfield>
                        </datafield>
                    </xsl:if>
                </xsl:for-each>

                <!-- 650: Sachschlagwort (NOTE: im Augenblick wird nicht zwischen Sach-, Personen-,
                          Organisations- und Geo-Schlagwörtern (ursprünglich 651) unterschieden, weil alle Felder aus
                          Pica 5580 (bzw. 5581 für Veranstaltungsort) importiert und hier nicht unterschieden werden
                          können und in der Verbundszentrale letztendlich wieder in Pica als Bearbeitungsformat resultieren -->
                <xsl:for-each select="kitodo:metadataGroup[@name='5580' or @name='5581']">
                    <datafield tag="650" ind1=" " ind2="7">
                        <xsl:variable name="gndnummer" select="kitodo:metadata[@name='5580_2' or @name='5581_2']"/>
                        <xsl:if test="normalize-space($gndnummer)">
                            <subfield code="0">(DE-588)<xsl:value-of select="normalize-space($gndnummer)"/></subfield>
                        </xsl:if>
                        <subfield code="2">gnd</subfield>
                        <xsl:variable name="thema" select="kitodo:metadata[@name='5580_1' or @name='5581_1']"/>
                        <xsl:if test="normalize-space($thema)">
                            <subfield code="a"><xsl:value-of select="normalize-space($thema)"/></subfield>
                        </xsl:if>
                    </datafield>
                </xsl:for-each>

                <!-- 655: Inhalt -->
                <xsl:if test="$p1131">
                    <datafield tag="655" ind1=" " ind2="7">
                        <!-- TODO: in Zukunft muss dieses Subfield vermutlich dynamisch befüllt werden -->
                        <subfield code="a">Plakat</subfield>
                        <subfield code="0">(DE-588)4046198-1</subfield>
                        <subfield code="0">(DE-627)<xsl:value-of select="replace($p1131, '!', '')"/></subfield>
                        <subfield code="0">(DE-576)209068558</subfield>
                        <subfield code="2">gnd-content</subfield>
                    </datafield>
                </xsl:if>
                
                <!-- 700: Person -->
                <xsl:for-each select="//kitodo:metadataGroup[@name='3010']">
                    <datafield tag="700" ind1="1" ind2=" ">
                        <!-- 3010_1: "Nachname, Vorname" -->
                        <xsl:if test="kitodo:metadata[@name='3010_1']">
                            <subfield code="a"><xsl:value-of select="normalize-space(kitodo:metadata[@name='3010_1'])"/></subfield>
                        </xsl:if>
                        <!-- 3010_2: "GND-Nummer" -->
                        <xsl:variable name="gnd_nummer" select="normalize-space(kitodo:metadata[@name='3010_2'])"/>
                        <xsl:if test="$gnd_nummer">
                            <subfield code="0"><xsl:value-of select="concat('(DE-588)', $gnd_nummer)"/></subfield>
                        </xsl:if>
                        <!-- 3010_3: "Rolle" -->
                        <xsl:variable name="rolecode" select="normalize-space(kitodo:metadata[@name='3010_3'])"/>
                        <xsl:choose>
                            <xsl:when test="$rolecode">
                                <xsl:choose>
                                    <xsl:when test="$rolecode = 'art'">
                                        <subfield code="e">KünstlerIn</subfield>
                                    </xsl:when>
                                    <xsl:when test="$rolecode = 'au'">
                                        <subfield code="e">VerfasserIn</subfield>
                                    </xsl:when>
                                    <xsl:when test="$rolecode = 'edt'">
                                        <subfield code="e">Herausgebende Person</subfield>
                                    </xsl:when>
                                    <xsl:when test="$rolecode = 'pht'">
                                        <subfield code="e">FotografIn</subfield>
                                    </xsl:when>
                                    <xsl:when test="$rolecode = 'dsr'">
                                        <subfield code="e">DesignerIn</subfield>
                                    </xsl:when>
                                    <xsl:when test="$rolecode = 'wst'">
                                        <subfield code="e">VerfasserIn von ergänzendem Text</subfield>
                                    </xsl:when>
                                    <xsl:when test="$rolecode = 'trl'">
                                        <subfield code="e">ÜbersetzerIn</subfield>
                                    </xsl:when>
                                    <xsl:when test="$rolecode = 'ctb'">
                                        <subfield code="e">MitwirkendeR</subfield>
                                    </xsl:when>
                                    <xsl:when test="$rolecode = 'oth'">
                                        <subfield code="e">Sonstige Person, Familie oder Körperschaft</subfield>
                                    </xsl:when>
                                </xsl:choose>
                                <subfield code="4"><xsl:value-of select="$rolecode"/></subfield>
                            </xsl:when>
                            <xsl:otherwise>
                                <subfield code="e">Sonstige Person, Familie und Körperschaft</subfield>
                                <subfield code="4">oth</subfield>
                            </xsl:otherwise>
                        </xsl:choose>
                    </datafield>
                </xsl:for-each>
                
                <!-- 710: Organisation -->
                <xsl:for-each select="//kitodo:metadataGroup[@name='3110']">
                    <xsl:variable name="name" select="normalize-space(kitodo:metadata[@name='3110_1'])"/>
                    <xsl:variable name="ppn" select="normalize-space(kitodo:metadata[@name='3110_2'])"/>
                    <xsl:variable name="code" select="normalize-space(kitodo:metadata[@name='3110_3'])"/>
                    <xsl:if test="$name or $code or $ppn">
                        <!-- 710 -->
                        <datafield tag="710" ind1="2" ind2=" ">
                            <xsl:if test="$name">
                                <subfield code="a"><xsl:value-of select="$name"/></subfield>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="$code">
                                    <xsl:choose>
                                        <xsl:when test="$code = 'isb'">
                                            <subfield code="e">Herausgebendes Organ</subfield>
                                        </xsl:when>
                                        <xsl:when test="$code = 'orm'">
                                            <subfield code="e">Veranstalter</subfield>
                                        </xsl:when>
                                        <xsl:when test="$code = 'dsr'">
                                            <subfield code="e">DesignerIn</subfield>
                                        </xsl:when>
                                        <xsl:when test="$code = 'oth'">
                                            <subfield code="e">Sonstige Person, Familie oder Körperschaft</subfield>
                                        </xsl:when>
                                    </xsl:choose>
                                    <subfield code="4"><xsl:value-of select="$code"/></subfield>
                                </xsl:when>
                                <xsl:otherwise>
                                    <subfield code="e">Sonstige Person, Familie und Körperschaft</subfield>
                                    <subfield code="4">oth</subfield>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="$ppn">
                                <subfield code="0"><xsl:value-of select="concat('(DE-588)', $ppn)"/></subfield>
                            </xsl:if>
                        </datafield>
                    </xsl:if>
                </xsl:for-each>

                <!-- 776: Verknüpfung zum Gesamttitel der Reproduktion -->
                <xsl:if test="$p4120 or $signatur or $p1109 or $p4110 or $p4048">
                    <datafield tag="776" ind1="1" ind2=" ">
                        <xsl:if test="$p4048">
                            <xsl:variable name="stadt" select="normalize-space(substring-before($p4048, '$n'))"/>
                            <xsl:variable name="organisation" select="normalize-space(substring-after($p4048, '$n'))"/>
                            <xsl:if test="$organisation">
                                <subfield code="n"><xsl:value-of select="$organisation"/></subfield>
                            </xsl:if>
                            <xsl:if test="$stadt">
                                <subfield code="g"><xsl:value-of select="$stadt"/></subfield>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="$p4110">
                            <xsl:variable name="p4110parts" select="tokenize($p4110, '\$p')"/>
                            <xsl:if test="count($p4110parts)>2">
                                <subfield code="t"><xsl:value-of select="$p4110parts[1]"/>. <xsl:value-of select="$p4110parts[2]"/></subfield>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="$p1109">
                            <subfield code="h"><xsl:value-of select="$p1109"/> </subfield>
                        </xsl:if>
                        <xsl:if test="$p4120">
                            <subfield code="w"><xsl:value-of select="replace(replace($p4120, '#\[Signatur\]#', '(DE-627)'), '!', '')"/></subfield>
                        </xsl:if>
                        <xsl:if test="$signatur">
                            <subfield code="9"><xsl:value-of select="$signatur"/></subfield>
                            <subfield code="g"><xsl:value-of select="$signatur"/></subfield>
                        </xsl:if>
                    </datafield>
                </xsl:if>

                <!-- 024: URN -->
                <xsl:if test="$p2050">
                    <datafield tag="024" ind1="7" ind2=" ">
                        <subfield code="a"><xsl:value-of select="$p2050"/></subfield>
                        <subfield code="2">urn</subfield>
                    </datafield>
                </xsl:if>

                <!-- 856: URL -->
                <xsl:if test="$p7133 and $p4950">
                    <datafield tag="856" ind1="4" ind2="0">
                        <subfield code="u"><xsl:value-of select="$p4950"/></subfield>
                        <xsl:variable name="subfield_values" select="tokenize($p7133, '\$')"/>
                        <xsl:choose>
                            <!-- Case 1: Field 7133 contains "D" and "LF" abbreviations -> map to marc subfields x and z -->
                            <xsl:when test="count($subfield_values)=3">
                                <!-- Skip first element only containing URL placeholder, e.g. "[URL] $xD$4LF" -> ["[URL] ", "xD", "4LF"] -->
                                <xsl:variable name="subfield_x" select="substring($subfield_values[2], 2)"/>
                                <xsl:variable name="subfield_z" select="substring($subfield_values[3], 2)"/>
                                <xsl:choose>
                                    <xsl:when test="$subfield_x='D'">
                                        <subfield code="x">Digitalisierung</subfield>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <subfield code="x"><xsl:value-of select="$subfield_x"/></subfield>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="$subfield_z='LF'">
                                        <subfield code="z">lizenzpflichtig</subfield>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <subfield code="z"><xsl:value-of select="$subfield_z"/></subfield>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Case 2: Field 7133 does _not_ contain "D" and "LF" -> set subfields x and z to static values -->
                                <subfield code="x">Digitalisierung</subfield>
                                <subfield code="z">lizenzpflichtig</subfield>
                            </xsl:otherwise>
                        </xsl:choose>
                    </datafield>
                </xsl:if>

                <!-- 924 -->
                <xsl:if test="$signatur and $p4801 or $p7100">
                    <datafield tag="924" ind1="1" ind2=" ">
                        <subfield code="j"><xsl:value-of select="replace($p4801, '\[SIGNATUR\]', $signatur)"/></subfield>
                        <xsl:if test="$p7100">
                            <xsl:variable name="subfield_values" select="tokenize($p7100, '\$')"/>
                            <xsl:if test="count($subfield_values)=3">
                                <!-- Skip empty element with index "1", which is just created because value of 7100 starts with a "$", e.g. "$B24$Jn" -> ["", "B24", "Jn"] -->
                                <subfield code="b"><xsl:value-of select="concat('DE-', substring($subfield_values[2], 2))"/></subfield>
                                <subfield code="d"><xsl:value-of select="substring($subfield_values[3], 2)"/></subfield>
                            </xsl:if>
                        </xsl:if>
                    </datafield>
                </xsl:if>

                <!-- 935: Veröffentlichungsart -->
                <xsl:if test="$p1140">
                    <datafield tag="935" ind1=" " ind2=" ">
                        <subfield code="c"><xsl:value-of select="$p1140"/></subfield>
                    </datafield>
                </xsl:if>

                <!-- 935: Abrufzeichen -->
                <xsl:if test="$p8012">
                    <xsl:variable name="subfield_values" select="tokenize($p8012, '\$')"/>
                    <datafield tag="935" ind1=" " ind2=" ">
                        <xsl:for-each select="$subfield_values">
                            <xsl:choose>
                                <xsl:when test="position()=1">
                                    <subfield code="a"><xsl:value-of select="normalize-space(.)"/></subfield>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- TODO: Kampagnen-Abrufzeichen (derzeit statisch 'p001') sollte in Zukunft ggf. aus einem anderen Feld ausgelesen werden -->
                                    <subfield code="a"><xsl:value-of select="replace(substring(., 2), '\[ABRUFZEICHENKAMPAGNE\]', 'p001')"/></subfield>
                                </xsl:otherwise>
                            </xsl:choose>

                        </xsl:for-each>
                    </datafield>
                    <datafield tag="935" ind1=" " ind2=" ">
                        <subfield code="h">SWB</subfield>
                        <subfield code="i">dm</subfield>
                    </datafield>
                    <datafield tag="935" ind1=" " ind2=" ">
                        <subfield code="h">SWB</subfield>
                        <subfield code="i">ld</subfield>
                    </datafield>
                </xsl:if>

                <!-- 935: SLoT -->
                <xsl:if test="$p0599_3">
                    <datafield tag="935" ind1=" " ind2=" ">
                        <subfield code="i">SLoT</subfield>
                    </datafield>
                </xsl:if>
            </record>
        </collection>
    </xsl:template>

    <!-- omit all text that is not specifically covered and mapped by a template -->
    <xsl:template match="text()"/>

</xsl:stylesheet>