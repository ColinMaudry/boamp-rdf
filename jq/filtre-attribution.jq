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
$donnees.ATTRIBUTION.DECISION as $decision |
$reference.IDWEB as $idweb |
$reference.TYPE_AVIS.NATURE | keys[0] | ascii_downcase as $type |
 {
    "@context": "https://gist.githubusercontent.com/ColinMaudry/5169cb4e285ca94a160272b7b59a5411/raw/c05b569bc7c37297c1f91424d58b99bf325f7000/boamp-context.jsonld",
    "@type": ("boamp:" + $type),
    "@id": ($type + "s:" + $idweb),
    "boamp:idweb": $idweb,
    "dct:identifier":"",
    "boamp:famille": $reference.TYPE_AVIS.FAMILLE | keys[0] | ascii_downcase,
    "boamp:statut": $reference.TYPE_AVIS.STATUT | keys[0] | ascii_downcase,
    "boamp:appelOffres" : $annonce.GESTION.MARCHE.ANNONCE_ANTERIEUR |
        (if type == "array" then map({"@id":.REFERENCE.IDWEB})
        elif type == "objet" then
        {"@id":.REFERENCE.IDWEB}
        else null
        end)
        ,
    "boamp:nomHtml": $annonce.GESTION.NOM_HTML,
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
  #"boamp:criteresSociauxEnv": ,
  #"boamp:departementPublication": "27",
  #"boamp:resumeObjet":"Pré du Bel Ebat - Accès pompiers SMAC : Plantations. Pré du Bel Ebat à Evreux"
  "boamp:acheteur": (
  if $donnees.IDENTITE.DENOMINATION then {
      "@id": ("acheteurs:" +
      ($donnees.IDENTITE.DENOMINATION |
      gsub("\\W";"-") )),
      "boamp:profilAcheteur": (
      if $donnees.IDENTITE.URL_PROFIL_ACHETEUR then {
          "@id": $donnees.IDENTITE.URL_PROFIL_ACHETEUR
      } else null end),
      "rdfs:label": $donnees.IDENTITE.DENOMINATION,
      "boamp:codePostal": $donnees.IDENTITE.CP,
      "@type": (if ($donnees.TYPE_ORGANISME | type) == "object" then
       ("boamp:" + ($donnees.TYPE_ORGANISME | keys[0] | ascii_downcase)) else
       "boamp:Acheteur" end)
   } else null end),
  "boamp:objetComplet": $donnees.OBJET.OBJET_COMPLET,
  #"boamp:criteres":{},
  "boamp:dateDecisionAttribution": $donnees.ATTRIBUTION.DATE_DECISION,
  "boamp:titulaire": (
    if ($decision | type) == "object" then
        if ($decision.TITULAIRE | type) == "object" then
            {
                "@id": ("titulaires:" + ($decision.TITULAIRE.DENOMINATION | gsub("\\W";"-")) + "-" + $decision.TITULAIRE.CP),
                "boamp:codePostal": $decision.TITULAIRE.CP
            }
            else null end
        elif  ($decision | type) == "array" then
        null else null end),

"boamp:valeurTotale": (if ($donnees.ATTRIBUTION.VALEUR_TOTALE | type) == "object" then  {
    "boamp:devise":$donnees.ATTRIBUTION.VALEUR_TOTALE["@DEVISE"],
    "boamp:montant": (($donnees.ATTRIBUTION.VALEUR_TOTALE["#text"] | tonumber) // null)
} else null end),
"boamp:montantAttribue": (
    if ($decision | type) == "object" and ($decision.RENSEIGNEMENT.MONTANT | type) == "object" then
    {
        "boamp:devise":$decision.RENSEIGNEMENT.MONTANT["@DEVISE"],
        "boamp:montant": (($decision.RENSEIGNEMENT.MONTANT["#text"] | tonumber) // null)
    } else null end)
  }
