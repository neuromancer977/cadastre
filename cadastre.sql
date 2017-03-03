-- *****************
-- IMMEUBLE


DROP MATERIALIZED VIEW IF EXISTS cadastre.bf_immeuble;
CREATE MATERIALIZED VIEW cadastre.bf_immeuble AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY imm.ogc_fid,imm._tid ASC) AS cid,
			imm.IdentDN,
			imm._tid,
			imm.numero,
			imm.genre,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur,
			bf.geometry IS NOT NULL as has_geometry,
			CASE
				WHEN bf.geometry IS NULL THEN ST_SetSRID(ST_MakeBox2D(ST_MakePoint(pos.pos_0-.1,pos.pos_1-.1),ST_MakePoint(pos.pos_0+.1,pos.pos_1+.1)),2056)::geometry(Polygon,2056)
				ELSE bf.geometry::geometry(Polygon,2056)
			END AS geometry
		FROM fribourg.biens_fonds__immeuble imm
		LEFT OUTER JOIN
		(
			SELECT _tid, geometrie::geometry(Polygon,2056) AS geometry, bien_fonds_de AS fk_immeuble FROM vaud.biens_fonds__bien_fonds
			UNION
			SELECT _tid, ST_CurveToLine(wkb_geometry)::geometry(Polygon,2056) AS geometry, ddp_de AS fk_immeuble FROM fribourg.biens_fonds__ddp
		) AS bf ON bf.fk_immeuble = imm._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON(posimmeuble_de) * FROM fribourg.biens_fonds__posimmeuble) pos ON pos.posimmeuble_de = imm._tid
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY imm.ogc_fid,imm._tid ASC) AS cid,
			imm.IdentDN,
			imm._tid,
			imm.numero,
			imm.genre,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur,
			bf.geometry IS NOT NULL as has_geometry,
			CASE
				WHEN bf.geometry IS NULL THEN ST_SetSRID(ST_MakeBox2D(ST_MakePoint(pos.pos_0-.1,pos.pos_1-.1),ST_MakePoint(pos.pos_0+.1,pos.pos_1+.1)),2056)::geometry(Polygon,2056)
				ELSE bf.geometry::geometry(Polygon,2056)
			END AS geometry
		FROM valais.biens_fonds__immeuble imm
		LEFT OUTER JOIN
		(
			SELECT _tid, geometrie::geometry(Polygon,2056) AS geometry, bien_fonds_de AS fk_immeuble FROM vaud.biens_fonds__bien_fonds
			UNION
			SELECT _tid, ST_CurveToLine(wkb_geometry)::geometry(Polygon,2056) AS geometry, ddp_de AS fk_immeuble FROM vaud.biens_fonds__ddp
		) AS bf ON bf.fk_immeuble = imm._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON(posimmeuble_de) * FROM valais.biens_fonds__posimmeuble) pos ON pos.posimmeuble_de = imm._tid
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY imm.ogc_fid,imm._tid ASC) AS cid,
			imm.IdentDN,
			imm._tid,
			imm.numero,
			imm.genre,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur,
			bf.geometry IS NOT NULL as has_geometry,
			CASE
				WHEN bf.geometry IS NULL THEN ST_SetSRID(ST_MakeBox2D(ST_MakePoint(pos.pos_0-.1,pos.pos_1-.1),ST_MakePoint(pos.pos_0+.1,pos.pos_1+.1)),2056)::geometry(Polygon,2056)
				ELSE bf.geometry::geometry(Polygon,2056)
			END AS geometry
		FROM vaud.biens_fonds__immeuble imm
		LEFT OUTER JOIN
		(
			SELECT _tid, geometrie::geometry(Polygon,2056) AS geometry, bien_fonds_de AS fk_immeuble FROM vaud.biens_fonds__bien_fonds
			UNION
			SELECT _tid, ST_CurveToLine(wkb_geometry)::geometry(Polygon,2056) AS geometry, ddp_de AS fk_immeuble FROM vaud.biens_fonds__ddp
		) AS bf ON bf.fk_immeuble = imm._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON(posimmeuble_de) * FROM vaud.biens_fonds__posimmeuble) pos ON pos.posimmeuble_de = imm._tid
	)
	;
CREATE INDEX bf_immeuble_geom_idx ON cadastre.bf_immeuble USING gist (geometry);

-- *****************
-- COUVERTURE DU SOL

