-- PROCEDURES CONCERNANT LA TABLE AUTORISER

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_autoriser
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		A.NATURE, A.CODE, M.PREMEMBRE, M.NOMMEMBRE, M.NUMMEMBRE, D.LIBDOMAINE
	FROM 
		AUTORISER A Inner Join MEMBRE M
		ON A.NUMMEMBRE = M.NUMMEMBRE
		Inner Join DOMAINE D
		ON A.NUMDOMAINE = D.NUMDOMAINE;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table autoriser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste autoriser');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Numéro');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.premembre || ' ' || rec.nommembre);
	htp.tableData(rec.nature);
	htp.tableData(rec.code);
	htp.tableData(rec.libdomaine);
	htp.tableData(
		htf.anchor('ui_frmedit_autoriser?vnummembre=' || rec.nummembre, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_autoriser?vnummembre=' || rec.nummembre, 'Supprimer')
	);
	htp.tableRowClose;
	END LOOP;
	htp.tableClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/

--2 Insertion


--2.1.1 Requête SQL
CREATE OR REPLACE PROCEDURE pa_add_autoriser
	(
		vnummembre in number,
		vnature in varchar2,
		vcode in varchar2,
		vnumdomaine in number
	)
IS
BEGIN
	INSERT INTO autoriser VALUES
	(
		vnummembre,
		vnature,
		vcode,
		vnumdomaine
	);
COMMIT;
END;
/


--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel à la requête pa_add_autoriser
CREATE OR REPLACE PROCEDURE ui_execadd_autoriser
	(
		vnummembre in number,
		vnature in varchar2,
		vcode in varchar2,
		vnumdomaine in number
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion autoriser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_autoriser(vnummembre,vnature,vcode,vnumdomaine);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table autoriser');
	htp.print('<a class="btn btn-primary" href="afft_autoriser" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_autoriser
CREATE OR REPLACE PROCEDURE ui_frmadd_autoriser
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion autoriser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table autoriser');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_autoriser', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnature');
	htp.tableData(htf.formText('vnature', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vcode');
	htp.tableData(htf.formText('vcode', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumdomaine');
	htp.tableData(htf.formText('vnumdomaine', 2));
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
------- Validation redirige vers ui_execedit_autoriser
CREATE OR REPLACE PROCEDURE ui_frmedit_autoriser
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition autoriser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition autoriser');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_autoriser', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnature');
	htp.tableData(htf.formText('vnature', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vcode');
	htp.tableData(htf.formText('vcode', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnumdomaine');
	htp.tableData(htf.formText('vnumdomaine', 2));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_autoriser
CREATE OR REPLACE
PROCEDURE ui_execedit_autoriser
	(
		vnummembre in number,
		vnature in varchar2,
		vcode in varchar2,
		vnumdomaine in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table AUTORISER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_autoriser(vnummembre,vnature,vcode,vnumdomaine);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table AUTORISER');
	htp.print('<a class="btn btn-primary" href="afft_autoriser" >>Consulter la liste AUTORISER</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_autoriser
	(
		vnummembre in number,
		vnature in varchar2,
		vcode in varchar2,
		vnumdomaine in number
	)
IS
BEGIN
	UPDATE 
		AUTORISER
	SET
		nature = vnature,
		code = vcode,
		numdomaine = vnumdomaine
	WHERE 
		nummembre = vnummembre;
	COMMIT;
END;
/


--4 Suppression

--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_autoriser
CREATE OR REPLACE
PROCEDURE ui_execdel_autoriser
	(
		vnummembre in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table AUTORISER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_autoriser(vnummembre);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table AUTORISER');
	htp.print('<a class="btn btn-primary" href="afft_autoriser" >>Consulter la liste AUTORISER</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--4.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_del_autoriser
	(
		vnummembre in number
	)
IS
BEGIN
	DELETE FROM 
		AUTORISER
	WHERE 
		nummembre = vnummembre;
	COMMIT;
END;
/

