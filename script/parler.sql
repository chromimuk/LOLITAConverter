-- PROCEDURES CONCERNANT LA TABLE PARLER

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_parler
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		 *
	FROM 
		PARLER;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table parler');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Liste parler');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Numéro');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.nummembre);
	htp.tableData(rec.numlangue);
	htp.tableData(
		htf.anchor('ui_frmedit_parler?vnummembre=' || rec.nummembre, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_parler?vnummembre=' || rec.nummembre, 'Supprimer')
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

--2.1.2 Page de validation d'insertion, avec gestion des erreurs
-------Appel à la requête pa_add_parler
CREATE OR REPLACE PROCEDURE ui_execadd_parler
	(
		vnummembre in number,
		vnumlangue in number
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion parler');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_parler(vnummembre,vnumlangue);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table parler');
	htp.print('<a class="btn btn-primary" href="afft_parler" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_parler
CREATE OR REPLACE PROCEDURE ui_frmadd_parler
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion parler');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table parler');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_parler', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('Numéro du membre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Numéro de la langue');
	htp.tableData(htf.formText('vnumlangue', 2));
	htp.tableRowClose;
	htp.tableClose;
	htp.print('<button class="btn btn-primary" type="submit">Validation</button>');
	htp.formClose;
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
END;
/


--2.1.1 Requête SQL
CREATE OR REPLACE PROCEDURE pa_add_parler
	(
		vnummembre in number,
		vnumlangue in number
	)
IS
BEGIN
	INSERT INTO parler VALUES
	(
		vnummembre,
		vnumlangue
	);
COMMIT;
END;
/


--3 Edition

--3.1.3 Formulaire d'édition
------- Validation redirige vers ui_execedit_parler
CREATE OR REPLACE PROCEDURE ui_frmedit_parler
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition parler');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition parler');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_parler', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('Numéro du membre');
	htp.tableData(htf.formText('vnummembre', 5));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Numéro de la langue');
	htp.tableData(htf.formText('vnumlangue', 2));
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
-------Appel à la requête pa_edit_parler
CREATE OR REPLACE
PROCEDURE ui_execedit_parler
	(
		vnummembre in number,
		vnumlangue in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table PARLER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_parler(vnummembre,vnumlangue);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table PARLER');
	htp.print('<a class="btn btn-primary" href="afft_parler" >>Consulter la liste PARLER</a>');
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
PROCEDURE pa_edit_parler
	(
		vnummembre in number,
		vnumlangue in number
	)
IS
BEGIN
	UPDATE 
		PARLER
	SET
		numlangue = vnumlangue
	WHERE 
		nummembre = vnummembre;
	COMMIT;
END;
/


--4 Suppression

--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_parler
CREATE OR REPLACE
PROCEDURE ui_execdel_parler
	(
		vnummembre in number
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table PARLER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_parler(vnummembre);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table PARLER');
	htp.print('<a class="btn btn-primary" href="afft_parler" >>Consulter la liste PARLER</a>');
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
PROCEDURE pa_del_parler
	(
		vnummembre in number
	)
IS
BEGIN
	DELETE FROM 
		PARLER
	WHERE 
		nummembre = vnummembre;
	COMMIT;
END;
/