DROP MATERIALIZED VIEW IF EXISTS cadastre.cs_couverture_sol;
CREATE MATERIALIZED VIEW cadastre.cs_couverture_sol AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY cs.ogc_fid,cs._tid,num.numero ASC) AS cid,
			cs.ogc_fid,
			cs._tid,
			cs.origine,
			cs.qualite,
			cs.genre,
			cs.geometrie::geometry(Polygon,2056),
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM fribourg.couverture_du_sol__surfacecs cs
		LEFT OUTER JOIN fribourg.couverture_du_sol__numero_de_batiment num ON cs._tid = num.numero_de_batiment_de
		LEFT OUTER JOIN (SELECT DISTINCT ON(posnumero_de_batiment_de) * FROM fribourg.couverture_du_sol__posnumero_de_batiment) pos ON pos.posnumero_de_batiment_de = num._tid
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY cs.ogc_fid,cs._tid,num.numero ASC) AS cid,
			cs.ogc_fid,
			cs._tid,
			cs.origine,
			cs.qualite,
			cs.genre,
			cs.geometrie::geometry(Polygon,2056),
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM valais.couverture_du_sol__surfacecs cs
		LEFT OUTER JOIN valais.couverture_du_sol__numero_de_batiment num ON cs._tid = num.numero_de_batiment_de
		LEFT OUTER JOIN (SELECT DISTINCT ON(posnumero_de_batiment_de) * FROM valais.couverture_du_sol__posnumero_de_batiment) pos ON pos.posnumero_de_batiment_de = num._tid
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY cs.ogc_fid,cs._tid,num.numero ASC) AS cid,
			cs.ogc_fid,
			cs._tid,
			cs.origine,
			cs.qualite,
			cs.genre,
			cs.geometrie::geometry(Polygon,2056),
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM vaud.couverture_du_sol__surfacecs cs
		LEFT OUTER JOIN (SELECT DISTINCT ON (numero_de_batiment_de) * FROM vaud.couverture_du_sol__numero_de_batiment) num ON cs._tid = num.numero_de_batiment_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (posnumero_de_batiment_de) * FROM vaud.couverture_du_sol__posnumero_de_batiment) pos ON pos.posnumero_de_batiment_de = num._tid
	);
CREATE INDEX cs_cs_geom_idx ON cadastre.cs_couverture_sol USING gist (geometrie);


-- *****************
-- NOMS DE RUE

DROP MATERIALIZED VIEW IF EXISTS cadastre.ab_rue;
CREATE MATERIALIZED VIEW cadastre.ab_rue AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY rue.troncon_rue_de ASC) AS cid,
			COALESCE(nom.texte_abrege, nom.texte) AS nom_rue,
			--loc.*,
			rue.geometrie
		FROM
		(
			SELECT
				troncon_rue_de,
				ST_Multi(ST_LineMerge(ST_Union(rue.geometrie)))::geometry(MultiLineString,2056) as geometrie
			FROM fribourg.adresses_des_batiments__troncon_rue rue GROUP BY troncon_rue_de
		) rue
		--LEFT OUTER JOIN fribourg.adresses_des_batiments__localisation loc ON loc._tid = rue.troncon_rue_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (nom_localisation_de) * FROM fribourg.adresses_des_batiments__nom_localisation) nom ON nom.nom_localisation_de = rue.troncon_rue_de
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY rue.troncon_rue_de ASC) AS cid,
			COALESCE(nom.texte_abrege, nom.texte) AS nom_rue,
			--loc.*,
			rue.geometrie
		FROM
		(
			SELECT
				troncon_rue_de,
				ST_Multi(ST_LineMerge(ST_Union(rue.geometrie)))::geometry(MultiLineString,2056) as geometrie
			FROM valais.adresses_des_batiments__troncon_rue rue GROUP BY troncon_rue_de
		) rue
		--LEFT OUTER JOIN valais.adresses_des_batiments__localisation loc ON loc._tid = rue.troncon_rue_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (nom_localisation_de) * FROM valais.adresses_des_batiments__nom_localisation) nom ON nom.nom_localisation_de = rue.troncon_rue_de
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY rue.troncon_rue_de ASC) AS cid,
			COALESCE(nom.texte_abrege, nom.texte) AS nom_rue,
			--loc.*,
			rue.geometrie
		FROM
		(
			SELECT
				troncon_rue_de,
				ST_Multi(ST_LineMerge(ST_Union(rue.geometrie)))::geometry(MultiLineString,2056) as geometrie
			FROM vaud.adresses_des_batiments__troncon_rue rue GROUP BY troncon_rue_de
		) rue
		--LEFT OUTER JOIN vaud.adresses_des_batiments__localisation loc ON loc._tid = rue.troncon_rue_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (nom_localisation_de) * FROM vaud.adresses_des_batiments__nom_localisation) nom ON nom.nom_localisation_de = rue.troncon_rue_de
	)
	;
