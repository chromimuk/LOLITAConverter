-- PROCEDURES CONCERNANT LA TABLE POSSEDER

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_posseder
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		 *
	FROM 
		POSSEDER;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table posseder');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste posseder');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Numéro');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.numcategorie);
	htp.tableData(rec.numdomaine);
	htp.tableData(
		htf.anchor('ui_frmedit_posseder?vnumcategorie=' || rec.numcategorie, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_posseder?vnumcategorie=' || rec.numcategorie, 'Supprimer')
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
CREATE OR REPLACE PROCEDURE pa_add_posseder
	(
		vnumcategorie in number,
		vnumdomaine in number
	)
IS
BEGIN
	INSERT INTO posseder VALUES
	(
		vnumcategorie,
		vnumdomaine
	);
COMMIT;
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_posseder
CREATE OR REPLACE PROCEDURE ui_frmadd_posseder
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion posseder');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table posseder');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_posseder', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnumcategorie');
	htp.tableData(htf.formText('vnumcategorie', 4));
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


--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel à la requête pa_add_posseder
CREATE OR REPLACE PROCEDURE ui_execadd_posseder
	(
		vnumcategorie in number,
		vnumdomaine in number
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion posseder');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_posseder(vnumcategorie,vnumdomaine);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table posseder');
	htp.print('<a class="btn btn-primary" href="afft_posseder" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--3 Edition

--3.1.2 Page de validation d'édition
-------Appel à la requête pa_edit_posseder
CREATE OR REPLACE
PROCEDURE ui_execedit_posseder
	(
		vnumcategorie in number,
		vnumdomaine in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table POSSEDER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_posseder(vnumcategorie,vnumdomaine);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table POSSEDER');
	htp.print('<a class="btn btn-primary" href="afft_posseder" >>Consulter la liste POSSEDER</a>');
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
------- Validation redirige vers ui_execedit_posseder
CREATE OR REPLACE PROCEDURE ui_frmadd_posseder
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition posseder');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition posseder');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_posseder', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnumcategorie');
	htp.tableData(htf.formText('vnumcategorie', 4));
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


--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_posseder
	(
		vnumcategorie in number,
		vnumdomaine in number
	)
IS
BEGIN
	UPDATE 
		POSSEDER
	SET
		numdomaine = vnumdomaine
	WHERE 
		numcategorie = vnumcategorie;
	COMMIT;
END;
/


--4 Suppression

--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_posseder
CREATE OR REPLACE
PROCEDURE ui_execdel_posseder
	(
		vnumcategorie in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table POSSEDER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_posseder(vnumcategorie);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table POSSEDER');
	htp.print('<a class="btn btn-primary" href="afft_posseder" >>Consulter la liste POSSEDER</a>');
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
PROCEDURE pa_del_posseder
	(
		vnumcategorie in number
	)
IS
BEGIN
	DELETE FROM 
		POSSEDER
	WHERE 
		numcategorie = vnumcategorie;
	COMMIT;
END;
/

