-- PROCEDURES CONCERNANT LA TABLE MEMBRE

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE 
PROCEDURE afft_membre
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst IS
		SELECT 
			M.NUMMEMBRE, S.NOMSOCIETE, L.LIBLANGUE, M.TYPMEMBRE, M.NOMMEMBRE,
			M.PREMEMBRE, M.MAIMEMBRE, M.DTEMEMBRE, M.POSMEMBRE
		FROM 
			SOCIETE S
			Inner Join MEMBRE M
			On M.NUMSOCIETE = S.NUMSOCIETE
			Inner Join LANGUE L
			On L.NUMLANGUE = M.NUMLANGUE
		ORDER BY
			M.NUMMEMBRE
		;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Table membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste membre');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
		htp.tableheader('N°');
		htp.tableheader('Type');
		htp.tableheader('Membre');
		htp.tableheader('Societe');
		htp.tableheader('Langue maternelle');
		htp.tableheader('Mail');
		htp.tableheader('Inscrit le');
		htp.tableheader('Poste');
		htp.tableheader('Actions');
	htp.tableRowClose;
	FOR rec IN lst loop
		if rec.typmembre = 'E' then
			htp.tableRowOpen(cattributes => 'class=success');
		elsif rec.typmembre = 'C' then
			htp.tableRowOpen(cattributes => 'class=info');
		else
			htp.tableRowOpen;
		end if;
		htp.tableData(rec.nummembre);
		htp.tableData(rec.typmembre);
		htp.tableData(
			htf.anchor('afft_membre_from_nummembre?vnummembre=' || rec.nummembre,
			rec.premembre || ' ' || rec.nommembre)
		);
		htp.tableData(rec.nomsociete);
		htp.tableData(rec.liblangue);
		htp.tableData(rec.maimembre);
		htp.tableData(rec.dtemembre);
		htp.tableData(rec.posmembre);
		htp.tableData(
			htf.anchor('ui_frmedit_membre?vnummembre=' || rec.nummembre, 'Modifier')
			|| ' ou ' ||
			htf.anchor('ui_execdel_membre?vnummembre=' || rec.nummembre, 'Supprimer')
		);
		htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--1.2 Affichage du profil d'un membre 
Create or replace procedure afft_membre_from_nummembre
	(vnummembre number default 1) is
		rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
		vnommembre varchar2(30);
		vpremembre varchar2(30);
		vphomembre clob;
		Cursor lst is 
			SELECT 
				M.NUMMEMBRE, S.NOMSOCIETE, L.LIBLANGUE, M.TYPMEMBRE, M.MAIMEMBRE, M.DTEMEMBRE, M.POSMEMBRE, M.PHOMEMBRE, M.DSCEXPERT, M.TELEXPERT
			FROM 
				SOCIETE S
				Inner Join MEMBRE M
				On M.NUMSOCIETE = S.NUMSOCIETE
				Inner Join LANGUE L
				On L.NUMLANGUE = M.NUMLANGUE
			WHERE
				M.NUMMEMBRE = vnummembre;