CREATE INDEX ab_rue_geom_idx ON cadastre.ab_rue USING gist (geometrie);



-- *****************
-- ELEMENTS SURFACIQUES

DROP MATERIALIZED VIEW IF EXISTS cadastre.od_element_surfacique;
CREATE MATERIALIZED VIEW cadastre.od_element_surfacique AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY os.ogc_fid,os._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			os.wkb_geometry::geometry(Polygon,2056) as geometry,
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM fribourg.objets_divers__element_surfacique os
		LEFT OUTER JOIN fribourg.objets_divers__objet_divers od ON od._tid = os.element_surfacique_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (numero_objet_de) * FROM fribourg.objets_divers__numero_objet) num ON num.numero_objet_de = od._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON (posnumero_objet_de) * FROM fribourg.objets_divers__posnumero_objet) pos ON pos.posnumero_objet_de = num._tid
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY os.ogc_fid,os._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			os.wkb_geometry::geometry(Polygon,2056) as geometry,
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM valais.objets_divers__element_surfacique os
		LEFT OUTER JOIN valais.objets_divers__objet_divers od ON od._tid = os.element_surfacique_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (numero_objet_de) * FROM valais.objets_divers__numero_objet) num ON num.numero_objet_de = od._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON (posnumero_objet_de) * FROM valais.objets_divers__posnumero_objet) pos ON pos.posnumero_objet_de = num._tid
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY os.ogc_fid,os._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			os.wkb_geometry::geometry(Polygon,2056) as geometry,
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM vaud.objets_divers__element_surfacique os
		LEFT OUTER JOIN vaud.objets_divers__objet_divers od ON od._tid = os.element_surfacique_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (numero_objet_de) * FROM vaud.objets_divers__numero_objet) num ON num.numero_objet_de = od._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON (posnumero_objet_de) * FROM vaud.objets_divers__posnumero_objet) pos ON pos.posnumero_objet_de = num._tid
	)
	;
CREATE INDEX od_element_surfacique_geom_idx ON cadastre.od_element_surfacique USING gist (geometry);


-- *****************
-- ELEMENTS LINEAIRES

DROP MATERIALIZED VIEW IF EXISTS cadastre.od_element_lineaire;
CREATE MATERIALIZED VIEW cadastre.od_element_lineaire AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY ol.ogc_fid,ol._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			ol.wkb_geometry::geometry(MultiLineString,2056) as geometry
		FROM fribourg.objets_divers__element_lineaire ol
		LEFT OUTER JOIN fribourg.objets_divers__objet_divers od ON od._tid = ol.element_lineaire_de
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY ol.ogc_fid,ol._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			ol.wkb_geometry::geometry(MultiLineString,2056) as geometry
		FROM valais.objets_divers__element_lineaire ol
		LEFT OUTER JOIN valais.objets_divers__objet_divers od ON od._tid = ol.element_lineaire_de
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY ol.ogc_fid,ol._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			ol.wkb_geometry::geometry(MultiLineString,2056) as geometry
		FROM vaud.objets_divers__element_lineaire ol
		LEFT OUTER JOIN vaud.objets_divers__objet_divers od ON od._tid = ol.element_lineaire_de
	)
	;
CREATE INDEX od_element_lineaire_geom_idx ON cadastre.od_element_lineaire USING gist (geometry);



-- *****************
-- POINT LIMITES

