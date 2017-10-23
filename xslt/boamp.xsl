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
    xmlns:lots="https://boamp.maudry.com/lots/"
    xmlns:cpv="https://boamp.maudry.com/cpv/"
    version="2.0">
    
    <xsl:include href="attribution.xsl"/>
    <xsl:include href="appel-offres.xsl" />
    
        
    <xsl:output method="xml" indent="yes"></xsl:output>
    
    <xsl:variable name="typeAnnonce" select="/ANNONCE/GESTION/REFERENCE/TYPE_AVIS/NATURE/*[1]/local-name()"/>
   
    <xsl:variable name="idweb" select="/ANNONCE/GESTION/REFERENCE/IDWEB/text()"/>
    <xsl:variable name="idAppelOffres">
        <xsl:choose>
            <xsl:when test="$typeAnnonce = 'APPEL_OFFRE'">
                <xsl:value-of select="$idweb"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/ANNONCE/GESTION/MARCHE/ANNONCE_ANTERIEUR/REFERENCE[TYPE_AVIS/NATURE/APPEL_OFFRE]/IDWEB/text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:b="https://data.maudry.com/voc/boamp#"
            xmlns:dct="http://purl.org/dc/terms/"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
            xmlns:attributions="https://boamp.maudry.com/attributions/"
            xmlns:appeloffres="https://boamp.maudry.com/appeloffres/"
            xmlns:annonces="https://boamp.maudry.com/annonces/"
            xmlns:acheteurs="https://boamp.maudry.com/acheteurs/"
            xmlns:titulaires="https://boamp.maudry.com/titulaires/"
            xmlns:descripteurs="https://boamp.maudry.com/descripteurs/"
            xmlns:lots="https://boamp.maudry.com/lots/"
            xmlns:cpv="https://boamp.maudry.com/cpv/"
            >
            <xsl:apply-templates mode="premierePasse"/>           
        </rdf:RDF>
    </xsl:template>
    
    
    <!-- Générique -->
    
    <xsl:template match="CP">
        <b:codePostal><xsl:value-of select="text()"/></b:codePostal>
    </xsl:template>
    
    <xsl:template match="VILLE">
        <b:ville><xsl:value-of select="text()"/></b:ville>
    </xsl:template>
    
    <xsl:template match="PAYS">
        <b:pays><xsl:value-of select="text()"/></b:pays>
    </xsl:template>
    
    <xsl:template match="CODE_IDENT_NATIONAL">
        <b:siret><xsl:value-of select="text()"/></b:siret>
    </xsl:template>
    
    <xsl:template match="DENOMINATION">
        <rdfs:label><xsl:value-of select="text()"/></rdfs:label>
    </xsl:template>   
    
    <xsl:template match="NUM">
        <b:numeroLot><xsl:value-of select="text()"/></b:numeroLot>
    </xsl:template>
    
    <xsl:template match="CPV/PRINCIPAL">
        <b:cpvPrincipal rdf:resource="&cpv;{text()}"/>
    </xsl:template>
    
    <xsl:template match="RENSEIGNEMENTS_COMPLEMENTAIRES"/>
       
    
    <!-- Annonce -->   
    
    <xsl:template match="GESTION" mode="premierePasse">
        <b:Annonce rdf:about="&annonces;{$idweb}">
            <rdfs:type rdf:resource="&boamp;Annonce"/>
            <xsl:apply-templates/>
            <xsl:apply-templates select="../DONNEES" mode="#default"/>
        </b:Annonce>
    </xsl:template>
    
    <xsl:template mode="premierePasse" match="DONNEES"/>
    
    
    <xsl:template match="GESTION/INDEXATION/DATE_PUBLICATION">
        <b:datePublication rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="text()"/></b:datePublication>
    </xsl:template>
    
    <xsl:template match="GESTION/INDEXATION/DATE_FIN_DIFFUSION">
        <b:dateFinDiffusion rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="text()"/></b:dateFinDiffusion>
    </xsl:template>
    
    <xsl:template match="INDEXATION/DESCRIPTEURS/DESCRIPTEUR/CODE">
        <b:descripteur rdf:resource="&descripteurs;{text()}"/>
    </xsl:template>
    
    <xsl:template match="GESTION/REFERENCE/IDWEB">
        <b:idweb><xsl:value-of select="text()"/></b:idweb>
    </xsl:template>
    
    <xsl:template match="GESTION/NOM_HTML">
        <b:nomHtml><xsl:value-of select="text()"/></b:nomHtml>
    </xsl:template>
    
    <xsl:template match="RESUME_OBJET">
        <b:resumeObjet><xsl:value-of select="text()"/></b:resumeObjet>
    </xsl:template>

    <xsl:template match="OBJET_COMPLET">
        <b:objetComplet><xsl:value-of select="text()"/></b:objetComplet>
    </xsl:template>
    
    <xsl:template match="TYPE_MARCHE/*">
        <b:typeMarche><xsl:value-of select="b:upperFirst(local-name())"/></b:typeMarche>
    </xsl:template>
    
    <xsl:template match="TYPE_PROCEDURE/*">
        <b:typeProcedure><xsl:value-of select="translate(b:upperFirst(local-name()),'_',' ')"/></b:typeProcedure>
    </xsl:template>
    
    <xsl:template match="DEP_PUBLICATION">
        <b:departementPublication><xsl:value-of select="text()"/></b:departementPublication>
    </xsl:template>
    
    
    <!-- Acheteur -->
    
    <xsl:template match="/ANNONCE/DONNEES/IDENTITE">
        <xsl:variable name="slugAcheteur" select="replace(DENOMINATION,'\W','-')"/>
        <b:acheteur>
            <rdf:Description rdf:about="&acheteurs;{$slugAcheteur}">
                <xsl:choose>
                    <xsl:when test="../TYPE_ORGANISME/*">
                        <xsl:apply-templates select="../TYPE_ORGANISME/*"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdfs:type rdf:resource="&boamp;Acheteur"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates/>
            </rdf:Description>
        </b:acheteur>
    </xsl:template>  
    
    <xsl:template match="TYPE_ORGANISME/*">
        <xsl:variable name="typeAcheteur" select="b:upperFirst(replace(local-name(),'\W','-'))"/>
        <rdfs:type rdf:resource="&boamp;{$typeAcheteur}"/>
    </xsl:template>
    
    <xsl:template match="URL_PROFIL_ACHETEUR">
        <b:profilAcheteur rdf:resource="{text()}"/>
    </xsl:template>
        
    <!-- Fonctions -->
    
    <xsl:function name="b:upperFirst">
        <xsl:param name="text"></xsl:param>
        <xsl:value-of select="concat(upper-case(substring($text,1,1)),lower-case(substring($text, 2)))"/>
    </xsl:function>  
    
    <!--Templates -->
    
    <xsl:template match="DONNEES">
        <xsl:choose>
            <xsl:when test="$typeAnnonce = 'APPEL_OFFRE'">
                <b:appelOffres>
                    <b:AppelOffres rdf:about="&appeloffres;{$idweb}">
                        <xsl:apply-templates/>
                    </b:AppelOffres>
                </b:appelOffres>
            </xsl:when>
            <xsl:when test="$typeAnnonce = 'ATTRIBUTION'">
                <xsl:apply-templates select="ATTRIBUTION"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="valeur">
        <b:montant rdf:datatype="http://www.w3.org/2001/XMLSchema#double">
            <xsl:value-of select="text()"/>
        </b:montant>
        <b:devise>
            <xsl:value-of select="@DEVISE"/>
        </b:devise>
    </xsl:template>
    
    <!-- Other templates -->
    
    <xsl:template match="*" priority="-1">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="text()"/>
    
</xsl:stylesheet>