Begin
	Select NOMMEMBRE, PREMEMBRE, PHOMEMBRE Into vnommembre, vpremembre, vphomembre From MEMBRE Where NUMMEMBRE = vnummembre;
	htp.htmlOpen;
	htp.headopen;
	htp.title('Profil membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headclose;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Profil de ' || vnommembre || ' ' || vpremembre);
	htp.br;
	htp.print('<img src="https://dl.dropboxusercontent.com/u/21548623/' || vphomembre || '" />');
	htp.br;
	htp.br;
	htp.print('<table class="table">');
	htp.tableRowOpen;
		htp.tableheader('N°');
		htp.tableheader('Type');
		htp.tableheader('Societe');
		htp.tableheader('Langue maternelle');
		htp.tableheader('Mail');
		htp.tableheader('Inscrit le');
		htp.tableheader('Poste');
	htp.tableRowClose;
	for rec in lst loop
		htp.tableRowOpen;
		htp.tableData(rec.nummembre);
		htp.tableData(rec.typmembre);
		htp.tableData(rec.nomsociete);
		htp.tableData(rec.liblangue);
		htp.tableData(rec.maimembre);
		htp.tableData(rec.dtemembre);
		htp.tableData(rec.posmembre);
		htp.tableRowClose;
	end loop;
	htp.tableClose;
	htp.print('<a class="btn btn-primary" href="hello" >Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
End;
/



--2 Insertion

--2.1.1 Requête SQL
CREATE OR REPLACE PROCEDURE pa_add_membre
	(
		vnummembre in number,
		vnumsociete in number,
		vnumlangue in number,
		vtypmembre in varchar2,
		vnommembre in varchar2,
		vpremembre in varchar2,
		vmaimembre in varchar2,
		vmdpmembre in varchar2,
		vdtemembre in date,
		vposmembre in varchar2,
		vphomembre in varchar2,
		vdscexpert in clob,
		vtelexpert in varchar2
	)
IS
BEGIN
	INSERT INTO membre VALUES
	(
		vnummembre,
		vnumsociete,
		vnumlangue,
		vtypmembre,
		vnommembre,
		vpremembre,
		vmaimembre,
		vmdpmembre,
		vdtemembre,
		vposmembre,
		vphomembre,
		vdscexpert,
		vtelexpert
	);
COMMIT;
END;
/


--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel à la requête pa_add_membre
CREATE OR REPLACE PROCEDURE ui_execadd_membre
	(
		vnummembre in number,
		vnumsociete in number,
		vnumlangue in number,
		vtypmembre in varchar2,
		vnommembre in varchar2,
		vpremembre in varchar2,
		vmaimembre in varchar2,
		vmdpmembre in varchar2,
		vdtemembre in date,
		vposmembre in varchar2,
		vphomembre in varchar2,
		vdscexpert in clob,
		vtelexpert in varchar2
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_membre(vnummembre,vnumsociete,vnumlangue,vtypmembre,vnommembre,vpremembre,vmaimembre,vmdpmembre,vdtemembre,vposmembre,vphomembre,vdscexpert,vtelexpert);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table membre');
	htp.print('<a class="btn btn-primary" href="afft_membre" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_membre
CREATE OR REPLACE PROCEDURE ui_frmadd_membre
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table membre');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_membre', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumsociete');
	htp.tableData(htf.formText('vnumsociete', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumlangue');
	htp.tableData(htf.formText('vnumlangue', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vtypmembre');
	htp.tableData(htf.formText('vtypmembre', 1));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnommembre');
	htp.tableData(htf.formText('vnommembre', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vpremembre');
	htp.tableData(htf.formText('vpremembre', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vmaimembre');
	htp.tableData(htf.formText('vmaimembre', 80));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vmdpmembre');
	htp.tableData(htf.formText('vmdpmembre', 20));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vdtemembre');
	htp.tableData(htf.formText('vdtemembre', 10));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vposmembre');
	htp.tableData(htf.formText('vposmembre', 40));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vphomembre');
	htp.tableData(htf.formText('vphomembre', 100));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vdscexpert');
	htp.tableData(htf.formText('vdscexpert', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vtelexpert');
	htp.tableData(htf.formText('vtelexpert', 20));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--3 Edition

--3.1.3 Formulaire d'édition
------- Validation redirige vers ui_execedit_membre
CREATE OR REPLACE PROCEDURE ui_frmedit_membre
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition membre');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition membre');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_membre', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumsociete');
	htp.tableData(htf.formText('vnumsociete', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumlangue');
	htp.tableData(htf.formText('vnumlangue', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vtypmembre');
	htp.tableData(htf.formText('vtypmembre', 1));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnommembre');
	htp.tableData(htf.formText('vnommembre', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vpremembre');
	htp.tableData(htf.formText('vpremembre', 30));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vmaimembre');
	htp.tableData(htf.formText('vmaimembre', 80));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vmdpmembre');
	htp.tableData(htf.formText('vmdpmembre', 20));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vdtemembre');
	htp.tableData(htf.formText('vdtemembre', 10));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vposmembre');
	htp.tableData(htf.formText('vposmembre', 40));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vphomembre');
	htp.tableData(htf.formText('vphomembre', 100));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vdscexpert');
	htp.tableData(htf.formText('vdscexpert', 1000));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vtelexpert');
	htp.tableData(htf.formText('vtelexpert', 20));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_membre
	(
		vnummembre in number,
		vnumsociete in number,
		vnumlangue in number,
		vtypmembre in varchar2,
		vnommembre in varchar2,
		vpremembre in varchar2,
		vmaimembre in varchar2,
		vmdpmembre in varchar2,
		vdtemembre in date,
		vposmembre in varchar2,
		vphomembre in varchar2,
		vdscexpert in clob,
		vtelexpert in varchar2
	)
IS
BEGIN
	UPDATE 
		MEMBRE
	SET
		numsociete = vnumsociete,
		numlangue = vnumlangue,
		typmembre = vtypmembre,
		nommembre = vnommembre,
		premembre = vpremembre,
		maimembre = vmaimembre,
		mdpmembre = vmdpmembre,
		dtemembre = vdtemembre,
		posmembre = vposmembre,
		phomembre = vphomembre,
		dscexpert = vdscexpert,
		telexpert = vtelexpert
	WHERE 
		nummembre = vnummembre;
	COMMIT;
END;
/


--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_membre
CREATE OR REPLACE
PROCEDURE ui_execedit_membre
	(
		vnummembre in number,
		vnumsociete in number,
		vnumlangue in number,
		vtypmembre in varchar2,
		vnommembre in varchar2,
		vpremembre in varchar2,
		vmaimembre in varchar2,
		vmdpmembre in varchar2,
		vdtemembre in date,
		vposmembre in varchar2,
		vphomembre in varchar2,
		vdscexpert in clob,
		vtelexpert in varchar2
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table MEMBRE');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_membre(vnummembre,vnumsociete,vnumlangue,vtypmembre,vnommembre,vpremembre,vmaimembre,vmdpmembre,vdtemembre,vposmembre,vphomembre,vdscexpert,vtelexpert);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table MEMBRE');
	htp.print('<a class="btn btn-primary" href="afft_membre" >>Consulter la liste MEMBRE</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--4 Suppression

--4.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_del_membre
	(
		vnummembre in number
	)
IS
BEGIN
	DELETE FROM 
		MEMBRE
	WHERE 
		nummembre = vnummembre;
	COMMIT;
END;
/


--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_membre
CREATE OR REPLACE
PROCEDURE ui_execdel_membre
	(
		vnummembre in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table MEMBRE');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_membre(vnummembre);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table MEMBRE');
	htp.print('<a class="btn btn-primary" href="afft_membre" >>Consulter la liste MEMBRE</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


