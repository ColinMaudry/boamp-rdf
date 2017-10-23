. |
def walk(f):
  . as $in
  | if type == "object" then
      reduce keys[] as $key
        ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
  elif type == "array" then map( walk(f) ) | f
  else f
  end;
.ANNONCE as $annonce |
.ANNONCE.GESTION.REFERENCE as $reference |
.ANNONCE.DONNEES as $donnees |
$donnees.OBJET as $objet |
$reference.IDWEB as $idweb |
$reference.TYPE_AVIS.NATURE | keys[0] | ascii_downcase as $type |
 {
    "@context": "https://gist.githubusercontent.com/ColinMaudry/5169cb4e285ca94a160272b7b59a5411/raw/c05b569bc7c37297c1f91424d58b99bf325f7000/boamp-context.jsonld",
    "@type": ("boamp:" + $type),
    "@id": ("appeloffres:" + $idweb),
    "boamp:idweb": $idweb,
    "dct:identifier": $objet.REF_MARCHE,
    "boamp:famille": $reference.TYPE_AVIS.FAMILLE | keys[0] | ascii_downcase,
    "boamp:statut": $reference.TYPE_AVIS.STATUT | keys[0] | ascii_downcase,
    "boamp:nomHtml": $annonce.GESTION.NOM_HTML,
    "boamp:cpvPrincipal": (
    if ($objet.CPV | type) == "objet" then
        {
            "@id":("cpv:" + $objet.CPV.PRINCIPAL),
            "rdfs:label": $objet.CPV.PRINCIPAL,
            "@type": "boamp:Cpv"
        } elif ($objet.CPV | type) == "array" then
        $objet.CPV | map(
        {
            "@id":("cpv:" + .PRINCIPAL),
            "rdfs:label": .PRINCIPAL,
            "@type": "boamp:Cpv"
        }) else null end),
    "boamp:debutDiffusion": {
        "@value": $annonce.GESTION.INDEXATION.DATE_PUBLICATION,
        "@type": "xsd:date"
    },
    "boamp:finDiffusion": {
        "@value": $annonce.GESTION.INDEXATION.DATE_FIN_DIFFUSION,
        "@type": "xsd:date"
    },
    "boamp:descripteur": $annonce.GESTION.INDEXATION.DESCRIPTEURS.DESCRIPTEUR |
    walk(if type == "object" then {"@id": ("descripteurs:" + .CODE)} elif type == "array" then map({"@id": (.["@id"])}) else . end),
    "boamp:lot": (
    $objet.LOTS.LOT | if type == "array" then
    map(
    {
        "@id":("lots:" + ($objet.REF_MARCHE // $idweb) + "_" + (.NUM | gsub("\\W";"_"))),
        "@type": "boamp:Lot",
        ""
        "rdfs:label": .INTITULE,
        "boamp:cpvPrincipal": (
        if (.CPV | type) == "objet" then
            {
                "@id":("cpv:" + .CPV.PRINCIPAL),
                "rdfs:label": .CPV.PRINCIPAL,
                "@type": "boamp:Cpv"
            } elif (.CPV | type) == "array" then
            .CPV | map(
            {
                "@id":("cpv:" + .PRINCIPAL),
                "rdfs:label": .PRINCIPAL,
                "@type": "boamp:Cpv"
            }) else null end)
    }
    ) elif type == "objet" then
    {
        "@id":("lots:" + ($objet.REF_MARCHE // $idweb) + "_" + (.NUM | gsub("\\W";"_") | input_line_number)) 
    }
    else null
    end ),
  #"boamp:criteresSociauxEnv": ,
  #"boamp:departementPublication": "27",
  #"boamp:resumeObjet":"Pré du Bel Ebat - Accès pompiers SMAC : Plantations. Pré du Bel Ebat à Evreux"
  "boamp:typeProcedure": (if ($donnees.PROCEDURE.TYPE_PROCEDURE | type) == "object" then
   ($donnees.PROCEDURE.TYPE_PROCEDURE | keys[0] | ascii_downcase)
   else
   null end),
  "boamp:eligibleMps": (if ($donnees.CONDITION_PARTICIPATION.ELIGIBLE_MPS | type) == "object" then
   ($donnees.CONDITION_PARTICIPATION.ELIGIBLE_MPS | keys[0])
   else
   null end),
  "boamp:acheteur": {
      "@id": ("acheteurs:" +
      ($donnees.IDENTITE.DENOMINATION |
      gsub("\\W";"-") )),
      "boamp:profilAcheteur": (
          if ($donnees.IDENTITE.URL_PROFIL_ACHETEUR | type) == "string" then
          {"@id": $donnees.IDENTITE.URL_PROFIL_ACHETEUR} else null end)
      ,
      "rdfs:label": $donnees.IDENTITE.DENOMINATION,
      "boamp:codePostal": $donnees.IDENTITE.CP,
      "@type": (if ($donnees.TYPE_POUVOIR_ADJUDICATEUR | type) == "object" then
       ("boamp:" + ($donnees.TYPE_POUVOIR_ADJUDICATEUR | keys[0] |
            if . == "AUTRE" then
            $donnees.TYPE_POUVOIR_ADJUDICATEUR.AUTRE | ascii_downcase | gsub("\\W";"-") else
            . | ascii_downcase end)
        ) else
       "boamp:Acheteur" end)
  },
  "boamp:objetComplet": $objet.OBJET_COMPLET,
  "boamp:titreMarche": $objet.TITRE_MARCHE
  #"boamp:criteres":{},
  }
