-- PROCEDURES CONCERNANT LA TABLE ATTRIBUER

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_attribuer
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		 A.NATURE, A.CODE, M.PREMEMBRE, M.NOMMEMBRE
	FROM 
		ATTRIBUER A Inner Join MEMBRE M
		ON A.NUMMEMBRE = M.NUMMEMBRE;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table attribuer');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Liste attribuer');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Numéro');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	htp.tableRowOpen;
	htp.tableData(rec.nature);
	htp.tableData(rec.code);
	htp.tableData(rec.premembre || ' ' || rec.nommembre);
	htp.tableData(
		htf.anchor('ui_frmedit_attribuer?vnature=' || rec.nature, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_attribuer?vnature=' || rec.nature, 'Supprimer')
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
-------Appel à la requête pa_add_attribuer
CREATE OR REPLACE PROCEDURE ui_execadd_attribuer
	(
		vcode in varchar2,
		vnummembre in number
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion attribuer');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_attribuer(vcode,vnummembre);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table attribuer');
	htp.print('<a class="btn btn-primary" href="afft_attribuer" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_attribuer
CREATE OR REPLACE PROCEDURE ui_frmadd_attribuer
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion attribuer');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table attribuer');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_attribuer', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('Code');
	htp.tableData(htf.formText('vcode', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('Numéro du membre');
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


--2.1.1 Requête SQL
CREATE OR REPLACE PROCEDURE pa_add_attribuer
	(
		vcode in varchar2,
		vnummembre in number
	)
IS
BEGIN
	INSERT INTO attribuer VALUES
	(
		'DRO',
		vcode,
		vnummembre
	);
COMMIT;
END;
/




--4 Suppression

--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_attribuer
CREATE OR REPLACE
PROCEDURE ui_execdel_attribuer
	(
		vnature in varchar2
	)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table ATTRIBUER');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_attribuer(vnature);
	htp.header(1, '<a href="hello">');
	htp.header(1, '<img src="https://dl.dropboxusercontent.com/u/21548623/LOGOLOLITA.PNG" width="300px" style="display:block; margin-left:auto; margin-right: auto;" />');
	htp.header(1, '</a>');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table ATTRIBUER');
	htp.print('<a class="btn btn-primary" href="afft_attribuer" >>Consulter la liste ATTRIBUER</a>');
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
PROCEDURE pa_del_attribuer
	(
		vnature in varchar2
	)
IS
BEGIN
	DELETE FROM 
		ATTRIBUER
	WHERE 
		nature = vnature;
	COMMIT;
END;
/