DROP MATERIALIZED VIEW IF EXISTS cadastre.bf_point_limite;
CREATE MATERIALIZED VIEW cadastre.bf_point_limite AS
		SELECT
			1000000 + row_number() OVER (ORDER BY ogc_fid,_tid ASC) AS cid,
			origine,
			identification,
			precplan,
			fiabplan,
			signe,
			defini_exactement,
			anc_borne_speciale,
			wkb_geometry::geometry(Point,2056) as geometry
		FROM fribourg.biens_fonds__point_limite
	UNION
		SELECT
			2000000 + row_number() OVER (ORDER BY ogc_fid,_tid ASC) AS cid,
			origine,
			identification,
			precplan,
			fiabplan,
			signe,
			defini_exactement,
			anc_borne_speciale,
			wkb_geometry::geometry(Point,2056) as geometry
		FROM valais.biens_fonds__point_limite
	UNION
		SELECT
			3000000 + row_number() OVER (ORDER BY ogc_fid,_tid ASC) AS cid,
			origine,
			identification,
			precplan,
			fiabplan,
			signe,
			defini_exactement,
			anc_borne_speciale,
			wkb_geometry::geometry(Point,2056) as geometry
		FROM vaud.biens_fonds__point_limite
	;
CREATE INDEX bf_point_limite_geom_idx ON cadastre.bf_point_limite USING gist (geometry);


-- *****************
-- POINT FIXES

DROP MATERIALIZED VIEW IF EXISTS cadastre.pf_points_fixes;
CREATE MATERIALIZED VIEW cadastre.pf_points_fixes AS
		SELECT
			1000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT _tid, 'PFP1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  fribourg.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFP2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  fribourg.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFP3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int as accessibilite, signe, wkb_geometry FROM  fribourg.points_fixescategorie3__pfp3
				UNION
				SELECT _tid, 'PFA1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  fribourg.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFA2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  fribourg.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFA3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  fribourg.points_fixescategorie3__pfp3
			) fribourg
	UNION
		SELECT
			2000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT _tid, 'PFP1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  valais.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFP2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  valais.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFP3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int as accessibilite, signe, wkb_geometry FROM  valais.points_fixescategorie3__pfp3
				UNION
				SELECT _tid, 'PFA1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  valais.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFA2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  valais.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFA3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  valais.points_fixescategorie3__pfp3
			) valais
	UNION
		SELECT
			3000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT _tid, 'PFP1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  vaud.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFP2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  vaud.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFP3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int as accessibilite, signe, wkb_geometry FROM  vaud.points_fixescategorie3__pfp3
				UNION
				SELECT _tid, 'PFA1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  vaud.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFA2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  vaud.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFA3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  vaud.points_fixescategorie3__pfp3
			) vaud
	;
CREATE INDEX pf_points_fixes_geom_idx ON cadastre.pf_points_fixes USING gist (wkb_geometry);


-- *****************
-- ENTREE BATIMENTS

DROP MATERIALIZED VIEW IF EXISTS cadastre.od_entree_batiment;
CREATE MATERIALIZED VIEW cadastre.od_entree_batiment AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY eb.ogc_fid,eb._tid ASC) AS cid,
			eb.origine,
			eb.entree_batiment_de,
			eb.validite,
			eb.niveau,
			eb.numero_maison,
			eb.dans_batiment,
			eb.regbl_egid,
			eb.regbl_edid,
			eb.wkb_geometry::geometry(Point,2056) as geometry,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur
		FROM fribourg.adresses_des_batiments__entree_batiment eb
		LEFT OUTER JOIN fribourg.adresses_des_batiments__posnumero_maison pos ON eb._tid = pos.posnumero_batiment_de
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY eb.ogc_fid,eb._tid ASC) AS cid,
			eb.origine,
			eb.entree_batiment_de,
			eb.validite,
			eb.niveau,
			eb.numero_maison,
			eb.dans_batiment,
			eb.regbl_egid,
			eb.regbl_edid,
			eb.wkb_geometry::geometry(Point,2056) as geometry,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur
		FROM valais.adresses_des_batiments__entree_batiment eb
		LEFT OUTER JOIN valais.adresses_des_batiments__posnumero_maison pos ON eb._tid = pos.posnumero_batiment_de
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY eb.ogc_fid,eb._tid ASC) AS cid,
			eb.origine,
			eb.entree_batiment_de,
			eb.validite,
			eb.niveau,
			eb.numero_maison,
			eb.dans_batiment,
			eb.regbl_egid,
			eb.regbl_edid,
			eb.wkb_geometry::geometry(Point,2056) as geometry,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur
		FROM vaud.adresses_des_batiments__entree_batiment eb
		LEFT OUTER JOIN vaud.adresses_des_batiments__posnumero_maison pos ON eb._tid = pos.posnumero_batiment_de
	)
	;
