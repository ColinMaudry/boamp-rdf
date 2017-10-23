<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE
   stylesheet
   [
      <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <!ENTITY xs "http://www.w3.org/2001/XMLSchema">
      <!ENTITY dct "http://purl.org/dc/terms/">
      <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
      <!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
      <!ENTITY attributions "https://boamp.maudry.com/attributions/">
      <!ENTITY appeloffres "https://boamp.maudry.com/appeloffres/">
      <!ENTITY annonces "https://boamp.maudry.com/annonces/">
      <!ENTITY acheteurs "https://boamp.maudry.com/acheteurs/">
      <!ENTITY titulaires "https://boamp.maudry.com/titulaires/">
      <!ENTITY descripteurs "https://boamp.maudry.com/descripteurs/">
      <!ENTITY boamp "https://data.maudry.com/voc/boamp#">
      <!ENTITY lots "https://boamp.maudry.com/lots/">
      <!ENTITY cpv "https://boamp.maudry.com/cpv/">
   ]
>
<xsl:stylesheet xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:attributions="https://boamp.maudry.com/attributions/"
    xmlns:appeloffres="https://boamp.maudry.com/appeloffres/"
    xmlns:annonces="https://boamp.maudry.com/annonces/"
    xmlns:acheteurs="https://boamp.maudry.com/acheteurs/"
    xmlns:titulaires="https://boamp.maudry.com/titulaires/"
    xmlns:descripteurs="https://boamp.maudry.com/descripteurs/"
    xmlns:b="https://data.maudry.com/voc/boamp#"
    xmlns:lots="https://boamp.maudry.com/lots/" xmlns:cpv="https://boamp.maudry.com/cpv/"
    version="2.0">
    
    <xsl:template match="TITRE_MARCHE">
        <b:titreMarche><xsl:value-of select="text()"/></b:titreMarche>
    </xsl:template>
    
    <xsl:template match="ELIGIBLE_MPS/non">
        <b:eligibleMps rdf:datatype="&xsd;boolean">false</b:eligibleMps>
    </xsl:template>
    
    <xsl:template match="ELIGIBLE_MPS/oui">
        <b:eligibleMps rdf:datatype="&xsd;boolean">true</b:eligibleMps>
    </xsl:template>
    
    <!-- Lots -->
    
    <xsl:template match="LOT">
        <b:lot>
            <b:Lot rdf:about="&lots;{$idAppelOffres}_{NUM/text()}">
                <b:appelOffres rdf:resource="&annonces;{$idAppelOffres}"/>
                <xsl:apply-templates/>
            </b:Lot>
        </b:lot>
    </xsl:template>
    
    <xsl:template match="VALEUR">
        <b:valeur rdf:parseType="Resource">
            <xsl:call-template name="valeur"/>
        </b:valeur>
    </xsl:template>
    
    <xsl:template match="OBJET/REF_MARCHE">
        <b:refMarche><xsl:value-of select="text()"/></b:refMarche>
    </xsl:template>
    
    <xsl:template match="LOT/DESCRIPTION">
        <b:description><xsl:value-of select="text()"/></b:description>
    </xsl:template>
    
    <xsl:template match="INTITULE">
        <b:intitule><xsl:value-of select="text()"/></b:intitule>
    </xsl:template>
</xsl:stylesheet>