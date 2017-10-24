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
    
    <xsl:template match="ATTRIBUTION">
      <xsl:apply-templates select="DECISION"/>  
    </xsl:template>
        
    <xsl:template match="DECISION">
        <b:attribution>
            <xsl:variable name="lotAttribution">
                <xsl:if test="NUM_LOT">
                    <xsl:value-of select="concat('_',NUM_LOT/text())"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="nbTitulaires" select="count(TITULAIRE)"/>
            <b:Attribution rdf:about="&attributions;{$idweb}{$lotAttribution}">
                <xsl:if test="not(TITULAIRE)">
                    <rdf:type rdf:resource="&boamp;NonAttribue"/>
                </xsl:if>
                <xsl:if test="string-length($idAppelOffres) > 0">
                    <b:appelOffres rdf:resource="&appeloffres;{$idAppelOffres}"/>
                </xsl:if>
                
                <xsl:apply-templates select="/ANNONCE/DONNEES/IDENTITE"/>
                
                <b:nbTitulaires rdf:datatype="&xsd;int"><xsl:value-of select="$nbTitulaires"/></b:nbTitulaires>
                <xsl:choose>
                    <xsl:when test="count(RENSEIGNEMENT) = 1">
                        <xsl:apply-templates select="NUM_LOT" mode="lien"/>
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="count(RENSEIGNEMENT) = 0">
                        <xsl:apply-templates select="NUM_LOT" mode="lien"/>
                        <xsl:apply-templates select="parent::ATTRIBUTION" mode="simpleDecision"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="RENSEIGNEMENT[1]"/>
                        <xsl:apply-templates select="*[not(local-name() = 'RENSEIGNEMENT')]"/>
                    </xsl:otherwise>
                </xsl:choose>
                                
            </b:Attribution>
        </b:attribution>
    </xsl:template>
    
    <xsl:template match="DECISION" mode="simpleDecision">
        <xsl:apply-templates mode="#default"/>
    </xsl:template>
    
    <xsl:template match="DECISION/INTITULE"/>
    
    <xsl:template match="NB_OFFRE_RECU">
        <b:nbOffresRecues rdf:datatype="http://www.w3.org/2001/XMLSchema#int">
            <xsl:value-of
                select="text()"/>
        </b:nbOffresRecues>
    </xsl:template>
    
    <xsl:template match="MARCHE/ANNONCE_ANTERIEUR/REFERENCE/IDWEB">        
        <b:annonceAnterieure>
            <b:Annonce rdf:about="&annonces;{text()}">
                <b:idweb>
                    <xsl:value-of select="text()"/>
                </b:idweb>
            </b:Annonce>
        </b:annonceAnterieure>
    </xsl:template>    
    
    <xsl:template match="VALEUR_TOTALE" mode="#default simpleDecision">
        <b:valeurTotale rdf:parseType="Resource">
            <xsl:call-template name="valeur"/>
        </b:valeurTotale>
    </xsl:template>
    
    <xsl:template match="MONTANT">
        <b:montant rdf:parseType="Resource">
            <xsl:call-template name="valeur"/>
        </b:montant>
    </xsl:template>
    
    <xsl:template match="MONTANT_MINI">
        <b:montantMini rdf:parseType="Resource">
            <xsl:call-template name="valeur"/>
        </b:montantMini>
    </xsl:template>
    
    <xsl:template match="MONTANT_MAXI">
        <b:montantMaxi rdf:parseType="Resource">
            <xsl:call-template name="valeur"/>
        </b:montantMaxi>
    </xsl:template>
    
    <xsl:template match="VALEUR_MIN">
        <b:valeurMin rdf:parseType="Resource">
            <xsl:call-template name="valeur"/>
        </b:valeurMin>
    </xsl:template>
    
    <xsl:template match="VALEUR_MAX">
        <b:valeurMax rdf:parseType="Resource">
            <xsl:call-template name="valeur"/>
        </b:valeurMax>
    </xsl:template>
    
    <xsl:template match="DATE_DECISION" mode="#default simpleDecision">
        <b:dateDecision rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="text()"/></b:dateDecision>
    </xsl:template>
    
    <xsl:template match="DATE_ATTRIBUTION">
        <b:dateAttribution rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="text()"/></b:dateAttribution>
    </xsl:template>
    
    <xsl:template match="NUM_LOT" mode="lien">
        <b:lot rdf:resource="&appeloffres;{$idAppelOffres}_{text()}"/>
    </xsl:template>
    
    <!--<xsl:template match="DECISION">
        <xsl:apply-templates select="*[not(local-name() = 'RENSEIGNEMENT')]"/>
    </xsl:template>-->
    
    <!-- <xsl:template match="LIEU_EXEC_LIVR">
        <b:lieuExecution rdf:parseType="Resource">
            <xsl:apply-templates/>            
        </b:lieuExecution> 
    </xsl:template>-->
    
    
    <!-- Titulaire -->
    
    <xsl:template match="TITULAIRE">
        <xsl:variable name="slugTitulaire" select="concat(replace(DENOMINATION,'\W','-'),'-',CP/text())"/>
        <b:titulaire>
            <b:Titulaire rdf:about="&titulaires;{$slugTitulaire}">
                <xsl:apply-templates/>
            </b:Titulaire>
        </b:titulaire>
    </xsl:template>
    
    <xsl:template match="PME_OUI">
        <b:pme rdf:datatype="&xsd;boolean">true</b:pme>
    </xsl:template>
    
    <xsl:template match="PME_NON">
        <b:pme rdf:datatype="&xsd;boolean">false</b:pme>
    </xsl:template>
</xsl:stylesheet>