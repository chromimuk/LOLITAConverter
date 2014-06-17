-- PROCEDURES CONCERNANT LA TABLE SE_SPECIALISER

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_se_specialiser
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		 *
	FROM 
		SE_SPECIALISER;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table se_specialiser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste se_specialiser');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Numéro');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.numdomaine);
	htp.tableData(rec.nummembre);
	htp.tableData(
		htf.anchor('ui_frmedit_se_specialiser?vnumdomaine=' || rec.numdomaine, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_se_specialiser?vnumdomaine=' || rec.numdomaine, 'Supprimer')
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
CREATE OR REPLACE PROCEDURE pa_add_se_specialiser
	(
		vnumdomaine in number,
		vnummembre in number
	)
IS
BEGIN
	INSERT INTO se_specialiser VALUES
	(
		vnumdomaine,
		vnummembre
	);
COMMIT;
END;
/


--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel à la requête pa_add_se_specialiser
CREATE OR REPLACE PROCEDURE ui_execadd_se_specialiser
	(
		vnumdomaine in number,
		vnummembre in number
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion se_specialiser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_se_specialiser(vnumdomaine,vnummembre);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table se_specialiser');
	htp.print('<a class="btn btn-primary" href="afft_se_specialiser" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_se_specialiser
CREATE OR REPLACE PROCEDURE ui_frmadd_se_specialiser
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion se_specialiser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table se_specialiser');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_se_specialiser', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnumdomaine');
	htp.tableData(htf.formText('vnumdomaine', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
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

--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_se_specialiser
	(
		vnumdomaine in number,
		vnummembre in number
	)
IS
BEGIN
	UPDATE 
		SE_SPECIALISER
	SET
		nummembre = vnummembre
	WHERE 
		numdomaine = vnumdomaine;
	COMMIT;
END;
/


--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_se_specialiser
CREATE OR REPLACE
PROCEDURE ui_execedit_se_specialiser
	(
		vnumdomaine in number,
		vnummembre in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table SE_SPECIALISER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_se_specialiser(vnumdomaine,vnummembre);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table SE_SPECIALISER');
	htp.print('<a class="btn btn-primary" href="afft_se_specialiser" >>Consulter la liste SE_SPECIALISER</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--3.1.3 Formulaire d'édition
------- Validation redirige vers ui_execedit_se_specialiser
CREATE OR REPLACE PROCEDURE ui_frmedit_se_specialiser
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition se_specialiser');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition se_specialiser');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_se_specialiser', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnumdomaine');
	htp.tableData(htf.formText('vnumdomaine', 2));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vnummembre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--4 Suppression

--4.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_del_se_specialiser
	(
		vnumdomaine in number
	)
IS
BEGIN
	DELETE FROM 
		SE_SPECIALISER
	WHERE 
		numdomaine = vnumdomaine;
	COMMIT;
END;
/


--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_se_specialiser
CREATE OR REPLACE
PROCEDURE ui_execdel_se_specialiser
	(
		vnumdomaine in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table SE_SPECIALISER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_se_specialiser(vnumdomaine);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table SE_SPECIALISER');
	htp.print('<a class="btn btn-primary" href="afft_se_specialiser" >>Consulter la liste SE_SPECIALISER</a>');
	htp.print('<a class="btn btn-primary" href="hello" >>Retour accueil</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/