CREATE INDEX od_entree_batiment_geom_idx ON cadastre.od_entree_batiment USING gist (geometry);


-- *****************
-- LIEUX DITS

DROP MATERIALIZED VIEW IF EXISTS cadastre.no_nomenclature;
CREATE MATERIALIZED VIEW cadastre.no_nomenclature AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT
					nl_pos._tid,
					nl.origine,
					nl.nom,
					nl_pos.pos_0 as lbl_x,
					nl_pos.pos_1 as lbl_y,
					90-180.0/200.0*nl_pos.ori AS ori,
					nl_pos.hali as lbl_hali,
					nl_pos.vali as lbl_vali,
					nl_pos.grandeur as lbl_grandeur,
					nl_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM fribourg.nomenclature__posnom_local nl_pos
				LEFT OUTER JOIN fribourg.nomenclature__nom_local nl ON nl_pos.posnom_local_de = nl._tid
				WHERE nom NOT LIKE 'Lac Léman'
				UNION
				SELECT
					ld_pos._tid,
					ld.origine,
					ld.nom,
					ld_pos.pos_0 as lbl_x,
					ld_pos.pos_1 as lbl_y,
					90-180.0/200.0*ld_pos.ori AS ori,
					ld_pos.hali as lbl_hali,
					ld_pos.vali as lbl_vali,
					ld_pos.grandeur as lbl_grandeur,
					ld_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM fribourg.nomenclature__poslieudit ld_pos
				LEFT OUTER JOIN fribourg.nomenclature__lieudit ld ON ld_pos.poslieudit_de = ld._tid
				WHERE nom NOT LIKE 'Lac Léman'
			) fribourg
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT
					nl_pos._tid,
					nl.origine,
					nl.nom,
					nl_pos.pos_0 as lbl_x,
					nl_pos.pos_1 as lbl_y,
					90-180.0/200.0*nl_pos.ori AS ori,
					nl_pos.hali as lbl_hali,
					nl_pos.vali as lbl_vali,
					nl_pos.grandeur as lbl_grandeur,
					nl_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM valais.nomenclature__posnom_local nl_pos
				LEFT OUTER JOIN valais.nomenclature__nom_local nl ON nl_pos.posnom_local_de = nl._tid
				WHERE nom NOT LIKE 'Lac Léman'
				UNION
				SELECT
					ld_pos._tid,
					ld.origine,
					ld.nom,
					ld_pos.pos_0 as lbl_x,
					ld_pos.pos_1 as lbl_y,
					90-180.0/200.0*ld_pos.ori AS ori,
					ld_pos.hali as lbl_hali,
					ld_pos.vali as lbl_vali,
					ld_pos.grandeur as lbl_grandeur,
					ld_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM valais.nomenclature__poslieudit ld_pos
				LEFT OUTER JOIN valais.nomenclature__lieudit ld ON ld_pos.poslieudit_de = ld._tid
				WHERE nom NOT LIKE 'Lac Léman'
			) valais
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT
					nl_pos._tid,
					nl.origine,
					nl.nom,
					nl_pos.pos_0 as lbl_x,
					nl_pos.pos_1 as lbl_y,
					90-180.0/200.0*nl_pos.ori AS ori,
					nl_pos.hali as lbl_hali,
					nl_pos.vali as lbl_vali,
					nl_pos.grandeur as lbl_grandeur,
					nl_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM vaud.nomenclature__posnom_local nl_pos
				LEFT OUTER JOIN vaud.nomenclature__nom_local nl ON nl_pos.posnom_local_de = nl._tid
				WHERE nom NOT LIKE 'Lac Léman'
				UNION
				SELECT
					ld_pos._tid,
					ld.origine,
					ld.nom,
					ld_pos.pos_0 as lbl_x,
					ld_pos.pos_1 as lbl_y,
					90-180.0/200.0*ld_pos.ori AS ori,
					ld_pos.hali as lbl_hali,
					ld_pos.vali as lbl_vali,
					ld_pos.grandeur as lbl_grandeur,
					ld_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM vaud.nomenclature__poslieudit ld_pos
				LEFT OUTER JOIN vaud.nomenclature__lieudit ld ON ld_pos.poslieudit_de = ld._tid
				WHERE nom NOT LIKE 'Lac Léman'
			) vaud
	)
	;
CREATE INDEX no_nomenclature_geom_idx ON cadastre.no_nomenclature USING gist (geometry);
