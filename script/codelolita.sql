-- PROCEDURES CONCERNANT LA TABLE CODELOLITA

--1 Affichage des données

--1.1 Affichage de toutes les données de la table
CREATE OR REPLACE
PROCEDURE afft_codelolita
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
	CURSOR lst
	IS 
	SELECT 
		 *
	FROM 
		CODELOLITA;
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Affichage table codelolita');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Liste codelolita');
	htp.print('<table class="table">');
	htp.tableRowOpen(cattributes => 'class=active');
	htp.tableHeader('Nature');
	htp.tableHeader('Code');
	htp.tableHeader('Libelle');
	htp.tableHeader('Actions');
	htp.tableRowClose;
	FOR rec IN lst LOOP
	if rec.nature = 'STA' then
		htp.tableRowOpen(cattributes => 'class=info');
	elsif rec.nature = 'DRO' then
		htp.tableRowOpen(cattributes => 'class=success');
	else 
		htp.tableRowOpen;
	end if;
	htp.tableData(rec.nature);
	htp.tableData(rec.code);
	htp.tableData(rec.libelle);
	htp.tableData(
		htf.anchor('ui_frmedit_codelolita?vcode=' || rec.code, 'Modifier')
		|| ' ou ' ||
		htf.anchor('ui_execdel_codelolita?vcode=' || rec.code, 'Supprimer')
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

--2.1.3 Formulaire d'insertion
------- Validation redirige vers ui_execadd_codelolita
CREATE OR REPLACE PROCEDURE ui_frmadd_codelolita
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion codelolita');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Ajout élément dans la table codelolita');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execadd_codelolita', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnature');
	htp.tableData(htf.formText('vnature', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vcode');
	htp.tableData(htf.formText('vcode', 3));
	htp.tableRowClose;
	htp.tableRowOpen;
	htp.tableData('vlibelle');
	htp.tableData(htf.formText('vlibelle', 50));
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
-------Appel à la requête pa_add_codelolita
CREATE OR REPLACE PROCEDURE ui_execadd_codelolita
	(
		vnature in varchar2,
		vcode in varchar2,
		vlibelle in varchar2
	)

IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Insertion codelolita');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_add_codelolita(vnature,vcode,vlibelle);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Ajout effectue dans la table codelolita');
	htp.print('<a class="btn btn-primary" href="afft_codelolita" >Voir la liste complete</a>');
	htp.print('</div>');
	htp.bodyClose;
	htp.htmlClose;
EXCEPTION
	WHEN OTHERS THEN
		htp.print('ERROR: ' || SQLCODE);
END;
/


--2.1.1 Requête SQL
CREATE OR REPLACE PROCEDURE pa_add_codelolita
	(
		vnature in varchar2,
		vcode in varchar2,
		vlibelle in varchar2
	)
IS
BEGIN
	INSERT INTO codelolita VALUES
	(
		vnature,
		vcode,
		vlibelle
	);
COMMIT;
END;
/


--3 Edition

--3.1.1 Requête SQL
CREATE OR REPLACE
PROCEDURE pa_edit_codelolita
	(
		vnature in varchar2,
		vcode in varchar2,
		vlibelle in varchar2
	)
IS
BEGIN
	UPDATE 
		CODELOLITA
	SET
		nature = vnature,
		libelle = vlibelle
	WHERE 
		nature = vnature;
	COMMIT;
END;
/


--3.1.3 Formulaire d'édition
------- Validation redirige vers ui_execedit_codelolita
CREATE OR REPLACE PROCEDURE ui_frmedit_codelolita
(
	vcode varchar2
)
IS
	rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition codelolita');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	htp.header(1, 'Edition codelolita');
	htp.formOpen(owa_util.get_owa_service_path || 'ui_execedit_codelolita', 'POST');
	htp.print('<table class="table">');
	htp.tableRowOpen;
	htp.tableData('vnature');
	htp.tableData(htf.formText('vnature', 3));
	htp.tableRowClose;
	htp.print('<input type="hidden" name="vnumcode" value="' || vcode || '"/>');
	htp.tableRowOpen;
	htp.tableData('vlibelle');
	htp.tableData(htf.formText('vlibelle', 50));
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
-------Appel à la requête pa_edit_codelolita
CREATE OR REPLACE
PROCEDURE ui_execedit_codelolita
	(
		vnature in varchar2,
		vcode in varchar2,
		vlibelle in varchar2
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Edition table CODELOLITA');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_edit_codelolita(vnature,vcode,vlibelle);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Edition effectuée dans la table CODELOLITA');
	htp.print('<a class="btn btn-primary" href="afft_codelolita" >>Consulter la liste CODELOLITA</a>');
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

--4.1.2 Page de validation de suppression
-------Appel à la requête pa_del_codelolita
CREATE OR REPLACE
PROCEDURE ui_execdel_codelolita
	(
		vcode in varchar2
	)
IS
rep_css varchar2(255) := 'https://dl.dropboxusercontent.com/u/21548623/bootstrap.min.css';
BEGIN
	htp.print('<!DOCTYPE html>');
	htp.htmlOpen;
	htp.headOpen;
	htp.title('Suppression table CODELOLITA');
	htp.print('<link href="' || rep_css || '" rel="stylesheet" type="text/css" />');
	htp.headClose;
	htp.bodyOpen;
	htp.print('<div class="container">');
	pa_del_codelolita(vcode);
	htp.header(1, 'LOLITA');
	htp.hr;
	htp.header(2, 'Suppression élément dans la table CODELOLITA');
	htp.print('<a class="btn btn-primary" href="afft_codelolita" >>Consulter la liste CODELOLITA</a>');
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
PROCEDURE pa_del_codelolita
	(
		vcode in varchar2
	)
IS
BEGIN
	DELETE FROM 
		CODELOLITA
	WHERE 
		code = vcode;
	COMMIT;
END;
/


